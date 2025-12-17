import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:view360/api/active_auctions/active_auctions_api.dart';
import 'package:view360/api/auction_details_api/auction_details_all_api.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/common/theme/sized_box.dart';
import 'package:view360/language/language_controller.dart';
import 'package:view360/model/active_auctions/active_auctions_model.dart';
import 'package:view360/view/auction_details/auction_details_page.dart';
import 'package:view360/view/bidding_list/bidding_list.dart';
import 'package:view360/view/widgets/appbar_widget/appbar_widget.dart';
import 'package:view360/view/widgets/empty_message/empty_message_widget.dart';
import 'package:view360/view/widgets/skeletonizer/list_homepage_skeleton.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime? selectedDate;
  final LanguageController languageController = Get.find();

  @override
  Widget build(BuildContext context) {
    final AsyncValue<AuctionResponse> activity = ref.watch(
      auctionResponseProvider,
    );
    final language = languageController.selectedLanguage.value;

    return Scaffold(
      appBar: AppbarWidget(title: 'Auction Calendar'.tr),
      body: activity.when(
        loading: () => ListWidgetSkeleton(),
        error: (error, stackTrace) => Center(
          child: EmptyMessageWidget(message: "No Auctions Available right now"),
        ),
        data: (auctionResponse) {
          final auctions = auctionResponse.auctionData ?? [];
          if (auctions.isEmpty) {
            return Center(
              child: EmptyMessageWidget(
                message: "No Auctions Available right now",
              ),
            );
          }

          // Get first and last auction dates
          final dates =
              auctions
                  .where((a) => a.startDate != null)
                  .map((a) => DateTime.tryParse(a.startDate!))
                  .whereType<DateTime>()
                  .toList()
                ..sort();

          if (dates.isEmpty) {
            return Center(
              child: EmptyMessageWidget(
                message: "No Auctions Available right now",
              ),
            );
          }

          final firstDate = dates.first;
          final lastDate = dates.last;

          // Generate list of dates between first and last
          List<DateTime> dateList = [];
          for (
            DateTime d = firstDate;
            !d.isAfter(lastDate);
            d = d.add(Duration(days: 1))
          ) {
            dateList.add(d);
          }

          // Set default selected date
          final DateTime currentSelected = selectedDate ?? dateList.first;

          // Filter auctions for selected date
          final auctionsForSelectedDate = auctions.where((a) {
            if (a.startDate == null) return false;
            final date = DateTime.tryParse(a.startDate!);
            if (date == null) return false;
            return date.year == currentSelected.year &&
                date.month == currentSelected.month &&
                date.day == currentSelected.day;
          }).toList();

          return Column(
            children: [
              Directionality(
                textDirection: TextDirection.ltr,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  height: 80, // Increased height for month label
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: dateList.length,
                    itemBuilder: (context, index) {
                      final date = dateList[index];
                      final isSelected =
                          date.year == currentSelected.year &&
                          date.month == currentSelected.month &&
                          date.day == currentSelected.day;

                      // Check if the date has auctions
                      final hasAuctions = auctions.any((auction) {
                        if (auction.startDate == null) return false;
                        final auctionDate = DateTime.tryParse(
                          auction.startDate!,
                        );
                        if (auctionDate == null) return false;
                        return auctionDate.year == date.year &&
                            auctionDate.month == date.month &&
                            auctionDate.day == date.day;
                      });

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedDate = date;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(isSelected ? 8 : 6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: isSelected
                                          ? AppStyle.black
                                          : hasAuctions
                                          ? Colors
                                                .green // Color for dates with auctions
                                          : Colors.grey[200],
                                    ),
                                    child: Text(
                                      "${date.day}",
                                      style: TextStyle(
                                        color: isSelected || hasAuctions
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    _weekdayShort(date.weekday),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              Container(
                // margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppStyle.lightGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.18),
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.calendar,
                        color: AppStyle.liteRed,
                        size: 24,
                      ),
                      SizedBox(width: 14),
                      Text(
                        "${currentSelected.day.toString().padLeft(2, '0')} "
                        "${_monthName(currentSelected.month)} "
                        "${currentSelected.year.toString().substring(2)}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppStyle.black,
                          letterSpacing: 1.1,
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppStyle.liteRed.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _weekdayShort(currentSelected.weekday),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: AppStyle.liteRed,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: auctionsForSelectedDate.isEmpty
                    ? Center(
                        child: EmptyMessageWidget(
                          message: "No Auctions for this date",
                          textcolor: AppStyle.secondary,
                        ),
                      )
                    : ListView.builder(
                        itemCount: auctionsForSelectedDate.length,
                        itemBuilder: (context, index) {
                          final auction = auctionsForSelectedDate[index];
                          return InkWell(
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
                                          auction.images?.first['image']
                                              ?.toString() ??
                                          '',
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Card(
                              margin: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(
                                          Icons.gavel,
                                          color: AppStyle.liteRed,
                                          size: 20,
                                        ),
                                        width05,
                                        Expanded(
                                          child: Text(
                                            language == 1
                                                ? auction.isAGroup == true
                                                      ? auction
                                                                .groupInfo
                                                                ?.groupNameAr ??
                                                            ''
                                                      : auction.titleAr ?? ''
                                                : auction.isAGroup == true
                                                ? auction
                                                          .groupInfo
                                                          ?.groupName ??
                                                      ''
                                                : auction.title ?? '',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: AppStyle.primary,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),

                                        Icon(
                                          CupertinoIcons.clock,
                                          size: 18,
                                          color: AppStyle.darkGray,
                                        ),
                                        width05,
                                        Text(
                                          _getTimeOnly(auction.startDate),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppStyle.darkGray,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${"Guarantee amount:".tr} ${auction.guaranteeAmount ?? '0'}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: AppStyle.darkGolden,
                                          ),
                                        ),
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
                                                        groupName: language == 1
                                                            ? auction
                                                                  .groupNameAr
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
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 15,
                                              vertical: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              gradient: LinearGradient(
                                                colors:
                                                    AppStyle.bidButtonGradient,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "View details".tr,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                width10,
                                                Icon(
                                                  Icons.info_outline,
                                                  size: 16,
                                                  color: Colors.white,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        // Text(
                                        //   "${"Client".tr}: ${auction. ?? 'N/A'}",
                                        //   style: TextStyle(
                                        //     fontSize: 14,
                                        //     color: Colors.grey[600],
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ],
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
      ),
    );
  }

  String _weekdayShort(int weekday) {
    switch (weekday) {
      case 1:
        return "MON";
      case 2:
        return "TUE";
      case 3:
        return "WED";
      case 4:
        return "THU";
      case 5:
        return "FRI";
      case 6:
        return "SAT";
      case 7:
        return "SUN";
      default:
        return "";
    }
  }

  String _monthName(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return months[month - 1];
  }

  String _getTimeOnly(String? dateTimeString) {
    if (dateTimeString == null) return '';
    final dt = DateTime.tryParse(dateTimeString);
    if (dt == null) return '';
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
