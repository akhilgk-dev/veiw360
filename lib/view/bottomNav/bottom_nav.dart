import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:view360/api/PDO_auctions.dart/pdo_auctions.dart';
import 'package:view360/api/previus_auctions/previous_auction_api.dart';
import 'package:view360/api/profile_details_api/profile_details_api.dart';
import 'package:view360/api/wallet_screen/wallet_paymant_user_information_api.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/providers/bottomnav_provider.dart';
import 'package:view360/view/bottomNav/wallet/wallet_screen.dart';
import 'package:view360/view/home/home_page.dart';
import 'package:view360/view/dashboard/dashboard_screen.dart';
import 'package:view360/view/home/home_screen.dart';
import 'package:view360/view/search/search_and_viewall.dart';

class BottomNavNotifier extends StateNotifier<int> {
  BottomNavNotifier() : super(0);

  void updateIndex(int newIndex) {
    state = newIndex;
  }
}

final bottomNavProvider = StateNotifierProvider<BottomNavNotifier, int>((ref) {
  return BottomNavNotifier();
});

class BottomNav extends ConsumerWidget {
  const BottomNav({super.key});

  static final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    HomePage(),
    // SearchViewAll(isSearch: false),
    // //AllAuctionList(),
    // WalletScreen(),
    // SearchViewAll(),
    //Center(child: Text('Wallet Screen')),
    Center(child: Text('Dashboard Screen')),
    Center(child: Text('Wallet Screen')),
    Center(child: Text('Dashboard Screen')),
    // DashboardScreen(),
    // MenuScreen(),
  ];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(bottomNavProvider);
    final notifier = ref.read(bottomNavProvider.notifier);

    //two providers are there
    final state = ref.watch(bottomnavProvider);
    final event = ref.read(bottomnavProvider.notifier);

    return Scaffold(
      body: _widgetOptions[state.selectedIndex],
      bottomNavigationBar: SizedBox(
        height: Platform.isIOS ? 120 : 80,

        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          enableFeedback: true,
          selectedLabelStyle: const TextStyle(fontSize: 12),
          unselectedFontSize: 11,
          iconSize: 22,

          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: state.selectedIndex == 0
                  ? Icon(Icons.home_filled, color: AppStyle.secondary, size: 24)
                  : Icon(
                      Icons.home_outlined,
                      color: AppStyle.secondary,
                      size: 22,
                    ),

              label: 'Home'.tr,
            ),
            BottomNavigationBarItem(
              icon: state.selectedIndex == 1
                  ? Icon(Icons.dashboard, color: AppStyle.secondary, size: 24)
                  : Icon(
                      Icons.dashboard_outlined,
                      color: AppStyle.secondary,
                      size: 22,
                    ),

              label: 'Misc'.tr,
            ),

            // BottomNavigationBarItem(
            //   icon: ImageIcon(
            //     AssetImage(
            //       state.selectedIndex == 2
            //           ? selectedIcon[1]
            //           : unselectedIcon[1],
            //     ),
            //     color: AppStyle.primary,
            //     size: 22,
            //   ),
            //   label: 'Wallet'.tr,
            // ),
            // BottomNavigationBarItem(
            //   icon: state.selectedIndex == 3
            //       ? Icon(Icons.dashboard, color: AppStyle.secondary, size: 24)
            //       : Icon(
            //           Icons.dashboard_outlined,
            //           color: AppStyle.secondary,
            //           size: 22,
            //         ),
            //   label: 'Dashboard'.tr,
            // ),
          ],

          currentIndex: state.selectedIndex,
          onTap: (value) {
            event.updateIndex(value);
            notifier.updateIndex(value);
            print(value);

            switch (value) {
              case 0:
                ref.invalidate(auctionResponseProviderProfile);
                ref.invalidate(auctionResponseProviderPrevious);
                ref.invalidate(pdoAuctionResponseProvider);
                //   ref.invalidate(auctionResponseProvider);
                break;
              case 1:
                // ref.invalidate(auctionResponseAllAuctions);
                break;
              case 2:
                ref.invalidate(auctionResponseProviderProfile);
                ref.invalidate(walletInformationDataProvider);
                // ref.invalidate(transationResponseProvider);
                break;
              case 3:
                ref.invalidate(auctionResponseProviderProfile);
                break;

              default:
            }
          },
        ),
      ),
    );
  }
}

List<String> selectedIcon = [
  'assets/bottomNavIcon/Vector.png',
  'assets/bottomNavIcon/wallet_filled.png',
  'assets/bottomNavIcon/Layer_1 (1).png',
  'assets/bottomNavIcon/Layer_1 (2).png',
  'assets/bottomNavIcon/Layer_1 (5).png',
  'assets/bottomNavIcon/auction_filled.png',
];
List<String> unselectedIcon = [
  'assets/bottomNavIcon/Vector.png',
  'assets/bottomNavIcon/wallet_outline.png',
  'assets/bottomNavIcon/Layer_1 (1).png',
  'assets/bottomNavIcon/Layer_1 (2).png',
  'assets/bottomNavIcon/auction_outline.png',
];
