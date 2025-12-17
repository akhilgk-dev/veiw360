import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../common/theme/sized_box.dart';
import '../../../common/theme/style.dart';

class EmptyMessageWidget extends StatelessWidget {
  final String message;
  Color textcolor = Colors.red;
  EmptyMessageWidget({
    super.key,
    required this.message,
    this.textcolor = Colors.red,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          height15,
          Lottie.asset(
            'assets/json/no_data.json',
            width: 200,
            height: 200,
            fit: BoxFit.fill,
          ),
          SizedBox(height: 15),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: textcolor),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                message,
                style: headingTextStyle.copyWith(
                  color: textcolor,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
