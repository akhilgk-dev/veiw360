import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ListWidgetSkeleton extends StatelessWidget {
  const ListWidgetSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.separated(
        //shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(16),
        itemCount: 5, // Display a few skeleton items
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          return Skeletonizer(
            enabled: true,
            child: Container(
              width: 200,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 20, width: 150, color: Colors.grey),
                  const SizedBox(height: 8),
                  Container(
                    height: 16,
                    width: double.infinity,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 8),
                  Container(height: 16, width: 100, color: Colors.grey),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ListSkeleton extends StatelessWidget {
  const ListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(16),
      itemCount: 5, // Display a few skeleton items
      separatorBuilder: (_, __) => const SizedBox(width: 16),
      itemBuilder: (context, index) {
        return Skeletonizer(
          enabled: true,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            width: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 5,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 20, width: 150, color: Colors.grey),
                const SizedBox(height: 8),
                Container(
                  height: 16,
                  width: double.infinity,
                  color: Colors.grey,
                ),
                const SizedBox(height: 8),
                Container(height: 16, width: 100, color: Colors.grey),
              ],
            ),
          ),
        );
      },
    );
  }
}
