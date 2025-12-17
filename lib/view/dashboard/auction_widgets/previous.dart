import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:view360/view/home/widgets/types_auctions/previus_auctions/previous_action.dart';
import 'package:view360/view/widgets/appbar_widget/appbar_widget.dart';

class PreviousAuctionDashboard extends StatelessWidget {
  const PreviousAuctionDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(title: 'Previous Auctions'.tr),
      body: PreviousAuctions(),
    );
  }
}
