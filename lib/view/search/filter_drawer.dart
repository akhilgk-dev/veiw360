import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:view360/api/type_auction_count/type_auction_count.dart';
import 'package:view360/common/theme/app_style.dart';

import 'package:view360/common/theme/style.dart';
import 'package:view360/view/home/widgets/categorie_list_auctions/categerie_widget.dart';
import 'package:view360/view/search/date_picker.dart';

final selectedAuctionTypeProvider = StateProvider<int>((ref) => -1);

class FilterDrawer extends StatelessWidget {
  const FilterDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppStyle.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Apply Filters'.tr,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: SvgPicture.asset(
                    'assets/images/filter_icon.svg',
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      AppStyle.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            ExpansionTile(
              initiallyExpanded: true,
              leading: Icon(Icons.gavel_rounded, color: AppStyle.liteRed),
              title: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 6,
                ),
                child: Text(
                  'Auctions'.tr,
                  style: blackStyle.copyWith(
                    fontSize: 16,
                    color: AppStyle.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              tilePadding: EdgeInsets.only(left: 18),
              childrenPadding: EdgeInsets.zero,
              children: [AuctionsInFilter()],
            ),
            ExpansionTile(
              initiallyExpanded: true,
              title: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 6,
                ),
                child: Text(
                  'Date picker'.tr,
                  style: blackStyle.copyWith(
                    fontSize: 16,
                    color: AppStyle.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              children: [DatePickerSearch()],
            ),

            ExpansionTile(
              initiallyExpanded: true,
              leading: Icon(Icons.category, color: AppStyle.liteRed),
              title: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 6,
                ),
                child: Text(
                  'Categories'.tr,
                  style: blackStyle.copyWith(
                    fontSize: 16,
                    color: AppStyle.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              tilePadding: EdgeInsets.only(left: 18),
              childrenPadding: EdgeInsets.zero,
              children: [CategoriesWidget(isDrawer: true)],
            ),
          ],
        ),
      ),
    );
  }
}

class AuctionsInFilter extends ConsumerWidget {
  AuctionsInFilter({super.key});
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
    final selectedIndex = ref.watch(selectedAuctionTypeProvider);

    return Column(
      children: [
        // Your widgets here
        for (int i = 0; i < 4; i++)
          ListTile(
            leading: Icon(
              auctionIcons[i].icon,

              color: selectedIndex == i ? AppStyle.primary : AppStyle.darkGray,
              size: 20,
            ),
            title: Text(
              drawerText[i].tr,
              style: TextStyle(
                fontSize: 15,
                color: selectedIndex == i
                    ? AppStyle.primary
                    : AppStyle.darkGolden,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: selectedIndex == i ? AppStyle.primary : AppStyle.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                auctionCounts[i].toString(),
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            selected: selectedIndex == i,
            selectedTileColor: AppStyle.primary.withValues(alpha: 0.08),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),

            onTap: () {
              if (selectedIndex == i) {
                // Deselect if already selected
                ref.read(selectedAuctionTypeProvider.notifier).state = -1;
                Navigator.of(context).pop();
              } else {
                // Select the tapped item
                ref.read(selectedAuctionTypeProvider.notifier).state = i;
                Navigator.of(context).pop();
              }
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
  List<Icon> auctionIcons = [
    Icon(Icons.gavel_rounded),
    Icon(Icons.schedule),
    Icon(Icons.history),
    Icon(Icons.gavel_rounded),
  ];
}
