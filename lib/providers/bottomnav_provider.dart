import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomnavState {
  int selectedIndex;
  BottomnavState({this.selectedIndex = 0});

  BottomnavState copyWith({int? selectedIndex}) {
    return BottomnavState(selectedIndex: selectedIndex ?? this.selectedIndex);
  }
}

final bottomnavProvider =
    StateNotifierProvider<BottomNavNotifier, BottomnavState>(
      (ref) => BottomNavNotifier(),
    );

class BottomNavNotifier extends StateNotifier<BottomnavState> {
  BottomNavNotifier() : super(BottomnavState());

  void updateIndex(int newIndex) {
    state = state.copyWith(selectedIndex: newIndex);
  }
}
