import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:view360/common/theme/colors.dart';
import 'package:view360/view/home/widgets/vision_card.dart';
import 'package:view360/view/widgets/appbar_widget/appbar_widget.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(title: 'About Us'.tr),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 20),

              /// Header with icon
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline, color: darkBlue, size: 28),
                  const SizedBox(width: 8),
                  Text(
                    "Who Are We?".tr,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// Card-style container
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Text(
                  "We are passionate about creating a dynamic marketplace where buyers and sellers come together to discover unique treasures and conduct transactions with confidence. With years of industry experience, our dedicated team is committed to providing a seamless and secure platform for auctions of all types.\n\nWhether you are a seasoned collector or a first-time bidder, we strive to offer an intuitive and user-friendly experience.\n\nOur commitment to transparency, trust, and customer satisfaction sets us apart, ensuring that every interaction with us is positive and memorable.\n\nJoin us today and be part of a vibrant community of enthusiasts where the thrill of bidding awaits you!"
                      .tr,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
              ),

              const SizedBox(height: 30),
              VisionCard(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
