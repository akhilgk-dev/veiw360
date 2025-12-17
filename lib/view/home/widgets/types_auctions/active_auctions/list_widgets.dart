import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:view360/api/auction_details_api/auction_details_all_api.dart';
import 'package:view360/api/bidding_list/bidding_list_api.dart';
import 'package:view360/api/profile_details_api/profile_details_api.dart';
import 'package:view360/common/text/text_static.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/common/theme/colors.dart';
import 'package:view360/common/theme/constants.dart';
import 'package:view360/common/theme/sized_box.dart';
import 'package:view360/common/utils/formatter/amount_formate.dart';
import 'package:view360/common/utils/formatter/date_formate.dart';
import 'package:view360/common/utils/helpers/navigation_helper.dart';
import 'package:view360/common/utils/helpers/snackbar.dart';
import 'package:view360/language/language_controller.dart';
import 'package:view360/model/active_auctions/active_auctions_model.dart';
import 'package:view360/view/auction_details/auction_details_page.dart';
import 'package:view360/view/authentication/registration/registration.dart';
import 'package:view360/view/bidding_list/bidding_list.dart';
import 'package:view360/view/enroll_live_bidding_screen/enroll_live_bidding_screen.dart';
import 'package:view360/view/enrollment_payment_screen/registration_for_bidders.dart';
import 'package:view360/view/home/controller/count_down.dart';
import 'package:view360/view/search/search_and_viewall.dart';
import 'package:view360/view/widgets/diologue_box/diologue_box.dart';
import 'package:view360/view/widgets/token/token_checking.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Active auctions list widget
class ListWidget extends ConsumerStatefulWidget {
  final AuctionResponse auctionResponse;

  final double padding;
  final double screenWidth;
  final double screenHeight;

