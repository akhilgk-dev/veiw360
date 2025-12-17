import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:view360/common/theme/colors.dart';

class DirectSaleAuctions extends ConsumerWidget {
  const DirectSaleAuctions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final favorites = ref.watch(favoritesProviderdirect);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: MediaQuery.of(context).size.height / 10),
        Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: darkBlue),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'No direct sales available at the moment.'.tr,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: darkBlue,
                ),
              ),
            ),
          ),
        ),
      ],
    );
    // return GridView.builder(
    //   shrinkWrap: true,
    //   itemCount: 4,
    //   physics: const ClampingScrollPhysics(),
    //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //     crossAxisCount: 2,
    //     crossAxisSpacing: 3,
    //     mainAxisSpacing: 3,
    //     childAspectRatio: 0.90,
    //   ),
    //   itemBuilder: (context, index) {
    //     final isFavorite = favorites.contains(index);

    //     return Stack(children: [
    //       InkWell(
    //         onTap: () {
    //           NavigationHelper.navigateTo(
    //               context, AuctionDetailsPage(index: index, pageNumber: 4));
    //         },
    //         child: Container(
    //           padding: const EdgeInsets.all(8.0),
    //           decoration: BoxDecoration(
    //             color: Colors.white,
    //             borderRadius: BorderRadius.circular(10),
    //             boxShadow: [
    //               BoxShadow(
    //                 color: Colors.black12,
    //                 blurRadius: 4,
    //                 spreadRadius: 2,
    //               ),
    //             ],
    //           ),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               ClipRRect(
    //                 borderRadius: BorderRadius.circular(5),
    //                 child: Heroine(
    //                   tag: 'directSale_$index',
    //                   child: CachedNetworkImage(
    //                     imageUrl:
    //                         'https://www.mzadcom.om/services/public/uploads/auctions/original/1486_1_1736145971.jpg',
    //                     height: 100, // Adjust image height
    //                     width: double.infinity,
    //                     fit: BoxFit.cover,
    //                   ),
    //                 ),
    //               ),
    //               const SizedBox(height: 10),
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: const [
    //                       Text(
    //                         'Toyota',
    //                         style: TextStyle(
    //                           fontSize: 12,
    //                           fontWeight: FontWeight.bold,
    //                         ),
    //                       ),
    //                       Text(
    //                         'MZAD1',
    //                         style: TextStyle(fontSize: 12),
    //                       ),
    //                     ],
    //                   ),
    //                   Column(
    //                     crossAxisAlignment: CrossAxisAlignment.end,
    //                     children: const [
    //                       Text(
    //                         '12.0 OMR',
    //                         style: TextStyle(
    //                             fontSize: 12,
    //                             fontWeight: FontWeight.bold,
    //                             color: Color.fromARGB(255, 146, 145, 145)),
    //                       ),
    //                       Text(
    //                         '12d 6h 30m',
    //                         style: TextStyle(fontSize: 12, color: Colors.grey),
    //                       ),
    //                     ],
    //                   ),
    //                 ],
    //               ),
    //               const SizedBox(height: 10),
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   // Enroll button
    //                   Container(
    //                     height: 25,
    //                     padding: const EdgeInsets.symmetric(horizontal: 8),
    //                     decoration: BoxDecoration(
    //                       color: yelloAccent,
    //                       borderRadius: BorderRadius.circular(10),
    //                     ),
    //                     child: TextButton.icon(
    //                       onPressed: () {},
    //                       icon: const Icon(
    //                         Icons.list,
    //                         color: Colors.white,
    //                         size: 10,
    //                       ),
    //                       label: const Text(
    //                         'Enroll',
    //                         style: TextStyle(fontSize: 9, color: Colors.white),
    //                       ),
    //                       style: TextButton.styleFrom(
    //                         minimumSize: const Size(0, 0),
    //                         padding: EdgeInsets.zero,
    //                       ),
    //                     ),
    //                   ),
    //                   width05,
    //                   // List Auction button
    //                   Container(
    //                     height: 25,
    //                     padding: const EdgeInsets.symmetric(horizontal: 8),
    //                     decoration: BoxDecoration(
    //                       color: darkBlue,
    //                       borderRadius: BorderRadius.circular(10),
    //                     ),
    //                     child: TextButton.icon(
    //                       onPressed: () {},
    //                       icon: const Icon(
    //                         Icons.list,
    //                         color: Colors.white,
    //                         size: 10,
    //                       ),
    //                       label: const Text(
    //                         'List Auction',
    //                         style: TextStyle(fontSize: 9, color: Colors.white),
    //                       ),
    //                       style: TextButton.styleFrom(
    //                         minimumSize: const Size(0, 0),
    //                         padding: EdgeInsets.zero,
    //                       ),
    //                     ),
    //                   ),
    //                   width05,
    //                   // Counter CircleAvatar
    //                   Expanded(
    //                     child: Container(
    //                       decoration: BoxDecoration(
    //                           border: Border.all(),
    //                           borderRadius: BorderRadius.circular(70)),
    //                       child: CircleAvatar(
    //                         backgroundColor: Colors.white,
    //                         radius: 7,
    //                         child: Text(
    //                           '10',
    //                           style: smallFontSize12.copyWith(fontSize: 7),
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //       Positioned(
    //           //left: 0,
    //           right: 15,
    //           top: 15,
    //           //bottom: 0,

    //           //favourite state riverpod with animation
    //           child: GestureDetector(
    //             onTap: () {
    //               ref
    //                   .read(favoritesProviderdirect.notifier)
    //                   .toggleFavorite(index);
    //               // print liked product by boolean show
    //               //  final isFavorite = favorites.contains(index);
    //               // if (!isFavorite) {
    //               //   print('Added to favorites: Product $index');
    //               // } else {
    //               //   print('Removed from favorites: Product $index');
    //               // }
    //             },
    //             child: AnimatedSwitcher(
    //               duration: const Duration(milliseconds: 300),
    //               transitionBuilder:
    //                   (Widget child, Animation<double> animation) {
    //                 return ScaleTransition(scale: animation, child: child);
    //               },
    //               child: CircleAvatar(
    //                 key: ValueKey<bool>(isFavorite),
    //                 radius: 15,
    //                 backgroundColor: white,
    //                 child: Icon(
    //                   isFavorite ? Icons.favorite : Icons.favorite_border,
    //                   size: 15,
    //                   color: isFavorite ? Colors.red : Colors.grey,
    //                 ),
    //               ),
    //             ),
    //           )),
    //       Positioned(
    //           right: 50,
    //           top: 15,
    //           child: GestureDetector(
    //             onTap: () async {
    //               await Share.share(
    //                 'Check out this auction: https://www.mzadcom.om/services/public/uploads/auctions/original/1486_1_1736145971.jpg',
    //                 subject: 'Auction Details',
    //               );
    //             },
    //             child: CircleAvatar(
    //               backgroundColor: white,
    //               radius: 15,
    //               child: Icon(Icons.share, color: Colors.black, size: 14),
    //             ),
    //           )),
    //       Positioned(
    //           bottom: 10,
    //           top: 0,
    //           right: 15,
    //           child: CircleAvatar(
    //             backgroundColor: white,
    //             radius: 15,
    //             child: ClipRRect(
    //               borderRadius: BorderRadius.circular(50),
    //               child: CachedNetworkImage(
    //                   imageUrl:
    //                       'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQT1KwnxTDjGgpyU2z-glZxIvO_JgrtVL1t7w&s'),
    //             ),
    //           ))
    //     ]);
    //   },
    // );
  }
}
