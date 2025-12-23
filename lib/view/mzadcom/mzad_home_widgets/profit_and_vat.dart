import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:view360/common/theme/app_style.dart';

class ProfitAndVat extends StatelessWidget {
  ProfitAndVat({super.key});
  final List<String> items = [
    'Service Cahrge'.tr,
    'Service Charge VAT'.tr,
    'Bid Amount VAT'.tr,
  ];
  final List<IconData> icons = [
    Icons.account_balance_wallet,
    Icons.receipt_long,
    Icons.monetization_on_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 3, // Example item count
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 4.0,
          child: ListTile(
            leading: Icon(
              icons[index],
              color: AppStyle.colorsList[index % AppStyle.colorsList.length],
              size: 40,
            ),
            title: Text(
              items[index],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Last 30 days'.tr),
                Container(
                  margin: EdgeInsets.only(left: 6),
                  padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                  decoration: BoxDecoration(
                    color: AppStyle.liteRed.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Text(
                    '100% '.tr,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: AppStyle.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${(index + 1) * 10000}', // Example amount
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: AppStyle.darkGray,
                  ),
                ),
                Text(
                  "  OMR",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppStyle.darkGray,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
