import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:view360/api/auction_details_api/auction_details_all_api.dart';
import 'package:view360/common/text/text_static.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/common/theme/colors.dart';
import 'package:view360/common/theme/constants.dart';
import 'package:view360/common/theme/sized_box.dart';
import 'package:view360/common/utils/formatter/amount_formate.dart';
import 'package:view360/common/utils/helpers/snackbar.dart';
import 'package:view360/language/language_controller.dart';
import 'package:view360/view/auction_details/auction_details_page.dart';
import 'package:view360/view/bidding_list/bidding_list.dart';
import 'package:view360/view/home/controller/count_down.dart';
import 'package:shared_preferences/shared_preferences.dart';

//view all widget for search page
class ViewAllWidget extends ConsumerStatefulWidget {
  const ViewAllWidget({
    super.key,
    required this.auctionResponse,
    required this.ref,
  });
  //final AuctionResponse auctionResponse;
  final dynamic auctionResponse;

  final WidgetRef ref;
  @override
  ConsumerState<ViewAllWidget> createState() => _ViewAllWidgetState();
}

class _ViewAllWidgetState extends ConsumerState<ViewAllWidget> {
  final LanguageController languageController = Get.find();
  String countDownDigit(String datetime, int ind) {
    List<String> parts = datetime.split(' ');

    if (ind >= parts.length) {
      print("that is issue");
      return "0";
    }
    return parts[ind];
  }

