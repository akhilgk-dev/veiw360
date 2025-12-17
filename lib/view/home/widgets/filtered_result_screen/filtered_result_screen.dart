import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:view360/api/auction_details_api/auction_details_all_api.dart';
import 'package:view360/api/filter_home_api.dart/filter_result_api.dart';
import 'package:view360/language/language_controller.dart';
import 'package:view360/view/auction_details/auction_details_page.dart';
import 'package:view360/view/home/controller/count_down.dart';
import 'package:view360/view/widgets/appbar_widget/appbar_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:view360/common/theme/colors.dart';
import 'package:view360/common/theme/sized_box.dart';
import 'package:view360/common/theme/style.dart';
import 'package:view360/view/widgets/skeletonizer/list_homepage_skeleton.dart';
import 'package:view360/view/widgets/token/token_checking.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../api/live_bidding_apis/user_validity_check.dart';
import '../../../../api/profile_details_api/profile_details_api.dart';
import '../../../enroll_live_bidding_screen/enroll_live_bidding_screen.dart';

class FilteredResultScreen extends ConsumerStatefulWidget {
  final int categoryID;
  final String? pageFrom;

  const FilteredResultScreen({
    required this.categoryID,
    this.pageFrom,
    super.key,
  });

  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  @override
  ConsumerState<FilteredResultScreen> createState() =>
      _FilteredResultScreenState();
}

class _FilteredResultScreenState extends ConsumerState<FilteredResultScreen> {
  final UserValidityCheckApi userValidityCheckApi = Get.put(
    UserValidityCheckApi(),
  );
  final LanguageController languageController = Get.find();
  final TokenCheckingState tokenCheckingState = Get.put(TokenCheckingState());
  final ProfileDetailsApi profiledetailsapi = Get.put(ProfileDetailsApi());
  final controller = Get.put(FilterResultController());

  final ScrollController _scrollController = ScrollController();
  int currentPage = 1;
  int minPage = 1;
  bool isLoadingMore = false;
  bool isLoadingPrev = false;

