// WalletCard.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:view360/api/wallet_screen/wallet_paymant_user_information_api.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/view/bottomNav/wallet/withdraw_amount/withdraw_amount.dart';
import 'package:skeletonizer/skeletonizer.dart';

class WalletCard extends ConsumerWidget {
  final int id;
  const WalletCard({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(walletInformationResponseProvider(id));
    return userData.when(
      data: (data) {
        if (data == null) {
          return Center(child: Text("No user data found".tr));
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                // Glassmorphism background
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                  child: Container(
                    height: 220,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        //Change ltr rtl
                        colors: AppStyle.bidButtonGradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppStyle.secondColor.withValues(alpha: 0.08),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                  ),
                ),
                // Card content
                Container(
                  height: 220,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white70,
                            child: Icon(
                              Icons.account_balance_wallet,
                              color: AppStyle.secondColor,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            data['name'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                "${data['wallet_amount'] ?? '0.00'} OMR",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Text(
                                data['name'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  // letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Available Balance".tr,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${data['wallet_amount'] ?? '0.00'} OMR",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white60,
                              foregroundColor: AppStyle.darkGray,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 12,
                              ),
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              if (data['wallet_amount'] == null ||
                                  data['wallet_amount'] == 0) {
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
                                  walletAmount: data['wallet_amount'],
                                ),
                              );
                            },
                            icon: const Icon(Icons.wallet, size: 20),
                            label: Text('Withdraw'.tr),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      error: (error, stackTrace) => Center(child: Text("Error: $error")),
      loading: () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        child: Container(
          height: 220,
          decoration: BoxDecoration(
            color: Colors.blueGrey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(24),
          ),
          child: LoadingCard(),
        ),
      ),
    );
  }
}

class LoadingCard extends StatelessWidget {
  const LoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppStyle.bidButtonGradient,
          //  [

          //   AppStyle.secondColor.withValues(alpha: 0.25),
          //   AppStyle.secondColor,
          // ],
        ),
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
        child: SizedBox(height: 150, width: 200),
      ),
    );
  }
}
