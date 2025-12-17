import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:view360/api/profile_details_api/profile_details_api.dart';
import 'package:view360/api/wallet_screen/wallet_paymant_user_information_api.dart';
import 'package:view360/common/theme/colors.dart';
import 'package:view360/common/theme/sized_box.dart';
import 'package:view360/common/theme/style.dart';
import 'package:view360/view/authentication/registration/state/file_upload/file_upload_state.dart';
import 'package:view360/view/widgets/appbar_widget/appbar_widget.dart';
import 'package:view360/view/widgets/skeletonizer/skeleton_loading_wallet_page.dart';
import '../widgets/image_picker_download/image_picker_all.dart';
import 'payment_system/bank_transfer/bank_transfer_payment.dart';
import 'payment_system/online_system/online_paymant_system.dart';
import 'payment_system/wallet_system/wallet_payment_system.dart';
import 'widgets/bank_details_guarntee_amount_policy.dart';
import 'widgets/selectable_payement_method_card.dart';

final selectedPaymentMethodProviderForRegistration = StateProvider<String>(
  (ref) => 'Online',
);

class RegistrationForBidders extends ConsumerStatefulWidget {
  final String? auctionName;
  final int? auctionID;
  final String? guranteeAmount;
  final dynamic filePaymentterms;
  final String? auctionNumber;
  final String? groupid;
  final List<bool> paymentTypes;

  const RegistrationForBidders({
    super.key,
    this.groupid,
    this.auctionName,
    this.auctionID,
    this.guranteeAmount,
    this.filePaymentterms,
    this.auctionNumber,
    this.paymentTypes = const [true, true, true],
  });

  @override
  ConsumerState<RegistrationForBidders> createState() =>
      _RegistrationForBiddersState();
}

