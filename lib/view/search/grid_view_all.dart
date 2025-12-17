import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:view360/api/auction_details_api/auction_details_all_api.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/common/theme/colors.dart';
import 'package:view360/common/utils/formatter/amount_formate.dart';
import 'package:view360/language/language_controller.dart';
import 'package:view360/view/auction_details/auction_details_page.dart';
import 'package:view360/view/bidding_list/bidding_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GridViewAllWidget extends ConsumerStatefulWidget {
  const GridViewAllWidget({
    super.key,
    required this.auctionResponse,
    required this.ref,
  });

  final dynamic auctionResponse;
  final WidgetRef ref;

  @override
  ConsumerState<GridViewAllWidget> createState() => _GridViewAllWidgetState();
}

class _GridViewAllWidgetState extends ConsumerState<GridViewAllWidget> {
  final LanguageController languageController = Get.find();

  DateTime? safeParse(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return null;
    return intl.DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateStr);
  }

  @override
  Widget build(BuildContext context) {
    final language = languageController.selectedLanguage.value;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.70,
      ),
      itemCount: widget.auctionResponse['data']?.length ?? 0,
      itemBuilder: (context, index) {
        final auction = widget.auctionResponse['data'][index];
        final auctionTitle = auction['is_a_group'] == true
            ? (language == 1
                  ? auction['group_info']['group_name_ar']?.toString() ?? ''
                  : auction['group_info']['group_name']?.toString() ?? '')
            : (language == 1
                  ? auction['title_ar']?.toString() ?? ''
                  : auction['title']?.toString() ?? '');

        return Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: CachedNetworkImage(
                  imageUrl: auction['is_a_group'] == true
                      ? auction['group_image']?.toString() ?? ''
                      : (auction['images'] != null &&
                            auction['images'].isNotEmpty)
                      ? auction['images'][0]['image']
                      : '',
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.image,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      auctionTitle,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "Starting".tr,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                "${AmountFormate().currencyFormat((auction['start_amount'] ?? '0.00').toString())} ${"OMR".tr}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppStyle.darkGray,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 5,
                          height: 30,
                          child: VerticalDivider(thickness: 2),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "Guarantee".tr,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                "${AmountFormate().currencyFormat((auction['guarantee_amount'] ?? '0.00').toString())} ",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppStyle.darkGray,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.timer, size: 14, color: AppStyle.primary),
                        const SizedBox(width: 4),
                        Text(
                          auction['end_date']?.toString() ?? '',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Row(
                    children: [
                      SizedBox(width: 8),
                      if (auction['location'] != null)
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: AppStyle.liteRed,
                        ),
                      SizedBox(
                        width: 60,
                        child: Text(
                          auction['location']?.toString() ?? '',
                          style: TextStyle(fontSize: 12, color: AppStyle.black),
                          overflow: TextOverflow.clip,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 4),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: InkWell(
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          final token = prefs.getString('token');

                          if (auction['is_a_group'] == true) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BiddingList(
                                  whichPage: 'active',
                                  groupName: language == 1
                                      ? auction['group_name_ar'].toString()
                                      : auction['group_name'].toString(),
                                  groupId: auction['group_info']['id']
                                      .toString(),
                                  check: 'true',
                                ),
                              ),
                            );
                          } else {
                            ref.invalidate(
                              auctionAllDetailsResponseProvider(auction['id']),
                            );

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AuctionDetailsPage(
                                  index: index,
                                  token: token ?? '',
                                  auctionId: auction['id'] ?? 0,
                                  imageUrl: auction['images'] ?? [],
                                  mainImage:
                                      auction['images'][0]['image'] ?? 'N/A',
                                ),
                              ),
                            );
                          }
                        },
                        child: Container(
                          height: 30,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(
                              colors: AppStyle.lightGradient,
                            ),
                            // border: Border.all(
                            //   color: darkBlue,
                            //   width: 0.5,
                            // ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.info_outline, color: black, size: 14),
                              SizedBox(width: 4),
                              Text(
                                auction['is_a_group'] == true
                                    ? 'List Auctions'.tr
                                    : 'View details'.tr,
                                style: TextStyle(
                                  color: black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
