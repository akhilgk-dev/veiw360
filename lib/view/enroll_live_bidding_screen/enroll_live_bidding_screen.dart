import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:view360/api/auction_details_api/auction_details_all_api.dart';
import 'package:view360/api/extra_time_live_bid/extra_time_live_bid.dart';
import 'package:view360/api/live_bidding_apis/all_top_bidders.dart';
import 'package:view360/api/live_bidding_apis/bidding_live.dart';
import 'package:view360/api/profile_details_api/profile_details_api.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/common/theme/colors.dart';
import 'package:view360/common/theme/sized_box.dart';
import 'package:view360/common/theme/style.dart';
import 'package:view360/common/utils/formatter/amount_formate.dart';
import 'package:view360/common/utils/helpers/navigation_helper.dart';
import 'package:view360/common/utils/helpers/snackbar.dart';
import 'package:view360/language/language_controller.dart';
import 'package:view360/model/live_bidding_model/top_bidders/top_bidders_model.dart';
import 'package:view360/view/authentication/registration/registration.dart';
import 'package:view360/view/enrollment_payment_screen/registration_for_bidders.dart';
import 'package:view360/view/home/controller/count_down.dart';
import 'package:view360/view/widgets/skeletonizer/bidder_skeleton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/live_bidding_apis/top_bidders.dart';
import 'components/bid_notifier.dart';

// final checkBox = StateProvider<bool>((ref) => false);

class EnrollLiveBiddingScreen extends ConsumerStatefulWidget {
  final String auctionName;
  final String countdown;
  final String startingPrice;
  final int auctionID;
  final List<dynamic> incrementNumbers;
  final DateTime auctionEndTime;
  final DateTime auctionStart;
  final bool isEnrolled;
  final String auctionNumber;
  final dynamic filePaymentterms;
  final String guranteeAmount;

  const EnrollLiveBiddingScreen({
    super.key,
    required this.auctionNumber,
    required this.filePaymentterms,
    required this.guranteeAmount,
    required this.isEnrolled,
    required this.auctionStart,
    required this.auctionEndTime,
    required this.auctionID,
    required this.countdown,
    required this.startingPrice,
    required this.auctionName,
    required this.incrementNumbers,
  });

  @override
  // ignore: library_private_types_in_public_api
  _EnrollLiveBiddingScreenState createState() =>
      _EnrollLiveBiddingScreenState();
}

