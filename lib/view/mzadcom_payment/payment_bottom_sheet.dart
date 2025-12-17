import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/common/theme/sized_box.dart';
import 'package:view360/common/utils/formatter/amount_formate.dart';
import 'package:view360/model/mzadcom_payment/mzad_payment_response.dart';
import 'package:view360/view/mzadcom_payment/payment_options_screeen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentBottomSheet extends StatefulWidget {
  PaymentBottomSheet({super.key, required this.selectedAuctions});
  List<PaymentData> selectedAuctions;
  @override
  State<PaymentBottomSheet> createState() => _PaymentBottomSheetState();
}

class _PaymentBottomSheetState extends State<PaymentBottomSheet> {
  late Map<int, TextEditingController> _controllers;
  double totalAmount = 0;
  late int? userId;
  List<SelectedAuction> selectedAuctionAmounts = [];

  @override
  void initState() {
    super.initState();
    // Initialize controllers for each auction
    _controllers = {
      for (int i = 0; i < widget.selectedAuctions.length; i++)
        i: TextEditingController(
          text: widget.selectedAuctions[i].balanceAmount.toString(),
        ),
    };
    addTotalAmount();
    getUserId();
  }

  @override
  void dispose() {
    // Dispose all controllers to avoid memory leaks
    _controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  addTotalAmount() {
    print("Calculating total amount");
    totalAmount = 0;
    for (int i = 0; i < widget.selectedAuctions.length; i++) {
      final amountText = _controllers[i]?.text ?? '0';
      final amount = double.tryParse(amountText) ?? 0.0;
      totalAmount += amount;
    }
    setState(() {});
  }

  getUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    userId = pref.getInt('userId');
    for (int index = 0; index < widget.selectedAuctions.length; index++) {
      selectedAuctionAmounts.add(
        SelectedAuction(
          amount: double.tryParse(_controllers[index]?.text ?? '0') ?? 0.0,
          auction: widget.selectedAuctions[index],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 8),
          child: Column(
            children: [
              Text(
                "Selected Auctions to pay",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              height15,
              if (widget.selectedAuctions.isEmpty) Text("No auctions selected"),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.selectedAuctions.length,
                itemBuilder: (context, index) {
                  final auction = widget.selectedAuctions[index];

                  return Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.all(4),
                                padding: EdgeInsets.symmetric(
                                  vertical: 3,
                                  horizontal: 6,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: AppStyle.bidButtonGradient,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  "MZAD ${auction.id}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4.0,
                                ),
                                child: Text(
                                  auction.title,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "Balance: ${auction.balanceAmount.toString()}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.redAccent,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    width05,
                                    SizedBox(
                                      height: 15,
                                      child: VerticalDivider(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      "Paid: ${auction.paidAmount.toString()}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 4,
                          ),
                          child: SizedBox(
                            width: 140,
                            height: 40,
                            child: TextFormField(
                              controller: _controllers[index],
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onChanged: (value) {
                                if ((double.tryParse(value) ?? 0.0) >
                                    auction.balanceAmount.toDouble()) {
                                  // Reset to max balance if exceeded
                                  _controllers[index]?.text = auction
                                      .balanceAmount
                                      .toString();
                                }

                                final amountText =
                                    _controllers[index]?.text ?? '0';
                                final amount =
                                    double.tryParse(amountText) ?? 0.0;
                                // Replace or add the element in the list

                                selectedAuctionAmounts[index] = SelectedAuction(
                                  amount: amount,
                                  auction: auction,
                                );

                                print(selectedAuctionAmounts.length);

                                addTotalAmount();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: widget.selectedAuctions.isEmpty
                      ? LinearGradient(colors: AppStyle.lightGradient)
                      : LinearGradient(colors: AppStyle.bidButtonGradient),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    // Handle payment submission
                    if (totalAmount > 0 &&
                        widget.selectedAuctions.isNotEmpty &&
                        userId != null) {
                      Get.to(
                        () => PaymentOptions(
                          userId: userId,
                          selectedAuctions: selectedAuctionAmounts,
                          totalAmount: totalAmount,
                        ),
                      );
                      print(selectedAuctionAmounts.length);
                      print(selectedAuctionAmounts[0].amount);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Proceed to Pay - ${AmountFormate().withDecimal(totalAmount.toStringAsFixed(2))} OMR",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectedAuction {
  double amount;
  PaymentData auction;
  SelectedAuction({required this.amount, required this.auction});
}
