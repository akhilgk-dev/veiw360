import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:view360/api/auction_details_api/auction_details_all_api.dart';
import 'package:view360/api/profile_details_api/profile_details_api.dart';
import 'package:view360/language/language_controller.dart';
import 'package:view360/view/auction_details/auction_details_page.dart';
import 'package:view360/view/bottomNav/bottom_nav.dart';
import 'package:view360/view/widgets/appbar_widget/appbar_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:view360/common/theme/colors.dart';
import 'package:view360/common/theme/sized_box.dart';
import 'package:view360/common/theme/style.dart';
import 'package:view360/view/widgets/empty_message/empty_message_widget.dart';
import 'package:view360/view/widgets/token/token_checking.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/all_auctions_list/all_auction_list_api.dart';
import '../../api/live_bidding_apis/user_validity_check.dart';
import '../home/controller/count_down.dart';

class AllAuctionList extends ConsumerWidget {
  AllAuctionList({super.key});

  bool isValid = false;
  final TokenCheckingState tokenCheckingState = Get.put(TokenCheckingState());
  final UserValidityCheckApi userValidityCheckApi = Get.put(
    UserValidityCheckApi(),
  );
  final LanguageController languageController = Get.find();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.invalidate(allAuctionsListProvider);

    final arabic = languageController.selectedLanguage.value == 1;
    //--------------------------------------------------------------------------
    tokenCheckingState.checkToken();
    final notifier = ref.read(bottomNavProvider.notifier);
    final auctionResponse = ref.watch(auctionResponseAllAuctions);
    final profileData = ref.watch(auctionResponseProviderProfile);
    final useridEmailverifiedAt =
        profileData.asData?.value.data.emailVerifiedAt;
    final useridphoneverifiedAt =
        profileData.asData?.value.data.mobileVerifiedAt;

    //--------------------------------------------------------------------------

    return PopScope<Object>(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }

