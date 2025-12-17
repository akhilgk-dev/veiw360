import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/common/theme/colors.dart';
import 'package:view360/common/theme/sized_box.dart';

class VisionCard extends StatelessWidget {
  VisionCard({super.key});

  final bgColors = [Colors.orange[50], Colors.blue[50], Colors.green[50]];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Our Vision',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          height10,
          decoratedContainer(
            Row(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(
                    'https://www.mzadcom.om/assets/images/about/chairman.jpg',
                  ),
                ),
                width05,
                SizedBox(
                  width: 220,
                  child: Text(
                    'We are building a trusted marketplace where buyers and sellers connect with confidence. Integrity and transparency guide everything we do.',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                      height: 1.5,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          height15,
          decoratedContainer(
            Row(
              children: [
                SizedBox(
                  width: 220,
                  child: Text(
                    'Our goal is to make every auction seamless, secure, and user-friendly. We work to deliver value for both collectors and first-time bidders.',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                      height: 1.5,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                width05,
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(
                    'https://www.mzadcom.om/assets/images/about/ceo.jpg',
                  ),
                  backgroundColor: Colors.white,
                ),
              ],
            ),
            index: 1,
          ),
          height15,
          decoratedContainer(
            Row(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(
                    'https://www.mzadcom.om/assets/images/about/gm.png',
                  ),
                ),
                width05,
                SizedBox(
                  width: 220,
                  child: Text(
                    'We are creating a vibrant community where the thrill of bidding meets trust and reliability. Customer satisfaction is at the heart of our journey.',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                      height: 1.5,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ],
            ),
            index: 2,
          ),
        ],
      ),
    );
  }

  Widget decoratedContainer(Widget child, {int index = 0}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          // color: bgColors[index] ?? Colors.white.withAlpha(83),
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [bgColors[index] ?? Colors.white.withAlpha(83), white],
          ),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: bgColors[index] ?? Colors.white.withAlpha(82),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(82),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: EdgeInsets.all(6),
        child: child,
      ),
    );
  }
}
