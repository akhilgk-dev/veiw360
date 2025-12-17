import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:view360/view/widgets/appbar_widget/appbar_widget.dart';

import '../../home/widgets/types_auctions/upcoming_auctions/upcoming_auction.dart';

class UpcomingAuctionDashboard extends StatelessWidget {
  const UpcomingAuctionDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(title: 'Upcoming Auctions'.tr),
      body: Padding(padding: EdgeInsets.all(8.0), child: UpcomingAuction()),
      // This is the part that is different from the other file
    );
  }
}