  const ListWidget({
    super.key,
    required this.auctionResponse,

    required this.padding,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  ConsumerState<ListWidget> createState() => _ListWidgetState();
}

class _ListWidgetState extends ConsumerState<ListWidget> {
  final LanguageController languageController = Get.find();

  final TokenCheckingState tokenCheckingState = Get.put(TokenCheckingState());

  String countDownDigit(String datetime, int ind) {
    List<String> parts = datetime.split(' ');

    if (ind >= parts.length) {
      return "0";
    }
    return parts[ind];
  }

  String token = '';

  @override
  void initState() {
    tokenCheckingState.checkToken();
    token = tokenCheckingState.token.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final profileData = token.isNotEmpty
        ? ref.watch(auctionResponseProviderProfile)
        : null;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate height dynamically based on screen height
    final listHeight = screenHeight * 0.65; // Adjust the fraction as needed

    final language = languageController.selectedLanguage.value;
    // final profileData = widget.ref.watch(auctionResponseProviderProfile);

    return SizedBox(
      height: listHeight,

      child: LayoutBuilder(
        builder: (context, constraints) {
          return ListView.builder(
            //  physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            // shrinkWrap: true,
            itemCount: widget.auctionResponse.auctionData!.length + 1,
            itemBuilder: (context, index) {
              if (index == widget.auctionResponse.auctionData!.length) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchViewAll(),
                              ),
                            );
                          },
                          child: SizedBox(
                            height: 60,
                            width: 60,
                            child: Image.asset('assets/images/search_icon.png'),
                          ),
                        ),
                        Text(
                          '${"Search".tr}...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppStyle.darkGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              final auction = widget.auctionResponse.auctionData![index];
              // print(
              //   'Auction ID: ${auction.auctionNumber} imageurl: ${auction.isAGroup == true ? auction.groupImage.toString() : auction.images!.first['image']}',
              // );
              final auctionListfromParticularGroup = ref.watch(
                auctionResponseGroup(
                  int.parse(auction.groupInfo!.id.toString()),
                ),
              );

              final regStart = parseBackendTime(
                intl.DateFormat(
                      auction.isAGroup == true
                          ? "yyyy-MM-dd HH:mm:ss"
                          : "yyyy-MM-dd HH:mm:ss",
                    )
                    .parse(
                      auction.isAGroup == true
                          ? auction.groupInfo!.regStartDate.toString()
                          : auction.regStartDate.toString(),
                    )
                    .toString(),
              );

              final regEnd = parseBackendTime(
                intl.DateFormat(
                      auction.isAGroup == true
                          ? "yyyy-MM-dd HH:mm:ss"
                          : "yyyy-MM-dd HH:mm:ss",
                    )
                    .parse(
                      auction.isAGroup == true
                          ? auction.groupInfo!.regEndDate.toString()
                          : auction.regEndDate.toString(),
                    )
                    .toString(),
              );

              final auctionStart = parseBackendTime(
                intl.DateFormat(
                      auction.isAGroup == true
                          ? "yyyy-MM-dd HH:mm:ss"
                          : "yyy-MM-dd HH:mm:ss",
                    )
                    .parse(
                      auction.isAGroup == true
                          ? auction.groupInfo!.startDate.toString()
                          : "${auction.startDate}",
                    )
                    .toString(),
              );

              final auctionEnd = parseBackendTime(
                intl.DateFormat(
                      auction.isAGroup == true
                          ? "yyyy-MM-dd HH:mm:ss"
                          : "yyyy-MM-dd HH:mm:ss",
                    )
                    .parse(
                      auction.isAGroup == true
                          ? auction.groupInfo!.endDate.toString()
                          : auction.endDate ?? '',
                    )
                    .toString(),
              );

              final countdown = ref.watch(
                countdownProvider((regStart, regEnd, auctionStart, auctionEnd)),
              );

              //
              // final data = tokenCheckingState.token.value == ''
              //     ? widget.ref.watch(auctionResponseGroupGuest(auction.groupInfo!.id ?? 0))
              //     : widget.ref.watch(auctionResponseGroup(auction.groupInfo!.id ?? 0));

              return SizedBox(
                //width: widget.screenWidth - 20,
                width: constraints.maxWidth * 0.80,
                child: Center(
                  child: InkWell(
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      final token = prefs.getString('token');

                      if (auction.isAGroup == true) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BiddingList(
                              whichPage: 'active',
                              groupName: language == 1
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
                              mainImage:
                                  auction.images?.first['image']?.toString() ??
                                  '',
                            ),
                          ),
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Card(
                        elevation: 5,
                        color: Colors.white,
                        semanticContainer: true,

                        shadowColor: Color.fromARGB(128, 241, 128, 128),
                        borderOnForeground: true,
                        child: Container(
                          //  padding: EdgeInsets.all(widget.padding),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              // Image Section
                              Stack(
                                children: [
                                  GestureDetector(
                                    onLongPress: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => Dialog(
                                          child: SizedBox(
                                            height: widget.screenWidth * 0.8,
                                            child: Column(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadiusGeometry.only(
                                                        topLeft:
                                                            Radius.circular(30),
                                                        topRight:
                                                            Radius.circular(30),
                                                      ),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        auction.isAGroup == true
                                                        ? auction.groupImage
                                                              .toString()
                                                        : auction
                                                              .images!
                                                              .first['image'],
                                                    fit: BoxFit.cover,
                                                    errorWidget:
                                                        (
                                                          context,
                                                          url,
                                                          error,
                                                        ) => Container(
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
                                        top: Radius.circular(12),
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
                                              imageUrl: auction.isAGroup == true
                                                  ? auction.groupImage
                                                        .toString()
                                                  : auction
                                                        .images!
                                                        .first['image'],
                                              width: widget.screenWidth * 0.90,
                                              height: widget.screenWidth * 0.5,
                                              fit: BoxFit.fitWidth,
                                              // Crop bottom by wrapping in Align and setting height
                                              errorWidget:
                                                  (context, url, error) =>
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
                                ],
                              ),
                              const SizedBox(width: 10),

                              // Text Section
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: RichText(
                                              text: TextSpan(
                                                text: auction.isAGroup == true
                                                    ? language == 1
                                                          ? auction
                                                                .groupInfo!
                                                                .groupNameAr
                                                          : auction
                                                                .groupInfo!
                                                                .groupName
                                                                .toString()
                                                    : language == 1
                                                    ? auction.titleAr
                                                    : auction.title.toString(),
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
                                          //  Spacer(),
                                          Container(
                                            //  margin: EdgeInsets.only(right: 8),
                                            // height: 28,
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppStyle.lightGray2,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: Row(
                                              children: [
                                                ImageIcon(
                                                  AssetImage(
                                                    'assets/bottomNavIcon/auction_filled.png',
                                                  ),
                                                  color: AppStyle.liteRed,
                                                  size: 14,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  "${auction.bidCount}",
                                                  style: TextStyle(
                                                    color: black,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 2),

                                      SizedBox(height: 8),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: Colors.grey.withAlpha(50),
                                            width: 0.8,
                                          ),
                                          gradient: LinearGradient(
                                            colors: AppStyle.bidButtonGradient,
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            if (countDownDigit(countdown, 1) !=
                                                "Ended")
                                              Directionality(
                                                textDirection:
                                                    TextDirection.ltr,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: List.generate(4, (
                                                    index,
                                                  ) {
                                                    return Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          height: 40,
                                                          width: 35,
                                                          padding:
                                                              EdgeInsets.all(6),
                                                          margin:
                                                              EdgeInsets.only(
                                                                right: 12,
                                                                top: 4,
                                                              ),
                                                          decoration: BoxDecoration(
                                                            color: AppStyle
                                                                .white
                                                                .withAlpha(100),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  10,
                                                                ),
                                                            // border: Border.all(
                                                            //   color: darkBlue,
                                                            //   width: 0.8,
                                                            // ),
                                                          ),

                                                          child: Center(
                                                            child: Text(
                                                              countDownDigit(
                                                                countdown,
                                                                index + 3,
                                                              ),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
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
                                          Expanded(
                                            child: coveringContainer(
                                              "Starting price:".tr,
                                              "${AmountFormate().currencyFormat(auction.startAmount.toString() ?? '0.00')} ${"OMR".tr}",
                                            ),
                                          ),
                                          SizedBox(width: 3),
                                          Expanded(
                                            child: coveringContainer(
                                              "Guarantee amount:".tr,
                                              "${AmountFormate().currencyFormat(auction.guaranteeAmount.toString() ?? '0.00')} ${"OMR".tr}",
                                            ),
                                          ),
                                        ],
                                      ),

                                      height05,
                                      Row(
                                        children: [
                                          Expanded(
                                            child: coveringContainer(
                                              "Current price:".tr,
                                              "${AmountFormate().currencyFormat(auction.currentAmount.toString() ?? '0.00')} ${"OMR".tr}",
                                            ),
                                          ),
                                          SizedBox(width: 3),
                                          coveringContainer(
                                            "End date".tr,
                                            intl.DateFormat(
                                              "yyyy-MM-dd",
                                            ).format(auctionEnd),
                                            isTime: true,
                                            day: language == 1
                                                ? "${auction.endDateAr?.time ?? ''} - ${DateHelper.getArabicDay(auction.endDateAr?.day ?? '')}"
                                                : "${auction.endDateAr?.time ?? ''} - ${auction.endDateAr?.day ?? ''}",
                                          ),
                                        ],
                                      ),

                                      // height05,
                                      if (auction.status != 'A' &&
                                          auction.isAGroup == false)
                                        Container(
                                          padding: EdgeInsets.only(
                                            top: 0,
                                            bottom: 15,
                                            left: 4,
                                            right: 4,
                                          ),

                                          /// width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.white70,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            border: Border.all(
                                              color: Colors.grey.withAlpha(50),
                                              width: 0.8,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              height15,
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .calendar_today_outlined,
                                                    size: 16,
                                                    color: AppStyle.primary,
                                                  ),
                                                  width05,
                                                  Text(
                                                    auction.startDateAr?.date ??
                                                        '',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Icon(
                                                    Icons.location_on_outlined,
                                                    size: 16,
                                                    color: AppStyle.liteRed,
                                                  ),
                                                  Text(
                                                    auction.location ?? '',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  width05,
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      //  Spacer(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            //  height: 20,
                                            margin: EdgeInsets.only(
                                              top: 6,
                                              bottom: 6,
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            //   width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: AppStyle.red,
                                              borderRadius:
                                                  BorderRadius.circular(50),

                                              // gradient: LinearGradient(
                                              //   colors: AppStyle.redGradient,
                                              // ),
                                            ),

                                            child: Center(
                                              child: Text(
                                                "Final approved by Owner".tr,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppStyle.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      //* enroll if it is a group or individual--------------
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          if (auction.isEnrolled == true &&
                                              auction.status == "A")
                                            InkWell(
                                              onTap: () {
                                                showModalBottomSheet(
                                                  // showDragHandle: true,
                                                  // scrollControlDisabledMaxHeightRatio:
                                                  //     225,
                                                  isScrollControlled: true,
                                                  context: context,
                                                  builder: (context) {
                                                    return FractionallySizedBox(
                                                      heightFactor: 0.85,
                                                      child: EnrollLiveBiddingScreen(
                                                        filePaymentterms: auction
                                                            .filePaymentTerms,
                                                        guranteeAmount:
                                                            auction
                                                                .paymentAmount ??
                                                            "0,",
                                                        auctionNumber:
                                                            auction
                                                                .auctionNumber ??
                                                            '',
                                                        isEnrolled:
                                                            auction
                                                                .isEnrolled ??
                                                            false,
                                                        auctionStart:
                                                            auctionStart,
                                                        auctionEndTime:
                                                            auctionEnd,
                                                        auctionID: auction.id,
                                                        incrementNumbers:
                                                            auction.incrementNumbers
                                                                as List<
                                                                  dynamic
                                                                >,
                                                        auctionName:
                                                            languageController
                                                                    .selectedLanguage
                                                                    .value ==
                                                                1
                                                            ? auction.titleAr ??
                                                                  ''
                                                            : auction.title ??
                                                                  '',
                                                        startingPrice:
                                                            auction.startAmount
                                                                ?.toString() ??
                                                            '',
                                                        countdown:
                                                            "${auction.endDateAr?.date} ${auction.endDateAr?.time}",
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              child: Container(
                                                height: 30,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),

                                                  gradient: LinearGradient(
                                                    colors:
                                                        AppStyle.orangeGradient,
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.gavel_outlined,
                                                      color: white,
                                                      size: 12,
                                                    ),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      'Bid Now'.tr,
                                                      style: TextStyle(
                                                        color: white,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          if (auction.status == "A" &&
                                              auction.isEnrolled == false)
                                            InkWell(
                                              onTap: () async {
                                                if (token.isEmpty) {
                                                  diologueBoxLogin(
                                                    'Please Login to see details'
                                                        .tr,
                                                  );
                                                  return;
                                                }
                                                if (auction.isEnrolled ==
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

                                                if (now.isAfter(regEnd)) {
                                                  if (context.mounted) {
                                                    SnackbarHelperTop.showSnackBar(
                                                      context,
                                                      'Registration completed'
                                                          .tr,
                                                      color: darkRed,
                                                    );
                                                  }
                                                  return;
                                                }

                                                //!----------------

                                                // await Future.delayed(
                                                //   const Duration(seconds: 1),
                                                // );

                                                final auctionListfromParticularGroup =
                                                    ref.watch(
                                                      auctionResponseGroup(
                                                        int.parse(
                                                          auction.groupInfo!.id
                                                              .toString(),
                                                        ),
                                                      ),
                                                    );

                                                final firstAuctionId =
                                                    auctionListfromParticularGroup
                                                        .whenData(
                                                          (data) =>
                                                              data['data'][0]['id']
                                                                  .toString(),
                                                        )
                                                        .value;
                                                if ((profileData
                                                                    ?.value
                                                                    ?.data
                                                                    .isCompany ==
                                                                0 &&
                                                            profileData
                                                                    ?.value
                                                                    ?.data
                                                                    .residentCardNumber ==
                                                                null ||
                                                        profileData
                                                                ?.value
                                                                ?.data
                                                                .residentCardNumber ==
                                                            '' ||
                                                        profileData
                                                                ?.value
                                                                ?.data
                                                                .fileIdNumber ==
                                                            null) ||
                                                    (profileData
                                                                    ?.value
                                                                    ?.data
                                                                    .isCompany ==
                                                                1 &&
                                                            profileData
                                                                    ?.value
                                                                    ?.data
                                                                    .crNumber ==
                                                                null ||
                                                        profileData
                                                                ?.value
                                                                ?.data
                                                                .crNumber ==
                                                            '' ||
                                                        profileData
                                                                ?.value
                                                                ?.data
                                                                .fileCrNumber ==
                                                            null ||
                                                        profileData
                                                                ?.value
                                                                ?.data
                                                                .fileCrNumber ==
                                                            '')) {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                          'Profile Update Required'
                                                              .tr,
                                                        ),
                                                        content: Text(
                                                          'Please update your profile to enroll.'
                                                              .tr,
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                context,
                                                              ).pop();
                                                              NavigationHelper.navigateTo(
                                                                context,
                                                                RegistrationScreen(
                                                                  checkPageID:
                                                                      1,
                                                                  token: token,
                                                                ), // Replace with your profile edit screen widget
                                                              );
                                                            },
                                                            child: Text(
                                                              'Edit Profile'.tr,
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                context,
                                                              ).pop();
                                                            },
                                                            child: Text(
                                                              'Cancel'.tr,
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                  return;
                                                } else {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => RegistrationForBidders(
                                                        groupid: auction
                                                            .groupInfo
                                                            ?.id
                                                            .toString(),
                                                        auctionNumber: auction
                                                            .auctionNumber,
                                                        auctionName:
                                                            language == 1
                                                            ? auction.titleAr
                                                            : auction.groupName,
                                                        filePaymentterms: auction
                                                            .filePaymentTerms,
                                                        auctionID:
                                                            int.tryParse(
                                                              firstAuctionId ??
                                                                  '0',
                                                            ) ??
                                                            0,
                                                        guranteeAmount:
                                                            auction
                                                                .paymentAmount ??
                                                            "0",
                                                        paymentTypes: [
                                                          auction
                                                                  .groupInfo
                                                                  ?.canOnline ??
                                                              true,
                                                          auction
                                                                  .groupInfo
                                                                  ?.canWallet ??
                                                              true,
                                                          auction
                                                                  .groupInfo
                                                                  ?.canOffline ??
                                                              true,
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                              child: Container(
                                                height: 30,
                                                padding:
                                                    const EdgeInsets.symmetric(
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
                                                    colors: AppStyle
                                                        .bidButtonGradient,
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
                                                      'Enroll'.tr,
                                                      style: TextStyle(
                                                        color: white,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          width05,
                                          InkWell(
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
                                                          whichPage: 'active',
                                                          groupName:
                                                              language == 1
                                                              ? auction
                                                                    .groupNameAr
                                                                    .toString()
                                                              : auction
                                                                    .groupName
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
                                                              auction.images ??
                                                              [],
                                                          mainImage:
                                                              auction
                                                                  .images
                                                                  ?.first['image']
                                                                  ?.toString() ??
                                                              '',
                                                        ),
                                                  ),
                                                );
                                              }
                                            },
                                            child: Container(
                                              height: 30,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: white,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                gradient: LinearGradient(
                                                  colors: AppStyle
                                                      .blueButtonGradient,
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
                                                    auction.isAGroup == true
                                                        ? 'List Auctions'.tr
                                                        : 'View details'.tr,
                                                    style: TextStyle(
                                                      color: white,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
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
              );
            },
          );
        },
      ),
    );
  }

  Widget coveringContainer(
    String title,
    String value, {
    bool isTime = false,
    String day = "",
  }) {
    return Container(
      // height: 50,
      padding: EdgeInsets.all(3),

      /// width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withAlpha(50), width: 0.8),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: AppStyle.darkGray,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (isTime)
            Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                day,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
