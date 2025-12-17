import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesNotifier extends StateNotifier<List<int>> {
  FavoritesNotifier() : super([]);

  void toggleFavorite(int auctionId) {
    if (state.contains(auctionId)) {
      state = state.where((id) => id != auctionId).toList();
    } else {
      state = [...state, auctionId];
    }
  }

  bool isFavorite(int auctionId) => state.contains(auctionId);
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<int>>((ref) {
  return FavoritesNotifier();
});

//upcoming
class FavoritesNotifierUpcoming extends StateNotifier<List<int>> {
  FavoritesNotifierUpcoming() : super([]);

  void toggleFavorite(int auctionId) {
    if (state.contains(auctionId)) {
      state = state.where((id) => id != auctionId).toList();
    } else {
      state = [...state, auctionId];
    }
  }

  bool isFavorite(int auctionId) => state.contains(auctionId);
}

final favoritesProviderUpcoming =
    StateNotifierProvider<FavoritesNotifierUpcoming, List<int>>((ref) {
  return FavoritesNotifierUpcoming();
});

//previus
class FavoritesNotifierPrevius extends StateNotifier<List<int>> {
  FavoritesNotifierPrevius() : super([]);

  void toggleFavorite(int auctionId) {
    if (state.contains(auctionId)) {
      state = state.where((id) => id != auctionId).toList();
    } else {
      state = [...state, auctionId];
    }
  }

  bool isFavorite(int auctionId) => state.contains(auctionId);
}

final favoritesProviderprevius =
    StateNotifierProvider<FavoritesNotifierPrevius, List<int>>((ref) {
  return FavoritesNotifierPrevius();
});

//directsale
class FavoritesNotifierDirectsale extends StateNotifier<List<int>> {
  FavoritesNotifierDirectsale() : super([]);

  void toggleFavorite(int auctionId) {
    if (state.contains(auctionId)) {
      state = state.where((id) => id != auctionId).toList();
    } else {
      state = [...state, auctionId];
    }
  }

  bool isFavorite(int auctionId) => state.contains(auctionId);
}

final favoritesProviderdirect =
    StateNotifierProvider<FavoritesNotifierDirectsale, List<int>>((ref) {
  return FavoritesNotifierDirectsale();
});
