import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:view360/api/tracking_new/tracking_mybids_api.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/view/widgets/appbar_widget/appbar_widget.dart';

class TrackingMybids extends StatefulWidget {
  const TrackingMybids({super.key, required this.acutionId});

  final int acutionId;

  @override
  State<TrackingMybids> createState() => _TrackingMybidsState();
}

class _TrackingMybidsState extends State<TrackingMybids> {
  final TrackingMybidsApi trackingMybidsApi = Get.put(TrackingMybidsApi());
  @override
  void initState() {
    super.initState();
    trackingMybidsApi.getTrackingMyBids(auctionId: widget.acutionId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(title: "Auction Tracking".tr),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: AppStyle.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                ),
                child: Row(
                  children: [
                    ImageIcon(
                      AssetImage('assets/images/tracking_icon.png'),
                      size: 26,
                      color: AppStyle.secondary,
                    ),
                    SizedBox(width: 8), // Add spacing
                    Text(
                      "Auction Progress Timeline".tr,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

              // SizedBox(height: 16), // Add spacing
              Obx(() {
                if (trackingMybidsApi.isLoading.value) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: LinearProgressIndicator(),
                    ),
                  );
                } else if (trackingMybidsApi.errorMessage.value.isNotEmpty) {
                  return Center(
                    child: Text(
                      trackingMybidsApi.errorMessage.value,
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  );
                } else if (trackingMybidsApi.success.value) {
                  final steps = trackingMybidsApi.trackingData?.steps ?? [];
                  final currentStep = steps.indexWhere(
                    (step) =>
                        step.status == 'in-progress' ||
                        step.status == 'rejected',
                  );

                  return Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(0),
                            bottom: Radius.circular(8),
                          ),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: Offset(
                                0,
                                3,
                              ), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 16),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.white,
                              ),
                              child: LinearProgressIndicator(
                                borderRadius: BorderRadius.circular(50),
                                value: (currentStep) / steps.length,
                                backgroundColor: Colors.grey[300],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppStyle.secondColor,
                                ),
                                minHeight: 10,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "${"Overall Progress".tr}: ${((currentStep) / steps.length * 100).toStringAsFixed(0)}%",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Stepper(
                        physics: NeverScrollableScrollPhysics(),
                        stepIconWidth: 35,
                        stepIconHeight: 35,
                        steps: steps.map((step) {
                          Color stepColor;
                          if (step.status == 'completed') {
                            stepColor = Colors.green;
                          } else if (step.status == 'in-progress') {
                            stepColor = Colors.blue;
                          } else if (step.status == 'rejected') {
                            stepColor = Colors.red;
                          } else {
                            stepColor = Colors.grey;
                          }

                          return Step(
                            title: Text(
                              (step.label ?? '').tr,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              step.date ?? step.status.toString(),
                              style: TextStyle(
                                fontSize: 12,
                                color: AppStyle.darkGray,
                              ),
                            ),
                            content: Container(), // Provide an empty container
                            isActive:
                                step.status == 'completed' ||
                                step.status == 'in-progress',
                            state: step.status == 'completed'
                                ? StepState.complete
                                : step.status == 'in-progress'
                                ? StepState.editing
                                : StepState.disabled,
                            // Custom styling for the step indicator
                            stepStyle: StepStyle(
                              color: stepColor,

                              boxShadow: BoxShadow(
                                color: stepColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),

                              border: Border.all(color: stepColor, width: 2),
                            ),
                          );
                        }).toList(),
                        currentStep:
                            (currentStep >= 0 && currentStep < steps.length)
                            ? currentStep
                            : 0, // Ensure currentStep is valid
                        onStepTapped: (index) {
                          // Add functionality if needed
                        },
                        controlsBuilder: (context, details) =>
                            SizedBox.shrink(),
                        margin: EdgeInsets.symmetric(
                          horizontal: 16,
                        ), // Add margin
                      ),
                    ],
                  );
                } else {
                  return Center(
                    child: Text(
                      "No Data Found",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
