import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:view360/api/auction_details_api/auction_details_all_api.dart';
import 'package:view360/api/bidding_list/bidding_list_api.dart';
import 'package:view360/api/bidding_list/enrolled_users_count_api.dart';
import 'package:view360/api/profile_details_api/profile_details_api.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/common/theme/colors.dart';
import 'package:view360/common/theme/constants.dart';
import 'package:view360/common/utils/formatter/amount_formate.dart';
import 'package:view360/language/language_controller.dart';
import 'package:view360/main.dart';
import 'package:view360/view/auction_details/auction_details_page.dart';
import 'package:view360/view/widgets/appbar_widget/appbar_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:view360/common/theme/sized_box.dart';
import 'package:view360/common/theme/style.dart';
import 'package:view360/view/widgets/token/token_checking.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../home/controller/count_down.dart';

final searchProvider = StateProvider<String>((ref) => '');

class BiddingList extends ConsumerStatefulWidget {
  final String? whichPage;
  final String? groupId;
  final String check;
  final String groupName;

  const BiddingList({
    super.key,
    required this.check,
    this.groupId,
    required this.groupName,
    this.whichPage,
  });

  //-------------
  @override
  ConsumerState<BiddingList> createState() => _BiddingListState();
}

class _BiddingListState extends ConsumerState<BiddingList> with RouteAware {
  //search controller-----------------------------------------------------

