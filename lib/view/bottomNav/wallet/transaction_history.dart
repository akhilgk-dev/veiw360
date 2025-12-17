import 'package:flutter/material.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:get/get.dart';
import 'package:view360/common/theme/sized_box.dart';

class TransactionHistory extends StatelessWidget {
  final List<dynamic> transactions;
  const TransactionHistory({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    if (transactions.length <= 10) {
      // Show all transactions without tabs
      return _buildTransactionList(transactions);
    }

    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.black54,
            indicatorColor: Colors.blue,
            tabs: [
              Tab(text: 'Last 10'.tr),
              Tab(text: 'Last 50'.tr),
              Tab(text: 'All'.tr),
            ],
          ),
          Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                _buildTransactionList(transactions.take(10).toList()),
                _buildTransactionList(transactions.take(50).toList()),
                _buildTransactionList(transactions),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(List<dynamic> txs) {
    if (txs.isEmpty) {
      return Center(
        child: Text(
          "No transactions found".tr,
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      //physics: NeverScrollableScrollPhysics(),
      itemCount: txs.length,
      itemBuilder: (context, index) {
        final transaction = txs[index];
        final date = DateTime.parse(transaction['created_at']);

        final approved = transaction['status'] == 'A';
        final waitingForAdminApproval = transaction['status'] == 'P';
        final waitingForFinanceApproval = transaction['status'] == 'F';
        final withdrawRequested = transaction['status'] == 'W';
        final withdrawRequestApprovedByAdmin = transaction['status'] == 'WA';
        final refundApproved = transaction['status'] == 'R';
        final withdrawRequestRejected = transaction['status'] == 'WR';

        Color statusColor = approved
            ? Colors.green.withAlpha(200)
            : waitingForAdminApproval
            ? Colors.orange.withAlpha(200)
            : waitingForFinanceApproval
            ? Colors.blue.withAlpha(200)
            : withdrawRequested
            ? Colors.red.withAlpha(200)
            : withdrawRequestApprovedByAdmin
            ? Colors.green.withAlpha(200)
            : refundApproved
            ? Colors.green.withAlpha(200)
            : withdrawRequestRejected
            ? Colors.red.withAlpha(200)
            : Colors.grey.withAlpha(200);

        String adminApprovedText = approved
            ? 'Approved'.tr
            : waitingForAdminApproval
            ? 'Waiting for admin approval'.tr
            : waitingForFinanceApproval
            ? 'Waiting for finance approval'.tr
            : withdrawRequested
            ? 'Withdraw requested'.tr
            : withdrawRequestApprovedByAdmin
            ? 'Withdraw request approved by admin'.tr
            : refundApproved
            ? 'Refund Approved'.tr
            : withdrawRequestRejected
            ? 'Withdraw Request Rejected'.tr
            : 'Not approved'.tr;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                colors: [
                  AppStyle.lightGray3.withAlpha((0.7 * 255).toInt()),
                  Colors.blue.withAlpha((0.08 * 255).toInt()),
                ],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.withAlpha((0.08 * 255).toInt()),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
              border: Border.all(
                color: Colors.blueAccent.withAlpha((0.10 * 255).toInt()),
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 2,
                horizontal: 16,
              ),
              leading: CircleAvatar(
                backgroundColor: statusColor,
                child: Icon(
                  approved
                      ? Icons.check_circle
                      : waitingForAdminApproval
                      ? Icons.hourglass_top
                      : waitingForFinanceApproval
                      ? Icons.account_balance
                      : withdrawRequested
                      ? Icons.upload
                      : withdrawRequestApprovedByAdmin
                      ? Icons.verified
                      : refundApproved
                      ? Icons.refresh
                      : withdrawRequestRejected
                      ? Icons.cancel
                      : Icons.info,
                  color: Colors.white,
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      "${transaction['type']} • ${date.day}/${date.month}/${date.year}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      adminApprovedText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    if (transaction['credit'] != null &&
                        double.parse(transaction['credit']) > 0)
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Credited:",
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                            TextSpan(
                              text: " ${transaction['credit']} OMR",
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    if (transaction['debit'] != null &&
                        double.parse(transaction['debit']) > 0)
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Debited:".tr,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                            TextSpan(
                              text: " ${transaction['debit']} OMR",
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    width05,
                    // const Spacer(),
                    Expanded(
                      child: SizedBox(
                        // width: 130,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            transaction['group_info'] != null
                                ? "#${transaction['group_info']?['group_name'] ?? ''}"
                                : "",
                            style: TextStyle(
                              fontSize: 11,
                              color: AppStyle.darkGray,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {},
            ),
          ),
        );
      },
    );
  }

  Widget _amountChip({
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withAlpha(200),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "$label: ",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],

          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
