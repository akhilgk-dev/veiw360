// For JSON parsing
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/view/dashboard/my_auctions/my_auction.dart';

class LiveAuctions extends ConsumerStatefulWidget {
  const LiveAuctions({super.key});

  @override
  ConsumerState<LiveAuctions> createState() => _LiveAuctionsState();
}

class MybidsModel {
  final int? id;
  final String? title;
  final String? titleAr;
  final String? startDate;
  final double? startAmount;
  final String? endDate;
  final int? deliveryStatus;
  final String? status;
  final String? auctionCoverUrl;
  final String? groupName;
  final String? groupNameAr;
  final String? organizationName;
  final String? organizationNameAr;
  final String? organizationUrl;
  final double? currentBidAmount;
  final int? totalBidders;
  final double? bidAmount;
  final String? lastBidAt;
  final double? previousBidAmount;
  final int? userRank;

  MybidsModel({
    this.id,
    this.title,
    this.titleAr,
    this.startDate,
    this.startAmount,
    this.endDate,
    this.deliveryStatus,
    this.status,
    this.auctionCoverUrl,
    this.groupName,
    this.groupNameAr,
    this.organizationName,
    this.organizationNameAr,
    this.organizationUrl,
    this.currentBidAmount,
    this.totalBidders,
    this.bidAmount,
    this.lastBidAt,
    this.previousBidAmount,
    this.userRank,
  });

  factory MybidsModel.fromJson(Map<String, dynamic> json) {
    return MybidsModel(
      id: json['id'] as int?,
      title: json['title'] as String?,
      titleAr: json['title_ar'] as String?,
      startDate: json['start_date'] as String?,
      startAmount: (json['start_amount'] as num?)?.toDouble(),
      endDate: json['end_date'] as String?,
      deliveryStatus: json['delivery_status'] as int?,
      status: json['status'] as String?,
      auctionCoverUrl: json['auction_cover_url'] as String?,
      groupName: json['group_name'] as String?,
      groupNameAr: json['group_name_ar'] as String?,
      organizationName: json['organization_name'] as String?,
      organizationNameAr: json['organization_name_ar'] as String?,
      organizationUrl: json['organization_url'] as String?,
      currentBidAmount: (json['current_bid_amount'] as num?)?.toDouble(),
      totalBidders: json['total_bidders'] as int?,
      bidAmount: (json['bid_amount'] as num?)?.toDouble(),
      lastBidAt: json['last_bid_at'] as String?,
      previousBidAmount: (json['previous_bid_amount'] as num?)?.toDouble(),
      userRank: json['user_rank'] as int?,
    );
  }
}

class _LiveAuctionsState extends ConsumerState<LiveAuctions> {
  List<MybidsModel> liveAuctions = [];
  bool isAnimating = true;

  @override
  Widget build(BuildContext context) {
    final auctionResponse = ref.watch(auctionResponseMYAuctions);
    return auctionResponse.when(
      data: (data) {
        final response = data['data'] as List;
        final list = response
            .map((item) => MybidsModel.fromJson(item))
            .toList();
        // Parse and filter live auctions
        liveAuctions = list.where((auction) => auction.status == "A").toList();
        if (liveAuctions.isEmpty) {
          return SizedBox();
        }

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyAuction()),
            );
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedContainer(
                decoration: BoxDecoration(
                  color: AppStyle.secondColor.withAlpha(100),
                  borderRadius: BorderRadius.circular(50),
                ),
                duration: Duration(milliseconds: 300),
                width: isAnimating ? 60 : 50,
                height: isAnimating ? 60 : 50,
              ),
              SizedBox(
                height: 60,
                width: 60,
                child: Center(
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: AppStyle.testGradient),
                      borderRadius: BorderRadius.circular(50),
                      // border: Border.all(color: AppStyle.secondColor, width: 2),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.gavel_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              TweenAnimationBuilder<double>(
                tween: Tween(
                  begin: isAnimating ? 12 : 10, // Start size
                  end: isAnimating ? 10 : 12,
                ), // Pulsating size range
                duration: Duration(milliseconds: 800),
                curve: Curves.easeInOut,
                builder: (context, size, child) {
                  return Container(
                    margin: EdgeInsets.only(top: 8, right: 8),
                    width: size,
                    height: size,
                  );
                },
                onEnd: () {
                  // Reverse the animation to create the pulsating effect
                  setState(() {
                    isAnimating = !isAnimating;
                  });
                },
              ),
            ],
          ),
        );
      },
      error: (error, stackTrace) {
        return SizedBox();
      },
      loading: () {
        return SizedBox();
      },
    );
  }
}
