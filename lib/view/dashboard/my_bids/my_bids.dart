import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:view360/api/auction_details_api/auction_details_all_api.dart';
import 'package:view360/api/profile_details_api/profile_details_api.dart';
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/common/text/text_static.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/language/language_controller.dart';
import 'package:view360/view/widgets/appbar_widget/appbar_widget.dart';
import 'package:view360/view/widgets/skeletonizer/list_homepage_skeleton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common/utils/network/http_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:view360/common/utils/helpers/shared_pref.dart';
import 'package:view360/view/home/controller/count_down.dart';
import 'package:view360/view/widgets/diologue_box/diologue_box.dart';
import 'package:http/http.dart' as http;
import 'package:view360/view/auction_details/auction_details_page.dart';
import 'package:view360/common/theme/colors.dart';
import 'package:view360/common/theme/sized_box.dart';
import 'package:view360/common/theme/style.dart';

//enrolled auction list
class MyBids extends ConsumerWidget {
  const MyBids({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auctionResponse = ref.watch(auctionResponseMYBids);
    final LanguageController languageController = Get.put(LanguageController());

    final isArabic = languageController.selectedLanguage.value == 1;

    return Scaffold(
      appBar: AppbarWidget(title: 'Enrolled Auctions'.tr),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: auctionResponse.when(
          data: (auctions) {
            final filteredAuctions =
                (auctions['data'] as List<dynamic>?)
                    ?.where(
                      (auction) => auction['status_label']?['status'] == 'A',
                    )
                    .toList() ??
                [];
            final filteredAuctionsEnded =
                (auctions['data'] as List<dynamic>?)
                    ?.where(
                      (auction) => auction['status_label']?['status'] == 'E',
                    )
                    .toList() ??
                [];

            if (filteredAuctions.isEmpty && filteredAuctionsEnded.isEmpty) {
              return const Center(child: Text('No Active auctions available.'));
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: filteredAuctions.isEmpty
                        ? filteredAuctionsEnded.length
                        : filteredAuctions.length,
                    itemBuilder: (context, index) {
                      final auction = filteredAuctions.isEmpty
                          ? filteredAuctionsEnded[index]
                          : filteredAuctions[index];
                      final regStart = DateTime(0);

                      final regEnd = DateFormat("yyyy/MM/dd HH:mm:ss").tryParse(
                        "${((auctions['data'][index]['group_info']['reg_end_date']) ?? "2023-03-21 05:30:00").replaceAll('-', '/')}",
                      );

                      final auctionStart = auction['is_a_group'] == false
                          ? DateFormat(
                              "yyyy-MM-dd HH:mm:ss",
                            ).parse("${auction['start_date']}")
                          : DateFormat(
                              "yyyy-MM-dd HH:mm:ss",
                            ).parse("${auction['group_info']['start_date']}");

                      final auctionEnd = auction['is_a_group'] == false
                          ? DateFormat(
                              "yyyy-MM-dd HH:mm:ss",
                            ).parse("${auction['end_date']}")
                          : DateFormat(
                              "yyyy-MM-dd HH:mm:ss",
                            ).parse("${auction['group_info']['end_date']}");

                      //countdown for only group
                      final countdown = ref.watch(
                        countdownProvider((
                          regStart,
                          regEnd ?? DateTime(0),
                          auctionStart,
                          auctionEnd,
                        )),
                      );

                      final profileData = ref.watch(
                        auctionResponseProviderProfile,
                      );
                      // final useridEmailverifiedAt =
                      //     profileData.asData?.value.data.emailVerifiedAt;
                      final useridphoneverifiedAt =
                          profileData.asData?.value.data.mobileVerifiedAt;

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5.0,
                          vertical: 8.0,
                        ),
                        child: InkWell(
                          onTap: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            final token = prefs.getString('token') ?? '';
                            ref.invalidate(
                              auctionAllDetailsResponseProvider(auction['id']),
                            );

                            Get.to(
                              () => AuctionDetailsPage(
                                index: index,
                                token: token,
                                auctionId: auction['id'],
                                imageUrl: auction['images'] ?? [],
                                mainImage: auction['images'][0]['image'],
                              ),
                            );
                          },
                          child: Card(
                            elevation: 4,
                            color: white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              auction['images'][0]['image'] ??
                                              '',
                                          height: 100,
                                          width: 110,
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                      width10,
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              isArabic
                                                  ? auction['title_ar'] ??
                                                        auction['title']
                                                  : auction['title'] ?? '',
                                              style: smallFontSize12.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            height05,
                                            Text(
                                              auction['auction_number'] ??
                                                  'Unknown ID',
                                              style: smallFontSize12.copyWith(
                                                color: darkBlue,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            height05,
                                            // Row(
                                            //   children: [
                                            //     const Icon(
                                            //       Icons.location_on,
                                            //       size: 12,
                                            //       color: AppStyle.liteRed,
                                            //     ),
                                            //     const SizedBox(width: 2),
                                            //     Text(
                                            //       auction['location'] ?? 'N/A',
                                            //       style: smallFontSize12,
                                            //     ),
                                            //   ],
                                            // ),
                                            height05,
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.timer,
                                                  size: 14,
                                                  color: Colors.black,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  countdown,
                                                  style: smallFontSize12
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            filteredAuctions
                                                                .isEmpty
                                                            ? Colors.red
                                                            : Colors.green,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            height05,
                                            Text(
                                              '${'Current'.tr}: ${auction['current_amount']} OMR',
                                              style: smallFontSize12.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            radius: 13,
                                            backgroundColor: darkBlue,
                                            child: Text(
                                              '${auction['bid_count'] ?? 0}',
                                              style: smallFontSize12.copyWith(
                                                color: white,
                                              ),
                                            ),
                                          ),
                                          height10,
                                          Text(
                                            '${auction['start_amount'] ?? 'N/A'} OMR',
                                            style: smallFontSize12.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: darkBlue,
                                            ),
                                          ),
                                          height05,
                                          // Container(
                                          //   width: 50,
                                          //   decoration: BoxDecoration(
                                          //     color: darkBlue,
                                          //     borderRadius:
                                          //         BorderRadius.circular(5),
                                          //   ),
                                          //   child: const Padding(
                                          //     padding: EdgeInsets.all(8.0),
                                          //     child: Icon(
                                          //       Icons.info_outline,
                                          //       color: white,
                                          //       size: 15,
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  height05,
                                  const Divider(),
                                  InkWell(
                                    onTap: () async {
                                      final token =
                                          await SharedPrefsHelper.getString(
                                            'token',
                                          );

                                      if (token!.isEmpty) {
                                        diologueBoxLogin(
                                          'You need to login to enroll this auction'
                                              .tr,
                                        );
                                        return;
                                      }

                                      ref.invalidate(
                                        auctionAllDetailsResponseProvider(
                                          auction['id'],
                                        ),
                                      );
                                      Get.to(
                                        () => AuctionDetailsPage(
                                          index: index,
                                          token: token,
                                          auctionId: auction['id'],
                                          imageUrl: auction['images'] ?? [],
                                          mainImage:
                                              auction['images'][0]['image'],
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: AppStyle.bidButtonGradient,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.info_outline,
                                            color: white,
                                          ),
                                          width05,
                                          Text(
                                            "View details".tr,
                                            style: blackStyle.copyWith(
                                              color: white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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

final messageProvidermyBidsApi = StateProvider<String>((ref) => '');

class MyBidsApi {
  Future<dynamic> getMyBids(Ref ref) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      // API call to get Previous auctions
      final response = await http.get(
        Uri.parse(baseUrl + enrolledAuctionEndPoint),
        headers: {
          "Authorization": "Bearer ${pref.getString('token')}",
          "Content-Type": "application/json",
        },
      );

      // print(response);

      if (response.statusCode == 200) {
        print('Success');
        print(response.request?.url);
        print(json.decode(response.body));
        return json.decode(response.body);
      } else {
        debugPrint(response.body);
        ref.read(messageProvidermyBidsApi.notifier).state = json.decode(
          response.body,
        )['message'];
        return Future.error('Failed to load previous auctions');
      }
    } on Exception catch (e) {
      ref.read(messageProvidermyBidsApi.notifier).state =
          'An error occurred: $e';
      ApiHelper().handleNetworkException(e);
      debugPrint('$e');

      return Future.error('Failed to load list auctions');
    }
  }
}

final myBidsListProvider = Provider((ref) => MyBidsApi());

final auctionResponseMYBids = FutureProvider<dynamic>((ref) async {
  final auctionService = ref.read(myBidsListProvider);
  return auctionService.getMyBids(ref);
});
