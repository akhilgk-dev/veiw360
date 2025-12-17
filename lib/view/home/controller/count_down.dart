import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:view360/api/extra_time_live_bid/extra_time_live_bid.dart';
import 'package:view360/api/server_time/server_time.dart';

//-----------------------------------------------------------------------------

class CountdownNotifier extends StateNotifier<String> {
  CountdownNotifier({
    required DateTime regStart,
    required DateTime regEnd,
    required DateTime auctionStart,
    required DateTime auctionEnd,
  }) : _regStart = regStart,
       _regEnd = regEnd,
       _auctionStart = auctionStart,
       _auctionEnd = auctionEnd,
       super('Calculating...') {
    _startCountdown();
  }

  final DateTime _regStart;
  final DateTime _regEnd;
  final DateTime _auctionStart;
  final DateTime _auctionEnd;

  final ServerTime serverTime = Get.put(ServerTime());

  void _startCountdown() {
    // final serverNow = DateTime.parse(serverTime.serverTime.value);
    // final phoneNow = DateTime.now();

    // final offset = serverNow.difference(phoneNow);

    Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();

      if (now.isBefore(_regStart)) {
        state = "Reg/not started";
      } else if (now.isBefore(_auctionStart)) {
        state =
            "${"Starts after".tr} : ${_formatDuration(_auctionStart.difference(now))}";
      } else if (now.isBefore(_auctionEnd) && now.isAfter(_auctionStart)) {
        state =
            "${"Ends after".tr} : ${_formatDuration(_auctionEnd.difference(now))}";
      } else if (now.isBefore(_regEnd)) {
        state = _formatDuration(_regEnd.difference(now));
      } else if (now.isBefore(_auctionEnd)) {
        state = _formatDuration(_auctionEnd.difference(now));
      } else {
        state = "Auction Ended".tr;
        timer.cancel();
      }
    });
  }

  String _formatDuration(Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    return "${days} ${hours} ${minutes} ${seconds}";
  }
}

final countdownProvider =
    StateNotifierProvider.family<
      CountdownNotifier,
      String,
      (DateTime, DateTime, DateTime, DateTime)
    >(
      (ref, times) => CountdownNotifier(
        regStart: times.$1,
        regEnd: times.$2,
        auctionStart: times.$3,
        auctionEnd: times.$4,
      ),
    );

//=====================================================================================================================================

class CountdownNotifierLive extends StateNotifier<String> {
  CountdownNotifierLive({
    required DateTime regStart,
    required DateTime regEnd,
    required DateTime auctionStart,
    required DateTime auctionEnd,
  }) : _regStart = regStart,
       //  _regEnd = regEnd,
       _auctionStart = auctionStart,
       _originalAuctionEnd = auctionEnd,
       _currentAuctionEnd = auctionEnd,
       super('Calculating...') {
    _extraTimeLiveBid = Get.find<ExtraTimeLiveBid>();
    _initialize();
  }

  final ServerTime serverTime = Get.put(ServerTime());

  final DateTime _regStart;
  //final DateTime _regEnd;
  final DateTime _auctionStart;
  final DateTime _originalAuctionEnd;
  final DateTime _currentAuctionEnd;
  late final ExtraTimeLiveBid _extraTimeLiveBid;
  Timer? _timer;
  StreamSubscription<DateTime>? _extraTimeSubscription;
  bool _isDisposed = false;

  void _initialize() {
    _startCountdown();
    // _listenForTimeExtensions();
  }

  // void _listenForTimeExtensions() {
  //   _extraTimeSubscription =
  //       _extraTimeLiveBid.newExtraTime.listen((newEndTime) {
  //     if (!_isDisposed && newEndTime.isAfter(_currentAuctionEnd)) {
  //       _currentAuctionEnd = newEndTime;
  //       _updateCountdown(); // <-- Add this line to update the UI instantly
  //     }
  //   });
  // }

  void _startCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isDisposed) {
        timer.cancel();
        return;
      }
      _updateCountdown();
    });
    _updateCountdown();
  }

  void _updateCountdown() {
    // final serverNow = DateTime.parse(serverTime.serverTime.value);
    // final phoneNow = DateTime.now();
    // final offset = serverNow.difference(phoneNow);
    if (_isDisposed) return;

    // Add 2 seconds initially to the current time
    // Add 2 seconds only for the very first call, then use normal DateTime.now()
    DateTime now = DateTime.now();
    // final now = DateTime.now();
    String newState;

    if (now.isBefore(_regStart)) {
      newState = "Reg/not started".tr;
    } else if (now.isBefore(_auctionStart)) {
      newState =
          "${"Starts after".tr} : ${_formatDuration(_auctionStart.difference(now))}";
    } else if (now.isBefore(_currentAuctionEnd)) {
      final timeLeft = _currentAuctionEnd.difference(now);
      newState = "${"Ends after".tr} : ${_formatDuration(timeLeft)}";
      if (_currentAuctionEnd.isAfter(_originalAuctionEnd)) {
        newState += "";
      }
    } else {
      newState = "Auction Ended".tr;
      _timer?.cancel();
    }

    if (!_isDisposed) {
      state = newState;
    }
  }

  String _formatDuration(Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    return "${days}d ${hours}h ${minutes}m ${seconds}s";
  }

  @override
  void dispose() {
    _isDisposed = true;
    _timer?.cancel();
    _extraTimeSubscription?.cancel();
    super.dispose();
  }
}

final countdownProviderLive =
    StateNotifierProvider.family<
      CountdownNotifierLive,
      String,
      (DateTime, DateTime, DateTime, DateTime)
    >(
      (ref, times) => CountdownNotifierLive(
        regStart: times.$1,
        regEnd: times.$2,
        auctionStart: times.$3,
        auctionEnd: times.$4,
      ),
    );
