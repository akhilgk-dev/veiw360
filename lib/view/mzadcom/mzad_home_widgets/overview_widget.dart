import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/model/mzad_overview/mzad_overvew_model.dart';
import 'package:view360/view/mzadcom/enrollments/enrolled_listing.dart';

class MzaccomOverview extends StatelessWidget {
  MzaccomOverview({super.key, required this.overviewData});
  MzadOverviewModel overviewData;
  List<String> items = [
    'Enrolled Bidders',
    'Strategy Enrolls',
    'Active Auctions',
    'Previous Auctions',
    'Total Winners',
  ];
  List<IconData> icons = [
    Icons.person_3_outlined,
    Icons.description_outlined,
    Icons.gavel_outlined,
    Icons.timer_outlined,
    Icons.star_outline,
  ];
  String getItemValue(int index) {
    switch (index) {
      case 0:
        return overviewData.enrollmentCount.toString();
      case 1:
        return overviewData.strategyCount.toString();
      case 2:
        return overviewData.runningAuctionCount.toString();
      case 3:
        return overviewData.previousAuctionCount.toString();
      case 4:
        return overviewData.totalWinnersCount.toString();
      default:
        return '0';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160, // Set the height for the horizontal scrolling widget
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length, // Number of cards
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => Get.to(EnrolledListingScreen()),
            child: Container(
              width: 160, // Set the width for each card
              margin: const EdgeInsets.symmetric(horizontal: 6.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 4.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppStyle.colorsList[index].withOpacity(0.1),
                      ),
                      child: Icon(
                        icons[index],
                        size: 38.0,
                        color: AppStyle.colorsList[index],
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      items[index],
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      getItemValue(index),
                      style: TextStyle(
                        fontSize: 24.0,
                        color: AppStyle.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
