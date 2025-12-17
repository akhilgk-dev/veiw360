import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:view360/api/tracking/tracking_all_api.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/model/tracking/tracking_model.dart';
import 'package:view360/view/widgets/appbar_widget/appbar_widget.dart';
import 'package:view360/view/widgets/empty_message/empty_message_widget.dart';

class TrackingScreen extends ConsumerWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trackingData = ref.watch(trackingAllResponseProvider);
    return Scaffold(
      backgroundColor: AppStyle.scaffoldBg,
      appBar: AppbarWidget(title: 'Tracking Screen'),
      body: trackingData.when(
        data: (data) {
          // Handle the successful data case
          return ListView.builder(
            itemCount: data.data.length,
            itemBuilder: (context, index) {
              final item = data.data[index];
              return TrackingWidget(trackingModel: item);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          // Handle the error case
          return Center(
            child: Column(
              children: [
                //  Text('Error: $error'),
                const SizedBox(height: 8),
                EmptyMessageWidget(message: "No data".tr),
              ],
            ),
          );
        },
      ),
    );
  }
}

class TrackingWidget extends StatefulWidget {
  final TrackingData trackingModel;
  const TrackingWidget({super.key, required this.trackingModel});

  @override
  State<TrackingWidget> createState() => _TrackingWidgetState();
}

class _TrackingWidgetState extends State<TrackingWidget> {
  final ScrollController _controller1 = ScrollController();
  final ScrollController _controller2 = ScrollController();
  bool _isSyncing = false;
  @override
  void initState() {
    super.initState();

    _controller1.addListener(() {
      if (_isSyncing) return;
      _isSyncing = true;
      _controller2.jumpTo(_controller1.offset);
      _isSyncing = false;
    });

    _controller2.addListener(() {
      if (_isSyncing) return;
      _isSyncing = true;
      _controller1.jumpTo(_controller2.offset);
      _isSyncing = false;
    });
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'A':
        return Colors.green;
      case 'N':
        return Colors.redAccent;
      default:
        return Colors.orange;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'A':
        return Icons.check;
      case 'N':
        return Icons.radio_button_unchecked;
      default:
        return Icons.timelapse;
    }
  }

  List<Map<String, dynamic>> getSteps() {
    return [
      {
        'label': 'Site Visit',
        'date': widget.trackingModel.siteVisit?.date ?? 'N/A',
        'status': widget.trackingModel.siteVisit?.status ?? 'N',
      },
      {
        'label': 'Registration',
        'date': widget.trackingModel.registration?.date ?? 'N/A',
        'status': widget.trackingModel.registration?.status ?? 'N',
      },
      {
        'label': 'Auction Start',
        'date': widget.trackingModel.auctionStart?.date ?? 'N/A',
        'status': widget.trackingModel.auctionStart?.status ?? 'N',
      },
      {
        'label': 'Auction End',
        'date': widget.trackingModel.auctionEnd?.date ?? 'N/A',
        'status': widget.trackingModel.auctionEnd?.status ?? 'N',
      },
      {
        'label': 'Client Approval',
        'date': widget.trackingModel.clientApproval?.date ?? 'N/A',
        'status': widget.trackingModel.clientApproval?.status ?? 'N',
      },
      {
        'label': 'Client Payment',
        'date': widget.trackingModel.clientPayment?.date ?? 'N/A',
        'status': widget.trackingModel.clientPayment?.status ?? 'N',
      },
      {
        'label': 'Completed',
        'date': widget.trackingModel.completed?.date ?? 'N/A',
        'status': widget.trackingModel.completed?.status ?? 'N',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final steps = getSteps();
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(6),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppStyle.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                children: [
                  Text(
                    widget.trackingModel.auctionTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Auction ID: ${widget.trackingModel.auctionId}',
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),

            // ignore: unnecessary_null_comparison
            const SizedBox(height: 16),
            SizedBox(
              height: 110,
              child: Column(
                children: [
                  // Row for circles and connecting lines
                  SingleChildScrollView(
                    controller: _controller1,
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: steps.length * 80.0,
                      child: Row(
                        children: List.generate(steps.length, (index) {
                          final step = steps[index];
                          final color = _getStatusColor(step['status']);
                          final icon = _getStatusIcon(step['status']);
                          return Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (index == 0)
                                  Expanded(
                                    child: Container(
                                      height: 4,
                                      color: Colors.transparent,
                                    ),
                                  ),
                                // Circle
                                if (index != 0)
                                  Expanded(
                                    child: Container(
                                      height: 4,
                                      color: AppStyle.green.withValues(
                                        alpha: 0.5,
                                      ),
                                    ),
                                  ),
                                CircleAvatar(
                                  backgroundColor: color,
                                  radius: 16,
                                  child: Icon(
                                    icon,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                // Line (except last)
                                if (index != steps.length - 1)
                                  Expanded(
                                    child: Container(
                                      height: 4,
                                      color: AppStyle.green.withValues(
                                        alpha: 0.5,
                                      ),
                                    ),
                                  ),
                                if (index == steps.length - 1)
                                  Expanded(
                                    child: Container(
                                      height: 4,
                                      color: Colors.transparent,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Row for labels
                  SingleChildScrollView(
                    controller: _controller2,
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: steps.length * 80.0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(steps.length, (index) {
                          final step = steps[index];
                          return Expanded(
                            child: Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    step['label'],
                                    style: const TextStyle(fontSize: 12),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  step['date'],
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.black54,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
