import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:view360/api/wallet_screen/wallet_screen_api.dart';
import 'package:view360/common/text/text_static.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/common/theme/colors.dart';
import 'package:view360/common/theme/sized_box.dart';
import 'package:view360/common/theme/style.dart';
import 'package:view360/common/utils/formatter/amount_formate.dart';
import 'package:view360/view/bottomNav/wallet/transaction_history.dart';
import 'package:view360/view/bottomNav/wallet/withdraw_amount/withdraw_amount.dart';
import 'package:view360/view/widgets/appbar_widget/appbar_widget.dart';
import 'package:view360/view/widgets/skeletonizer/list_homepage_skeleton.dart';
import 'package:view360/view/widgets/token/token_checking.dart';
import 'package:view360/view/widgets/user_id_state/user_id_state.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../api/wallet_screen/wallet_paymant_user_information_api.dart';
import '../../enrollment_payment_screen/payment_system/wallet_system/add_fund_screen.dart';
import '../bottom_nav.dart';

final transactionTypeProvider = StateProvider<String?>((ref) => "");

class WalletScreen extends ConsumerStatefulWidget {
  const WalletScreen({super.key});

  @override
  WalletScreenState createState() => WalletScreenState();
}

class WalletScreenState extends ConsumerState<WalletScreen> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  var isInternet = 0.obs;

  final UserIdState userid = Get.put((UserIdState()));

  // Add filter state
  String? transactionFilter = '';

  @override
  void initState() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
    user();
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        if (userid.userid.value != null) {
          ref.invalidate(
            walletInformationResponseProvider(userid.userid.value),
          );
        }
      }
    });
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result.isNotEmpty
          ? result.first
          : ConnectivityResult.none;
    });

    if (_connectionStatus == ConnectivityResult.none) {
      //1 means no internet
      isInternet.value = 1;
    } else {
      //0 means have internet
      isInternet.value = 0;
    }
    // ignore: avoid_print
    print('Connectivity changed: $_connectionStatus');
  }

  Future<void> user() async {
    await userid.setUserId();
    await Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        ref.invalidate(walletInformationResponseProvider(userid.userid.value));
        ref.invalidate(transationResponseProvider);
      }
    });
  }

  void transactionType(String? type) {
    ref.read(transactionTypeProvider.notifier).state = type;
  }

  String getType() {
    switch (ref.read(transactionTypeProvider)) {
      case '':
        return '';
      case 'withdraw':
        return 'Withdraw'.tr;
      case 'hold':
        return ' - Hold';
      case 'deposit':
        return 'Deposits'.tr;
      default:
        return ' - All ';
    }
  }

  final TokenCheckingState tokenCheckingState = Get.put(TokenCheckingState());

  @override
  Widget build(BuildContext context) {
    tokenCheckingState.checkToken();
    final screenWidth = MediaQuery.of(context).size.width;
    final notifier = ref.read(bottomNavProvider.notifier);
    final iD = userid.userid.value;
    final data = ref.watch(walletInformationResponseProvider(iD));
    final walletData = ref.watch(transationResponseProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        notifier.updateIndex(0);
      },
      child: Scaffold(
        appBar: AppbarWidgetWithoutBackButton(title: 'Wallet'.tr),
        body: RefreshIndicator(
          onRefresh: () async {
            print("refreshed");
            await userid.setUserId();
            ref.invalidate(
              walletInformationResponseProvider(userid.userid.value),
            );
            ref.invalidate(transationResponseProvider);
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                height05,
                // ElevatedButton(
                //   onPressed: () => Get.to(() => Paymentchcheck()),
                //   child: Text("Walleter".tr),
                // ),
                // tokenCheckingState.token.value.isNotEmpty
                //     ? WalletCard(id: iD)
                //     // _buildFrontCard(iD, walletData)
                //     : Center(
                //         child: Column(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             SizedBox(
                //               height: MediaQuery.of(context).size.height / 5,
                //             ),
                //             ClipRRect(
                //               borderRadius: BorderRadius.circular(5),
                //               child: Image.asset('assets/images/no_msg.gif'),
                //             ),
                //             height20,
                //             InkWell(
                //               onTap: () {
                //                 Get.offAll(() {
                //                   return LoginPage();
                //                 });
                //               },
                //               child: Container(
                //                 decoration: BoxDecoration(
                //                   border: Border.all(color: Colors.black),
                //                   borderRadius: BorderRadius.circular(5),
                //                 ),
                //                 child: Padding(
                //                   padding: const EdgeInsets.all(15.0),
                //                   child: Text('Please Login to see details'.tr),
                //                 ),
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                // const SizedBox(height: 20),
                // tokenCheckingState.token.value.isNotEmpty
                //     ? Text(
                //         "Financial Account Details".tr,
                //         style: TextStyle(
                //           fontSize: 18,
                //           fontWeight: FontWeight.bold,
                //           color: Colors.black,
                //         ),
                //       )
                //     : SizedBox(),
                const SizedBox(height: 10),
                tokenCheckingState.token.value.isNotEmpty
                    //account details
                    ? _buildTransactionList(
                        screenWidth,
                        iD,
                        walletData,
                        data.value,
                      )
                    : SizedBox(),

                // height05,
                // tokenCheckingState.token.value.isNotEmpty
                //     ? Padding(
                //         padding: const EdgeInsets.all(10.0),
                //         child: Row(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: [
                //             //                     Obx(() {
                //             //                       if(isInternet.value==1){
                //             //                         SizedBox();
                //             //                       }
                //             //                       else{
                //             // walletData.value!=null
                //             //                         ? Text(
                //             //                             'Transaction History'.tr,
                //             //                             style: bold,
                //             //                           )
                //             //                         : SizedBox();
                //             //                       }
                //             //                     },)
                //           ],
                //         ),
                //       )
                //     : SizedBox(),
                height10,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Transaction History'.tr,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    walletData.when(
                      data: (data) {
                        return Text(
                          " (${walletData.value.length ?? 0})",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        );
                      },
                      error: (error, stackTrace) {
                        return Text(
                          "0",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        );
                      },
                      loading: () => SizedBox(),
                    ),

                    width05,

                    Text(
                      " ${getType()}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppStyle.darkGray,
                      ),
                    ),

                    PopupMenuButton<String>(
                      position: PopupMenuPosition.under,
                      color: AppStyle.white,
                      icon: Icon(Icons.filter_list),
                      onSelected: (value) {
                        transactionType(value);
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: "deposit",
                          child: GestureDetector(
                            onTap: () {
                              transactionType("deposit");
                              transactionFilter = "deposit";
                              Navigator.of(context).pop();
                            },
                            child: _modernListTile(
                              icon: Icons.arrow_upward,
                              iconBg: Colors.greenAccent.withAlpha(50),
                              iconColor: Colors.green,
                              title: "Deposits".tr,
                              amount: "${meta['credit_sum']} OMR",
                            ),
                          ),
                        ),
                        // PopupMenuItem(
                        //   value: "client_due",
                        //   child: GestureDetector(
                        //     onTap: () {
                        //       debugPrint("Client Due tapped");
                        //       Navigator.of(context).pop();
                        //     },
                        //     child: _modernListTile(
                        //       icon: Icons.person,
                        //       iconBg: Colors.orangeAccent.withAlpha(50),
                        //       iconColor: Colors.orange,
                        //       title: "Client Due".tr,
                        //       amount: "${meta['client_due'] ?? 'N/A'} OMR",
                        //     ),
                        //   ),
                        // ),
                        PopupMenuItem(
                          value: "hold",
                          child: GestureDetector(
                            onTap: () {
                              transactionType("hold");
                              transactionFilter = "hold";
                              Navigator.of(context).pop();
                            },
                            child: _modernListTile(
                              icon: Icons.block_outlined,
                              iconBg: Colors.redAccent.withAlpha(50),
                              iconColor: Colors.red,
                              title: "Hold Amount".tr,
                              amount: "${meta['hold_sum']} OMR",
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          value: "withdraw",
                          child: GestureDetector(
                            onTap: () {
                              transactionType("withdraw");
                              transactionFilter = "withdraw";
                              Navigator.of(context).pop();
                            },
                            child: _modernListTile(
                              icon: Icons.arrow_downward,
                              iconBg: Colors.blueAccent.withAlpha(50),
                              iconColor: Colors.blue,
                              title: "Withdraw".tr,
                              amount: "${meta['debit_sum']} OMR",
                            ),
                          ),
                        ),
                        // if (_transactionFilter != null)
                        PopupMenuItem(
                          value: "",
                          child: TextButton(
                            onPressed: () {
                              transactionFilter = '';
                              transactionType('');
                              Navigator.of(context).pop();
                            },
                            child: Text("Clear Filter".tr),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                height05,
                tokenCheckingState.token.value.isNotEmpty
                    ? walletData.when(
                        data: (data) {
                          // Apply filter before passing to TransactionHistory
                          // final filtered = _transactionFilter == null
                          //     ? data
                          //     : data.where((tx) {
                          //         // Example: filter by type
                          //         return tx['type'] == _transactionFilter;
                          //       }).toList();
                          return ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height,
                            ),
                            child: TransactionHistory(transactions: data),
                          );
                        },
                        error: (error, stackTrace) =>
                            TransactionHistory(transactions: []),
                        loading: () => ListWidgetSkeleton(),
                      )
                    : Text("No data found".tr),
              ],
            ),
          ),
        ),
        bottomNavigationBar: tokenCheckingState.token.value.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    gradient: LinearGradient(
                      colors: AppStyle.bidButtonGradient,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () async {
                      final datas = data.value ?? {};
                      print(datas.toString());
                      Get.to(
                        () => AddFundScreen(
                          auctionID: 2292,
                          // datas['id'],
                          emailVerifiedAt: datas['email_verified_at'] ?? '',
                          phoneNumberVerifiedAt:
                              datas['mobile_verified_at'] ?? '',
                          addFund: 'addFund',
                          accountNumber: datas['account_number'] ?? '',
                          bankName: datas['bank'] ?? '',
                          beneficiary: datas['beneficiary'] ?? '',
                          civilID: datas['resident_card_number'] ?? '',
                          enrollName: datas['name'] ?? '',
                          isCompany: datas['is_company'] ?? 0,
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Add Funds".tr,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.account_balance_wallet, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              )
            : SizedBox(),
      ),
    );
  }

  Column transactionListAllDetails(int userID, AsyncValue<dynamic> walletData) {
    ref.listen(transationResponseProvider, (previous, next) {
      setState(() {});
    });

    return walletData.when(
      data: (data) {
        final userTransactions = data;
        return Column(
          children: List.generate(userTransactions.length, (index) {
            final transaction = userTransactions[index];
            final date = DateTime.parse(transaction['created_at']);

            final approved = transaction['status'] == 'A';
            final waitingForAdminApproval = transaction['status'] == 'P';
            final waitingForFinanceApproval = transaction['status'] == 'F';
            final withdrawRequested = transaction['status'] == 'W';
            final withdrawRequestApprovedByAdmin =
                transaction['status'] == 'WA';
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
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 2.0,
              ),
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
                    vertical: 12,
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
                        _amountChip(
                          label: "Debit".tr,
                          value: "${transaction['debit']} OMR",
                          color: Colors.red,
                        ),
                        const SizedBox(width: 8),
                        _amountChip(
                          label: "Credit".tr,
                          value: "${transaction['credit']} OMR",
                          color: Colors.green,
                        ),
                        const Spacer(),
                        Text(
                          "#${transaction['id']}",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {},
                ),
              ),
            );
          }),
        );
      },
      error: (error, stackTrace) {
        return Column(children: [Image.asset(noInternetImage)]);
      },
      loading: () {
        return const Column(children: [ListWidgetSkeleton()]);
      },
    );
  }

  // Helper for modern amount chip
  Widget _amountChip({
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withAlpha(200),
        borderRadius: BorderRadius.circular(8),
        border: BoxBorder.all(color: color),
      ),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Text(
        "$label: $value",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Container loading() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [darkBlue, Colors.blue]),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.5),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Skeletonizer(
        enabled: true,
        child: frontcard({
          "name": "Loading...",
          "cr_number": "Loading...",
          "wallet_amount": "Loading...",
        }),
      ),
    );
  }

  Widget frontcard(Map<String, dynamic> userInfo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Icon(Icons.account_balance_wallet, color: Colors.white),
        ),
        const SizedBox(height: 10),
        Text(
          "Welcome Back".tr,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          userInfo['name'],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Available Balance".tr,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${userInfo['wallet_amount'] ?? '0.00'} OMR",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            InkWell(
              onTap: () {
                if (userInfo['wallet_amount'] == null ||
                    userInfo['wallet_amount'] == 0) {
                  Get.snackbar(
                    'Error',
                    'No amount available to withdraw'.tr,
                    backgroundColor: darkRed,
                    colorText: Colors.white,
                    duration: const Duration(seconds: 2),
                  );
                  return;
                }

                Get.dialog(
                  WithdrawAmountFromWallet(
                    walletAmount: userInfo['wallet_amount'],
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: yelloAccent),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Icon(Icons.wallet, color: darkBlue),
                      width05,
                      Text('Withdraw'.tr, style: smallFontSize12),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTransactionList(
    double screenWidth,
    int userID,
    AsyncValue<dynamic> walletData,
    dynamic userData,
  ) {
    return Consumer(
      builder: (context, ref, child) {
        ref.listen(transationResponseProvider, (previous, next) {
          setState(() {});
        });

        return walletData.when(
          data: (data) {
            // if (data.isEmpty) {
            //   return Center(
            //     child: Text(
            //       "No Transactions Available right now".tr,
            //       style: TextStyle(fontSize: 16, color: AppStyle.darkGray),
            //     ),
            //   );
            // }
            // if (data.isNotEmpty) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  width: screenWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
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
                  child: Row(
                    children: [
                      if (userData != null)
                        Text(
                          (userData['name'] ?? 'User').toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  width: screenWidth * 0.95,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    // gradient: LinearGradient(
                    //   colors: [
                    //     Colors.white.withValues(alpha: 0.7),
                    //     Colors.blue.withValues(alpha: 0.08),
                    //   ],
                    //   begin: Alignment.topLeft,
                    //   end: Alignment.bottomRight,
                    // ),
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 12,
                    ),
                    child: Column(
                      children: [
                        height05,
                        // Summary cards
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        WidgetSpan(
                                          child: Transform.translate(
                                            offset: const Offset(0, -4),
                                            child: Text(
                                              " OMR ",
                                              style: TextStyle(
                                                color: AppStyle.darkGray,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      text: AmountFormate().withDecimal(
                                        (meta['balance_sum'] ?? '0.00'),
                                      ),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 26,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Available Balance".tr,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 60,
                              child: VerticalDivider(
                                width: 30,
                                thickness: 1.5,
                                color: Colors.black45,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        WidgetSpan(
                                          child: Transform.translate(
                                            offset: const Offset(0, -4),
                                            child: Text(
                                              " OMR ",
                                              style: TextStyle(
                                                color: AppStyle.darkGray,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      text: AmountFormate().withDecimal(
                                        (meta['hold_sum'] ?? '0.00').toString(),
                                      ),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 26,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Hold Amount".tr,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        height15,
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              71,
                              24,
                              141,
                              154,
                            ),
                            foregroundColor: AppStyle.darkGray,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 58,
                              vertical: 12,
                            ),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            if (meta['balance_sum'] == null ||
                                meta['balance_sum'] == 0) {
                              Get.snackbar(
                                'Error',
                                'No amount available to withdraw'.tr,
                                backgroundColor: Colors.redAccent,
                                colorText: Colors.white,
                                duration: const Duration(seconds: 2),
                              );
                              return;
                            }
                            Get.dialog(
                              WithdrawAmountFromWallet(
                                walletAmount: meta['balance_sum'],
                              ),
                            );
                          },
                          icon: const Icon(Icons.wallet, size: 20),
                          label: Text('Withdraw'.tr),
                        ),
                        height10,
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(right: 6.0),
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white38,
                                  border: Border.all(color: Colors.white70),
                                ),
                                child: Column(
                                  children: [
                                    Text("Client Due".tr),
                                    Text(
                                      "${meta['client_due']} OMR",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  if (transactionFilter == "withdraw") {
                                    transactionType('');
                                    return;
                                  }

                                  transactionType("withdraw");
                                  transactionFilter = "withdraw";
                                },
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  margin: const EdgeInsets.only(right: 6.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white38,
                                    border: Border.all(color: Colors.white70),
                                  ),
                                  child: Column(
                                    children: [
                                      Text("Withdraw".tr),
                                      Text(
                                        "${meta['debit_sum'] ?? 'N/A'} OMR",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // GestureDetector(
                        //   onTap: () {
                        //     transactionType("deposit");
                        //   },
                        //   child: _modernListTile(
                        //     icon: Icons.arrow_upward,
                        //     iconBg: Colors.greenAccent.withValues(alpha: 0.2),
                        //     iconColor: Colors.green,
                        //     title: "Deposits".tr,
                        //     amount: "${meta['credit_sum']} OMR",
                        //   ),
                        // ),
                        // const Divider(
                        //   height: 15,
                        //   thickness: 1,
                        //   color: Color(0xFFE0E0E0),
                        // ),
                        // GestureDetector(
                        //   onTap: () {
                        //     debugPrint("Client Due tapped");
                        //   },
                        //   child: _modernListTile(
                        //     icon: Icons.person,
                        //     iconBg: Colors.orangeAccent.withValues(alpha: 0.2),
                        //     iconColor: Colors.orange,
                        //     title: "Client Due".tr,
                        //     amount: "${meta['client_due'] ?? 'N/A'} OMR",
                        //   ),
                        // ),
                        // const Divider(
                        //   height: 15,
                        //   thickness: 1,
                        //   color: Color(0xFFE0E0E0),
                        // ),
                        // GestureDetector(
                        //   onTap: () {
                        //     transactionType("hold");
                        //   },
                        //   child: _modernListTile(
                        //     icon: Icons.block_outlined,
                        //     iconBg: Colors.redAccent.withValues(alpha: 0.2),
                        //     iconColor: Colors.red,
                        //     title: "Hold Amount".tr,
                        //     amount: "${meta['hold_sum']} OMR",
                        //   ),
                        // ),
                        // const Divider(
                        //   height: 15,
                        //   thickness: 1,
                        //   color: Color(0xFFE0E0E0),
                        // ),
                        // GestureDetector(
                        //   onTap: () {
                        //     transactionType("withdraw");
                        //   },
                        //   child: _modernListTile(
                        //     icon: Icons.arrow_downward,
                        //     iconBg: Colors.blueAccent.withValues(alpha: 0.2),
                        //     iconColor: Colors.blue,
                        //     title: "Withdraw".tr,
                        //     amount: "${meta['debit_sum']} OMR",
                        //   ),
                        // ),
                        // if (_transactionFilter != null)
                        //   Padding(
                        //     padding: const EdgeInsets.only(top: 8.0),
                        //     child: TextButton(
                        //       onPressed: () {
                        //         transactionType('');
                        //       },
                        //       child: Text("Clear Filter".tr),
                        //     ),
                        //   ),
                      ],
                    ),
                  ),
                ),
              ],
            );
            // } else {
            //   return Center(
            //     child: InkWell(
            //       child: Text(
            //         "No transactions found".tr,
            //         style: TextStyle(
            //           color: Colors.grey[600],
            //           fontWeight: FontWeight.w500,
            //         ),
            //       ),
            //     ),
            //   );
            // }
            // } else {
            //   return Center(
            //     child: InkWell(
            //       child: Text(
            //         "No transactions found".tr,
            //         style: TextStyle(
            //           color: Colors.grey[600],
            //           fontWeight: FontWeight.w500,
            //         ),
            //       ),
            //     ),
            //   );
            // }
          },
          error: (error, stackTrace) {
            return Text("Something went wrong");
          },
          loading: () {
            return Skeletonizer(
              enabled: true,
              child: Container(
                width: screenWidth * 0.95,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blueGrey.withValues(alpha: 0.08),
                ),
                child: Column(
                  children: [
                    _modernListTile(
                      icon: Icons.arrow_upward,
                      iconBg: Colors.greenAccent.withValues(alpha: 0.2),
                      iconColor: Colors.green,
                      title: "Deposits",
                      amount: "Loading...",
                    ),
                    _modernListTile(
                      icon: Icons.person,
                      iconBg: Colors.orangeAccent.withValues(alpha: 0.2),
                      iconColor: Colors.orange,
                      title: "Customer Dues",
                      amount: "Loading...",
                    ),
                    _modernListTile(
                      icon: Icons.block_outlined,
                      iconBg: Colors.redAccent.withValues(alpha: 0.2),
                      iconColor: Colors.red,
                      title: "Reserved Amounts",
                      amount: "Loading...",
                    ),
                    _modernListTile(
                      icon: Icons.arrow_downward,
                      iconBg: Colors.blueAccent.withValues(alpha: 0.2),
                      iconColor: Colors.blue,
                      title: "Withdrawn Amounts",
                      amount: "Loading...",
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _modernListTile({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String amount,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(10),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ),
          // Text(
          //   amount,
          //   style: const TextStyle(
          //     fontWeight: FontWeight.bold,
          //     fontSize: 15,
          //     color: Colors.black,
          //   ),
          // ),
        ],
      ),
    );
  }
}
