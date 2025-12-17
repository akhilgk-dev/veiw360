import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:view360/common/theme/app_style.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    super.key,
    required this.childWidget,
    required this.onTap,
  });
  final Widget childWidget;
  final Callback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: AppStyle.blueButtonGradient),
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Center(child: childWidget),
      ),
    );
  }
}
