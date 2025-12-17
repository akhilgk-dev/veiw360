import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:view360/api/active_auctions/active_auctions_api.dart';
import 'package:view360/common/theme/colors.dart';
import 'package:view360/common/utils/helpers/snackbar.dart';
import 'package:view360/model/active_auctions/active_auctions_model.dart';
import 'package:view360/view/auction_details/pdf_web_view/pdf_view.dart';
import 'package:view360/view/widgets/appbar_widget/appbar_widget.dart';

class TermsAndConditionsScreen extends ConsumerWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<AuctionResponse> activity = ref.watch(
      auctionResponseProvider,
    );

    return Scaffold(
      appBar: AppbarWidget(title: 'Terms and Conditions'.tr),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: darkBlue,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.description, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      "Terms and Conditions".tr,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            activity.when(
              loading: () => Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) =>
                  Center(child: Text('Error: $error'.tr)),
              data: (auctionResponse) {
                final auctionData = auctionResponse.auctionData;
                if (auctionData!.isEmpty) {
                  return Text(
                    'No Terms and condition.'.tr,
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  );
                }
                final filePaymentTerms = auctionData[0].filePaymentTerms;

                if (filePaymentTerms != null) {
                  return ListTile(
                    onTap: () {
                      if (filePaymentTerms == false) {
                        SnackbarHelper.showSnackBar(
                          context,
                          'No terms and conditions available.'.tr,
                        );
                      } else {
                        Get.to(
                          () => PdfViewerScreen(
                            pdfUrl: filePaymentTerms,
                            page: 'Payment Terms'.tr,
                          ),
                        );
                      }
                    },
                    leading: Icon(Icons.picture_as_pdf, color: Colors.red),
                    title: Text('Terms and condtion'.tr),
                  );
                } else {
                  return Text(
                    'No terms and conditions available.'.tr,
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  );
                }
              },
            ),
            // Add more sections as needed
          ],
        ),
      ),
    );
  }
}
