import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:view360/api/auction_details_api/auction_details_all_api.dart';
import 'package:view360/common/text/text_static.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/common/utils/formatter/amount_formate.dart';
import 'package:view360/language/language_controller.dart';
import 'package:view360/view/dashboard/my_auctions/tracking_mybids.dart';
import 'package:view360/view/widgets/empty_message/empty_message_widget.dart';
import 'package:view360/view/widgets/skeletonizer/list_homepage_skeleton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:view360/view/auction_details/auction_details_page.dart';
import 'package:view360/view/widgets/appbar_widget/appbar_widget.dart';
import 'package:view360/common/theme/sized_box.dart';
import 'package:view360/common/theme/style.dart';
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/common/utils/network/http_api.dart';

//my bids page - web
class MyAuction extends ConsumerWidget {
  const MyAuction({super.key});

  getAuctionDetails(String id, WidgetRef ref) async {
    final actionDetails = ref.watch(
      auctionAllDetailsResponseProvider(int.parse(id)),
    );
    return actionDetails;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auctionResponse = ref.watch(auctionResponseMYAuctions);
    final LanguageController languageController = Get.find();

    // final profileData = ref.watch(auctionResponseProviderProfile);

    // final useridEmailverifiedAt =
    //     profileData.asData?.value.data.emailVerifiedAt;
    // final useridphoneverifiedAt =
    //     profileData.asData?.value.data.mobileVerifiedAt;

    return Scaffold(
      appBar: AppbarWidget(title: 'My Auctions'.tr),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: auctionResponse.when(
          data: (auctions) {
            final filteredAuctions = (auctions['data'] as List<dynamic>?) ?? [];
            //     ?.where(
            //       (auction) => auction['status_label']?['status'] == 'A',
            //     )
            //     .toList() ??
            // [];

            if (filteredAuctions.isEmpty) {
              return Center(
                child: EmptyMessageWidget(
                  message: 'No Auctions Available right now'.tr,
                ),
              );
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: filteredAuctions.length,
                    itemBuilder: (context, index) {
                      final auction = filteredAuctions[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5.0,
                          vertical: 0.0,
                        ),
                        child: InkWell(
                          onTap: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            final token = prefs.getString('token') ?? '';

                            Get.to(
                              () => AuctionDetailsPage(
                                index: index,
                                token: token,
                                auctionId: auction['id'],
                                imageUrl: auction[''] ?? [],
                                mainImage: auction['auction_cover_url'],
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 8,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                    border: Border.all(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  ' ${languageController.selectedLanguage.value == 1 ? auction['title_ar'] : auction['title']}',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                height05,
                                                Text(
                                                  '${"Client".tr}: ',
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Icons moved to a row above the button
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: AppStyle.lightGradient,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Column(
                                              children: [
                                                Text("Rank".tr),
                                                Text(
                                                  '${auction['user_rank'] ?? "-"}',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: AppStyle.primary,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '${auction['organization_name'] ?? ""}',
                                              style: const TextStyle(
                                                fontSize: 13,
                                                color: AppStyle.primary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      '${"Current".tr}: ',
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${AmountFormate().currencyFormat(auction['current_bid_amount'].toString())} OMR',
                                                      style: const TextStyle(
                                                        fontSize: 15,
                                                        color:
                                                            Colors.blueAccent,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                      child: VerticalDivider(),
                                                    ),
                                                    Text(
                                                      '${"Your Bid".tr}: ',
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${AmountFormate().currencyFormat((auction['bid_amount']).toString())} OMR',
                                                      style: const TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.green,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 4),
                                              ],
                                            ),
                                          ),

                                          // InkWell(
                                          //   onTap: () {
                                          //     print('Pay Now tapped');
                                          //   },
                                          //   borderRadius: BorderRadius.circular(8),
                                          //   child: Container(
                                          //     padding: EdgeInsets.symmetric(
                                          //       vertical: 10,
                                          //       horizontal: 13,
                                          //     ),
                                          //     decoration: BoxDecoration(
                                          //       gradient: LinearGradient(
                                          //         colors: AppStyle.bidButtonGradient,
                                          //       ),
                                          //       borderRadius: BorderRadius.circular(10),
                                          //     ),
                                          //     alignment: Alignment.center,
                                          //     child: Text(
                                          //       "Pay Now".tr,
                                          //       style: TextStyle(
                                          //         color: Colors.white,
                                          //         fontWeight: FontWeight.bold,
                                          //         fontSize: 14,
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                      height05,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              auction['status'] != "A"
                                                  ? Get.to(
                                                      () => AuctionDetailsPage(
                                                        index: index,
                                                        token: '',
                                                        auctionId:
                                                            auction['id'],
                                                        imageUrl:
                                                            auction[''] ?? [],
                                                        mainImage:
                                                            auction['auction_cover_url'],
                                                      ),
                                                    )
                                                  : {
                                                      showModalBottomSheet(
                                                        context: context,
                                                        builder: (context) {
                                                          return SizedBox(
                                                            height: 2000,
                                                            child: Center(
                                                              child: Text(
                                                                "data",
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    };
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 6.0,
                                                    horizontal: 14.0,
                                                  ),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors:
                                                      auction['status'] == "A"
                                                      ? AppStyle.orangeGradient
                                                      : AppStyle.redGradient,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  auction['status'] == "A"
                                                      ? Icon(
                                                          Icons.gavel_outlined,
                                                          color: Colors.white,
                                                          size: 22,
                                                        )
                                                      : Icon(
                                                          Icons.info_outline,
                                                          color: Colors.white,
                                                        ),
                                                  width05,
                                                  (auction['status'] == "A")
                                                      ? Text(
                                                          "Bid Now".tr,
                                                          style: blackStyle
                                                              .copyWith(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        )
                                                      : Text(
                                                          "Auction Ended".tr,
                                                          style: blackStyle
                                                              .copyWith(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              print(
                                                "auction no: ${auction['id']}",
                                              );
                                              print(
                                                "group no: ${auction['group']}",
                                              );

                                              Get.to(
                                                () => TrackingMybids(
                                                  acutionId: auction['id'],
                                                ),
                                              );
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 6.0,
                                                    horizontal: 24.0,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: AppStyle.lightGray3,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Row(
                                                children: [
                                                  ImageIcon(
                                                    AssetImage(
                                                      'assets/images/tracking_outline.png',
                                                    ),
                                                    size: 26,
                                                    color: AppStyle.secondary,
                                                  ),
                                                  width05,
                                                  Text(
                                                    "Tracking".tr,
                                                    style: blackStyle.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppStyle.secondary,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      // Pay Now button below the icons, full width
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(child: ListSkeleton()),
          error: (error, stackTrace) =>
              Center(child: Image.asset(noInternetImage)),
        ),
      ),
    );
  }
}

//---------------------------------------------------------------------

final messageProvidermyAuctionApi = StateProvider<String>((ref) => '');

class MyAuctionApi {
  Future<dynamic> getMyAuction(Ref ref) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      // API call to get Previous auctions
      final response = await http.get(
        Uri.parse('$baseUrl$myBidsEndPoint'),
        headers: {
          "Authorization": "Bearer ${pref.getString('token')}",
          "Content-Type": "application/json",
        },
      );

      // print(response);

      if (response.statusCode == 200) {
        //        print('Success');
        //      print(json.decode(response.body));
        return json.decode(response.body);
      } else {
        debugPrint(response.body);
        ref.read(messageProvidermyAuctionApi.notifier).state = json.decode(
          response.body,
        )['message'];
        return Future.error('Failed to load previous auctions');
      }
    } on Exception catch (e) {
      ref.read(messageProvidermyAuctionApi.notifier).state =
          'An error occurred: $e';
      ApiHelper().handleNetworkException(e);
      debugPrint('$e');

      return Future.error('Failed to load list auctions'.tr);
    }
  }
}

final myAuctionsListProvider = Provider((ref) => MyAuctionApi());

final auctionResponseMYAuctions = FutureProvider<dynamic>((ref) async {
  final auctionService = ref.read(myAuctionsListProvider);
  return auctionService.getMyAuction(ref);
});
