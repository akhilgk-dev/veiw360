import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:view360/api/active_auctions/active_auctions_api.dart';
import 'package:view360/common/text/text_static.dart';
import 'package:view360/model/active_auctions/active_auctions_model.dart';
import 'package:view360/view/home/widgets/types_auctions/active_auctions/active_auction.dart';
import 'package:view360/view/home/widgets/types_auctions/active_auctions/list_widgets.dart';
import 'package:view360/view/widgets/empty_message/empty_message_widget.dart';

class TodaysDeals extends ConsumerWidget {
  const TodaysDeals({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<AuctionResponse> activity = ref.watch(
      auctionResponseProvider,
    );
    return activity.when(
      data: (auctionResponse) {
        final filteredAuctions = auctionResponse.auctionData!.where((auction) {
          final title = auction.groupName?.toLowerCase() ?? '';
          // final query = searchQuery.toLowerCase();
          return title.contains("query");
        }).toList();

        if (filteredAuctions.isEmpty) {
          return EmptyMessageWidget(
            message: 'No Auctions Available right now'.tr,
          );
        }
        return Text("data");
      },
      error: (error, stackTrace) => Center(child: Image.asset(noInternetImage)),
      loading: () => CircularProgressIndicator(),
    );
  }
}
