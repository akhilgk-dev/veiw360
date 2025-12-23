import 'package:flutter/material.dart';
import 'package:view360/common/theme/app_style.dart';

class MzaccomOverview extends StatelessWidget {
  MzaccomOverview({super.key});
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160, // Set the height for the horizontal scrolling widget
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length, // Number of cards
        itemBuilder: (context, index) {
          return Container(
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
                      size: 48.0,
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
                    "34",
                    style: TextStyle(
                      fontSize: 28.0,
                      color: AppStyle.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
