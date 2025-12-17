import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/common/theme/colors.dart';
import 'package:view360/common/theme/sized_box.dart';
import 'package:view360/language/language_controller.dart';
import 'package:view360/view/dashboard/widgets/tracking_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../common/api_url/api_helper.dart';
import '../../../common/utils/network/http_api.dart';
import 'package:view360/view/widgets/appbar_widget/appbar_widget.dart';

class MyWinnings extends StatefulWidget {
  const MyWinnings({super.key});
  @override
  State<MyWinnings> createState() => _MyWinningsState();
}

class _MyWinningsState extends State<MyWinnings> {
  final MywinningListApi mywinningListApi = Get.put(MywinningListApi());
  final LanguageController languageController = Get.find();
  int currentPage = 1;
  static const int itemsPerPage = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(title: 'My Winnings'.tr),
      bottomNavigationBar: Obx(() {
        final totalItems = mywinningListApi.data.length;
        final totalPages = (totalItems / itemsPerPage).ceil();
        if (totalPages <= 1) return SizedBox.shrink();
        return CustomPagination(
          currentPage: currentPage,
          totalPages: totalPages,
          onPageChanged: (page) {
            setState(() {
              currentPage = page;
            });
          },
        );
      }),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Row(
                children: [
                  Icon(Icons.emoji_events, color: Colors.orange),
                  SizedBox(width: 8),
                  Text(
                    'Winning Bids'.tr,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                "Here's an overview of your winning bids.".tr,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // Card
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Payment Dues'.tr,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Obx(
                          () => mywinningListApi.loading.value
                              ? Skeletonizer(
                                  child: Text(
                                    '1111111',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              : Text(
                                  '${mywinningListApi.paymentDue.value} OMR',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ],
                ),
              ),
              height10,
              Obx(() {
                if (mywinningListApi.loading.value) {
                  return Center(
                    child: Skeletonizer(
                      child: Column(
                        children: List.generate(
                          5,
                          (index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(
                                '111111111111111111111111111111111111',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text('11111111111111111'),
                              trailing: Icon(
                                Icons.picture_as_pdf,
                                color: Colors.red,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }
                final data = mywinningListApi.data;
                if (data.isEmpty) {
                  return Text(
                    'No data available'.tr,
                    style: TextStyle(color: Colors.grey),
                  );
                }
                // Pagination logic
                final totalItems = data.length;
                final totalPages = (totalItems / itemsPerPage).ceil();
                final start = (currentPage - 1) * itemsPerPage;
                final end = min(start + itemsPerPage, totalItems);
                final pageItems = data.sublist(start, end);

                return Column(
                  children: List.generate(pageItems.length, (index) {
                    final datas = pageItems[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    ' ${languageController.selectedLanguage.value == 1 ? datas['title_ar'] : datas['title']}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                // Icons moved to a row above the button
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        SharedPreferences pref =
                                            await SharedPreferences.getInstance();
                                        final userId = pref.getInt('userId');
                                        final token = pref.getString('token');
                                        var url =
                                            '$baseUrl/my_winnings/pdf?id=$userId&auction=${datas['id']}&auth=$token';
                                        launchPDF(url);
                                      },
                                      child: Icon(
                                        Icons.picture_as_pdf_outlined,
                                        color: const Color.fromARGB(
                                          181,
                                          255,
                                          68,
                                          0,
                                        ),
                                        size: 28,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    InkWell(
                                      onTap: () {
                                        print("auction no: ${datas['id']}");
                                        print("group no: ${datas['group']}");
                                        print(
                                          "client no: ${datas['organization']}",
                                        );
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return TrackingWidget(
                                              auctionId: datas['id'],
                                              groupId: datas['group'],
                                              clientId: datas['organization'],
                                            );
                                          },
                                        );
                                      },
                                      child: ImageIcon(
                                        AssetImage(
                                          'assets/images/tracking_icon.png',
                                        ),
                                        size: 26,
                                        color: AppStyle.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '${"Client".tr}: ',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '${datas['organizationInfo']['organization_name'] ?? ""}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppStyle.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '${"Winning Amount:".tr} ',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            '${datas['bid_amount']} OMR',
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 4),
                                    ],
                                  ),
                                ),

                                // InkWell(
                                //   onTap: () {
                                //     print('Pay Now tapped');
                                //   },
                                //   borderRadius: BorderRadius.circular(8),
                                //   child: Container(
                                //     padding: EdgeInsets.symmetric(
                                //       vertical: 10,
                                //       horizontal: 13,
                                //     ),
                                //     decoration: BoxDecoration(
                                //       gradient: LinearGradient(
                                //         colors: AppStyle.bidButtonGradient,
                                //       ),
                                //       borderRadius: BorderRadius.circular(10),
                                //     ),
                                //     alignment: Alignment.center,
                                //     child: Text(
                                //       "Pay Now".tr,
                                //       style: TextStyle(
                                //         color: Colors.white,
                                //         fontWeight: FontWeight.bold,
                                //         fontSize: 14,
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),

                            // Pay Now button below the icons, full width
                          ],
                        ),
                      ),
                    );
                  }),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> launchPDF(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    print('❌ Could not launch $url');
  }
}

// Future<void> launchInBrowser(Uri url) async {
//   if (!await launchUrl(
//     url,
//     mode: LaunchMode.inAppBrowserView,
//   )) {
//     throw Exception('Could not launch $url');
//   }
// }

class MywinningListApi extends GetxController {
  var paymentDue = ''.obs;
  var data = [].obs;

  @override
  void onInit() {
    super.onInit();
    myWinninglist();
  }

  var loading = false.obs;
  Future<void> myWinninglist() async {
    loading(true);
    SharedPreferences pref = await SharedPreferences.getInstance();

    final response = await ApiHelper().postMethod(
      url: baseUrl + winnigListEndPoint,
      headers: {'Authorization': 'Bearer ${pref.getString('token')}'},
      body: jsonEncode({'group': ''}),
    );

    if (response.statusCode == 200) {
      print(response.body);
      final data = jsonDecode(response.body);
      data['data'].forEach((element) {
        this.data.add(element);
      });
      paymentDue.value = data['meta']['due_amount']
          .toString(); // Update with actual amount
      // Example: update with actual amount

      loading(false);

      print("payment due===============${paymentDue.value}");
      // lastUpdated.value = '3 min'; // You can update this dynamically
    } else {
      Get.snackbar(
        "Error",
        "Failed to load winning list".tr,
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
      loading(false);
    }
  }
}

// Custom Pagination Widget
class CustomPagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  const CustomPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> pageButtons = [];
    for (int i = 1; i <= totalPages; i++) {
      pageButtons.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: i == currentPage
                  ? AppStyle.secondary
                  : Colors.grey[200],
              foregroundColor: i == currentPage ? Colors.white : Colors.black,
              minimumSize: Size(36, 36),
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            onPressed: () {
              if (i != currentPage) onPageChanged(i);
            },
            child: Text('$i', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      );
    }

    return Container(
      color: white,
      padding: const EdgeInsets.only(top: 10, bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: currentPage > 1
                ? () => onPageChanged(currentPage - 1)
                : null,
          ),
          ...pageButtons,
          IconButton(
            icon: Icon(Icons.chevron_right),
            onPressed: currentPage < totalPages
                ? () => onPageChanged(currentPage + 1)
                : null,
          ),
        ],
      ),
    );
  }
}
