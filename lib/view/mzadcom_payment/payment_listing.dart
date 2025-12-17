import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/common/theme/colors.dart';
import 'package:view360/common/theme/sized_box.dart';
import 'package:view360/common/utils/formatter/amount_formate.dart';
import 'package:view360/model/mzadcom_payment/mzad_payment_response.dart';
import 'package:view360/view/auction_details/pdf_web_view/pdf_view.dart';
import 'package:view360/view/mzadcom_payment/payment_bottom_sheet.dart';
import 'package:view360/view/widgets/empty_message/empty_message_widget.dart';

class PaymentListing extends StatefulWidget {
  const PaymentListing({
    super.key,
    required this.paymentResponse,
    required this.selectedTab,
  });
  final MzadPaymentResponse? paymentResponse;
  final String selectedTab;

  @override
  State<PaymentListing> createState() => _PaymentListingState();
}

class _PaymentListingState extends State<PaymentListing> {
  int selectedAuctionCount = 0;
  final Set<int> selectedIndexes = {}; // Track selected items
  final Set<PaymentData> selectedAuctions = {};

  @override
  Widget build(BuildContext context) {
    return (widget.paymentResponse?.data != null &&
            widget.paymentResponse!.data.isNotEmpty)
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                height05,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${"Auctions selected".tr}: $selectedAuctionCount",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          print(selectedAuctions);
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return PaymentBottomSheet(
                                selectedAuctions: selectedAuctions.toList(),
                              );
                            },
                            isScrollControlled: true,
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 40,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: AppStyle.bidButtonGradient,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "Pay".tr,
                            style: TextStyle(
                              color: white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                height05,
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.paymentResponse!.data.length,
                  itemBuilder: (context, index) {
                    final payment = widget.paymentResponse!.data[index];
                    final isSelected = selectedIndexes.contains(index);

                    return Card(
                      elevation: 4,
                      shadowColor: Colors.blueAccent.withValues(alpha: 0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        leading:
                            (payment.approveStatus == 'A' &&
                                payment.balanceAmount > 0)
                            ? Checkbox(
                                value: isSelected,
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (value == true) {
                                      selectedIndexes.add(index);
                                      selectedAuctions.add(payment);
                                      selectedAuctionCount++;
                                    } else {
                                      selectedIndexes.remove(index);
                                      selectedAuctions.remove(payment);
                                      selectedAuctionCount--;
                                    }
                                  });
                                },
                              )
                            : SizedBox(width: 20),

                        title: Text(
                          payment.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Amount: ${AmountFormate().withDecimal(payment.totalAmount.toStringAsFixed(2))}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                Text(
                                  "Paid: ${AmountFormate().withDecimal(payment.paidAmount.toString())}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "Balance: ${AmountFormate().withDecimal(payment.balanceAmount.toString())}",
                            ),
                          ],
                        ),
                        trailing: payment.approveStatus == 'A'
                            ? InkWell(
                                onTap: () {
                                  final url = Uri.parse(
                                    "$baseUrl/my_winnings/pdf?id=213&auction=636",
                                  );
                                  Get.to(
                                    () => PdfViewerScreen(
                                      pdfUrl: url.toString(),
                                      page: 'Invoice'.tr,
                                      isPayment: true,
                                    ),
                                  );
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey.shade300,
                                  child: Icon(
                                    Icons.picture_as_pdf_outlined,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              )
                            : SizedBox(),
                      ),
                    );
                  },
                ),
              ],
            ),
          )
        : EmptyMessageWidget(
            message: "No payment details available.",
            textcolor: Colors.blueGrey,
          );
  }
}