  @override
  void initState() {
    super.initState();
    controller.fetchAuctions(page: currentPage, categoryID: widget.categoryID);

    _scrollController.addListener(() async {
      // Fetch next page at bottom
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !isLoadingMore &&
          !controller.isLoading.value &&
          controller.hasMore.value) {
        setState(() => isLoadingMore = true);
        currentPage++;
        await controller.fetchAuctions(
          page: currentPage,
          categoryID: widget.categoryID,
          append: true,
        );
        setState(() => isLoadingMore = false);
      }

      // Fetch previous page at top
      if (_scrollController.position.pixels <= 100 &&
          !isLoadingPrev &&
          minPage > 1) {
        setState(() => isLoadingPrev = true);
        minPage--;
        double oldOffset = _scrollController.offset;
        int oldLength = controller.auctions.length;
        await controller.fetchAuctions(
          page: minPage,
          categoryID: widget.categoryID,
          prepend: true,
        );
        // Maintain scroll position after prepending
        WidgetsBinding.instance.addPostFrameCallback((_) {
          int newItems = controller.auctions.length - oldLength;
          double itemExtent = 160; // Approximate height of each item
          _scrollController.jumpTo(oldOffset + newItems * itemExtent);
        });
        setState(() => isLoadingPrev = false);
      }
    });
  }

  // @override
  // void dispose() {
  //   _scrollController.dispose();
  //   super.dispose();
  // }
  DateTime? tryParseDate(String pattern, String? dateStr) {
    if (dateStr == null || dateStr.trim().isEmpty) return null;
    try {
      return DateFormat(pattern).parse(dateStr);
    } catch (e) {
      print("Date parse error → pattern: $pattern | input: $dateStr\n$e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = languageController.selectedLanguage.value == 1;
    tokenCheckingState.checkToken();

    // Fetch data when screen loads
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   controller.fetchAuctions(
    //     page: 1,
    //     categoryID: widget.categoryID,
    //   );
    // });

    final profileData = ref.watch(auctionResponseProviderProfile);
    final useridEmailverifiedAt =
        profileData.asData?.value.data.emailVerifiedAt;
    final useridphoneverifiedAt =
        profileData.asData?.value.data.mobileVerifiedAt;

    return Scaffold(
      appBar: AppbarWidget(title: widget.pageFrom ?? 'Filtered Results'.tr),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() {
          // if (controller.isLoading.value) {
          //   ref.invalidate(countdownProvider);
          //   return ListWidgetSkeleton();
          // }

          if (controller.errorMessage.value.isNotEmpty) {
            return Center(child: Text(controller.errorMessage.value));
          }

          if (controller.auctions.isEmpty) {
            return ListWidgetSkeleton();
          }

          final activeAuctions = controller.auctions.where((auction) {
            return auction['status_label']['status'] == 'A' ||
                auction['status_label']['status'] == 'E';
          }).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${"Showing Auction:".tr} ${activeAuctions.length}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: darkBlue,
                  ),
                ),
              ),
              Divider(),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: activeAuctions.length + (isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == 0 && isLoadingPrev) {
                      // Loader at the top
                      return SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (index == activeAuctions.length) {
                      // Loader at the bottom (smaller size)
                      return const Center(
                        child: SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    }
                    final auction = activeAuctions[index];

                    final isActive = auction['status_label']['status'] == 'A';
                    final isEnded = auction['status_label']['status'] == 'E';
                    final regEndStr = auction['reg_end_date_ar'];
                    final regEnd = regEndStr != null
                        ? tryParseDate(
                            "dd/MM/yyyy hh:mm:ss a",
                            "${regEndStr['date']} ${regEndStr['time']}",
                          )
                        : null;

                    // final regEnd = DateFormat("dd/MM/yyyy hh:mm:ss a").parse(
                    //     "${auction['reg_end_date_ar']['date']} ${auction['reg_end_date_ar']['time']}");

                    //

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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            auction['images'][0]['image'] ?? '',
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
                                              const Icon(
                                                Icons.location_on,
                                                size: 12,
                                              ),
                                              const SizedBox(width: 2),
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
                                            children: [
                                              const Icon(
                                                Icons.timer,
                                                size: 14,
                                                color: Colors.black,
                                              ),
                                              const SizedBox(width: 4),
                                              Consumer(
                                                builder: (context, ref, child) {
                                                  // Safely construct reg start & end
                                                  final regDate =
                                                      auction['reg_start_date_ar'];
                                                  final regEndDate =
                                                      auction['reg_end_date_ar'];

                                                  final regStart =
                                                      (regDate != null)
                                                      ? tryParseDate(
                                                          "dd/MM/yyyy hh:mm:ss a",
                                                          "${regDate['date']} ${regDate['time']}",
                                                        )
                                                      : null;

                                                  final regEnd =
                                                      (regEndDate != null)
                                                      ? tryParseDate(
                                                          "dd/MM/yyyy hh:mm:ss a",
                                                          "${regEndDate['date']} ${regEndDate['time']}",
                                                        )
                                                      : null;

                                                  // Safely get auction start & end
                                                  final auctionStartStr =
                                                      auction['is_a_group'] ==
                                                          false
                                                      ? auction['start_date']
                                                      : auction['group_info']?['start_date'];

                                                  final auctionEndStr =
                                                      auction['is_a_group'] ==
                                                          false
                                                      ? auction['end_date']
                                                      : auction['group_info']?['end_date'];

                                                  final auctionStart =
                                                      tryParseDate(
                                                        "yyyy-MM-dd HH:mm:ss",
                                                        auctionStartStr,
                                                      );
                                                  final auctionEnd =
                                                      tryParseDate(
                                                        "yyyy-MM-dd HH:mm:ss",
                                                        auctionEndStr,
                                                      );

                                                  // Null check fallback
                                                  if ([
                                                    regStart,
                                                    regEnd,
                                                    auctionStart,
                                                    auctionEnd,
                                                  ].contains(null)) {
                                                    return const Expanded(
                                                      child: Text(
                                                        "Invalid or missing date",
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                    );
                                                  }

                                                  final countdown = ref.watch(
                                                    countdownProvider((
                                                      regStart!,
                                                      regEnd!,
                                                      auctionStart!,
                                                      auctionEnd!,
                                                    )),
                                                  );

                                                  return Expanded(
                                                    child: Text(
                                                      countdown,
                                                      style: smallFontSize12
                                                          .copyWith(
                                                            fontSize: 10,
                                                            color: isActive
                                                                ? Colors.green
                                                                : Colors.red,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Guarantee amount:'.tr,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                ),
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
                                        InkWell(
                                          onTap: () async {
                                            SharedPreferences prefs =
                                                await SharedPreferences.getInstance();
                                            final token = prefs.getString(
                                              'token',
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
                                                imageUrl:
                                                    auction['images'] ?? [],
                                                mainImage:
                                                    auction['main_image']
                                                        ?.toString() ??
                                                    'N/A',
                                              );
                                            });
                                          },
                                          child: Container(
                                            width: 50,
                                            decoration: BoxDecoration(
                                              color: darkBlue,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            padding: const EdgeInsets.all(8.0),
                                            child: const Icon(
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
                                const Divider(),
                                height05,

                                //------------------------------------------------
                                biddingButton(
                                  ref,
                                  auction,
                                  useridEmailverifiedAt,
                                  useridphoneverifiedAt,
                                  regEnd!,
                                  context,
                                  index,
                                  isActive,
                                  isEnded,
                                  auctionEnd,
                                  auctionStart,
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
        }),
      ),
    );
  }

  InkWell biddingButton(
    WidgetRef ref,
    auction,
    String? useridEmailverifiedAt,
    String? useridphoneverifiedAt,
    DateTime regEnd,
    BuildContext context,
    int index,
    bool isActive,
    bool isEnded,
    DateTime auctionEnd,
    DateTime auctionStart,
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

        //----------------------------------------
      },
      child: Container(
        decoration: BoxDecoration(
          color: isEnded
              ? darkBlue
              : isActive
              ? darkBlue
              : Colors.grey,
          borderRadius: BorderRadius.circular(10),
        ),
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isActive
                ? Icon(Icons.info_outline, color: white, size: 20)
                : Icon(Icons.info_outline, color: white, size: 20),
            width10,
            Text(
              isActive ? 'View details'.tr : 'View details'.tr,
              style: smallFontSize12.copyWith(color: isActive ? white : white),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> bidNowBottomSheetLive(
    BuildContext context,
    auctionData,
    DateTime auctionEnd,
    DateTime auctionStart,
  ) {
    return showModalBottomSheet(
      showDragHandle: true,
      scrollControlDisabledMaxHeightRatio: 225,
      context: context,
      builder: (context) {
        return EnrollLiveBiddingScreen(
          filePaymentterms: auctionData['file_payment_terms'],
          guranteeAmount: auctionData['guarantee_amount'],
          auctionNumber: auctionData['auction_number'],
          isEnrolled: auctionData['is_enrolled'] ?? false,
          auctionStart: auctionStart,
          auctionEndTime: auctionEnd,
          auctionID: auctionData['id'],
          incrementNumbers: auctionData['increment_numbers'],
          auctionName: languageController.selectedLanguage.value == 1
              ? auctionData['title_ar']
              : auctionData['title'].toString(),
          startingPrice: auctionData['start_amount'].toString(),
          countdown:
              "${auctionData['end_date_ar']['date']} ${auctionData['end_date_ar']['time']}",
        );
      },
    );
  }
}
