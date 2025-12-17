import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class TermsAndConditionWidget extends StatelessWidget {
  const TermsAndConditionWidget({
    super.key,
    required this.checkboxProvider,
    required this.termsAndCondition,
    required this.onChanged,
  });

  final StateProvider<bool> checkboxProvider;
  final String termsAndCondition;
  final Function(bool value) onChanged;

  @override
  Widget build(BuildContext context) {
    print("termsAndCondition:$termsAndCondition");
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: [
          Consumer(
            builder: (context, ref, child) {
              final isTrue = ref.watch(checkboxProvider);

              return Checkbox(
                value: isTrue,
                onChanged: (value) {
                  ref.read(checkboxProvider.notifier).state = value!;
                  onChanged(value);
                },
              );
            },
          ),
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                // final data = ref.watch(auctionResponseProviderProfile);
                return Text(
                  'Please accept the'.tr + 'Terms and Conditions(*)'.tr,
                  style: TextStyle(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