class _EnrollLiveBiddingScreenState
    extends ConsumerState<EnrollLiveBiddingScreen> {
  //------------------------------------------------------------------------
  final BiddingLiveAPI bidController = Get.put(BiddingLiveAPI());
  final TopBiddersApi controller = Get.put(TopBiddersApi());
  final ExtraTimeLiveBid extraTimeLiveBid = Get.put(ExtraTimeLiveBid());
  // final extraTimeApi = Get.put(ExtraTimeLiveCalling());
  String? token = '';
  DateTime? actualEndTime;
  //----------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    getToken();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.auctionID.value = widget.auctionID;
      if (widget.incrementNumbers.isNotEmpty) {
        int initialStep = widget.incrementNumbers.first is int
            ? widget.incrementNumbers.first
            : int.tryParse(widget.incrementNumbers.first.toString()) ?? 0;
        ref.read(bidProvider.notifier).setStep(initialStep);
        ref.read(bidProvider.notifier).setAmount(initialStep);
      }

      // Start fetching only when widget is mounted
      controller.startFetchingTopBidders();
      //  extraTimeApi.startExtraTimePolling(widget.auctionID);
    });
    actualEndTime = widget.auctionEndTime;
  }

  @override
  void dispose() {
    // Stop fetching when widget is disposed
    controller.stopFetchingTopBidders();

    super.dispose();
  }

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
  }

  void callAfterAuctionEnd() async {
    final extraTime = await extraTimeLiveBid.getExtraTime(widget.auctionID);
    debugPrint(extraTime.toString());
    if (extraTime == actualEndTime) {
      debugPrint("actualEndTime $actualEndTime");
      debugPrint("extraTimeLiveBid.newExtraTime.value $extraTime");
      debugPrint("@@@@@extraTimeLiveBid.newExtraTime.value == actualEndTime");
      actualEndTime = widget.auctionEndTime;
    } else {
      debugPrint("@@@@@else is working");
      actualEndTime = extraTime;
      ref.invalidate(auctionAllDetailsResponseProvider(widget.auctionID));
    }
  }
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     controller.auctionID.value = widget.auctionID;
  //     if (widget.incrementNumbers.isNotEmpty) {
  //       int initialStep = widget.incrementNumbers.first is int
  //           ? widget.incrementNumbers.first
  //           : int.tryParse(widget.incrementNumbers.first.toString()) ?? 0;
  //       ref.read(bidProvider.notifier).setStep(initialStep);
  //       ref.read(bidProvider.notifier).setAmount(initialStep);
  //     }
  //     controller.startFetchingTopBidders();
  //   });
  // }

  final LanguageController languageController = Get.find();
  final aaa = false.obs;
  final alreadyBid = false.obs;
  bool isExtendedtime = true;
  @override
  Widget build(BuildContext context) {
    print("Rebuilding EnrollLiveBiddingScreen");

    final profileData = (token ?? '').isNotEmpty
        ? ref.watch(auctionResponseProviderProfile)
        : null;
    final bidState = ref.watch(bidProvider);
    final now = DateTime.now();

    final auctionData = ref.watch(
      auctionAllDetailsResponseProvider(widget.auctionID),
    );

    final regStart = auctionData.when(
      data: (data) => parseBackendTime(
        DateFormat("dd/MM/yyyy hh:mm:ss a")
            .parse(
              "${data['reg_start_date_ar']['date']} ${data['reg_start_date_ar']['time']}",
            )
            .toString(),
      ),
      loading: () => DateTime.now(), // Provide a default value during loading
      error: (err, stack) => DateTime.now(), // Provide a default value on error
    );

    final regEnd = auctionData.when(
      data: (data) => parseBackendTime(
        DateFormat("dd/MM/yyyy hh:mm:ss a")
            .parse(
              "${data['reg_end_date_ar']['date']} ${data['reg_end_date_ar']['time']}",
            )
            .toString(),
      ),
      loading: () => DateTime.now(), // Provide a default value during loading
      error: (err, stack) => DateTime.now(), // Provide a default value on error
    );

    final auctionStart = auctionData.when(
      data: (data) => parseBackendTime(
        DateFormat("dd/MM/yyyy hh:mm:ss a")
            .parse(
              "${data['start_date_ar']['date']} ${data['start_date_ar']['time']}",
            )
            .toString(),
      ),
      loading: () => DateTime.now(),
      error: (err, stack) => DateTime.now(),
    );

    final auctionEnd = auctionData.when(
      data: (data) => parseBackendTime(
        DateFormat(
          "yyyy-MM-dd HH:mm:ss",
        ).parse("${data['end_date']}").toString(),
      ),
      loading: () => DateTime.now(),
      error: (err, stack) => DateTime.now(),
    );

    // final now = DateTime.now();
    final extraTimeLiveBid = Get.find<ExtraTimeLiveBid>();

    final countdown = ref.watch(
      countdownProviderLive((regStart, regEnd, auctionStart, auctionEnd)),
    );

    //check these conditions for extra time
    if (now.isAfter(actualEndTime ?? auctionEnd)) {
      print("sdfs");
      callAfterAuctionEnd();
    }

    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Auction Name
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.lightBlueAccent.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.lightBlueAccent.withOpacity(0.2),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.auctionName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: darkBlue,
                          ),
                        ),
                        height10,
                        // Auction Price Details
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       child: Container(
                        //         padding: const EdgeInsets.all(12),
                        //         decoration: BoxDecoration(
                        //           border: Border.all(color: darkBlue),
                        //           borderRadius: BorderRadius.circular(12),
                        //         ),
                        //         child: Row(
                        //           children: [
                        //             Text(
                        //               'Starting price:'.tr,
                        //               style: TextStyle(
                        //                 fontSize: 10,
                        //                 color: darkBlue,
                        //                 fontWeight: FontWeight.bold,
                        //               ),
                        //             ),
                        //             width05,
                        //             Text(
                        //               "${widget.startingPrice} OMR",
                        //               style: const TextStyle(
                        //                 fontSize: 12,
                        //                 fontWeight: FontWeight.bold,
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //     width05,
                        //     Expanded(
                        //       child: Container(
                        //         padding: const EdgeInsets.all(12),
                        //         decoration: BoxDecoration(
                        //           border: Border.all(color: darkBlue),
                        //           borderRadius: BorderRadius.circular(12),
                        //         ),
                        //         child: Row(
                        //           children: [
                        //             Text(
                        //               'Current price:'.tr,
                        //               style: TextStyle(
                        //                 fontSize: 10,
                        //                 color: darkBlue,
                        //                 fontWeight: FontWeight.bold,
                        //               ),
                        //             ),
                        //             SizedBox(width: 5),
                        //             Obx(
                        //               () => Text(
                        //                 "${controller.highestBid.value == 0 ? widget.startingPrice : controller.highestBid.value} OMR",
                        //                 style: const TextStyle(
                        //                   fontSize: 12,
                        //                   fontWeight: FontWeight.bold,
                        //                 ),
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            width05,
                            Column(
                              children: [
                                Text(
                                  "${AmountFormate().currencyFormat(widget.startingPrice)} OMR",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Starting price:'.tr,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppStyle.darkGray,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                width05,
                              ],
                            ),
                            SizedBox(
                              height: 40,
                              child: VerticalDivider(thickness: 2),
                            ),
                            Column(
                              children: [
                                Obx(
                                  () => Text(
                                    "${AmountFormate().currencyFormat((controller.highestBid.value == 0 ? widget.startingPrice : controller.highestBid.value).toString())} OMR",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  'Current price:'.tr,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppStyle.darkGray,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 5),
                              ],
                            ),
                            width05,
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Remaining Time
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: darkBlue, width: 1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.timer, color: AppStyle.gray),
                              width15,
                              Center(
                                child: Row(
                                  children: [
                                    width05,
                                    Text(
                                      countdown,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: darkBlue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              ),

              height05,
              // now.isAfter(auctionEnd)
              //     ? Center(
              //         child: Column(
              //           children: [
              //             Text(
              //               'Auction End'.tr,
              //               style: TextStyle(
              //                 color: Colors.red,
              //                 fontSize: 15,
              //                 fontWeight: FontWeight.bold,
              //               ),
              //             ),
              //             height05,
              //             Text(
              //               'Thankyou for the participation'.tr,
              //               style: TextStyle(color: Colors.red, fontSize: 12),
              //             ),
              //           ],
              //         ),
              //       )
              //     :
              now.isBefore(widget.auctionStart)
                  ? Center(
                      child: Text(
                        'Auction is not started'.tr,
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "Start bidding Now".tr,
                            style: TextStyle(
                              color: darkBlue,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        height05,

                        //* selectable amount box========================================
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: widget.incrementNumbers.map((step) {
                              int parsedStep = step is int
                                  ? step
                                  : int.tryParse(step.toString()) ?? 0;
                              if (parsedStep == 0) return SizedBox.shrink();
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                ),
                                child: ChoiceChip(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  showCheckmark: false,
                                  backgroundColor: AppStyle.lightGray3,
                                  selectedColor: AppStyle.secondary,
                                  label: Text(
                                    "$parsedStep",
                                    style: bidState.step == parsedStep
                                        ? whiteStyle
                                        : blackStyle,
                                  ),
                                  selected: bidState.step == parsedStep,
                                  onSelected: (selected) {
                                    if (selected) {
                                      ref
                                          .read(bidProvider.notifier)
                                          .setStep(parsedStep);
                                      ref
                                          .read(bidProvider.notifier)
                                          .setAmount(parsedStep);
                                    }
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ),

                        height20,

                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 0.5,
                              color: AppStyle.gray,
                            ),
                            color: white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "Bid Amount".tr,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: darkBlue,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppStyle.lightGray2,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: AppStyle.lightGray2,
                                        ),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.remove,
                                          size: 40,
                                          color: Colors.red,
                                        ),
                                        onPressed: () => ref
                                            .read(bidProvider.notifier)
                                            .decrement(),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      child: Obx(() {
                                        final bidAmount =
                                            controller.highestBid.value +
                                            bidState.amount;
                                        final startingPrice =
                                            int.tryParse(
                                              widget.startingPrice,
                                            ) ??
                                            0;

                                        if (bidAmount < startingPrice) {
                                          return Text(
                                            "${AmountFormate().currencyFormat(startingPrice.toString())} OMR",
                                            style: const TextStyle(
                                              color: black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          );
                                        }
                                        return Text(
                                          "${AmountFormate().currencyFormat(bidAmount.toString())} OMR",
                                          style: const TextStyle(
                                            fontFamily: 'SFPRO',
                                            color: black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: -0.3,
                                          ),
                                        );
                                      }),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: AppStyle.lightGray2,
                                        ),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.add,
                                          size: 40,
                                          color: Colors.green,
                                        ),
                                        onPressed: () {
                                          final startingPrice =
                                              int.tryParse(
                                                widget.startingPrice,
                                              ) ??
                                              0;
                                          if (controller.highestBid.value +
                                                  bidState.amount <
                                              startingPrice) {
                                            ref
                                                .read(bidProvider.notifier)
                                                .setAmount(
                                                  startingPrice -
                                                      controller
                                                          .highestBid
                                                          .value,
                                                );
                                          } else {
                                            ref
                                                .read(bidProvider.notifier)
                                                .increment();
                                          }
                                        },
                                        // ref.read(bidProvider.notifier).increment(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        height05,

                        widget.isEnrolled == false
                            ? Column(
                                children: [
                                  height05,
                                  Text(
                                    'You need to enroll into this auction for bidding. If already enrolled, please wait for admin approval!'
                                        .tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  height05,
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        shape: WidgetStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                        backgroundColor:
                                            WidgetStateProperty.all(darkBlue),
                                      ),
                                      onPressed: () async {
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
                                                  'Profile Update Required'.tr,
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
                                                          checkPageID: 1,
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
                                                    child: Text('Cancel'.tr),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                          return;
                                        } else {
                                          auctionData.when(
                                            data: (data) {
                                              Get.off(
                                                () => RegistrationForBidders(
                                                  auctionID: widget.auctionID,
                                                  auctionName:
                                                      widget.auctionName,
                                                  auctionNumber:
                                                      widget.auctionNumber,
                                                  filePaymentterms:
                                                      widget.filePaymentterms,
                                                  guranteeAmount:
                                                      widget.guranteeAmount,
                                                  paymentTypes: [
                                                    data['group_info']?['can_online'] ??
                                                        true,
                                                    data['group_info']?['can_wallet'] ??
                                                        true,
                                                    data['group_info']?['can_offline'] ??
                                                        true,
                                                  ],
                                                ),
                                              );
                                            },
                                            error: (er, e) {},
                                            loading: () {},
                                          );
                                        }
                                      },
                                      child: Text(
                                        'Enroll'.tr,
                                        style: whiteStyle,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Row(
                                      //   children: [
                                      //     Checkbox(
                                      //       value: ref.watch(checkBox),
                                      //       onChanged: (value) {
                                      //         ref
                                      //                 .read(checkBox.notifier)
                                      //                 .state =
                                      //             value!;
                                      //       },
                                      //     ),
                                      //     Text(
                                      //       "I agree to the terms and conditions"
                                      //           .tr,
                                      //       style: TextStyle(
                                      //         color: AppStyle.darkGray,
                                      //         fontSize: 12,
                                      //         fontWeight: FontWeight.bold,
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),
                                    ],
                                  ),
                                  height05,

                                  //*Bidnow button--------------------------------------------------------------------------------------------------------------------------------
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: AppStyle.orangeGradient,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    width: double.infinity,
                                    child: InkWell(
                                      onTap: () async {
                                        if (controller.highestBid.value ==
                                            controller.highestBid.value +
                                                bidState.amount) {
                                          SnackbarHelperTop.showSnackBar(
                                            context,
                                            'Please bid more than the current price'
                                                .tr,
                                            color: const Color.fromARGB(
                                              255,
                                              179,
                                              24,
                                              24,
                                            ),
                                          );
                                          return;
                                        }

                                        // if (ref.watch(checkBox) == false) {
                                        //   SnackbarHelperTop.showSnackBar(
                                        //     context,
                                        //     'Please agree to the terms and conditions'
                                        //         .tr,
                                        //     color: const Color.fromARGB(
                                        //       255,
                                        //       179,
                                        //       24,
                                        //       24,
                                        //     ),
                                        //   );
                                        //   return;
                                        // }

                                        await bidController.bidNow(
                                          widget.auctionID,
                                          bidState.amount.toString(),
                                        );

                                        final hasExtendedTime = false.obs;
                                        final lastBidTime = DateTime.now().obs;

                                        if (bidController.success.value) {
                                          SnackbarHelperTop.showSnackBar(
                                            context,
                                            bidController.message.value,
                                            color: darkBlue,
                                          );

                                          final now = DateTime.now();
                                          final originalTimeLeft = auctionEnd
                                              .difference(now);
                                          final extendedTimeLeft =
                                              extraTimeLiveBid
                                                  .newExtraTime
                                                  .value
                                                  .difference(now);

                                          // Check if we're in the last 2 minutes of either original or extended time
                                          final isCriticalTime =
                                              (!hasExtendedTime.value &&
                                                  originalTimeLeft.inMinutes <
                                                      2) ||
                                              (hasExtendedTime.value &&
                                                  extendedTimeLeft.inSeconds <
                                                      10);

                                          if (isCriticalTime &&
                                              !hasExtendedTime.value) {
                                            // First time in last 2 minutes - extend immediately
                                            extraTimeLiveBid.extraTimeBid(
                                              widget.auctionID,
                                            );
                                            hasExtendedTime.value = true;
                                            lastBidTime.value = now;
                                          } else if (hasExtendedTime.value &&
                                              extendedTimeLeft.inSeconds < 10) {
                                            // In extended time with less than 10 seconds - extend again
                                            extraTimeLiveBid.extraTimeBid(
                                              widget.auctionID,
                                            );
                                            lastBidTime.value = now;
                                          }

                                          // Reset if the extended time has passed
                                          if (hasExtendedTime.value &&
                                              extendedTimeLeft.isNegative) {
                                            hasExtendedTime.value = false;
                                          }
                                        } else {
                                          if (context.mounted) {
                                            SnackbarHelper.showSnackBar(
                                              context,
                                              'Bid Failed'.tr,
                                              color: Colors.red,
                                            );
                                          }
                                        }

                                        ref
                                            .read(bidProvider.notifier)
                                            .resetStep();

                                        //
                                        controller.startFetchingTopBidders();

                                        await controller.fetchTopBidders(
                                          widget.auctionID,
                                        );

                                        ref.invalidate(countdownProviderLive);
                                        ref.invalidate(
                                          auctionAllDetailsResponseProvider(
                                            widget.auctionID,
                                          ),
                                        );

                                        debugPrint(
                                          'Bid Amount: ${bidState.amount}',
                                        );
                                      },
                                      child: Obx(
                                        () => bidController.loading.value
                                            ? SizedBox(
                                                height: 20,
                                                width: 20,
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 3,
                                                        color: white,
                                                      ),
                                                ),
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    'assets/bottomNavIcon/auction_outline.png',
                                                    height: 20,
                                                    color: white,
                                                  ),
                                                  SizedBox(width: 7),
                                                  Text(
                                                    'Bid Now'.tr,
                                                    style: whiteStyle.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'SFPRO',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ),
                                    ),
                                  ),
                                  // height10,
                                  // SizedBox(
                                  //   height: 20,
                                  //   child: Image.asset(
                                  //     'assets/icons/refresh_icon.png',
                                  //   ),
                                  // ),
                                ],
                              ),

                        //****---------------------------------------------------------------------------------- */
                        // Top Biddersh
                        height15,
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  // color: yelloAccent,
                                  gradient: LinearGradient(
                                    colors: AppStyle.lightGradient,
                                  ),
                                  border: Border.all(
                                    color: AppStyle.darkGolden,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 15,
                                          ),
                                          child: Text(
                                            "Top 3 Bidders".tr,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        width05,

                                        Image.asset(
                                          'assets/images/winner.png',
                                          width: 30,
                                        ),
                                      ],
                                    ),
                                    Consumer(
                                      builder: (context, ref, child) {
                                        final isExpanded = ref.watch(
                                          arrowDwnUp,
                                        );

                                        return IconButton(
                                          onPressed: () async {
                                            ref
                                                    .read(arrowDwnUp.notifier)
                                                    .state =
                                                !isExpanded;
                                          },
                                          icon: isExpanded
                                              ? Icon(
                                                  Icons.keyboard_arrow_up,
                                                  color: darkBlue,
                                                )
                                              : Icon(
                                                  Icons.keyboard_arrow_down,
                                                  color: darkBlue,
                                                ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            //refresh button---------------------------------------------------------------------------------------------------------------------------------------------------
                            InkWell(
                              onTap: () async {
                                try {
                                  // Invalidate the old provider to trigger disposal
                                  ref.invalidate(countdownProviderLive);
                                  ref.invalidate(
                                    auctionAllDetailsResponseProvider(
                                      widget.auctionID,
                                    ),
                                  );

                                  // Get fresh data
                                  final updatedData = await ref.read(
                                    auctionAllDetailsResponseProvider(
                                      widget.auctionID,
                                    ).future,
                                  );

                                  // Parse new dates
                                  final newRegStart =
                                      DateFormat("dd/MM/yyyy hh:mm:ss a").parse(
                                        "${updatedData['reg_start_date_ar']['date']} ${updatedData['reg_start_date_ar']['time']}",
                                      );
                                  final newRegEnd =
                                      DateFormat("dd/MM/yyyy hh:mm:ss a").parse(
                                        "${updatedData['reg_end_date_ar']['date']} ${updatedData['reg_end_date_ar']['time']}",
                                      );
                                  final newAuctionStart =
                                      DateFormat("dd/MM/yyyy hh:mm:ss a").parse(
                                        "${updatedData['start_date_ar']['date']} ${updatedData['start_date_ar']['time']}",
                                      );
                                  final newAuctionEnd =
                                      DateFormat("dd/MM/yyyy hh:mm:ss a").parse(
                                        "${updatedData['end_date_ar']['date']} ${updatedData['end_date_ar']['time']}",
                                      );

                                  // This will automatically create a new CountdownNotifierLive with fresh data
                                  ref.read(
                                    countdownProviderLive((
                                      newRegStart,
                                      newRegEnd,
                                      newAuctionStart,
                                      newAuctionEnd,
                                    )),
                                  );
                                } catch (e) {
                                  debugPrint('Refresh error: $e');
                                  // Optionally show error to user
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: AppStyle.lightGradient,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Icon(
                                    Icons.refresh_outlined,
                                    color: AppStyle.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // const SizedBox(height: 10),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                                return SizeTransition(
                                  sizeFactor: animation,
                                  child: child,
                                );
                              },
                          child: ref.watch(arrowDwnUp)
                              ? Column(
                                  children: [
                                    //* top bidders---------------------------------------
                                    height05,
                                    StreamBuilder<TopBiddersModel>(
                                      stream: controller.topBiddersStream,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return Text('');
                                        }
                                        if (!snapshot.hasData) {
                                          return Center(
                                            child: TopBidderSkeleton(),
                                          );
                                        }

                                        final model = snapshot.data!;
                                        final bidders = model.data;

                                        return Obx(() {
                                          return Column(
                                            children: List.generate(
                                              bidders.length > 3
                                                  ? 3
                                                  : bidders.length,
                                              (index) {
                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    topBidders(
                                                      index,
                                                      bidders,
                                                      controller.myUserID.value,
                                                      bidders.length,
                                                    ),
                                                    bidders.length > 3 &&
                                                            index == 2
                                                        ? InkWell(
                                                            onTap: () {
                                                              debugPrint(
                                                                'Navigating to AllTopBidders screen',
                                                              );

                                                              Get.to(
                                                                () => AllTopBidders(
                                                                  bidders:
                                                                      bidders,
                                                                  myUserid:
                                                                      controller
                                                                          .myUserID
                                                                          .value,
                                                                  length: bidders
                                                                      .length,
                                                                ),
                                                              );
                                                            },
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets.all(
                                                                    10.0,
                                                                  ),
                                                              child: Text(
                                                                "See all top bidders",
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : SizedBox(),
                                                  ],
                                                );
                                              },
                                            ),
                                          );
                                        });
                                      },
                                    ),
                                  ],
                                )
                              : SizedBox.shrink(),
                        ),
                      ],
                    ),

              height10,
            ],
          ),
        ),
      ),
    );
  }

  //top bidders widget=============================================================================================================================================

  InkWell topBidders(
    int index,
    List<BidData> bidders,
    int myUserId,
    int length,
  ) {
    final bidder = bidders[index];
    final isMyBidder = bidder.userId == myUserId;

    int? userPosition;
    for (int i = 0; i < bidders.length; i++) {
      if (bidders[i].userId == myUserId) {
        userPosition = i + 1;
        break;
      }
    }

    // Gradient colors for top 3
    final List<Gradient> rankGradients = [
      LinearGradient(
        colors: [Colors.orangeAccent, const Color.fromARGB(255, 242, 59, 4)],
      ),
      LinearGradient(colors: [Colors.grey.shade400, Colors.grey.shade600]),
      LinearGradient(colors: [Colors.brown.shade300, Colors.brown.shade500]),
    ];

    final gradient = (index < 3) ? rankGradients[index] : null;
    final badgeIcon = index == 0
        ? Icons.emoji_events
        : index == 1
        ? Icons.emoji_events_outlined
        : index == 2
        ? Icons.military_tech
        : null;

    return InkWell(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          gradient: gradient,
          color: gradient == null ? Colors.white : null,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.30),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Profile Circle
            CircleAvatar(
              radius: 20,
              backgroundColor: isMyBidder ? Colors.green : Colors.blueGrey,
              child: Icon(Icons.person, color: white),
            ),
            const SizedBox(width: 12),

            // Enroll Number & Rank
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bidder.enrollNumber ?? 'Unknown',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isMyBidder ? Colors.black : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: MediaQuery.of(context).size.width / 3.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: darkBlue,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (badgeIcon != null)
                            Icon(badgeIcon, size: 18, color: Colors.amber),
                          const SizedBox(width: 6),
                          Text(
                            isMyBidder
                                ? 'My Rank: ${userPosition ?? "-"}'
                                : 'Rank ${index + 1}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
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

            // Bid Amount
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isMyBidder ? Colors.green : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "${AmountFormate().currencyFormat(bidder.bidAmount.toString())} OMR",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isMyBidder ? Colors.white : Colors.black87,
                  fontSize: 14,
                ),
              ),
            ),
            width10,
          ],
        ),
      ),
    );
  }
}
