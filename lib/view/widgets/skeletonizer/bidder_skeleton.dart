import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TopBidderSkeleton extends StatelessWidget {
  const TopBidderSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Skeletonizer(
          enabled: true,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Loading...........'),
                  Text('Loading..'),
                  Text('130'),
                ],
              ),
            ),
          )),
    );
  }
}
