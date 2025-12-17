import 'dart:ui';

import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key, required this.child});
  final Widget child;
  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  //late final Animation<double> _scaleAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-0.05, 0), // Slightly left, less movement
      end: const Offset(0.05, 0), // Slightly right, less movement
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
    super.initState();
    // _controller = AnimationController(
    //   vsync: this,
    //   duration: const Duration(seconds: 3),
    // )..repeat(reverse: true);
    // _scaleAnimation = Tween<double>(begin: 1, end: 1.05).animate(
    //   CurvedAnimation(parent: _controller, curve: Curves.linearToEaseOut),
    // );
    // super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Stack(
          fit: StackFit.expand,
          children: [
            // Animated blurry background
            SlideTransition(
              position: _slideAnimation,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Transform.scale(
                    scale: 1.20, // Slightly zoom in to avoid white edges
                    child: Image.asset(
                      'assets/splash/splash_background.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 1.1, sigmaY: 1.1),
                    child: Container(color: Colors.black.withAlpha(0)),
                  ),
                ],
              ),
            ),
            // Transform.scale(
            //   scale: _scaleAnimation.value,
            //   child: Stack(
            //     fit: StackFit.expand,
            //     children: [
            //       Image.asset(
            //         'assets/splash/mzadcom_bg.JPG',
            //         fit: BoxFit.cover,
            //       ),
            //       BackdropFilter(
            //         filter: ImageFilter.blur(sigmaX: 1.1, sigmaY: 1.1),
            //         child: Container(
            //           color: Colors.black.withValues(alpha: 0),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            // Animated splash image (centered, but not double-animated)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      // gradient: LinearGradient(
                      //   colors: [
                      //     Colors.grey.withValues(alpha: 0.8),
                      //     Colors.white.withValues(alpha: 0.8),
                      //   ],
                      //   begin: Alignment.topLeft,
                      //   end: Alignment.bottomRight,
                      // ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    // height: 150,
                    // width: 200,
                    child: widget.child,
                  ),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     Navigator.pop(context);
                  //   },
                  //   child: Text("data"),
                  // ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
