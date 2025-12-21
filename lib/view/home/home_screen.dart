import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/common/theme/colors.dart';
import 'package:view360/view/drawer/drawer_widget.dart';
import 'package:view360/view/home/home_charts/home_chart.dart';
import 'package:view360/view/home/widgets/home_widget.dart';
import 'package:view360/view/mzadcom/mzadcom_home.dart';
import 'package:view360/view/widgets/appbar_widget/appbar_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final ValueNotifier<double> _scrollOffsetNotifier = ValueNotifier(0.0);
  final List<String> apps = [
    'Mzadcom',
    'ROP Auction',
    'Webware',
    'Maksab',
    'Goldcom',
    'Alkhalil',
  ];
  final List<String> appsIocns = [
    'assets/mzadcom_splash_logo.png',
    //'assets/logos/rop_auction_logo.png',
    'assets/logos/rop_logo.png',
    'assets/logos/webware.png',
    'assets/logos/maksab.png',
    // 'assets/mzadcom_splash_logo.png',
    'assets/logos/gold_com.png',
    'assets/logos/alkhalili.png',
  ];
  @override
  void dispose() {
    _scrollOffsetNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Building HomeScreen");
    return Scaffold(
      key: scaffoldKey,
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollUpdateNotification) {
            _scrollOffsetNotifier.value = scrollNotification.metrics.pixels;
          }
          return true;
        },
        child: CustomScrollView(
          slivers: [
            ValueListenableBuilder<double>(
              valueListenable: _scrollOffsetNotifier,
              builder: (context, scrollOffset, child) {
                return SliverAppBar(
                  expandedHeight: 120.0,
                  pinned: true,
                  backgroundColor: scrollOffset > 100
                      ? const Color.fromARGB(255, 203, 214, 0)
                      : Colors.transparent, // Change color based on scroll
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.only(
                          bottomStart: Radius.circular(30),
                          bottomEnd: Radius.circular(30),
                        ),
                        gradient: LinearGradient(
                          colors: AppStyle.bidButtonGradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 20),
                            Text(
                              'View360',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 34,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "All your 360 needs in one place",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  title: scrollOffset > 100
                      ? Text(
                          'View360',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        )
                      : null,
                  actions: [
                    scrollOffset > 100 ? TransalatorIcon() : SizedBox.shrink(),
                  ],
                  leading: scrollOffset > 100
                      ? IconButton(
                          onPressed: () {
                            scaffoldKey.currentState?.openDrawer();
                          },
                          icon: Icon(CupertinoIcons.list_dash, color: white),
                        )
                      : SizedBox.shrink(),
                );
              },
            ),
            SliverPadding(
              padding: const EdgeInsets.all(
                16.0,
              ), // Add padding around the grid
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Three items per row
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 0.8,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => InkWell(
                    onTap: () {
                      switch (index) {
                        case 0:
                          {
                            Get.to(MzadcomHomeScreen());
                          }
                        case 1:
                          {}
                        case 2:
                          {}
                        case 3:
                          {}
                        case 4:
                          {}
                        case 5:
                          {}
                      }
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      elevation: 4.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16.0),
                              ),
                              child: Image.asset(
                                appsIocns[index], // Placeholder image
                                fit: BoxFit.fitWidth,
                                //  width: double.infinity,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              apps[index],
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  childCount: apps.length, // Number of items in the grid
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: HomeWidget(),
              ),
            ),
          ],
        ),
      ),
      drawer: DrawerWidget(),
    );
  }
}
