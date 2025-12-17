import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:view360/api/type_auction_count/type_auction_count.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/view/search/filter_drawer.dart';
import 'package:view360/view/search/search_and_viewall.dart';

class AuctionsInMenu extends ConsumerWidget {
  AuctionsInMenu({super.key});
  final TypeAuctionCountAPI typeAuctionCountAPI = Get.put(
    TypeAuctionCountAPI(),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<int> auctionCounts = [
      typeAuctionCountAPI.activeCount.value,
      typeAuctionCountAPI.upcomingCount.value,
      typeAuctionCountAPI.previusCount.value,
      typeAuctionCountAPI.directSaleCount.value,
    ];
    List<Icon> auctionIcons = [
      Icon(Icons.gavel_sharp),
      Icon(Icons.schedule),
      Icon(Icons.history),
      Icon(Icons.store),
    ];
    return Column(
      children: [
        // Your widgets here
        for (int i = 0; i < 4; i++)
          ListTile(
            leading: Icon(
              auctionIcons[i].icon,
              color: AppStyle.darkGray,
              size: 18,
            ),
            title: Text(
              drawerText[i].tr,
              style: TextStyle(
                fontSize: 14,
                color: AppStyle.darkGolden,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: AppStyle.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                auctionCounts[i].toString(),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            onTap: () {
              // Handle tap event
              if (ref.read(selectedAuctionTypeProvider.notifier).state == i) {
                // Deselect if already selected
                ref.read(selectedAuctionTypeProvider.notifier).state = -1;
                Navigator.of(context).pop();
              } else {
                // Select the tapped item
                ref.read(selectedAuctionTypeProvider.notifier).state = i;
                Navigator.of(context).pop();
              }
              Get.to(() => SearchViewAll());
            },
          ),
      ],
    );
  }

  List<String> drawerText = [
    'Active Auctions'.tr,
    'Upcoming Auctions'.tr,
    'Previous Auctions'.tr,
    'Special Auctions'.tr,
  ];
}
