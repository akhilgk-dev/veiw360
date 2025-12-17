import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:view360/api/tracking/tracking_api.dart';
import 'package:view360/common/theme/app_style.dart';

class TrackingWidget extends ConsumerStatefulWidget {
  final int auctionId;
  final int groupId;
  final int clientId;

  const TrackingWidget({
    super.key,
    required this.auctionId,
    required this.groupId,
    required this.clientId,
  });

  @override
  ConsumerState<TrackingWidget> createState() => _TrackingWidgetState();
}

class _TrackingWidgetState extends ConsumerState<TrackingWidget> {
  late final TrackingParams _params;

  @override
  void initState() {
    super.initState();
    _params = TrackingParams(
      auctionId: widget.auctionId,
      groupId: widget.groupId,
      clientId: widget.clientId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final trackingAsync = ref.watch(trackingResponseProvider(_params));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Auction Tracking'.tr,
          style: TextStyle(color: AppStyle.primary),
        ),
      ),
      body: trackingAsync.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (trackingModel) {
          if (trackingModel.data.isEmpty) {
            return Center(child: Text('No tracking data available'));
          }
          final data = trackingModel.data.first;
          final steps = [
            _TrackingStep(
              title: 'Site Visit',
              status: data.siteVisit,
              date: data.siteVisit?.date ?? 'No date',
            ),
            _TrackingStep(
              title: 'Registration',
              status: data.registration,
              date: data.registration?.date ?? 'No date',
            ),
            _TrackingStep(
              title: 'Auction Start',
              status: data.auctionStart,
              date: data.auctionStart?.date ?? 'No date',
            ),
            _TrackingStep(
              title: 'Auction End',
              status: data.auctionEnd,
              date: data.auctionEnd?.date ?? 'No date',
            ),
            _TrackingStep(
              title: 'Client Approval',
              status: data.clientApproval,
              date: data.clientApproval?.date ?? 'No date',
            ),
            _TrackingStep(
              title: 'Client Payment',
              status: data.clientPayment,
              date: data.clientPayment?.date ?? 'No date',
            ),
            _TrackingStep(
              title: 'Completed',
              status: data.completed,
              date: data.completed?.date ?? 'No date',
            ),
          ];

          return Stepper(
            physics: NeverScrollableScrollPhysics(),
            currentStep: _getCurrentStepIndex(steps),
            controlsBuilder: (context, details) => SizedBox.shrink(),
            steps: steps
                .map(
                  (step) => Step(
                    title: Text(step.title),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.auctionEnd?.date ?? 'No date',
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        ),
                        Text(
                          _statusText(step.status?.status),
                          style: TextStyle(
                            color: _statusColor(step.status?.status),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          step.date ?? '',
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        ),
                      ],
                    ),
                    isActive: step.status?.status == 'A',
                    state: _stepState(step.date),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }

  int _getCurrentStepIndex(List<_TrackingStep> steps) {
    for (int i = 0; i < steps.length; i++) {
      if (steps[i].status?.status != 'A') {
        return i > 0 ? i - 1 : 0;
      }
    }
    return steps.length - 1;
  }

  String _statusText(String? status) {
    switch (status) {
      case 'A':
        return 'Completed';
      case 'P':
        return 'Pending';
      case 'R':
        return 'Rejected';
      default:
        return 'Unknown';
    }
  }

  Color _statusColor(String? status) {
    switch (status) {
      case 'A':
        return Colors.green;
      case 'P':
        return Colors.orange;
      case 'R':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  StepState _stepState(String? status) {
    switch (status) {
      case 'A':
        return StepState.complete;
      case 'P':
        return StepState.editing;
      case 'R':
        return StepState.error;
      default:
        return StepState.indexed;
    }
  }
}

class _TrackingStep {
  final String title;
  final dynamic status; // TrackingStatus?
  final String date;

  _TrackingStep({
    required this.title,
    required this.status,
    required this.date,
  });
}
