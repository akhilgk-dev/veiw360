import 'package:flutter/material.dart';
import 'package:view360/common/theme/app_style.dart';

class DashboardGrid extends StatelessWidget {
  final List<Map<String, dynamic>> actions;
  final Color cardColor;
  final double iconSize;

  const DashboardGrid({
    super.key,
    required this.actions,
    this.cardColor = Colors.white,
    this.iconSize = 40,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 26, vertical: 8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return GestureDetector(
          onTap: action["route"],
          child: Container(
            decoration: BoxDecoration(
              color: AppStyle.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: AppStyle.lightGray,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                action["icon"] is String
                    ? SizedBox(
                        height: 65,
                        child: Image.asset(
                          action["icon"],
                          height: iconSize,
                          // color: AppStyle
                          //     .colorsList[index % AppStyle.colorsList.length]
                          //     .withValues(alpha: 0.8),
                        ),
                      )
                    : action["icon"],
                SizedBox(height: 12),
                Text(
                  action["label"],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppStyle.secondary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
