import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:view360/view/auction_details/auction_details_page.dart';
import 'package:view360/view/auction_details/state/image_updation_state.dart';

class ImageListingRow extends StatelessWidget {
  const ImageListingRow({
    super.key,
    required this.widget,
    required this.ref,
    required this.images,
  });

  final AuctionDetailsPage widget;
  final WidgetRef ref;
  final List<dynamic> images;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(images.length, (index) {
          return InkWell(
            onTap: () {
              ref
                  .read(selectedPageProvider.notifier)
                  .updateImage(images[index]['image']);
            },
            child: SizedBox(
              height: 70,
              width: 80,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: CachedNetworkImage(
                    imageUrl: images[index]['image'],
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.image,
                        size: 30,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
      // print("clicked");
      //   //pop up with image listview
      //   showDialog(
      //     context: context,
      //     builder: (context) {
      //       return AlertDialog(
      //         content: SizedBox(
      //           width: double.maxFinite,
      //           child: ListView.builder(
      //             shrinkWrap: true,
      //             itemCount: images.length,
      //             itemBuilder: (context, index) {
      //               return Padding(
      //                 padding: const EdgeInsets.all(8.0),
      //                 child: CachedNetworkImage(
      //                   imageUrl: images[index]['image'],
      //                   width: double.infinity,
      //                   fit: BoxFit.cover,
      //                 ),
      //               );
      //             },
      //           ),
      //         ),
      //       );
      //     },
      //   );