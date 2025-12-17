import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:view360/common/utils/helpers/snackbar.dart';
import 'package:view360/view/home/controller/favourite_notifier.dart';
import '../../../api/favourite_auctions.dart/toggle_like.dart';
import '../../../common/theme/colors.dart';

class FavouriteLikeWidget extends StatelessWidget {
  FavouriteLikeWidget({
    super.key,
    required this.ref,
    required this.isFavorite,
    required this.index,
    required this.auctionID,
    required this.auctionName,
  });

  final WidgetRef ref;
  final bool isFavorite;
  final int index;
  final int auctionID;
  final String auctionName;
  final ToggleLikeGetX toggleLikeGetX = Get.put(ToggleLikeGetX());

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      left: 60,
      child: GestureDetector(
        onTap: () async {
          ref.read(favoritesProvider.notifier).toggleFavorite(index);
          //print like or not (true or false)

          // print('like or not: $isFavorite');

          if (isFavorite == false) {
            toggleLikeGetX.toggleLike(auctionID, '1');

            if (toggleLikeGetX.success.value) {
              SnackbarHelper.showSnackBar(
                context,
                '$auctionName Added to favourites ',
                color: Colors.green,
              );
            }
          } else {
            toggleLikeGetX.toggleLike(auctionID, '');

            if (toggleLikeGetX.success.value) {
              SnackbarHelper.showSnackBar(
                context,
                '$auctionName Removed from Favourites',
                color: darkRed,
              );
            }
          }
        },
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: CircleAvatar(
            key: ValueKey<bool>(isFavorite),
            backgroundColor: white,
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
