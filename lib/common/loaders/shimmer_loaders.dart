import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LoaderCard extends StatelessWidget {
  const LoaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: SizedBox(height: 150, width: 200),
    );
  }
}

class CardShimmerLoader extends StatelessWidget {
  const CardShimmerLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: SizedBox(height: 150, width: 200),
      ),
    );
  }
}
