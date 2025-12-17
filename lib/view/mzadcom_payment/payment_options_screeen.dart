import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:view360/common/theme/sized_box.dart';
import 'package:view360/view/enrollment_payment_screen/widgets/bank_details_guarntee_amount_policy.dart';
import 'package:view360/view/mzadcom_payment/bank_payment_widget.dart';
import 'package:view360/view/mzadcom_payment/payment_bottom_sheet.dart';
import 'package:view360/view/mzadcom_payment/payment_widgets.dart';
import 'package:view360/view/mzadcom_payment/wallet_payment_widget.dart';
import 'package:view360/view/widgets/appbar_widget/appbar_widget.dart';

// Controller for managing tab state
class PaymentOptionsController extends GetxController {
  var selectedTab = 0.obs; // Observable for tab index
}

class PaymentOptions extends StatelessWidget {
  PaymentOptions({
    super.key,
    required this.userId,
    required this.selectedAuctions,
    required this.totalAmount,
  });

  final PaymentOptionsController controller = Get.put(
    PaymentOptionsController(),
  );
  final int? userId;
  final List<SelectedAuction> selectedAuctions;
  final double totalAmount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(title: 'Payment Options'),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            PaymentOptionTabBar(controller: controller),
            height05,
            Row(
              children: [
                //* guarantee amount static ----------------------------------
                GuranteeAmountStatic(),
                width10,
                //* Bank details ---------------------------------------------
                BankDetailsStaticContainer(),
              ],
            ),
            height10,
            Expanded(
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.3),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Obx(() {
                  // Render content based on the selected tab
                  return controller.selectedTab.value == 0
                      ? WalletPaymentWidget(
                          userId: userId ?? 0,
                          totalAmount: totalAmount,
                          selectedAuctions: selectedAuctions,
                        )
                      : BankPaymentWidget(
                          totalAmount: totalAmount,
                          selectedAuctionPayments: selectedAuctions,
                        );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
