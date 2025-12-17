import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:view360/api/winning_bids.dart/winning_bids_api.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/common/theme/sized_box.dart';
import 'package:view360/common/utils/formatter/amount_formate.dart';
import 'package:view360/view/widgets/appbar_widget/appbar_widget.dart';
import 'package:view360/view/widgets/skeletonizer/list_homepage_skeleton.dart';

class WinningBidsScreen extends StatefulWidget {
  const WinningBidsScreen({super.key});

  @override
  State<WinningBidsScreen> createState() => _WinningBidsScreenState();
}

class _WinningBidsScreenState extends State<WinningBidsScreen> {
  final winningBidsApi = Get.put(WinningBidsApi());
  @override
  void initState() {
    winningBidsApi.fetchWinningbids();
    super.initState();
  }

  String approvalStatus(String status) {
    switch (status) {
      case 'A':
        return 'Approved'.tr;
      case 'NU':
        return 'Pending'.tr;
      case 'R':
        return 'Rejected'.tr;
      default:
        return 'Pending'.tr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(title: 'Winning Auctions'.tr),
      body: Obx(() {
        if (winningBidsApi.isLoading.value) {
          return const Center(child: ListSkeleton());
        } else {
          if (winningBidsApi.responseData == null ||
              winningBidsApi.responseData['data'].isEmpty) {
            return Center(child: Text('No winning bids found.'.tr));
          } else {
            final auctions = winningBidsApi.responseData['data'];
            return ListView.builder(
              itemCount: auctions.length,
              itemBuilder: (context, index) {
                final auction = auctions[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  child: InkWell(
                    onTap: () {
                      // Add navigation or action logic here
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.lightBlue.withValues(
                                          alpha: 0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.gavel_outlined,
                                            size: 14,
                                            color: AppStyle.darkGolden,
                                          ),
                                          width05,
                                          Expanded(
                                            child: Text(
                                              auction['title'] ?? 'No Title',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${"Client".tr}: ${auction['organization_name'] ?? 'N/A'}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppStyle.gray,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              width10,
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blueAccent,
                                      Colors.lightBlueAccent,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      "Total Payable".tr,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      AmountFormate().withDecimal(
                                        (auction['total_amount'] ?? "0.0"),
                                      ),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '${'Client Approved'.tr}: ',
                                style: const TextStyle(
                                  color: AppStyle.darkGolden,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                  horizontal: 14.0,
                                ),
                                decoration: BoxDecoration(
                                  color: auction['approve_status'] == 'A'
                                      ? Colors.green
                                      : auction['approve_status'] == 'NU'
                                      ? Colors.lightBlueAccent
                                      : auction['approve_status'] == 'R'
                                      ? Colors.redAccent
                                      : Colors.blueGrey,

                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(width: 5),
                                    Text(
                                      approvalStatus(
                                        auction['approve_status'] ?? "NU",
                                      ),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${"Paid".tr}: ${AmountFormate().withDecimal((auction['paid_amount']))}',
                                    style: TextStyle(color: AppStyle.liteRed),
                                  ),
                                  Text(
                                    '${"Balance".tr}: ${AmountFormate().withDecimal(auction['balance_amount'])}',
                                    style: TextStyle(color: AppStyle.darkGray),
                                  ),
                                ],
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
      }),
    );
  }
}