        notifier.updateIndex(0);
      },
      child: Scaffold(
        appBar: AppbarWidgetWithoutBackButton(title: 'All Auctions'.tr),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: auctionResponse.when(
            data: (auctions) {
              print("auctionresponse in ui");
              final filteredAuctions = auctions;
              //filter swowing only active auctions
              // auctions['data'].where((auction) {
              //   final status = auction['status_label']?['status'];
              //   return status == 'A';
              // }).toList();

              if (filteredAuctions.isEmpty) {
                return EmptyMessageWidget(
                  message: 'No Auctions Available right now'.tr,
                );
              }

              return ListView.builder(
                itemCount: filteredAuctions.length,
                itemBuilder: (context, index) {
                  final auction = filteredAuctions[index];

                  if (isValid == false) {
                    userValidityCheckApi.checkUserValidity(auction['id']);
                    isValid = true;
                  }

                  //------------------------------------------------------------------------------------

                  final isActive = auction['status_label']['status'] == 'A';
                  final isEnded = auction['status_label']['status'] == 'E';
                  //  final isUpcoming = auction['status_label']['status'] == 'U';

                  //----------------------------------------------------------------------------------------------

                  final regStart = DateFormat("dd/MM/yyyy hh:mm:ss a").parse(
                    "${auction['reg_start_date_ar']['date']} ${auction['reg_start_date_ar']['time']}",
                  );

                  final regEnd = DateFormat("dd/MM/yyyy hh:mm:ss a").parse(
                    "${auction['reg_end_date_ar']['date']} ${auction['reg_end_date_ar']['time']}",
                  );

                  final auctionStart = auction['is_a_group'] == true
                      ? DateFormat("dd/MM/yyyy hh:mm:ss a").parse(
                          "${auction['group_info']['start_date_ar']['date']} ${auction['group_info']['start_date_ar']['time']}",
                        )
                      : DateFormat("dd/MM/yyyy hh:mm:ss a").parse(
                          "${auction['start_date_ar']['date']} ${auction['start_date_ar']['time']}",
                        );

                  final auctionEnd = auction['is_a_group'] == true
                      ? DateFormat(
                          "yyyy-MM-dd HH:mm:ss",
                        ).parse(auction['group_info']['end_date'])
                      : DateFormat(
                          "yyyy-MM-dd HH:mm:ss",
                        ).parse(auction['end_date']);

                  // final auctionStart = DateFormat("dd/MM/yyyy hh:mm:ss a").parse(
                  //     "${auction['start_date_ar']['date']} ${auction['start_date_ar']['time']}");

                  // final auctionEnd = DateFormat("dd/MM/yyyy hh:mm:ss a").parse(
                  //     "${auction['end_date_ar']['date']} ${auction['end_date_ar']['time']}");

                  final countdown = ref.watch(
                    countdownProvider((
                      regStart,
                      regEnd,
                      auctionStart,
                      auctionEnd,
                    )),
                  );

                  //------------------------------------------------------------------------------------------------------
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5.0,
                      vertical: 0.0,
                    ),
                    child: InkWell(
                      onTap: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        final token = prefs.getString('token');

                        ref.invalidate(
                          auctionAllDetailsResponseProvider(auction['id']),
                        );

                        Get.to(() {
                          return AuctionDetailsPage(
                            index: index,
                            token: token ?? '',
                            auctionId: filteredAuctions[index]['id'],
                            imageUrl: filteredAuctions[index]['images'] ?? [],
                            mainImage: filteredAuctions[index]['main_image'],
                          );
                        });
                      },
                      child: Card(
                        elevation: 4,
                        color: white,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: grey100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CachedNetworkImage(
                                      imageUrl: auction['main_image'] ?? '',
                                      height: 100,
                                      width: 110,
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                  ),
                                  width10,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          arabic
                                              ? auction['title_ar']
                                              : auction['title'] ?? 'No Title',
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
                                        Row(
                                          children: [
                                            Icon(Icons.location_on, size: 12),
                                            SizedBox(width: 2),
                                            Text(
                                              arabic
                                                  ? auction['location_ar']
                                                  : auction['location'] ??
                                                        'N/A',
                                              style: smallFontSize12,
                                            ),
                                          ],
                                        ),
                                        height05,
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.timer,
                                                    size: 14,
                                                    color: Colors.black,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Expanded(
                                                    child: Text(
                                                      overflow:
                                                          TextOverflow.visible,
                                                      countdown,
                                                      style: smallFontSize12
                                                          .copyWith(
                                                            color: Colors.green,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Guarantee Amt:'.tr,
                                              style: TextStyle(fontSize: 11),
                                            ),
                                            Text(
                                              '${auction['start_amount']} OMR',
                                              style: smallFontSize12.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
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
                                      height25,
                                      Text(
                                        '${auction['start_amount'] ?? 'N/A'} OMR',
                                        style: smallFontSize12.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: darkBlue,
                                        ),
                                      ),
                                      height05,
                                      Container(
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: darkBlue,
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.info_outline,
                                            color: white,
                                            size: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 2),
                              Divider(),
                              height05,

                              //
                              biddingButton(
                                ref,
                                isEnded,
                                index,
                                auction,
                                isActive,
                                useridEmailverifiedAt,
                                useridphoneverifiedAt,
                                context,
                                regEnd,
                              ),

                              //
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => Center(
              child: SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: darkBlue,
                ),
              ),
            ),
            error: (error, stackTrace) => Center(
              child: Image.asset(
                'assets/images/no-connection-concept-illustration_114360-6157.avif',
              ),
            ),
          ),
        ),
      ),
    );
  }

  //*==========================================================================

  InkWell biddingButton(
    WidgetRef ref,
    bool isEnded,
    int index,
    auction,
    bool isActive,
    String? useridEmailverifiedAt,
    String? useridphoneverifiedAt,
    BuildContext context,
    DateTime regEnd,
  ) {
    return InkWell(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token') ?? '';

        ref.invalidate(auctionAllDetailsResponseProvider(auction['id']));

        Get.to(
          () => AuctionDetailsPage(
            index: index,
            token: token,
            auctionId: auction['id'],
            imageUrl: auction['images'] ?? [],
            mainImage: auction['main_image'],
          ),
        );
      },

      //
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? darkBlue : Colors.grey,
          borderRadius: BorderRadius.circular(10),
        ),
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline, color: white),
            width10,
            Text(
              'View details'.tr,
              style: smallFontSize12.copyWith(
                color: white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
