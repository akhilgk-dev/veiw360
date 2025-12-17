import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:view360/view/drawer/favourites/favourites_screen.dart';

class FeaturedAuctionDashboard extends ConsumerWidget {
  const FeaturedAuctionDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FavouritesScreen();
  }
}
