import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/common/theme/colors.dart';
import 'package:view360/common/theme/sized_box.dart';
import 'package:view360/common/theme/style.dart';
import 'package:view360/language/language_controller.dart';

class GuranteeAmountStatic extends StatelessWidget {
  GuranteeAmountStatic({super.key});

  final LanguageController languageController = Get.find<LanguageController>();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          Get.dialog(
            AlertDialog(
              title: Text(
                'Guarantee amount deposit and refund policy'.tr,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: languageController.selectedLanguage.value == 1
                    ? Text(
                        '1) يجب على من يرغب في المشاركة في المزاد الإلكتروني دفع مبلغ الضمان.\n\n'
                                '2) مبلغ الضمان قابل للاسترداد. ومع ذلك، فإن رسوم الخدمة للدفع الإلكتروني غير قابلة للاسترداد، وهي 1.5٪ للبطاقات المحلية و2٪ للبطاقات البنكية.\n\n'
                                '3) مبلغ الضمان منفصل عن قيمة السلع المعروضة في المزاد.\n\n'
                                '4) قد يختلف مبلغ الضمان من سلعة (مادة) إلى أخرى، وقد يكون مبلغًا ثابتًا أو نسبة مئوية من القيمة الحالية للسلعة (المادة) المعروضة.\n\n'
                                '5) مبلغ الضمان لا يُعاد تلقائيًا. وفي حالة التأخير، فإن مزادكم غير مسؤول عن أي تأخير في الاسترداد.\n\n'
                                '6) سيتم إعادة مبلغ الضمان إلى محفظة المزايد، ويمكن للمزايد طلب استرداده.\n\n'
                                '7) سيتم إعادة مبلغ الضمان للمزايدين المصنفين في المرتبة الرابعة فما فوق خلال فترة تتراوح من 1 إلى 5 أيام عمل لبنك مسقط. وقد تستغرق العملية وقتًا أطول لعملاء البنوك الأخرى، لذا نوصي باستخدام بطاقات بنك مسقط.\n\n'
                                '8) عند استلام مبلغ الضمان في حسابك، قد لا تتلقى رسالة نصية. يُرجى التحقق من الحساب من خلال تطبيق البنك على الهاتف الذكي أو كشف الحساب.'
                            .tr,
                      )
                    : Text(
                        '1) Those willing to participate in the e-auction must deposit a Guarantee amount.\n\n'
                                '2) The Guarantee amount is refundable. However, the Service Charges for the Online Payment is not refundable, which is 1.5% for local cards and 2% for debit cards.\n\n'
                                '3) The guarantee amount is separate from the value of the items offered in the auction.\n\n'
                                '4) The Guarantee amount may vary from an item (a commodity) to another, and it may be a fixed amount or a percentage of the present value of the offered commodity (item).\n\n'
                                '5) The Guarantee amount is not automatically returned. In case of delay, Mzadcom will not bear any delay in refund.\n\n'
                                '6) The Guarantee amount will return to the Bidders Wallet and Bidders can request for refund.\n\n'
                                '7) Bidders who are ranked fourth and above, the guarantee amount will be returned to them within a period ranging from 1-5 working days of Bank Muscat’s work. but the process may take longer for other banks’ clients. Thus, we recommend using Bank Muscat’s cards.\n\n'
                                '8) When retrieving the Guarantee amount in your account, you may not receive an SMS. Please check your account through the bank\'s smart phone application or account statement.'
                            .tr,
                      ),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    Get.back();
                  },
                  child: const Text('Close'),
                ),
              ],
            ),
          );
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: AppStyle.lightGray2),
            borderRadius: BorderRadius.circular(8),
            color: white,
            boxShadow: [
              BoxShadow(
                color: AppStyle.lightGray2,
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(2, 3), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.policy, color: AppStyle.primary),

                Expanded(
                  child: Text(
                    'Deposit and refund policy'.tr,
                    style: smallFontSize12.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BankDetailsStaticContainer extends StatelessWidget {
  const BankDetailsStaticContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          Get.dialog(
            AlertDialog(
              backgroundColor: AppStyle.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: Text('Bank Details'.tr, style: bold),
              content: Column(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Account Name: Mzadcom Smart Auction Solutions LLC'.tr),
                  Text('Account Number: 0440061839220015'.tr),
                  Text('SWIFT CODE: BMUSOMRX'.tr),
                  Text('IBAN: OM360270440061839220015'.tr),
                  Text('Currency: OMANI RIYAL'.tr),
                  Text('Bank/Branch: Gala'.tr),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    Get.back();
                  },
                  child: Text('Close'.tr),
                ),
              ],
            ),
          );
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            // border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
            color: white,
            boxShadow: [
              BoxShadow(
                color: AppStyle.lightGray2,
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(2, 3), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Row(
                children: [
                  Icon(Icons.account_balance, color: AppStyle.primary),
                  width05,
                  Text(
                    'Bank Details'.tr,
                    style: smallFontSize12.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
