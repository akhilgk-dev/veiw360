// Bid State Provider
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bidProvider =
    StateNotifierProvider<BidNotifier, BidState>((ref) => BidNotifier());

final arrowDwnUp = StateProvider<bool>((ref) => true);

class BidState {
  final int amount;
  final int step;
  final List<Bidder> topBidders;
  final Duration remainingTime;
  final int startingPrice;
  final int endingPrice;

  BidState({
    required this.amount,
    required this.step,
    required this.topBidders,
    required this.remainingTime,
    required this.startingPrice,
    required this.endingPrice,
  });

  BidState copyWith({
    int? amount,
    int? step,
    List<Bidder>? topBidders,
    Duration? remainingTime,
    int? startingPrice,
    int? endingPrice,
  }) {
    return BidState(
      amount: amount ?? this.amount,
      step: step ?? this.step,
      topBidders: topBidders ?? this.topBidders,
      remainingTime: remainingTime ?? this.remainingTime,
      startingPrice: startingPrice ?? this.startingPrice,
      endingPrice: endingPrice ?? this.endingPrice,
    );
  }
}

class BidNotifier extends StateNotifier<BidState> {
  BidNotifier()
      : super(BidState(
          amount: 0,
          step: 0,
          topBidders: [],
          remainingTime: const Duration(hours: 1, minutes: 30, seconds: 0),
          startingPrice: 0,
          endingPrice: 0,
        ));

  void setStep(int newStep) {
    state = state.copyWith(step: newStep);
  }

  void setAmount(int amount) {
    state = state.copyWith(amount: amount);
  }

  void increment() {
    int newAmount = state.amount == state.startingPrice
        ? state.startingPrice + state.step
        : state.amount + state.step;

    state = state.copyWith(amount: newAmount);
  }

  void resetStep() {
    state = state.copyWith(amount: 0 + state.step);
  }

  // void increment() {
  //   // Add the selected step to the current amount
  //   state = state.copyWith(amount: state.amount + state.step);
  // }

  void decrement() {
    if (state.amount > state.startingPrice) {
      int newAmount = state.amount - state.step;
      if (newAmount < state.startingPrice) {
        newAmount =
            state.startingPrice; // Ensure it never goes below startingPrice
      }
      state = state.copyWith(amount: newAmount);
    }
  }

  // void decrement() {
  //   // Subtract the selected step from the current amount, but ensure it doesn't go below the starting price
  //   if (state.amount >= state.step) {
  //     state = state.copyWith(amount: state.amount - state.step);
  //   }
  // }
}

class Bidder {
  final String name;
  final int bidAmount;
  Bidder({required this.name, required this.bidAmount});
}