  final fontStyle = TextStyle(fontSize: 12);
  @override
  Widget build(BuildContext context) {
    final language = languageController.selectedLanguage.value;
    return ListView.builder(
      itemCount: widget.auctionResponse['data']?.length ?? 0,
      itemBuilder: (context, index) {
        final auction = widget.auctionResponse['data'][index];
        DateTime? safeParse(String? dateStr) {
          if (dateStr == null || dateStr.isEmpty) return null;
          return intl.DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateStr);
        }

        // Usage:
        final regStart = parseBackendTime(
          auction['is_a_group'] == true
              ? safeParse(
                  auction['group_info']['reg_start_date']?.toString(),
                ).toString()
              : safeParse(auction['reg_start_date']?.toString()).toString(),
        );

        final regEnd = parseBackendTime(
          auction['is_a_group'] == true
              ? safeParse(
                  auction['group_info']['reg_end_date']?.toString(),
                ).toString()
              : safeParse(auction['reg_end_date']?.toString()).toString(),
        );

        final auctionStart = parseBackendTime(
          auction['is_a_group'] == true
              ? safeParse(
                  auction['group_info']['start_date']?.toString(),
                ).toString()
              : safeParse(auction['start_date']?.toString()).toString(),
        );

        final auctionEnd = parseBackendTime(
          auction['is_a_group'] == true
              ? ((auction['group_info']['end_date'] ??
                        DateTime.now().subtract(Duration(days: 1)))
                    .toString())
              : ((auction['end_date'] ??
                        DateTime.now().subtract(Duration(days: 1)))
                    .toString()),
        );

        final countdown = widget.ref.watch(
          countdownProvider((
            regStart ?? DateTime(2000, 1, 1, 0, 0, 0),
            regEnd ?? DateTime(2000, 1, 1, 0, 0, 0),
            auctionStart ?? DateTime(2000, 1, 1, 0, 0, 0),
            auctionEnd ?? DateTime(2000, 1, 1, 0, 0, 0),
          )),
        );
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
          child: SizedBox(
            height: (countDownDigit(countdown, 1) != "Ended") ? 370 : 305,
            child: Center(
              child: InkWell(
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  final token = prefs.getString('token');

                  if (auction['is_a_group'] == true) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BiddingList(
                          whichPage: 'active',
                          groupName: language == 1
                              ? auction['group_name_ar'].toString()
                              : auction['group_name'].toString(),
                          groupId: auction['group_info']['id'].toString(),
                          check: 'true',
                        ),
                      ),
                    );
                  } else {
                    ref.invalidate(
                      auctionAllDetailsResponseProvider(auction['id']),
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AuctionDetailsPage(
                          index: index,
                          token: token ?? '',
                          auctionId: auction['id'] ?? 0,
                          imageUrl: auction['images'] ?? [],
                          mainImage: auction['images'][0]['image'] ?? 'N/A',
                        ),
                      ),
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4.0,
                    vertical: 4,
                  ),
                  child: Card(
                    elevation: 5,
                    color: Colors.white,
                    semanticContainer: true,
                    shadowColor: Color.fromARGB(128, 187, 216, 239),
                    borderOnForeground: true,
                    child: Container(
                      //  padding: EdgeInsets.all(widget.padding),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          // Image Section
                          Row(
                            children: [
                              GestureDetector(
                                onLongPress: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                      child: SizedBox(
                                        height: 200,
                                        child: Column(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadiusGeometry.only(
                                                    topLeft: Radius.circular(
                                                      30,
                                                    ),
                                                    topRight: Radius.circular(
                                                      30,
                                                    ),
                                                  ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    auction['is_a_group'] ==
                                                        true
                                                    ? auction['group_image']
                                                              ?.toString() ??
                                                          ''
                                                    : (auction['images'] !=
                                                              null &&
                                                          auction['images']
                                                              .isNotEmpty)
                                                    ? auction['images'][0]['image']
                                                    : '',
                                                fit: BoxFit.cover,
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Container(
                                                          color:
                                                              Colors.grey[200],
                                                          child: const Icon(
                                                            Icons.image,
                                                            size: 50,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                              ),
                                            ),
                                            Text("Name"),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(6),
                                    bottom: Radius.circular(6),
                                  ),
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child:
                                        // Image.asset(
                                        //   'assets/test/mazadcom-pic5.jpg',
                                        //   width: widget.screenWidth * 0.90,
                                        //   height: widget.screenWidth * 0.5,
                                        //   fit: BoxFit.fitHeight,
                                        // ),
                                        CachedNetworkImage(
                                          imageUrl:
                                              auction['is_a_group'] == true
                                              ? auction['group_image']
                                                        ?.toString() ??
                                                    ''
                                              : (auction['images'] != null &&
                                                    auction['images']
                                                        .isNotEmpty)
                                              ? auction['images'][0]['image']
                                              : '',
                                          width: 200,
                                          height: 150,
                                          fit: BoxFit.fitHeight,
                                          // Crop bottom by wrapping in Align and setting height
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
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    coveringContainer(
                                      "Starting price:".tr,
                                      "${AmountFormate().currencyFormat(auction['start_amount'].toString() ?? '0.00')} ${"OMR".tr}",
                                    ),
                                    SizedBox(height: 3),
                                    coveringContainer(
                                      "Guarantee amount:".tr,
                                      "${AmountFormate().currencyFormat((auction['guarantee_amount'] ?? '0.00').toString())} ${"OMR".tr}",
                                    ),
                                    SizedBox(height: 3),
                                    coveringContainer(
                                      "Current price:".tr,
                                      "${AmountFormate().currencyFormat((auction['current_amount'] ?? '0.00').toString())} ${"OMR".tr}",
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          // Text Section
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 280,
                                        child: RichText(
                                          text: TextSpan(
                                            text: auction['is_a_group'] == true
                                                ? language == 1
                                                      ? auction['group_info']['group_name_ar']
                                                                .toString() ??
                                                            ''
                                                      : auction['group_info']['group_name']
                                                                ?.toString() ??
                                                            ''
                                                : language == 1
                                                ? auction['title_ar']
                                                          ?.toString() ??
                                                      ''
                                                : auction['title']
                                                          ?.toString() ??
                                                      '',

                                            style: TextStyle(
                                              color: black,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),

                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(
                                                0.5,
                                              ),
                                              spreadRadius: 1,
                                              blurRadius: 3,
                                              offset: Offset(
                                                0,
                                                1,
                                              ), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            ImageIcon(
                                              AssetImage(
                                                'assets/bottomNavIcon/auction_filled.png',
                                              ),
                                              size: 16,
                                              color: AppStyle.darkGolden,
                                            ),
                                            if (auction['bid_count'] != null)
                                              Text(
                                                (auction['bid_count'] ?? 0)
                                                    .toString(),
                                                style: fontStyle,
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  height10,
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.grey.withAlpha(50),
                                        width: 0.8,
                                      ),
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFF189397),
                                          Color(0xFF4fc1c0),
                                        ],
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        height05,

                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.timer_outlined,
                                              size: 15,
                                              color: Colors.white,
                                            ),
                                            SizedBox(width: 3),
                                            RichText(
                                              text: TextSpan(
                                                text:
                                                    "${countDownDigit(countdown, 0)} ${countDownDigit(countdown, 1)}",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        if (countDownDigit(countdown, 1) !=
                                            "Ended")
                                          Directionality(
                                            textDirection: TextDirection.ltr,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: List.generate(4, (
                                                index,
                                              ) {
                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: 40,
                                                      width: 35,
                                                      padding: EdgeInsets.all(
                                                        6,
                                                      ),
                                                      margin: EdgeInsets.only(
                                                        right: 12,
                                                        top: 4,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: AppStyle.white
                                                            .withAlpha(100),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                      ),

                                                      child: Center(
                                                        child: Text(
                                                          countDownDigit(
                                                            countdown,
                                                            index + 3,
                                                          ),
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    height05,
                                                    Text(
                                                      timesStrings[index],
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        color: white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }),
                                            ),
                                          ),
                                        height05,
                                      ],
                                    ),
                                  ),

                                  height05,

                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today_outlined,
                                        size: 16,
                                        color: AppStyle.primary,
                                      ),
                                      SizedBox(width: 3),
                                      Text(
                                        auction['end_date']?.toString() ?? '',
                                        style: fontStyle,
                                      ),
                                      Spacer(),
                                      if (auction['location'] != null)
                                        Icon(
                                          Icons.location_on_outlined,
                                          size: 16,
                                          color: AppStyle.liteRed,
                                        ),
                                      Text(
                                        auction['location']?.toString() ?? '',
                                        style: fontStyle,
                                      ),
                                    ],
                                  ),
                                  Spacer(),

                                  //* enroll if it is a group or individual--------------
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (auction['status'] == "A")
                                        InkWell(
                                          onTap: () async {
                                            if (auction['is_enrolled'] ==
                                                true) {
                                              if (context.mounted) {
                                                SnackbarHelperTop.showSnackBar(
                                                  context,
                                                  alreadyEnrolledMessage.tr,
                                                  color: darkBlue,
                                                );
                                              }
                                              return;
                                            }

                                            final now = DateTime.now();

                                            if (now.isAfter(
                                              regEnd ??
                                                  DateTime(2000, 1, 1, 0, 0, 0),
                                            )) {
                                              if (context.mounted) {
                                                SnackbarHelperTop.showSnackBar(
                                                  context,
                                                  'Registration completed'.tr,
                                                  color: darkRed,
                                                );
                                              }
                                              return;
                                            }

                                            //!----------------

                                            // await Future.delayed(
                                            //   const Duration(seconds: 1),
                                            // );

                                            // final auctionListfromParticularGroup = ref
                                            //     .watch(auctionResponseGroup(int.parse(
                                            //   auction.groupInfo!.id.toString(),
                                            // )));

                                            // final firstAuctionId =
                                            //     auctionListfromParticularGroup
                                            //         .whenData(
                                            //           (data) =>
                                            //               data['data'][0]['id']
                                            //                   .toString(),
                                            //         )
                                            //         .value;

                                            // Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //     builder: (context) =>
                                            //         RegistrationForBidders(
                                            //           groupid: auction
                                            //               .groupInfo
                                            //               ?.id
                                            //               .toString(),
                                            //           auctionNumber:
                                            //               auction.auctionNumber,
                                            //           auctionName: language == 1
                                            //               ? auction.titleAr
                                            //               : auction.groupName,
                                            //           filePaymentterms: auction
                                            //               .filePaymentTerms,
                                            //           auctionID:
                                            //               int.tryParse(
                                            //                 firstAuctionId ??
                                            //                     '0',
                                            //               ) ??
                                            //               0,
                                            //           guranteeAmount: auction
                                            //               .groupInfo
                                            //               ?.guaranteeAmount,
                                            //         ),
                                            //   ),
                                            // );
                                          },
                                          child: Container(
                                            height: 30,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: AppStyle.secondary,
                                                width: 0.5,
                                              ),
                                              gradient: LinearGradient(
                                                colors: [
                                                  AppStyle.primary,
                                                  AppStyle.secondColor,
                                                ],
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.menu,
                                                  color: white,
                                                  size: 12,
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  (auction['is_enrolled'] ==
                                                          true)
                                                      ? 'Bid Now'.tr
                                                      : 'Enroll'.tr,
                                                  style: TextStyle(
                                                    color: white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      width05,
                                      Container(
                                        height: 30,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: white,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xFF189397),
                                              Color(0xFF4fc1c0),
                                            ],
                                          ),
                                          border: Border.all(
                                            color: darkBlue,
                                            width: 0.5,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.info_outline,
                                              color: white,
                                              size: 14,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              auction['is_a_group'] == true
                                                  ? 'List Auctions'.tr
                                                  : 'View details'.tr,
                                              style: TextStyle(
                                                color: white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
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
              ),
            ),
          ),
        );
      },
    );
  }

  Widget coveringContainer(String title, String value) {
    return Container(
      padding: EdgeInsets.all(2),
      margin: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withAlpha(50), width: 0.8),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(fontSize: 12, color: Colors.black87)),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
