import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:view360/api/previus_auctions/previous_auction_api.dart';
import 'package:view360/view/home/widgets/types_auctions/active_auctions/active_auction.dart';
import 'package:view360/view/home/widgets/types_auctions/previus_auctions/previous_action.dart';
import 'package:view360/view/widgets/skeletonizer/list_homepage_skeleton.dart';

class TestingScreen extends ConsumerWidget {
  const TestingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final response = ref.watch(auctionResponseProviderPrevious);
    return Scaffold(
      body: Column(children: [ListWidgetSkeleton(), PreviousAuctions()]),
    );
  }
}