  final searchController = TextEditingController();
  final TokenCheckingState tokenCheckingState = Get.put(TokenCheckingState());
  final LanguageController languageController = Get.put(LanguageController());
  final bool refresh = false;
  bool _hasRunInitialLogic = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tokenCheckingState.checkToken();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasRunInitialLogic) {
      routeObserver.subscribe(this, ModalRoute.of(context)!);
      _hasRunInitialLogic = true;
      _runOneTimeLogic(); // first time
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  void _runOneTimeLogic() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(auctionResponseGroup(int.parse(widget.groupId!)));
    });

    print('Refreshed once on first appearance');
  }

  // Called when user navigates **back to this screen**
  @override
  void didPopNext() {
    if (widget.groupId == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(auctionResponseGroup(int.parse(widget.groupId!)));
    });

    print('Refreshed on return to screen');
  }

  String countDownDigit(String datetime, int ind) {
    List<String> parts = datetime.split(' ');

    if (ind >= parts.length) {
      return "0";
    }
    return parts[ind];
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = languageController.selectedLanguage.value == 1;

    final auctionResponse = tokenCheckingState.token.value == ''
        ? ref.watch(auctionResponseGroupGuest(int.parse(widget.groupId!)))
        : ref.watch(auctionResponseGroup(int.parse(widget.groupId!)));

    final enrollCount = ref.watch(
      auctionEnrollCount(int.parse(widget.groupId!)),
    );

    return Scaffold(
      backgroundColor: AppStyle.scaffoldBg,
      appBar: widget.check == 'true'
          ? AppbarWidget(title: widget.groupName.tr)
          : AppbarWidgetWithoutBackButton(title: widget.groupName.tr),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: auctionResponse.when(
            data: (auctions) {
              if (auctions['data'].isEmpty) {
                return Center(child: Text('No auctions available.'.tr));
              }
              final searchQuery = ref.watch(searchProvider).toLowerCase();

              // Apply search filter BEFORE building the list
              final allAuctions = auctions['data'] as List;

              // Filter auctions based on search query
              final filteredAuctions = allAuctions.where((auction) {
                final title = (auction['title'] ?? '').toString().toLowerCase();
                final titleAr = (auction['title_ar'] ?? '')
                    .toString()
                    .toLowerCase();
                return title.contains(searchQuery) ||
                    titleAr.contains(searchQuery);
              }).toList();

              // final regStart = DateTime(0);

              // final regEnd = DateFormat("yyyy/MM/dd HH:mm:ss").parse(
              //     "${auctions['data'][0]['group_info']['reg_end_date'].replaceAll('-', '/')}");

              // final auctionStart = DateTime(0);

              // final auctionEnd = DateTime(0);

              // final countdown = ref.watch(countdownProvider(
              //   (regStart, regEnd, auctionStart, auctionEnd),
              // ));

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: AppStyle.bidButtonGradient,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      border: Border.all(
                        color: Colors.grey.withAlpha(50),
                        width: 0.8,
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 45,
                          child: TextFormField(
                            controller: searchController,
                            onChanged: (value) {
                              ref.read(searchProvider.notifier).state = value;
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              hintText: 'Search for products'.tr,
                              hintStyle: TextStyle(fontSize: 12),
                              alignLabelWithHint: true,
                              contentPadding: EdgeInsets.all(7),
                              filled: true,
                              fillColor: white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(50),
                                  right: Radius.circular(50),
                                ),
                                borderSide: BorderSide(
                                  color: grey100 ?? Colors.grey,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(50),
                                  right: Radius.circular(50),
                                ),
                                borderSide: BorderSide(
                                  color: grey100 ?? Colors.grey,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(7),
                                ),
                                borderSide: BorderSide(color: Colors.red),
                              ),
                            ),
                          ),
                        ),
                        height10,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: white,
                                  child: Icon(
                                    Icons.gavel,
                                    color: AppStyle.darkGolden,
                                    size: 25,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  '${"Enrolled users:".tr}:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: white,
                                  ),
                                ),
                                enrollCount.when(
                                  data: (auction) {
                                    final count =
                                        auctions['meta']['enrolledUsers'];

                                    // final previousCount = auction['data']
                                    //   .where((item) => item['auction']['status'] == 'E')
                                    //   .length;

                                    final enrolledText = '$count';
                                    //  : '${"Enrolled users:".tr}: $previousCount'.tr;

                                    return RichText(
                                      text: TextSpan(
                                        text: enrolledText,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: white,
                                        ),
                                      ),
                                    );
                                  },
                                  loading: () =>
                                      Skeletonizer(child: Text('Enr 1')),
                                  error: (error, stackTrace) => Text(
                                    '',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),

                            Column(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: white,
                                  child: Icon(
                                    Icons.schedule,
                                    color: AppStyle.darkGolden,
                                    size: 25,
                                  ),
                                ),
                                SizedBox(height: 5),
                                RichText(
                                  textWidthBasis: TextWidthBasis.longestLine,
                                  text: TextSpan(
                                    text: '${"Reg start:".tr}  '.tr,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: white,
                                    ),
                                    children: [],
                                  ),
                                ),
                                Text(
                                  '${auctions['data'][0]['group_info']['reg_start_date']}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: white,
                                  child: Icon(
                                    Icons.timer_off_outlined,
                                    color: AppStyle.darkGolden,
                                    size: 25,
                                  ),
                                ),
                                SizedBox(height: 5),
                                RichText(
                                  text: TextSpan(
                                    text: '${"Reg End:".tr}  '.tr,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: white,
                                    ),
                                    children: [],
                                  ),
                                ),
                                Text(
                                  '${auctions['data'][0]['group_info']['reg_end_date']}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: filteredAuctions.isEmpty
                        ? Center(child: Text("No result"))
                        : ListView.builder(
                            itemCount: filteredAuctions.length,
                            itemBuilder: (context, index) {
                              final auction = filteredAuctions[index];

                              final regStart =
                                  DateFormat("dd/MM/yyyy hh:mm:ss a").parse(
                                    "${auction['reg_start_date_ar']['date']} ${auction['reg_start_date_ar']['time']}",
                                  );

                              final regEnd = DateFormat("dd/MM/yyyy hh:mm:ss a")
                                  .parse(
                                    "${auction['reg_end_date_ar']['date']} ${auction['reg_end_date_ar']['time']}",
                                  );

                              final auctionStart =
                                  DateFormat("dd/MM/yyyy hh:mm:ss a").parse(
                                    "${auction['start_date_ar']['date']} ${auction['start_date_ar']['time']}",
                                  );

                              final auctionEnd =
                                  DateFormat("dd/MM/yyyy hh:mm:ss a").parse(
                                    "${auction['end_date_ar']['date']} ${auction['end_date_ar']['time']}",
                                  );

                              final countdown = ref.watch(
                                countdownProvider((
                                  regStart,
                                  regEnd,
                                  auctionStart,
                                  auctionEnd,
                                )),
                              );

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
                                      auctionResponseProviderProfile,
                                    );
                                    ref.invalidate(
                                      auctionAllDetailsResponseProvider(
                                        auction['id'],
                                      ),
                                    );

                                    Get.to(() {
                                      return AuctionDetailsPage(
                                        index: index,
                                        token: token ?? '',
                                        auctionId: auction['id'],
                                        imageUrl: auction['images'] ?? [],
                                        mainImage:
                                            auction['images'][0]['image']
                                                ?.toString() ??
                                            'N/A',
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
                                        color: white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          (auction['images'] !=
                                                                  null &&
                                                              auction['images']
                                                                  .isNotEmpty)
                                                          ? auction['images']
                                                                .first['image']
                                                          : '',
                                                      height: 100,
                                                      width: 110,
                                                      fit: BoxFit.cover,
                                                      errorWidget:
                                                          (
                                                            context,
                                                            url,
                                                            error,
                                                          ) => Container(
                                                            color: Colors
                                                                .grey[200],
                                                            height: 100,
                                                            width: 110,
                                                            child: const Icon(
                                                              Icons.image,
                                                              size: 50,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                    ),
                                                  ),
                                                  height10,
                                                  if (countDownDigit(
                                                        countdown,
                                                        1,
                                                      ) ==
                                                      "Ended")
                                                    Container(
                                                      padding: EdgeInsets.all(
                                                        3,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                        border: Border.all(
                                                          color: Colors.grey
                                                              .withAlpha(50),
                                                          width: 0.8,
                                                        ),
                                                        gradient:
                                                            LinearGradient(
                                                              colors: AppStyle
                                                                  .redGradient,
                                                            ),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .timer_outlined,
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
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                ],
                                              ),
                                              width10,
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      isArabic
                                                          ? auction['title_ar']
                                                          : auction['title'] ??
                                                                'No Title'.tr,
                                                      style: smallFontSize12
                                                          .copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: darkBlue,
                                                          ),
                                                    ),
                                                    height05,
                                                    Text(
                                                      auction['auction_number'] ??
                                                          'Unknown ID'.tr,
                                                      style: smallFontSize12
                                                          .copyWith(
                                                            color: darkBlue,
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                                              ? auction['location_ar'] ??
                                                                    'N/A'.tr
                                                              : auction['location'] ??
                                                                    'N/A'.tr,
                                                          style:
                                                              smallFontSize12,
                                                        ),
                                                      ],
                                                    ),
                                                    height05,

                                                    // Row(
                                                    //   mainAxisAlignment:
                                                    //       MainAxisAlignment
                                                    //           .spaceBetween,
                                                    //   children: [
                                                    //     Expanded(
                                                    //       child: Row(
                                                    //         children: [
                                                    //           const Icon(
                                                    //             Icons.timer,
                                                    //             size: 14,
                                                    //             color:
                                                    //                 Colors.black,
                                                    //           ),
                                                    //           const SizedBox(
                                                    //             width: 4,
                                                    //           ),
                                                    //           Expanded(
                                                    //             child: Text(
                                                    //               countdown,
                                                    //               style: smallFontSize12.copyWith(
                                                    //                 color:
                                                    //                     auction['status'] ==
                                                    //                         'A'
                                                    //                     ? Colors
                                                    //                           .green
                                                    //                     : Colors
                                                    //                           .red,
                                                    //                 fontWeight:
                                                    //                     FontWeight
                                                    //                         .bold,
                                                    //               ),
                                                    //             ),
                                                    //           ),
                                                    //         ],
                                                    //       ),
                                                    //     ),
                                                    //   ],
                                                    // ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Guarantee amount:'
                                                              .tr,
                                                          style: TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            '${AmountFormate().currencyFormat(auction['guarantee_amount'] ?? "0.0")} OMR',
                                                            style: smallFontSize12
                                                                .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
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
                                                      style: smallFontSize12
                                                          .copyWith(
                                                            color: white,
                                                          ),
                                                    ),
                                                  ),
                                                  height25,
                                                  RichText(
                                                    text: TextSpan(
                                                      text: AmountFormate()
                                                          .currencyFormat(
                                                            auction['current_amount']
                                                                    .toString() ??
                                                                '0.0',
                                                          ),
                                                      style: smallFontSize12
                                                          .copyWith(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: darkBlue,
                                                          ),
                                                      children: [
                                                        TextSpan(
                                                          text: ' OMR',
                                                          style: smallFontSize12
                                                              .copyWith(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: darkBlue,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  // height05,
                                                  // InkWell(
                                                  //   onTap: () async {
                                                  //     ref.invalidate(
                                                  //       auctionAllDetailsResponseProvider(
                                                  //         auction['id'],
                                                  //       ),
                                                  //     );

                                                  //     SharedPreferences prefs =
                                                  //         await SharedPreferences.getInstance();
                                                  //     final token = prefs
                                                  //         .getString('token');

                                                  //     Get.to(
                                                  //       () => AuctionDetailsPage(
                                                  //         index: index,
                                                  //         token: token ?? '',
                                                  //         auctionId:
                                                  //             auctions['data'][index]['id'],
                                                  //         imageUrl:
                                                  //             auctions['data'][index]['images'] ??
                                                  //             [],
                                                  //         mainImage:
                                                  //             auctions['data'][index]['main_image']
                                                  //                 ?.toString() ??
                                                  //             'N/A',
                                                  //       ),
                                                  //     );
                                                  //   },
                                                  //   child: Container(
                                                  //     width: 50,
                                                  //     decoration: BoxDecoration(
                                                  //       color: darkBlue,
                                                  //       borderRadius:
                                                  //           BorderRadius.circular(
                                                  //             5,
                                                  //           ),
                                                  //     ),
                                                  //     child: Padding(
                                                  //       padding:
                                                  //           const EdgeInsets.all(
                                                  //             8.0,
                                                  //           ),
                                                  //       child: Icon(
                                                  //         Icons.info_outline,
                                                  //         color: white,
                                                  //         size: 15,
                                                  //       ),
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          height05,
                                          if (countDownDigit(countdown, 1) !=
                                              "Ended")
                                            Container(
                                              padding: EdgeInsets.all(3),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: Colors.grey.withAlpha(
                                                    50,
                                                  ),
                                                  width: 0.8,
                                                ),
                                                gradient: LinearGradient(
                                                  colors:
                                                      (countDownDigit(
                                                            countdown,
                                                            1,
                                                          ) ==
                                                          "Ended")
                                                      ? AppStyle.redGradient
                                                      : [
                                                          Color(0xFF189397),
                                                          Color(0xFF4fc1c0),
                                                        ],
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  width10,

                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
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
                                                  width10,

                                                  if (countDownDigit(
                                                        countdown,
                                                        1,
                                                      ) !=
                                                      "Ended")
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
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
                                                                  EdgeInsets.all(
                                                                    6,
                                                                  ),
                                                              margin:
                                                                  EdgeInsets.only(
                                                                    right: 12,
                                                                    top: 4,
                                                                  ),
                                                              decoration: BoxDecoration(
                                                                color: AppStyle
                                                                    .white
                                                                    .withAlpha(
                                                                      100,
                                                                    ),
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
                                                                    fontSize:
                                                                        14,
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
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      }),
                                                    ),
                                                  height05,
                                                ],
                                              ),
                                            ),
                                          SizedBox(height: 2),
                                          Divider(),
                                          height05,
                                          InkWell(
                                            onTap: () async {
                                              SharedPreferences prefs =
                                                  await SharedPreferences.getInstance();
                                              final token = prefs.getString(
                                                'token',
                                              );
                                              ref.invalidate(
                                                auctionResponseProviderProfile,
                                              );
                                              ref.invalidate(
                                                auctionAllDetailsResponseProvider(
                                                  auction['id'],
                                                ),
                                              );

                                              //-----------------

                                              //-----------------
                                              print(
                                                'Auction ID: ${auction['id']}',
                                              );

                                              Get.to(
                                                () => AuctionDetailsPage(
                                                  index: index,
                                                  token: token ?? '',
                                                  auctionId: auction['id'],
                                                  imageUrl:
                                                      auction['images'] ?? [],
                                                  mainImage:
                                                      auction['images'][0]['image']
                                                          ?.toString() ??
                                                      'N/A',
                                                ),
                                              );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                gradient: LinearGradient(
                                                  colors: AppStyle
                                                      .bidButtonGradient,
                                                ),
                                              ),
                                              height: 40,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.info_outline,
                                                    color: white,
                                                    size: 20,
                                                  ),
                                                  width10,
                                                  Text(
                                                    'View details'.tr,
                                                    style: smallFontSize12
                                                        .copyWith(color: white),
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
                  ),
                ],
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
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset('assets/images/no_msg.gif'),
                  ),
                  height20,
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        error.toString(),
                        style: TextStyle(color: Colors.red),
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
  }

  Widget coveringContainer(String text1, String text2) {
    return Container(
      padding: EdgeInsets.all(3),

      /// width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withAlpha(50), width: 0.8),
      ),
      child: Row(
        children: [
          Text(
            '$text1 $text2',
            style: smallFontSize12.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          Text(
            text2,
            style: smallFontSize12.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
