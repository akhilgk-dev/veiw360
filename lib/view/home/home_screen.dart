import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final Random _random = Random();
  final ValueNotifier<double> _scrollOffsetNotifier = ValueNotifier(0.0);

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
                      ? Colors.purple
                      : Colors.transparent, // Change color based on scroll
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.only(
                          bottomStart: Radius.circular(40),
                          bottomEnd: Radius.circular(40),
                        ),
                        gradient: LinearGradient(
                          colors: [Colors.blue, Colors.purple],
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
                  title: scrollOffset > 100 ? Text('View360') : null,
                );
              },
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      height: 100,
                      color: Color.fromARGB(
                        100,
                        _random.nextInt(256),
                        _random.nextInt(256),
                        _random.nextInt(256),
                      ),
                    ),
                  ],
                ),
                childCount: 1, // Example list items
              ),
            ),
          ],
        ),
      ),
    );
  }
}
