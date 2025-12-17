import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/common/utils/network/http_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/live_bidding_model/top_bidders/top_bidders_model.dart';

class TopBiddersApi extends GetxController {
  final topBiddersModel = Rxn<TopBiddersModel>();
  var message = ''.obs;
  var isLoading = false.obs;
  var highestBid = 0.obs;
  var auctionID = 0.obs;
  var myUserID = 0.obs;

  final _topBiddersController = StreamController<TopBiddersModel>.broadcast();
  Stream<TopBiddersModel> get topBiddersStream => _topBiddersController.stream;

  Timer? _timer;
  bool _isActive = false;

  @override
  void onClose() {
    stopFetchingTopBidders();
    _topBiddersController.close();
    super.onClose();
  }

  void startFetchingTopBidders() {
    if (_isActive) return;

    _isActive = true;
    fetchTopBidders(auctionID.value);

    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_isActive) {
        fetchTopBidders(auctionID.value);
      }
    });
  }

  void stopFetchingTopBidders() {
    _isActive = false;
    _timer?.cancel();
    _timer = null;
  }

  Future<void> fetchTopBidders(int auctionID) async {
    if (!_isActive) return;

    try {
      isLoading.value = true;
      SharedPreferences pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');

      if (token == null) {
        message.value = 'Authentication token not found';
        return;
      }

      myUserID.value = pref.getInt('userId')!;

      final response = await ApiHelper().postMethod(
        url: baseUrl + topBiddersEndpoint,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'auction': auctionID}),
      );

      if (response.statusCode == 200) {
        print("Top Bidders fetched");
        final model = TopBiddersModel.fromJson(jsonDecode(response.body));
        model.data.sort((a, b) => b.bidAmount.compareTo(a.bidAmount));

        topBiddersModel.value = model;
        _topBiddersController.add(model);
        highestBid.value = model.data.isNotEmpty
            ? model.data.first.bidAmount
            : 0;
        message.value = model.message;
      } else {
        message.value =
            jsonDecode(response.body)['message'] ??
            'Failed to fetch top bidders';
      }
    } catch (e) {
      message.value = 'Error fetching top bidders: ${e.toString()}';
      _topBiddersController.addError(e);
    } finally {
      isLoading.value = false;
    }
  }
}
