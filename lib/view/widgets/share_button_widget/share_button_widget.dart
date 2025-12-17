import 'package:flutter/material.dart';
import 'package:view360/common/theme/colors.dart';
import 'package:share_plus/share_plus.dart';

class ShareButtonWidget extends StatelessWidget {
  const ShareButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 50,
      top: 10,
      child: GestureDetector(
        onTap: () async {
          await Share.share(
            'Check out this auction: ${"auction.categoryDetails!.fileCategoryImage.toString"}',
            subject: 'Auction Details',
          );
        },
        child: CircleAvatar(
          backgroundColor: white,
          radius: 15,
          child: const Icon(Icons.share, color: Colors.black, size: 14),
        ),
      ),
    );
  }
}
