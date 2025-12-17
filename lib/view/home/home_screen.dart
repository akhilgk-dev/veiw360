import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/view/home/home_charts/home_chart.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ValueNotifier<double> _scrollOffsetNotifier = ValueNotifier(0.0);
  final List<String> apps = [
    'Mzadcom',
    'ROP ',
    'Webware',
    'Maksab',
    'Goldcom',
    'AlKhalili',
  ];
  final List<String> appsIocns = [
    'assets/mzadcom_splash_logo.png',
    'assets/logos/alkhalili.png',
    //'assets/logos/rop_logo.png',
    'assets/logos/webware.png',
    'assets/logos/maksab.png',
    'assets/mzadcom_splash_logo.png',
    //'assets/logos/goldcom.png',
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
                  expandedHeight: 140.0,
                  pinned: true,
                  backgroundColor: scrollOffset > 100
                      ? AppStyle.primary
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
                          ),
                        )
                      : null,
                  actions: [
                    scrollOffset > 100
                        ? IconButton(
                            icon: Icon(Icons.notifications),
                            onPressed: () {
                              // Handle notification icon press
                            },
                          )
                        : SizedBox.shrink(),
                  ],
                  leading: scrollOffset > 100
                      ? IconButton(
                          icon: Icon(Icons.menu),
                          onPressed: () {
                            // Handle menu icon press
                          },
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
                  (context, index) => Card(
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
                  childCount: apps.length, // Number of items in the grid
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Overall View",
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Row(
                          children: [
                            Expanded(
                              child: Card(
                                child: Container(
                                  decoration: BoxDecoration(
                                    //    color: AppStyle.primary,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  padding: EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.person,
                                            color: Colors.deepPurple,
                                          ),
                                          Text(
                                            "Total Users",
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        "1,234",
                                        style: TextStyle(
                                          color: AppStyle.primary,
                                          fontSize: 28.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Card(
                                child: Container(
                                  decoration: BoxDecoration(
                                    //    color: AppStyle.primary,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  padding: EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.attach_money,
                                            color: Colors.deepPurple,
                                          ),
                                          Text(
                                            "Overall Revenue",
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        "1,234,34",
                                        style: TextStyle(
                                          color: AppStyle.primary,
                                          fontSize: 28.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.0),
                        SizedBox(height: 260, child: HomeChart()),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
