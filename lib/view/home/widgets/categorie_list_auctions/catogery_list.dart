import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:view360/api/all_auctions_list/all_auction_list_api.dart';
import 'package:view360/api/auction_details_api/auction_details_all_api.dart';
import 'package:view360/language/language_controller.dart';
import 'package:view360/view/auction_details/auction_details_page.dart';
import 'package:view360/view/home/controller/count_down.dart';
import 'package:view360/view/widgets/appbar_widget/appbar_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:view360/common/theme/colors.dart';
import 'package:view360/common/theme/sized_box.dart';
import 'package:view360/common/theme/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../api/live_bidding_apis/user_validity_check.dart';
import '../../../../api/profile_details_api/profile_details_api.dart';
import '../../../widgets/token/token_checking.dart';

class CategorySortList extends ConsumerStatefulWidget {
  final int categoryId;
  final String categoryName;
  const CategorySortList({
    required this.categoryId,
    required this.categoryName,
    super.key,
  });

  @override
  ConsumerState<CategorySortList> createState() => _CategorySortListState();
}

class _CategorySortListState extends ConsumerState<CategorySortList> {
  final UserValidityCheckApi userValidityCheckApi = Get.put(
    UserValidityCheckApi(),
  );
  bool isUservalid = false;
  final TokenCheckingState tokenCheckingState = Get.put(TokenCheckingState());
  final LanguageController languageController = Get.find();
  @override
  Widget build(BuildContext context) {
    final isArabic = languageController.selectedLanguage.value == 1;
    //----------------------------------------------------------------------------------------
    //getx controller

    //riverpod provider
    final auctionResponse = ref.watch(auctionResponseAllAuctions);
    final profileData = ref.watch(auctionResponseProviderProfile);
    final useridEmailverifiedAt =
        profileData.asData?.value.data.emailVerifiedAt;
    final useridphoneverifiedAt =
        profileData.asData?.value.data.mobileVerifiedAt;

    //------------------------------------------------------------------------------------------

    return Scaffold(
      appBar: AppbarWidget(title: widget.categoryName.tr),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: auctionResponse.when(
          data: (auctions) {
            if (auctions['data'].isEmpty) {
              return Center(child: Text('No auctions available.'.tr));
            }

            // Filter auctions based on categoryId
            final filteredAuctions = auctions['data'].where((auction) {
              return auction['categoryDetails'] != null &&
                  auction['categoryDetails']['id'] == widget.categoryId &&
                  auction['status_label'] != null &&
                  auction['status_label']['status'] == 'A';
            }).toList();

            if (filteredAuctions.isEmpty) {
              return Center(
                child: Text('No auctions available for this category.'.tr),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: RichText(
                    text: TextSpan(
                      text:
                          '${"Total Auction:".tr} ${filteredAuctions.length} ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: darkBlue,
                      ),
                    ),
                  ),
                ),
                Divider(),
                // Container(
                //   decoration: BoxDecoration(
                //       border: Border.all(),
                //       borderRadius: BorderRadius.circular(7)),
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         RichText(
                //           text: TextSpan(
                //             text:
                //                 '${'Enrolled users'.tr}: ${filteredAuctions[0]['is_grouped_enroll']}',
                //             style: TextStyle(
                //                 fontWeight: FontWeight.bold,
                //                 fontSize: 12,
                //                 color: darkBlue),
                //           ),
                //         ),
                //         SizedBox(
                //           height: 20,
                //           child: VerticalDivider(
                //             indent: 2,
                //             endIndent: 2,
                //           ),
                //         ),
                //         RichText(
                //           text: TextSpan(
                //             text:
                //                 '${"Total Auction:".tr} ${filteredAuctions.length} ',
                //             style: TextStyle(
                //                 fontWeight: FontWeight.bold,
                //                 fontSize: 12,
                //                 color: darkBlue),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // height05,
                // height10,
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredAuctions.length,
                    itemBuilder: (context, index) {
                      //-----------------------------------------------------------------------------------------------------------
                      //-----------------------------------------------------------------------------------------------------------

                      final auction = filteredAuctions[index];

                      // if (isUservalid == false) {
                      //   userValidityCheckApi.checkUserValidity(auction['id']);
                      //   isUservalid = true;
                      // }

                      final isActive = auction['status_label']['status'] == 'A';
                      final isEnded = auction['status_label']['status'] == 'E';
                      final regStart = DateFormat("dd/MM/yyyy hh:mm:ss a").parse(
                        "${auction['reg_start_date_ar']['date']} ${auction['reg_start_date_ar']['time']}",
                      );
                      final regEnd = DateFormat("dd/MM/yyyy hh:mm:ss a").parse(
                        "${auction['reg_end_date_ar']['date']} ${auction['reg_end_date_ar']['time']}",
                      );

                      //
                      final auctionStart =
                          auctions['data'][index]['is_a_group'] == false
                          ? DateFormat(
                              "yyyy-MM-dd HH:mm:ss",
                            ).parse("${auctions['data'][index]['start_date']}")
                          : DateFormat("yyyy-MM-dd HH:mm:ss").parse(
                              "${auctions['data'][index]['group_info']['start_date']}",
                            );

                      final auctionEnd =
                          auctions['data'][index]['is_a_group'] == false
                          ? DateFormat(
                              "yyyy-MM-dd HH:mm:ss",
                            ).parse("${auctions['data'][index]['end_date']}")
                          : DateFormat("yyyy-MM-dd HH:mm:ss").parse(
                              "${auctions['data'][index]['group_info']['end_date']}",
                            );
                      // final auctionStart = DateFormat("dd/MM/yyyy hh:mm:ss a")
                      //     .parse(
                      //         "${auction['start_date_ar']['date']} ${auction['start_date_ar']['time']}");
                      // final auctionEnd = DateFormat("dd/MM/yyyy hh:mm:ss a").parse(
                      //     "${auction['end_date_ar']['date']} ${auction['end_date_ar']['time']}");

                      //
                      final countdown = ref.watch(
                        countdownProvider((
                          regStart,
                          regEnd,
                          auctionStart,
                          auctionEnd,
                        )),
                      );

                      //---------------------------------------------------------------------------------------------------------------------
                      //---------------------------------------------------------------------------------------------------------------------
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
                                auctionId: auction['id'],
                                imageUrl: auction['images'] ?? [],
                                mainImage:
                                    auction['main_image']?.toString() ?? 'N/A',
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              languageController
                                                          .selectedLanguage
                                                          .value ==
                                                      1
                                                  ? auction['title_ar']
                                                  : auction['title'] ??
                                                        'No Title',
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
                                                Icon(
                                                  Icons.location_on,
                                                  size: 12,
                                                ),
                                                SizedBox(width: 2),
                                                Text(
                                                  isArabic
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                auction['status_label']['status'] ==
                                                        'A'
                                                    ? Expanded(
                                                        child: Row(
                                                          children: [
                                                            const Icon(
                                                              Icons.timer,
                                                              size: 14,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            const SizedBox(
                                                              width: 4,
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                countdown,
                                                                style: smallFontSize12.copyWith(
                                                                  color: Colors
                                                                      .green,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : Row(
                                                        children: [
                                                          const Icon(
                                                            Icons.timer,
                                                            size: 14,
                                                            color: Colors.black,
                                                          ),
                                                          const SizedBox(
                                                            width: 4,
                                                          ),
                                                          Text(
                                                            'Auction Ended'.tr,
                                                            style: smallFontSize12
                                                                .copyWith(
                                                                  color: Colors
                                                                      .red,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  '${"Guarantee Amt:".tr} ',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                  ),
                                                ),
                                                Text(
                                                  '${auction['start_amount']} OMR',
                                                  style: smallFontSize12
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
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

                                          //------------------------------------------
                                          viewDetailsSmallContainerButton(
                                            index,
                                            auction,
                                          ),

                                          //-------------------------------------------
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 2),
                                  Divider(),
                                  height05,

                                  //--------------------------------------
                                  buttonPlaceBidOrViewDetails(
                                    tokenCheckingState,
                                    auction,
                                    isActive,
                                    useridEmailverifiedAt,
                                    useridphoneverifiedAt,
                                    regEnd,
                                    context,
                                    index,
                                    regStart,
                                    isEnded,
                                    auctionEnd,
                                    auctionStart,
                                  ),

                                  //---------------------------------------
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
          loading: () => Center(
            child: SizedBox(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(strokeWidth: 2, color: darkBlue),
            ),
          ),
          error: (error, stackTrace) =>
              Center(child: Text('Error: ${error.toString()}')),
        ),
      ),
    );
  }

  ///*===========================================================================
  //*===========================================================================

  //viewDetailsSmallContainerButton

  InkWell viewDetailsSmallContainerButton(int index, auction) {
    return InkWell(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        ref.invalidate(auctionAllDetailsResponseProvider(auction['id']));

        Get.to(() {
          return AuctionDetailsPage(
            index: index,
            token: token ?? '',
            auctionId: auction['id'],
            imageUrl: auction['images'] ?? [],
            mainImage: auction['main_image']?.toString() ?? 'N/A',
          );
        });
      },
      child: Container(
        width: 50,
        decoration: BoxDecoration(
          color: darkBlue,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.info_outline, color: white, size: 15),
        ),
      ),
    );
  }

  ///*==========================================================================
  //*===========================================================================

  //button

  Row buttonPlaceBidOrViewDetails(
    TokenCheckingState tokenCheckingState,
    auction,
    bool isActive,
    String? useridEmailverifiedAt,
    String? useridphoneverifiedAt,
    DateTime regEnd,
    BuildContext context,
    int index,
    DateTime regStart,
    bool isEnded,
    DateTime auctionEnd,
    DateTime auctionStart,
  ) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
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
              //   print(isActive);

              //   if (tokenCheckingState.token.value.isEmpty) {
              //     diologueBoxLogin("Login required for bid".tr);
              //     return;
              //   }

              //   //
              //   if (isEnded) {
              //     SharedPreferences prefs = await SharedPreferences.getInstance();
              //     final token = prefs.getString('token');

              //     Get.to(() {
              //       return AuctionDetailsPage(
              //         index: index,
              //         token: token ?? '',
              //         auctionId: auction['id'],
              //         imageUrl: auction['images'] ?? [],
              //         mainImage: auction['main_image']?.toString() ?? 'N/A',
              //       );
              //     });
              //     return;
              //   }
              //   //

              //   //

              //   if (isActive) {
              //     if (
              //         useridphoneverifiedAt == null) {
              //       diologueBox();
              //       return;
              //     }
              //   }

              //   // if (userValidityCheckApi.enrollstatus.value != 'A') {
              //   //   if (context.mounted) {
              //   //     SnackbarHelperTop.showSnackBar(
              //   //         context, "You are not enrolled, please enroll to bid".tr,
              //   //         color: darkRed);
              //   //   }
              //   //   return;
              //   // }

              //   //

              //   // if (userValidityCheckApi.valid.value == false &&
              //   //     userValidityCheckApi.enrollstatus.value == 'A') {
              //   //   if (context.mounted) {
              //   //     SnackbarHelperTop.showSnackBar(
              //   //         context,
              //   //         "You are not verified, please wait for approval to bid"
              //   //             .tr,
              //   //         color: darkRed);
              //   //   }
              //   //   return;
              //   // }

              //  // final now = DateTime.now();

              //   // if (now.isBefore(regEnd) &&
              //   //     now.isAfter(regStart) &&
              //   //     userValidityCheckApi.valid.value == true) {
              //   //   if (context.mounted) {
              //   //     SnackbarHelperTop.showSnackBar(context,
              //   //         'You can bid this auction after registration end date'.tr,
              //   //         color: darkRed);
              //   //   }
              //   //   return;
              //   // }

              //   await userValidityCheckApi.checkUserValidity(auction['id']);

              //      final now= DateTime.now();
              //     if (userValidityCheckApi.enrollstatus.value != 'A'&& now.isBefore(auctionStart)) {
              //       Get.to(()=>RegistrationForBidders(
              //         auctionNumber: auction['auction_number'],
              //         auctionName:languageController.selectedLanguage.value==1?auction['title_ar'].toString():
              //          auction['title'].toString(),
              //         filePaymentterms: auction['file_payment_terms'],
              //         auctionID: auction['id'],
              //         guranteeAmount: auction['guarantee_amount'],
              //       ));
              //       if (context.mounted) {
              //         SnackbarHelperTop.showSnackBar(context,
              //             'You are not enrolled, please enroll to bid'.tr,
              //             color: black);
              //       }
              //       return;
              //     }

              //   //
              //   if (isActive ) {
              //     showModalBottomSheet(
              //       showDragHandle: true,
              //       scrollControlDisabledMaxHeightRatio: 225,
              //       context: context,
              //       builder: (context) {
              //         return EnrollLiveBiddingScreen(
              //                             filePaymentterms: auction['file_payment_terms'],
              //   guranteeAmount: auction['guarantee_amount'],
              //     auctionNumber: auction['auction_number'],
              //           isEnrolled: auction['is_enrolled'],
              //           auctionStart: auctionStart,
              //           auctionEndTime: auctionEnd,
              //           auctionID: auction['id'],
              //           incrementNumbers: auction['increment_numbers'],
              //           auctionName:languageController.selectedLanguage.value==1?auction['title_ar']: auction['title'].toString(),
              //           startingPrice: auction['start_amount'].toString(),
              //           countdown:
              //               "${auction['end_date_ar']['date']} ${auction['end_date_ar']['time']}",
              //         );
              //       },
              //     );
              //   }
            },

            //

            // child: Container(
            //   decoration: BoxDecoration(
            //     color: isEnded
            //         ? darkBlue
            //         : isActive
            //             ? yelloAccent
            //             : Colors.grey,
            //     borderRadius: BorderRadius.circular(10),
            //   ),
            //   height: 40,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       isActive
            //           ? Image.asset(
            //               'assets/bottomNavIcon/Layer_1 (4).png',
            //               color: black,
            //               height: 20,
            //             )
            //           : Icon(
            //               Icons.info_outline,
            //               color: white,
            //               size: 20,
            //             ),
            //       width10,
            //       Text(
            //         isActive ? 'Bid now'.tr : 'View details'.tr,
            //         style: smallFontSize12.copyWith(
            //             color: isActive ? black : white),
            //       ),
            //     ],
            //   ),
            // ),

            //temporary
            child: Container(
              decoration: BoxDecoration(
                color: darkBlue,
                borderRadius: BorderRadius.circular(10),
              ),
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline, color: white, size: 20),
                  width10,
                  Text(
                    'View details'.tr,
                    style: smallFontSize12.copyWith(color: white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
