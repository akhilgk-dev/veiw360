import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:view360/api/all_auctions_list/all_auction_list_api.dart';
import 'package:view360/common/theme/style.dart';
import 'package:view360/language/language_controller.dart';
import 'package:view360/view/home/controller/count_down.dart';
import 'package:view360/view/widgets/appbar_widget/appbar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auction_details/auction_details_page.dart';

class EndingSoonAllScreen extends ConsumerWidget {
  EndingSoonAllScreen({super.key});

  final LanguageController languageController = Get.find();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auctionsResponse = ref.watch(auctionResponseAllAuctions);

    return Scaffold(
      appBar: AppbarWidget(title: 'Ending Soon'.tr),
      body: auctionsResponse.when(
        data: (auctions) {
          final now = DateTime.now();
          final oneDayFromNow = now.add(Duration(days: 2));
          final filteredAuctions = auctions['data'].where((auction) {
            final status = auction['status_label']['status'];
            if (status == 'A') {
              final endDate = DateFormat("dd/MM/yyyy hh:mm:ss a").parse(
                "${auction['reg_end_date_ar']['date']} ${auction['reg_end_date_ar']['time']}",
              );
              return endDate.isBefore(oneDayFromNow);
            }
            return false;
          }).toList();

          if (filteredAuctions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('No Auctions Ending Soon'.tr)],
              ),
            );
          }

          return ListView.builder(
            itemCount: filteredAuctions.length,
            itemBuilder: (context, index) {
              final auction = filteredAuctions[index];
              final regStart = DateFormat("dd/MM/yyyy hh:mm:ss a").parse(
                "${auction['reg_start_date_ar']['date']} ${auction['reg_start_date_ar']['time']}",
              );

              final regEnd = DateFormat("dd/MM/yyyy hh:mm:ss a").parse(
                "${auction['reg_end_date_ar']['date']} ${auction['reg_end_date_ar']['time']}",
              );

              final auctionStart = DateFormat("dd/MM/yyyy hh:mm:ss a").parse(
                "${auction['start_date_ar']['date']} ${auction['start_date_ar']['time']}",
              );

              final auctionEnd = DateFormat("dd/MM/yyyy hh:mm:ss a").parse(
                "${auction['end_date_ar']['date']} ${auction['end_date_ar']['time']}",
              );

              final countdown = ref.watch(
                countdownProvider((regStart, regEnd, auctionStart, auctionEnd)),
              );
              return Card(
                elevation: 4,
                child: ListTile(
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    final token = prefs.getString('token');

                    Get.to(() {
                      return AuctionDetailsPage(
                        index: index,
                        token: token ?? '',
                        auctionId: auction['id'],
                        imageUrl: auction['images'] ?? [],
                        mainImage: auction['main_image']?.toString() ?? 'N/A',
                      );
                    });
                  },
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: CachedNetworkImage(
                      imageUrl: auction['main_image'] ?? '',
                      height: 100,
                      width: 110,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  title: Text(
                    languageController.selectedLanguage.value == 1
                        ? auction['title_ar']
                        : auction['title'] ?? 'No Title'.tr,
                    style: bold.copyWith(fontSize: 10),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        auction['auction_number'] ?? 'Unknown ID'.tr,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${"Guarantee amount:".tr} ${auction['start_amount']} OMR'
                            .tr,
                        style: TextStyle(fontSize: 10),
                      ),
                      // Text('${"Visit amount:".tr} 0.00 OMR'.tr,
                      //     style: TextStyle(fontSize: 10)),
                    ],
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${auction['start_amount'] ?? 'N/A'} OMR'.tr,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        countdown,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text('Error loading data'.tr)),
      ),
    );
  }
}
