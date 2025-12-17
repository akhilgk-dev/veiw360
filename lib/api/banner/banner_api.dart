import 'dart:convert';

import 'package:get/get.dart';
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/common/utils/network/http_api.dart';

class BannerApi extends GetxController {
  RxBool isLoading = false.obs;
  RxBool success = false.obs;
  BannerResponse? bannerResponse;

  Future<void> fetchBanners() async {
    try {
      isLoading.value = true;
      final response = await ApiHelper().getMethod(
        url: baseUrl + bannersEndpoint,
        headers: ApiHelper().headersWithoutToken(),
      );
      if (response.statusCode == 200) {
        bannerResponse = BannerResponse.fromJson(json.decode(response.body));
        success.value = true;
      } else {
        success.value = false;
      }

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      // Handle error
    }
  }
}

class BannerResponse {
  final List<BannerModel> banners;

  BannerResponse({required this.banners});

  factory BannerResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<BannerModel> bannerList = list
        .map((i) => BannerModel.fromJson(i))
        .toList();
    return BannerResponse(banners: bannerList);
  }
}

class BannerModel {
  final int id;
  final String imageUrl;

  BannerModel({required this.id, required this.imageUrl});

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(id: json['id'], imageUrl: json['banner']);
  }
}
