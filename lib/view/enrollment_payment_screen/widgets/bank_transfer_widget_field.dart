import 'package:flutter/material.dart';
import 'package:view360/common/theme/app_style.dart';

class BankTransferTextField extends StatelessWidget {
  const BankTransferTextField({
    super.key,
    required this.label,
    required this.validator,
    required this.controller,
    required this.hinttext,
    this.keyBOARD,
  });

  final String label;
  final String? Function(String? p1) validator;
  final TextEditingController controller;
  final String hinttext;
  final TextInputType? keyBOARD;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8), // Adjusted spacing for better alignment
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600, // Slightly bolder font
                color: Colors.black87, // Darker text color for better contrast
              ),
            ),
          ),
          const SizedBox(height: 6), // Adjusted spacing

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 58),
              child: TextFormField(
                keyboardType: keyBOARD,
                controller: controller,
                validator: validator,
                decoration: InputDecoration(
                  hintText: hinttext,
                  hintStyle: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey, // Subtle hint text color
                  ),
                  filled: true,
                  fillColor: Colors.white, // White background for modern look
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      12.0,
                    ), // Rounded corners
                    borderSide: BorderSide(
                      color: AppStyle.lightGray2,
                      width: 0.8,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: AppStyle.lightGray2,
                      width: 0.8,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: AppStyle.secondary, // Highlighted border
                      width: 1.2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(color: Colors.red, width: 0.8),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(color: Colors.red, width: 1.2),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8), // Adjusted spacing
        ],
      ),
    );
  }
}
