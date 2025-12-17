import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:view360/api/active_auctions/active_auctions_api.dart';
import 'package:view360/common/text/text_static.dart';
import 'package:view360/model/active_auctions/active_auctions_model.dart';
import 'package:view360/view/home/home_page.dart';
import 'package:view360/view/widgets/appbar_widget/appbar_widget.dart';
import 'package:view360/view/widgets/empty_message/empty_message_widget.dart';
import 'package:view360/view/widgets/skeletonizer/list_homepage_skeleton.dart';

import '../../home/widgets/types_auctions/active_auctions/list_widgets.dart';

class ActiveAuctionDashboard extends ConsumerWidget {
  const ActiveAuctionDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final padding = screenWidth > 600 ? 27.0 : 10.0;
    final searchQuery = ref.watch(searchQueryProvider);

    final AsyncValue<AuctionResponse> activity = ref.watch(
      auctionResponseProvider,
    );

    return Scaffold(
      appBar: AppbarWidget(title: 'Active Auctions'.tr),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: activity.when(
          loading: () => ListWidgetSkeleton(),
          error: (error, stackTrace) =>
              Center(child: Image.asset(noInternetImage)),
          data: (auctionResponse) {
            final filteredAuctions = auctionResponse.auctionData!.where((
              auction,
            ) {
              final title = auction.groupName?.toLowerCase() ?? '';
              final query = searchQuery.toLowerCase();
              return title.contains(query);
            }).toList();

            if (filteredAuctions.isEmpty) {
              return EmptyMessageWidget(
                message: 'No Auctions Available right now'.tr,
              );
            }
            return ListWidget(
              auctionResponse: auctionResponse,

              padding: padding,
              screenWidth: screenWidth,
              screenHeight: screenHeight,
            );
          },
        ),
      ),
    );
  }
}
