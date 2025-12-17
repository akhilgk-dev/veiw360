import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:view360/api/active_auctions/active_auctions_api.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/common/theme/colors.dart';
import 'package:view360/common/theme/sized_box.dart';
import 'package:view360/model/active_auctions/active_auctions_model.dart';
import 'package:view360/view/widgets/skeletonizer/list_homepage_skeleton.dart';
import '../../../../widgets/empty_message/empty_message_widget.dart';
import '../../../home_page.dart';
import 'list_widgets.dart';

class ActiveAuctions extends ConsumerWidget {
  const ActiveAuctions({super.key, required this.title, this.isToday = false});
  final String title;
  final bool isToday;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final padding = screenWidth > 600 ? 27.0 : 10.0;
    final searchQuery = ref.watch(searchQueryProvider);

    final AsyncValue<AuctionResponse> activity = ref.watch(
      auctionResponseProvider,
    );

    return activity.when(
      loading: () => ListWidgetSkeleton(),
      error: (error, stackTrace) => Padding(
        padding: const EdgeInsets.all(17.0),
        child: Center(
          child: EmptyMessageWidget(
            message: "No Auctions Available right now".tr,
          ),
        ),
      ),
      data: (auctionResponse) {
        final filteredAuctions = isToday
            ? auctionResponse.auctionData!.where((auction) {
                if (auction.endDate == null || auction.startDate == null)
                  return false;

                final startDate = DateTime.tryParse(auction.startDate!);
                final endDate = DateTime.tryParse(auction.endDate!);
                if (startDate == null || endDate == null) return false;

                final now = DateTime.now();
                final isEndingToday =
                    endDate.year == now.year &&
                    endDate.month == now.month &&
                    endDate.day == now.day;

                final isStartingToday =
                    startDate.year == now.year &&
                    startDate.month == now.month &&
                    startDate.day == now.day;

                return (isStartingToday || isEndingToday) &&
                    endDate.isAfter(now); // Ensure it's still active
              }).toList()
            : auctionResponse.auctionData!.where((auction) {
                final title = auction.isAGroup == true
                    ? auction.groupInfo!.groupName?.toLowerCase()
                    : auction.title?.toLowerCase() ?? '';
                final query = searchQuery.toLowerCase();
                return title!.contains(query);
              }).toList();

        if (filteredAuctions.isEmpty) {
          return isToday
              ? SizedBox()
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Spacer(),
                          Text(
                            '${filteredAuctions.length} ${'Auctions'.tr}',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppStyle.darkGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                    EmptyMessageWidget(
                      message: 'No Auctions Available right now'.tr,
                    ),
                  ],
                );
        }
        return Container(
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              height10,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Spacer(),
                    Text(
                      '${filteredAuctions.length} ${'Auctions'.tr}',
                      style: TextStyle(fontSize: 14, color: AppStyle.darkGray),
                    ),
                    width05,
                    GestureDetector(
                      onTap: () {
                        ref.invalidate(auctionResponseProvider);
                      },
                      child: Icon(
                        Icons.refresh_outlined,
                        color: Colors.black54,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              ListWidget(
                auctionResponse: AuctionResponse(
                  auctionData: filteredAuctions,
                  success: true,
                  message: 'Success',

                  // Add other required fields with appropriate values if needed
                ),

                padding: padding,
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              ),
            ],
          ),
        );
      },
    );
  }
}
