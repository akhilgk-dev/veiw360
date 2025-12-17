import 'package:flutter/material.dart';
import 'package:view360/common/theme/colors.dart';

class BannerLogin extends StatelessWidget {
  const BannerLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 150,
      child: Stack(
        children: [
          Container(width: double.infinity, height: 110, color: white),
          // Right-side semi-circle
          // Align(
          //   alignment: Alignment.centerRight,
          //   child: Container(
          //     width: 160,
          //     height: 130,
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.only(
          //         bottomLeft: Radius.circular(50),
          //         topLeft: Radius.circular(50),
          //       ),
          //       color: darkBlue,
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Left logo
                    Image.asset(
                      'assets/images/logo-l.png',
                      fit: BoxFit.contain,
                      height: 30,
                    ),
                    // Right logo
                    // Image.asset(
                    //   'assets/images/logo-r (1).png',
                    //   fit: BoxFit.contain,
                    //   height: 30,
                    // ),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
