import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/common/theme/sized_box.dart';

class ProjectSummary extends StatelessWidget {
  ProjectSummary({super.key});
  final List<String> items = [
    "Pending".tr,
    "Approved".tr,
    "Rejected".tr,
    "Fund Added".tr,
    "Fund Rejected".tr,
    "Finance Settled".tr,
    "Loading Started".tr,
    "Loading Completed".tr,
    "Completed".tr,
  ];
  final List<IconData> icons = [
    Icons.pending_actions,
    Icons.check_circle_outline,
    Icons.cancel_outlined,
    Icons.account_balance_wallet_outlined,
    Icons.money_off_csred_outlined,
    Icons.set_meal_outlined,
    Icons.local_shipping_outlined,
    Icons.verified_outlined,
    Icons.task_alt_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350, // Set the height for the horizontal grid
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two rows
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: .7, // Adjust the aspect ratio as needed
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 4.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    color: AppStyle
                        .colorsList[index % AppStyle.colorsList.length]
                        .withOpacity(0.1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icons[index],
                        size: 28.0,
                        color: AppStyle
                            .colorsList[index % AppStyle.colorsList.length],
                      ),
                      width05,
                      Text(
                        items[index],
                        style: const TextStyle(
                          fontSize: 19.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                height15,
                Text(
                  "OMR 34,000",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  "34   Auctions",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: AppStyle.darkGray,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
