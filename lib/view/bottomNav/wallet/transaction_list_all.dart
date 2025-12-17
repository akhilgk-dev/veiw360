import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:view360/api/wallet_screen/wallet_screen_api.dart';
import 'package:view360/view/widgets/appbar_widget/appbar_widget.dart';

class TransactionListAll extends ConsumerWidget {
  final int userID;

  const TransactionListAll({super.key, required this.userID});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppbarWidget(title: 'Transaction List'.tr),
      body: transactionListAllDetails(userID, ref),
    );
  }

  Widget transactionListAllDetails(int userID, WidgetRef ref) {
    final walletData = ref.watch(transationResponseProvider);

    return walletData.when(
      data: (data) {
        final userTransactions = data
            .where((transaction) => transaction['user'] == userID)
            .toList();

        if (userTransactions.isEmpty) {
          return Center(child: Text('No transactions found'.tr));
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: userTransactions.length,
          itemBuilder: (context, index) {
            final transaction = userTransactions[index];
            final date = DateTime.parse(transaction['created_at']);

            print(transaction['status']);

            final adminApproved = transaction['status'];

            // A: Approved
            // P: Waiting for admin approval
            // F: Waiting for finance approval
            // W: Withdraw requested
            // WA: Withdraw request approved by admin
            // R:  Refund Approved
            // WR:  Withdraw Request Rejected

            final approved = transaction['status'] == 'A';
            final waitingForAdminApproval = transaction['status'] == 'P';
            final waitingForFinanceApproval = transaction['status'] == 'F';
            final withdrawRequested = transaction['status'] == 'W';
            final withdrawRequestApprovedByAdmin =
                transaction['status'] == 'WA';
            final refundApproved = transaction['status'] == 'R';
            final withdrawRequestRejected = transaction['status'] == 'WR';
            final adminApprovedText = approved
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

            return Card(
              elevation: 4,
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${transaction['type']} - ${date.day}/${date.month}/${date.year}",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: approved
                            ? Colors.green
                            : waitingForAdminApproval
                            ? Colors.orange
                            : waitingForFinanceApproval
                            ? Colors.blue
                            : withdrawRequested
                            ? Colors.yellow
                            : withdrawRequestApprovedByAdmin
                            ? Colors.purple
                            : refundApproved
                            ? Colors.red
                            : withdrawRequestRejected
                            ? Colors.redAccent
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          adminApprovedText,
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              '${"Debit:".tr} ${transaction['debit']} OMR'.tr,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              '${"Credit:".tr} ${transaction['credit']} OMR',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    //   const Divider(),
                    // Text(
                    //   '${"TransactionID".tr}: ${transaction['transaction_id'] ?? 'N/A'}',
                    //   style: const TextStyle(fontSize: 12),
                    // ),
                    // Text(
                    //   '${"ReferenceID:".tr} ${transaction['reference']}'.tr,
                    //   style: const TextStyle(fontSize: 12),
                    // ),
                  ],
                ),
                onTap: () {},
              ),
            );
          },
        );
      },
      error: (error, stackTrace) {
        return Column(
          children: [Text("error", style: const TextStyle(color: Colors.red))],
        );
      },
      loading: () {
        return const Column(children: [CircularProgressIndicator()]);
      },
    );
  }
}
