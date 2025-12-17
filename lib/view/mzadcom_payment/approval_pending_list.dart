import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart';
import 'package:view360/api/mzadcom_payment/approval_pending_list_api.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/common/theme/sized_box.dart';
import 'package:view360/model/mzadcom_payment/approval_pending_response.dart';

class ApprovalPendingList extends StatefulWidget {
  const ApprovalPendingList({super.key});

  @override
  State<ApprovalPendingList> createState() => _ApprovalPendingListState();
}

class _ApprovalPendingListState extends State<ApprovalPendingList> {
  ApprovalPendingResponse? approvalPendingResponse;
  final pendingListApi = Get.put(ApprovalPendingListApi());
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    approvalPendingResponse = await pendingListApi.fetchPaymentDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Adjust height to content
      children: [
        Obx(() {
          if (pendingListApi.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (approvalPendingResponse == null ||
                approvalPendingResponse!.data.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 30.0,
                    horizontal: 12,
                  ),
                  child: Text('${'No pending approvals found'.tr}.'),
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppStyle.primary.withAlpha(50),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Transactions awaiting approval".tr,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppStyle.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: approvalPendingResponse?.data.length ?? 0,
                    itemBuilder: (context, index) {
                      final item = approvalPendingResponse!.data[index];
                      return Card(
                        elevation: 4,
                        shadowColor: Colors.blueAccent.withAlpha(30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ),
                          title: Text(
                            item.auctionRelation.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${"Amount".tr}: ${item.credit} OMR",
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                "${"Receipt No".tr}: ${item.receiptNumber}",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          trailing: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 18,
                                ),
                                child: Text(
                                  "Pending".tr,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              height05,
                              Text(
                                "${"ID".tr}: ${item.id}",
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: AppStyle.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 30),
                ],
              ),
            );
          }
        }),
      ],
    );
  }
}
