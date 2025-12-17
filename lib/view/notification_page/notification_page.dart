import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:view360/view/widgets/appbar_widget/appbar_widget.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(title: 'Notifications'.tr),
      body: Center(child: Text('There is no Notifications'.tr)),
    );
  }
}
