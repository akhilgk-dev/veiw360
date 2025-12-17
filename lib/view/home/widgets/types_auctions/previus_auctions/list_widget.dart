import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:view360/api/auction_details_api/auction_details_all_api.dart';
import 'package:view360/common/theme/colors.dart';
import 'package:view360/common/theme/sized_box.dart';
import 'package:view360/language/language_controller.dart';
import 'package:view360/view/auction_details/auction_details_page.dart';
import 'package:view360/view/bidding_list/bidding_list.dart';
import 'package:view360/view/home/controller/count_down.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../model/previous_auction/previous_auction_model.dart';

class ListWidgetPrevius extends StatelessWidget {
  final PreviousAuctionModel auctionResponse;
  final WidgetRef ref;
  final double padding;
  final double screenWidth;

  ListWidgetPrevius({
    super.key,
    required this.auctionResponse,
    required this.ref,
    required this.padding,
    required this.screenWidth,
  });

  final LanguageController languageController = Get.find();
  @override
  Widget build(BuildContext context) {
    final isArabic = languageController.selectedLanguage.value == 1;
    return SizedBox(
      height: screenWidth * 0.80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        //shrinkWrap: true,
        itemCount: auctionResponse.auctionData!.length,
        itemBuilder: (context, index) {
          //  final favorites = ref.watch(favoritesProvider);
          //   final isFavorite = favorites.contains(index);
          final auction = auctionResponse.auctionData![index];
          final regStart =
              DateFormat(
                auction.isAGroup == true
                    ? "yyyy-MM-dd HH:mm:ss"
                    : "yyyy-MM-dd HH:mm:ss",
              ).parse(
                auction.isAGroup == true
                    ? auction.groupInfo!.regStartDate.toString()
                    : auction.regStartDate.toString(),
              );

          final regEnd =
              DateFormat(
                auction.isAGroup == true
                    ? "yyyy-MM-dd HH:mm:ss"
                    : "yyyy-MM-dd HH:mm:ss",
              ).parse(
                auction.isAGroup == true
                    ? auction.groupInfo!.regEndDate.toString()
                    : auction.regEndDate.toString(),
              );

          final auctionStart =
              DateFormat(
                auction.isAGroup == true
                    ? "yyyy-MM-dd HH:mm:ss"
                    : "yyyy-MM-dd HH:mm:ss",
              ).parse(
                auction.isAGroup == true
                    ? auction.groupInfo!.startDate.toString()
                    : auction.startDate ?? '',
              );

          final auctionEnd =
              DateFormat(
                auction.isAGroup == true
                    ? "yyyy-MM-dd HH:mm:ss"
                    : "yyyy-MM-dd HH:mm:ss",
              ).parse(
                auction.isAGroup == true
                    ? auction.groupInfo!.endDate.toString()
                    : auction.endDate ?? '',
              );

          // final regStart = DateFormat("dd/MM/yyyy hh:mm:ss a").parse(
          //     "${auction.regStartDateAr!.date} ${auction.regStartDateAr!.time}");

          // final regEnd = DateFormat("dd/MM/yyyy hh:mm:ss a").parse(
          //     "${auction.regEndDateAr!.date} ${auction.regEndDateAr!.time}");

          // final auctionStart = DateFormat("dd/MM/yyyy hh:mm:ss a")
          //     .parse("${auction.startDateAr!.date} ${auction.startDateAr!.time}");

          // final auctionEnd = DateFormat("dd/MM/yyyy hh:mm:ss a")
          //     .parse("${auction.endDateAr!.date} ${auction.endDateAr!.time}");

          final countdown = ref.watch(
            countdownProvider((regStart, regEnd, auctionStart, auctionEnd)),
          );
          // final countdown = ref.watch(countdownProvider(
          //     DateFormat("dd/MM/yyyy hh:mm:ss a").parse(
          //         "${auction.regEndDateAr!.date} ${auction.regEndDateAr!.time}")));

          return SizedBox(
            width: screenWidth * 0.50,
            child: Center(
              child: InkWell(
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  final token = prefs.getString('token');
                  //  print(token);

                  if (auction.isAGroup == true) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BiddingList(
                          whichPage: 'previus',
                          groupName: isArabic
                              ? auction.groupNameAr.toString()
                              : auction.groupName.toString(),
                          groupId: auction.groupInfo!.id.toString(),
                          check: 'true',
                        ),
                      ),
                    );
                  } else {
                    ref.invalidate(
                      auctionAllDetailsResponseProvider(auction.id),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AuctionDetailsPage(
                          index: index,
                          token: token ?? '',
                          auctionId: auction.id,
                          imageUrl: auction.images ?? [],
                          mainImage: auction.mainImage?.toString() ?? 'N/A',
                        ),
                      ),
                    );
                  }
                },
                child: Card(
                  elevation: 5,
                  semanticContainer: true,
                  shadowColor: Color(0x802196F3),
                  borderOnForeground: true,
                  child: Container(
                    //  padding: EdgeInsets.all(padding),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        // Image Section
                        Stack(
                          children: [
                            Hero(
                              tag: "auctionImage",
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      auction.images == null ||
                                          auction.images!.isEmpty
                                      ? 'https://thumbs.dreamstime.com/b/no-image-available-icon-photo-camera-flat-vector-illustration-132483141.jpg'
                                      : auction.images?[0]['image'],
                                  // auction.isAGroup == true
                                  //     ? auction.groupImage.toString()
                                  //     : auction.mainImage.toString(),
                                  width: screenWidth * 0.50,
                                  height: screenWidth * 0.3,
                                  fit: BoxFit.fitWidth,
                                  errorWidget: (context, url, error) =>
                                      Container(
                                        color: Colors.grey[200],
                                        child: const Icon(
                                          Icons.image,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
                                      ),
                                ),
                              ),
                            ),
                            // Positioned(
                            //     right: 10,
                            //     bottom: 10,
                            //     child: CircleAvatar(
                            //       backgroundColor: white,
                            //       radius: 15,
                            //       child: ClipRRect(
                            //         borderRadius: BorderRadius.circular(5),
                            //         child: CachedNetworkImage(
                            //             imageUrl:
                            //                 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcThHxSRSjwXZTqBVsEiZ4tLwMDAGA0yE8KKXQ&s'),
                            //       ),
                            //     )),
                            Positioned(
                              left: 10,
                              top: 10,
                              child: CircleAvatar(
                                backgroundColor:
                                    auction.statusLabel!.status == 'A'
                                    ? Colors.green
                                    : Colors.red,
                                radius: 8,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        // Text Section
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(padding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: auction.isAGroup == true
                                        ? isArabic
                                              ? auction.groupInfo!.groupNameAr
                                              : auction.groupInfo!.groupName
                                                    .toString()
                                        : auction.title.toString(),
                                    style: TextStyle(
                                      color: darkBlue,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 2),
                                Row(
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        text: auction.auctionNumber,
                                        style: TextStyle(
                                          color: darkBlue,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                      child: VerticalDivider(),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text:
                                            '${auction.groupInfo!.startAmount ?? 'N/A'} OMR',
                                        style: TextStyle(
                                          color: darkBlue,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(Icons.timer, size: 12),
                                    SizedBox(width: 3),
                                    Expanded(
                                      child: RichText(
                                        text: TextSpan(
                                          text:
                                              auction.statusLabel!.status == 'A'
                                              ? countdown
                                              : 'Auction Ended'.tr,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color:
                                                auction.statusLabel!.status ==
                                                    'A'
                                                ? Colors.green
                                                : Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                height05,
                                RichText(
                                  text: TextSpan(
                                    text:
                                        '${"Guarantee amount:".tr} ${auction.guaranteeAmount} OMR',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: black,
                                      //fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                height05,
                                // RichText(
                                //   text: TextSpan(
                                //     text: '${"Visit amount".tr}: 500 OMR',
                                //     style: TextStyle(
                                //         fontSize: 12,
                                //         color: black,
                                //         fontWeight: FontWeight.bold),
                                //   ),
                                // ),
                                const SizedBox(height: 8),
                                Spacer(),
                                Row(
                                  children: [
                                    // Expanded(
                                    //   flex: 0,
                                    //   child: InkWell(
                                    //     onTap: () async {
                                    //       final useridEmailverifiedAt = profileData
                                    //           .asData!.value.data.emailVerifiedAt;
                                    //       final useridphoneverifiedAt = profileData
                                    //           .asData!.value.data.mobileVerifiedAt;
                                    //       if (useridEmailverifiedAt == null ||
                                    //           useridphoneverifiedAt == null) {
                                    //         diologueBox();
                                    //         return;
                                    //       }
                                    //       if (auction.status == 'A') {
                                    //         Navigator.push(
                                    //           context,
                                    //           MaterialPageRoute(
                                    //             builder: (context) =>
                                    //                 RegistrationForBidders(
                                    //               auctionNumber: auction.auctionNumber
                                    //                   .toString(),
                                    //               auctionName:
                                    //                   auction.title.toString(),
                                    //               filePaymentterms:
                                    //                   auction.filePaymentTerms,
                                    //               auctionID: auction.id,
                                    //               guranteeAmount:
                                    //                   auction.guaranteeAmount,
                                    //             ),
                                    //           ),
                                    //         );
                                    //       } else {
                                    //         if (auction.statusLabel!.status == 'E') {
                                    //           SnackbarHelper.showSnackBar(
                                    //               context, 'Auction is completed'.tr,
                                    //               color: darkRed);
                                    //         } else {
                                    //           SnackbarHelper.showSnackBar(
                                    //               context, 'Registration closed'.tr,
                                    //               color: darkRed);
                                    //         }
                                    //       }
                                    //     },
                                    //     child: Container(
                                    //       height: 30,
                                    //       padding: const EdgeInsets.symmetric(
                                    //           horizontal: 8, vertical: 4),
                                    //       decoration: BoxDecoration(
                                    //         color: Colors.grey,
                                    //         borderRadius: BorderRadius.circular(8),
                                    //       ),
                                    //       child: Row(
                                    //         children: [
                                    //           Icon(
                                    //             Icons.menu,
                                    //             color: Colors.white,
                                    //             size: 12,
                                    //           ),
                                    //           SizedBox(width: 4),
                                    //           Text(
                                    //             'Enroll'.tr,
                                    //             style: TextStyle(
                                    //               color: Colors.white,
                                    //               fontSize: 12,
                                    //             ),
                                    //           ),
                                    //         ],
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    Expanded(
                                      //  flex: 0,
                                      child: InkWell(
                                        onTap: () async {
                                          SharedPreferences prefs =
                                              await SharedPreferences.getInstance();
                                          final token = prefs.getString(
                                            'token',
                                          );

                                          if (auction.isAGroup == true) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    BiddingList(
                                                      whichPage: 'previus',
                                                      groupName: isArabic
                                                          ? auction.groupNameAr
                                                                .toString()
                                                          : auction.groupName
                                                                .toString(),
                                                      groupId: auction
                                                          .groupInfo!
                                                          .id
                                                          .toString(),
                                                      check: 'true',
                                                    ),
                                              ),
                                            );
                                          } else {
                                            ref.invalidate(
                                              auctionAllDetailsResponseProvider(
                                                auction.id,
                                              ),
                                            );
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AuctionDetailsPage(
                                                      index: index,
                                                      token: token ?? '',
                                                      auctionId: auction.id,
                                                      imageUrl:
                                                          auction.images ?? [],
                                                      mainImage:
                                                          auction.mainImage
                                                              ?.toString() ??
                                                          'N/A',
                                                    ),
                                              ),
                                            );
                                          }
                                        },
                                        child: Container(
                                          height: 30,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: darkBlue,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.info,
                                                color: Colors.white,
                                                size: 12,
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                auction.isAGroup == true
                                                    ? 'List Auctions'.tr
                                                    : 'View details'.tr,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                height10,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
