import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:view360/common/theme/app_style.dart';

class WalletSummery extends StatelessWidget {
  WalletSummery({super.key});
  final List<String> items = [
    'Client Due'.tr,
    'Hold'.tr,
    'Withdrawal Request'.tr,
    'Balance'.tr,
  ];

  final List<IconData> icons = [
    Icons.account_balance_wallet_outlined,
    Icons.lock_outline,
    Icons.request_page_outlined,
    Icons.account_balance_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Two cards per row
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        childAspectRatio: 1,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 4.0,
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: AppStyle.colorsList[index % AppStyle.colorsList.length]
                  .withOpacity(0.2),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    icons[index],
                    size: 40,
                    color:
                        AppStyle.colorsList[index % AppStyle.colorsList.length],
                  ),
                  Text(
                    items[index],
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${(index + 1) * 5000}', // Example amount
                        style: TextStyle(
                          fontSize: 24.0,
                          color: AppStyle.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        " OMR".tr,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: AppStyle.darkGray,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
