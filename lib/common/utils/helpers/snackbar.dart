import 'package:flutter/material.dart';

class SnackbarHelper {
  static OverlayEntry? _overlayEntry;

  static void showSnackBar(BuildContext context, String message,
      {Color? color}) {
    _overlayEntry?.remove();
    _overlayEntry = OverlayEntry(
      builder: (context) => _TopSnackbar(
        message: message,
        color: color ?? Colors.black,
        onDismissed: _removeOverlay,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  static void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

//
class _TopSnackbar extends StatefulWidget {
  final String message;
  final Color color;
  final VoidCallback onDismissed;

  const _TopSnackbar({
    required this.message,
    required this.color,
    required this.onDismissed,
  });

  @override
  __TopSnackbarState createState() => __TopSnackbarState();
}

class __TopSnackbarState extends State<_TopSnackbar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -1), end: const Offset(0, 0))
            .animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutExpo),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutBack,
    );

    _controller.forward(); // Show animation

    Future.delayed(const Duration(seconds: 3), () {
      _controller.reverse();
      Future.delayed(const Duration(milliseconds: 500), widget.onDismissed);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 50,
      //top: 50,
      left: 20,
      right: 20,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.message,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//top -------

class SnackbarHelperTop {
  static OverlayEntry? _overlayEntry;

  static void showSnackBar(BuildContext context, String message,
      {Color? color}) {
    _overlayEntry?.remove();
    _overlayEntry = OverlayEntry(
      builder: (context) => _TopSnackbarTop(
        message: message,
        color: color ?? Colors.black,
        onDismissed: _removeOverlay,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  static void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

//
class _TopSnackbarTop extends StatefulWidget {
  final String message;
  final Color color;
  final VoidCallback onDismissed;

  const _TopSnackbarTop({
    required this.message,
    required this.color,
    required this.onDismissed,
  });

  @override
  __TopSnackbarTopState createState() => __TopSnackbarTopState();
}

class __TopSnackbarTopState extends State<_TopSnackbarTop>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -1), end: const Offset(0, 0))
            .animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutExpo),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutBack,
    );

    _controller.forward(); // Show animation

    Future.delayed(const Duration(seconds: 3), () {
      _controller.reverse();
      Future.delayed(const Duration(milliseconds: 500), widget.onDismissed);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      // bottom: 50,
      top: 50,
      left: 20,
      right: 20,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.message,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
