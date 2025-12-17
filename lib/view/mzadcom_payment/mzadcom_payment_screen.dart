import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:view360/api/mzadcom_payment/mzadcom_payment_api.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/common/theme/colors.dart';
import 'package:view360/common/theme/sized_box.dart';
import 'package:view360/common/utils/formatter/amount_formate.dart';
import 'package:view360/model/mzadcom_payment/mzad_payment_response.dart';
import 'package:view360/view/mzadcom_payment/approval_pending_list.dart';
import 'package:view360/view/mzadcom_payment/payment_listing.dart';
import 'package:view360/view/widgets/appbar_widget/appbar_widget.dart';
import 'package:view360/view/widgets/skeletonizer/list_homepage_skeleton.dart';

class MzadcomPaymentScreen extends StatefulWidget {
  const MzadcomPaymentScreen({super.key});

  @override
  State<MzadcomPaymentScreen> createState() => _MzadcomPaymentScreenState();
}

class _MzadcomPaymentScreenState extends State<MzadcomPaymentScreen> {
  final paymentDetails = Get.put(MzadcomPaymentApi());
  MzadPaymentResponse? paymentResponse;
  final RxString selectedTab = 'Approved Due'.obs; // Reactive variable

  @override
  void initState() {
    getPaymentDetails("approved");
    super.initState();
  }

  getPaymentDetails(String status) async {
    print("Fetching payment details for status: $status");
    paymentResponse = await paymentDetails.fetchPaymentDetails(status);
  }

  String amountFix(String amount) {
    final amt = (double.tryParse(amount) ?? 0.00).toStringAsFixed(2);
    return amt;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(title: "Mzadcom Payment".tr),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() {
              if (paymentDetails.isLoading.value && paymentResponse == null) {
                return ListWidgetSkeleton();
              } else {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(15),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.withValues(alpha: 0.08),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.blueAccent.withValues(alpha: 0.15),
                    ),
                  ),

                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customTabs(
                              "Approved Due".tr,
                              amountFix(
                                (paymentResponse?.meta.approved.total
                                        .toString() ??
                                    '0'),
                              ),

                              Icon(
                                Icons.check_circle_outline_outlined,
                                color: Colors.green,
                              ),

                              () {
                                getPaymentDetails("approved");
                              },
                              paymentResponse?.meta.approved.count.toString() ??
                                  '0',
                            ),
                            height10,
                            customTabs(
                              "Total Amount".tr,
                              paymentResponse?.meta.all.total.toStringAsFixed(
                                    2,
                                  ) ??
                                  '0.00',
                              Icon(Icons.money, color: Colors.cyan),
                              () {
                                getPaymentDetails("all");
                              },
                              paymentResponse?.meta.all.count.toString() ?? '0',
                            ),
                          ],
                        ),
                      ),

                      width10,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customTabs(
                              "Pending Due".tr,
                              paymentResponse?.meta.pending.total
                                      .toStringAsFixed(2) ??
                                  '0.00',
                              Icon(Icons.timelapse, color: Colors.orange),
                              () {
                                getPaymentDetails("pending");
                              },
                              paymentResponse?.meta.pending.count.toString() ??
                                  '0',
                            ),

                            height10,
                            customTabs(
                              "Paid Amount".tr,
                              paymentResponse?.meta.paid.total.toStringAsFixed(
                                    2,
                                  ) ??
                                  '0.00',
                              Icon(Icons.account_balance, color: Colors.purple),
                              () {
                                getPaymentDetails("paid");
                              },
                              paymentResponse?.meta.paid.count.toString() ??
                                  '0',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            }),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: lightGreen),
              ),
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Obx(() {
                if (paymentDetails.isLoading.value) {
                  return SizedBox(
                    width: 40,
                    child: LinearProgressIndicator(color: Colors.white),
                  );
                } else {
                  return InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return ApprovalPendingList();
                        },
                        isScrollControlled: true,
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          ("Amount waiting for approval".tr).toString(),
                          style: TextStyle(
                            color: AppStyle.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          ": ${paymentResponse?.meta.paidPendingAmount ?? '0.00'}",
                          style: TextStyle(
                            color: AppStyle.secondary,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        width15,
                        Icon(CupertinoIcons.list_bullet),
                      ],
                    ),
                  );
                }
              }),
            ),

            Obx(() {
              if (paymentDetails.isLoading.value) {
                return ListSkeleton();
              } else {
                return PaymentListing(
                  paymentResponse: paymentResponse,
                  selectedTab: selectedTab.value,
                );
              }
            }),
          ],
        ),
      ),
    );
  }

  customTabs(
    String title,
    String value,
    Icon icon,
    VoidCallback ontap,
    String auctionCount,
  ) {
    return Obx(() {
      return GestureDetector(
        onTap: () {
          selectedTab.value = title; // Update the reactive variable
          ontap();
        },
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppStyle.white,
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(
              color: selectedTab.value == title
                  ? Colors.blueAccent
                  : Colors.blueAccent.withValues(alpha: 0.15),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  icon,
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppStyle.darkGray,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    AmountFormate().withDecimal(value),
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                    decoration: BoxDecoration(
                      color: AppStyle.lightGray.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 15,
                          height: 15,
                          child: Image.asset(
                            'assets/bottomNavIcon/auction_outline.png',
                            color: AppStyle.liteRed,
                          ),
                        ),
                        Text(
                          auctionCount,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppStyle.darkGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
