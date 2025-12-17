import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedPageNotifier extends StateNotifier<String> {
  SelectedPageNotifier(super.state);

  void updateImage(String newImage) {
    state = newImage;
  }
}

final selectedPageProvider =
    StateNotifierProvider<SelectedPageNotifier, String>(
  (ref) => SelectedPageNotifier(''),
);
