import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonLoadingWallet extends StatelessWidget {
  const SkeletonLoadingWallet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Skeletonizer(
        enabled: true,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Skeletonizer(
                enabled: true,
                child: Container(
                  width: 100,
                  height: 20,
                  color: Colors.grey[300],
                ),
              ),
              const SizedBox(height: 10),
              Skeletonizer(
                enabled: true,
                child: Container(
                  width: 200,
                  height: 20,
                  color: Colors.grey[300],
                ),
              ),
              const SizedBox(height: 10),
              Skeletonizer(
                enabled: true,
                child: Container(
                  width: 150,
                  height: 20,
                  color: Colors.grey[300],
                ),
              ),
              const SizedBox(height: 10),
              Skeletonizer(
                enabled: true,
                child: Container(
                  width: 100,
                  height: 20,
                  color: Colors.grey[300],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
