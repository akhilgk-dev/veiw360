import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:view360/api/previus_auctions/previous_auction_api.dart';
import 'package:view360/common/text/text_static.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/common/theme/colors.dart';
import 'package:view360/model/active_auctions/active_auctions_model.dart';
import 'package:view360/view/home/widgets/types_auctions/active_auctions/list_widgets.dart';
import 'package:view360/view/search/search_and_viewall.dart';
import 'package:view360/view/widgets/empty_message/empty_message_widget.dart';
import 'package:view360/view/widgets/skeletonizer/list_homepage_skeleton.dart';
import '../../../home_page.dart';

class PreviousAuctions extends ConsumerWidget {
  const PreviousAuctions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(searchQueryProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth > 600 ? 27.0 : 10.0;
    final AsyncValue<AuctionResponse> activity = ref.watch(
      auctionResponseProviderPrevious,
    );
    return activity.when(
      data: (auctionPreviousData) {
        if (auctionPreviousData.auctionData!.isEmpty) {
          return const Center(child: Text('No Data Found'));
        }
        final filteredAuctions = auctionPreviousData.auctionData!.where((
          auction,
        ) {
          final title = auction.isAGroup == true
              ? auction.groupInfo!.groupName?.toLowerCase()
              : auction.title?.toLowerCase() ?? '';
          final query = searchQuery.toLowerCase();
          return title!.contains(query);
        }).toList();
        if (filteredAuctions.isEmpty) {
          return EmptyMessageWidget(
            message: 'No Auctions Available right now'.tr,
          );
        }
        return Container(
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Previous Auctions".tr,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () {
                        // Handle view all action
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchViewAll(),
                          ),
                        );
                      },
                      child: Text(
                        "View All".tr,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppStyle.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                ListWidget(
                  auctionResponse: auctionPreviousData,

                  padding: padding,
                  screenWidth: screenWidth,
                  screenHeight: MediaQuery.of(context).size.height,
                ),
                // ListWidgetPrevius(
                //   auctionResponse: PreviousAuctionModel(
                //     success: true,
                //     auctionData: filteredAuctions,
                //     message: 'Success',
                //   ),
                //   ref: ref,
                //   padding: padding,
                //   screenWidth: screenWidth,
                // ),
              ],
            ),
          ),
        );
      },
      error: (error, stackTrace) {
        return Center(
          child: Column(
            children: [Image.asset(noInternetImage), Text(error.toString())],
          ),
        );
      },
      loading: () => ListWidgetSkeleton(),
    );
  }
}