class _RegistrationForBiddersState
    extends ConsumerState<RegistrationForBidders> {
  final checkboxProvider = StateProvider<bool>((ref) => false);
  final _formkey = GlobalKey<FormState>();
  final PickImageGetX filePickerNotifier = Get.put(PickImageGetX());
  final FilesUploadGetX filesUploadGetXController = Get.put(FilesUploadGetX());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(selectedPaymentMethodProviderForRegistration.notifier)
          .state = widget.paymentTypes[0]
          ? 'Online'
          : widget.paymentTypes[1]
          ? 'Wallet'
          : 'Bank';
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final selectedPaymentMethod = ref.watch(
      selectedPaymentMethodProviderForRegistration,
    );

    final profilData = ref.watch(auctionResponseProviderProfile);

    final civilId = profilData.asData?.map(
      data: (data) => data.value.data.residentCardNumber,
      loading: (_) => '',
      error: (_) => '',
    );

    int userId = profilData.asData?.value.data.id ?? 0;

    final bank = profilData.asData?.map(
      data: (data) => data.value.data.bank,
      loading: (_) => '',
      error: (_) => '',
    );

    final accountNumber = profilData.asData?.map(
      data: (data) => data.value.data.accountNumber,
      loading: (_) => '',
      error: (_) => '',
    );

    final idNumber = profilData.asData?.map(
      data: (data) => data.value.data.fileIdNumber,
      loading: (_) => '',
      error: (_) => '',
    );

    final beneficiary = profilData.asData?.map(
      data: (data) => data.value.data.beneficiary,
      loading: (_) => '',
      error: (_) => '',
    );

    final username = profilData.asData?.map(
      data: (data) => data.value.data.name,
      loading: (_) => 'Loading...',
      error: (_) => 'Error',
    );

    final isCompany = profilData.asData?.map(
      data: (data) => data.value.data.isCompany,
      loading: (_) => 'Loading...',
      error: (_) => 'Error',
    );

    final emailVerifiedAt = profilData.asData?.map(
      data: (data) => data.value.data.emailVerifiedAt,
      loading: (_) => 'Loading...',
      error: (_) => 'Error',
    );

    final phoneNumberVerifiedAt = profilData.asData?.map(
      data: (data) => data.value.data.mobileVerifiedAt,
      loading: (_) => 'Loading...',
      error: (_) => 'Error',
    );

    final userEmail = profilData.asData?.map(
      data: (data) => data.value.data.email,
      loading: (_) => 'Loading...',
      error: (_) => 'Error',
    );

    return Scaffold(
      appBar: AppbarWidget(
        title: widget.auctionID != null
            ? 'Registration for Bidders'.tr
            : 'Add Funds to your wallet'.tr,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              height05,

              //checking auctionname is null or not, if null dont neeed to show below widget
              if (widget.auctionName != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(
                          0,
                          3,
                        ), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              overflow: TextOverflow.ellipsis,
                              widget.auctionName ?? '',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            height10,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(widget.auctionNumber ?? '', style: bold),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    width30,
                                    Text(
                                      'Guarantee amount:'.tr,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    width05,
                                    Text(
                                      '${widget.guranteeAmount ?? 0} OMR',
                                      style: bold,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              height15,

              // Selectable payment method widget
              SelectablePaymentMethodWidget(
                ref: ref,
                selectedPaymentMethod: selectedPaymentMethod,
                paymentTypes: widget.paymentTypes,
              ),
              height15,
              Row(
                children: [
                  //* guarantee amount static ----------------------------------
                  GuranteeAmountStatic(),
                  width10,
                  //* Bank details ---------------------------------------------
                  BankDetailsStaticContainer(),
                ],
              ),
              height05,
              Divider(),

              selectedPaymentMethod == 'Bank'
                  ? bankTransfer(
                      _formkey,
                      ref,
                      guaranteeAmount: widget.guranteeAmount.toString(),
                      isCompany: isCompany as int? ?? 0,
                      auctionID: widget.auctionID ?? 0,
                      emailVerifiedAt: emailVerifiedAt.toString(),
                      phoneNumberVerifiedAt: phoneNumberVerifiedAt.toString(),
                      enrollName: username.toString(),
                    )
                  : selectedPaymentMethod == 'Online'
                  ? onlinePayment(
                      ref,
                      guaranteeAmount: widget.guranteeAmount.toString(),
                      emailVerifiedAt: emailVerifiedAt.toString(),
                      phoneNumberVerifiedAt: phoneNumberVerifiedAt.toString(),
                      accountNumber: accountNumber.toString(),
                      bankName: bank.toString(),
                      beneficiary: beneficiary.toString(),
                      civilID: civilId.toString(),
                      isCompany: isCompany as int? ?? 0,
                      auctionID:
                          widget.auctionID ?? int.parse(widget.groupid ?? '0'),
                      enrollName: username.toString(),
                      email: userEmail.toString(),
                      groupID: int.tryParse(widget.groupid ?? '0'),
                    )
                  : walletPayment(
                      fileIdNumber: idNumber.toString() ?? 'Wallet',
                      userID: userId,
                      guaranteeAmount: widget.guranteeAmount.toString(),
                      emailVerifiedAt.toString(),
                      phoneNumberVerifiedAt.toString(),
                      accountNumber: accountNumber.toString(),
                      bankName: bank.toString(),
                      beneficiary: beneficiary.toString(),
                      civilID: civilId.toString(),
                      isCompany: isCompany as int? ?? 0,
                      auctionID: widget.auctionID ?? 0,
                      enrollName: username.toString(),
                      userMail: userEmail.toString(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
  //* bank transfer widgets, textfields and file upload field, etc.....----------

  Widget bankTransfer(
    GlobalKey<FormState> formkey,
    WidgetRef ref, {
    required String emailVerifiedAt,
    required String phoneNumberVerifiedAt,
    required String enrollName,
    required int auctionID,
    required int isCompany,
    required String guaranteeAmount,
  }) {
    //widget
    return BankPayment(
      auctionID: auctionID,
      enrollName: enrollName,
      isCompany: isCompany,
      guaranteeAmount: double.parse(guaranteeAmount),
      formkey: formkey,
      filesUploadGetXController: filesUploadGetXController,
      filePickerNotifier: filePickerNotifier,
      checkboxProvider: checkboxProvider,
      emailVerifiedAt: emailVerifiedAt,
      phoneNumberVerifiedAt: phoneNumberVerifiedAt,
    );
  }

  //*online payment widgets-----------------------------------------------------
  Widget onlinePayment(
    WidgetRef ref, {
    required String emailVerifiedAt,
    required String phoneNumberVerifiedAt,
    required String guaranteeAmount,
    required String enrollName,
    required int auctionID,
    required int isCompany,
    required String civilID,
    required String bankName,
    required String accountNumber,
    required String beneficiary,
    required String email,
    required int? groupID,
  }) {
    //widget
    return OnlinePaymentSystem(
      termsAndCondition: widget.filePaymentterms.toString() ?? '',
      page: 'enrollPage',
      enrollEmail: email,
      accountNumber: accountNumber,
      bankName: bankName,
      beneficiary: beneficiary,
      civilID: civilID,
      auctionID: auctionID,
      enrollName: enrollName,
      isCompany: isCompany,
      guaranteeAmount: double.parse(guaranteeAmount),
      checkboxProvider: checkboxProvider,
      emailVerifiedAt: emailVerifiedAt,
      phoneNumberVerifiedAt: phoneNumberVerifiedAt,
      groupID: groupID,
    );
  }

  //* wallet payment widgets-----------------------------------------------------
  Widget walletPayment(
    String emailVerifiedAt,
    String phoneNumberVerifiedAt, {
    required String guaranteeAmount,
    required String enrollName,
    required int auctionID,
    required int isCompany,
    required String civilID,
    required String bankName,
    required String accountNumber,
    required String beneficiary,
    required String userMail,
    required int userID,
    required String fileIdNumber,
  }) {
    return Consumer(
      builder: (context, ref, child) {
        final AsyncValue<dynamic> walletData = ref.watch(
          walletInformationResponseProvider(userID),
        );

        ref.listen<AsyncValue<dynamic>>(
          walletInformationResponseProvider(userID),
          (previous, next) {
            setState(() {});
          },
        );

        return walletData.when(
          data: (data) {
            if (data != null &&
                data is Map &&
                data.containsKey('wallet_amount')) {
              final transaction = data;
              final balance = transaction['wallet_amount'] ?? '0';
              //widget
              return WalletPayamntSystem(
                fileIdNumber: fileIdNumber,
                userMail: userMail,
                accountNumber: accountNumber,
                bankName: bankName,
                beneficiary: beneficiary,
                civilID: civilID,
                auctionID: auctionID,
                enrollName: enrollName,
                isCompany: isCompany,
                guaranateeAmount: guaranteeAmount,
                balance: balance,
                emailVerifiedAt: emailVerifiedAt,
                phoneNumberVerifiedAt: phoneNumberVerifiedAt,
              );
            } else {
              return Center(child: Text("No transactions found".tr));
            }
          },
          error: (error, stackTrace) {
            return Text(
              'Something went wrong. Please check your internet connection or login status and try again.'
                  .tr,
              style: const TextStyle(color: Colors.black),
            );
          },
          loading: () {
            return SkeletonLoadingWallet();
          },
        );
      },
    );
  }
}
