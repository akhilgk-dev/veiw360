import 'package:flutter/material.dart';
import 'package:view360/common/theme/colors.dart';
import 'package:view360/common/theme/sized_box.dart';
import 'package:view360/model/live_bidding_model/top_bidders/top_bidders_model.dart';
import 'package:view360/view/widgets/appbar_widget/appbar_widget.dart';

class AllTopBidders extends StatelessWidget {
  final List<BidData> bidders;
  final int myUserid;
  final int length;
  const AllTopBidders({
    super.key,
    required this.bidders,
    required this.myUserid,
    required this.length,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(title: 'Top All Bidders'),

      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: bidders.length,
          itemBuilder: (context, index) {
            return topBidders(
              index,
              bidders,
              myUserid,
              bidders.length,
              context,
            );
          },
        ),
      ),
    );
  }

  InkWell topBidders(
    int index,
    List<BidData> bidders,
    int myUserId,
    int length,
    BuildContext context,
  ) {
    final bidder = bidders[index];
    final isMyBidder = bidder.userId == myUserId;

    int? userPosition;
    for (int i = 0; i < bidders.length; i++) {
      if (bidders[i].userId == myUserId) {
        userPosition = i + 1;
        break;
      }
    }

    // Updated gradient colors for top 3 ranks
    final List<Gradient> rankGradients = [
      LinearGradient(
        colors: [Colors.yellow.shade300, Colors.orange.shade700],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      LinearGradient(
        colors: [Colors.grey.shade300, Colors.grey.shade700],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      LinearGradient(
        colors: [Colors.brown.shade200, Colors.brown.shade600],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ];

    final gradient = (index < 3) ? rankGradients[index] : null;
    final badgeIcon = index == 0
        ? Icons.emoji_events
        : index == 1
        ? Icons.emoji_events_outlined
        : index == 2
        ? Icons.military_tech
        : null;

    return InkWell(
      onTap: () {
        // Add interactivity: maybe show a bottom sheet with more user info
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: gradient,
          color: gradient == null ? Colors.white : null,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Profile Circle
            CircleAvatar(
              radius: 22,
              backgroundColor: isMyBidder ? Colors.green : Colors.blueGrey,
              child: Icon(Icons.person, color: white),
            ),
            const SizedBox(width: 12),

            // Enroll Number & Rank
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bidder.enrollNumber ?? 'Unknown',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isMyBidder ? Colors.black : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: MediaQuery.of(context).size.width / 3.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: darkBlue,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (badgeIcon != null)
                            Icon(badgeIcon, size: 18, color: Colors.amber),
                          const SizedBox(width: 6),
                          Text(
                            isMyBidder
                                ? 'My Rank: ${userPosition ?? "-"}'
                                : 'Rank ${index + 1}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bid Amount
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isMyBidder ? Colors.green : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "${bidder.bidAmount} OMR",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isMyBidder ? Colors.white : Colors.black87,
                  fontSize: 14,
                ),
              ),
            ),
            width10,
          ],
        ),
      ),
    );
  }
}
