import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:view360/api/mzadcom/acution_overview/over_view_api.dart';
import 'package:view360/api/mzadcom/project_overview/project_overview_api.dart';
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/common/theme/colors.dart';
import 'package:view360/common/theme/sized_box.dart';
import 'package:view360/view/mzadcom/mzad_home_widgets/overview_widget.dart';
import 'package:view360/view/mzadcom/mzad_home_widgets/profit_and_vat.dart';
import 'package:view360/view/mzadcom/mzad_home_widgets/project_summary.dart';
import 'package:view360/view/mzadcom/mzad_home_widgets/wallet_summery.dart';
import 'package:view360/view/widgets/appbar_widget/appbar_widget.dart';

class MzadcomHomeScreen extends StatefulWidget {
  const MzadcomHomeScreen({super.key});

  @override
  State<MzadcomHomeScreen> createState() => _MzadcomHomeScreenState();
}

class _MzadcomHomeScreenState extends State<MzadcomHomeScreen> {
  TextEditingController searchController = TextEditingController();
  String selectedValue = 'Last 7 Days';
  final overViewController = Get.put(MzadOverviewApi());
  final projectOverviewController = Get.put(MzadProjectOverview());
  @override
  void initState() {
    String endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String startDate = DateFormat(
      'yyyy-MM-dd',
    ).format(DateTime.now().subtract(Duration(days: 7)));
    overViewController.getMzadOverviewData(startDate, endDate);
    projectOverviewController.getProjectOverviewData(startDate, endDate);
    super.initState();
  }

  void applyDatefilter(String range) {
    DateTime endDate = DateTime.now();
    DateTime startDate;
    if (range == 'Last 7 Days') {
      startDate = endDate.subtract(Duration(days: 7));
    } else if (range == 'Today') {
      startDate = endDate;
    } else if (range == 'Last 15 Days') {
      startDate = endDate.subtract(Duration(days: 15));
    } else if (range == 'Last 30 Days') {
      startDate = endDate.subtract(Duration(days: 30));
    } else {
      startDate = DateTime(2000); // Arbitrary early date for 'All'
    }

    overViewController.getMzadOverviewData(
      DateFormat('yyyy-MM-dd').format(startDate),
      DateFormat('yyyy-MM-dd').format(endDate),
    );
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(fontSize: 14, color: AppStyle.darkGray);
    return Scaffold(
      appBar: AppbarWidget(title: 'Mzadcom Home'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.lightBlueAccent.withAlpha(15),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 2), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: TextFormField(
                        controller: searchController,
                        onChanged: (value) {
                          // ref.read(searchAllProvider.notifier).state = value;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey.withAlpha(190),
                          ),
                          hintText: 'Search for products'.tr,
                          hintStyle: TextStyle(fontSize: 14),
                          alignLabelWithHint: true,
                          contentPadding: EdgeInsets.all(12),
                          filled: true,
                          fillColor: white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(20),
                              right: Radius.circular(20),
                            ),
                            borderSide: BorderSide(
                              color: grey100 ?? Colors.grey,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(20),
                              right: Radius.circular(20),
                            ),
                            borderSide: BorderSide(
                              color: grey100 ?? Colors.grey,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(5),
                            ),
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                    width05,
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),

                      child: DropdownButton<String>(
                        value: selectedValue,
                        items: [
                          DropdownMenuItem(
                            value: 'Today',
                            child: Text('Today', style: textStyle),
                          ),
                          DropdownMenuItem(
                            value: 'Last 7 Days',
                            child: Text('Last 7 Days', style: textStyle),
                          ),
                          DropdownMenuItem(
                            value: 'Last 15 Days',
                            child: Text('Last 15 Days', style: textStyle),
                          ),
                          DropdownMenuItem(
                            value: 'Last 30 Days',
                            child: Text('Last 30 Days', style: textStyle),
                          ),
                          DropdownMenuItem(
                            value: 'All',
                            child: Text('All', style: textStyle),
                          ),
                        ],
                        onChanged: (value) {
                          applyDatefilter(value!);
                          setState(() {
                            selectedValue = value!;
                          });
                        },
                        underline: SizedBox(), // Removes the underline
                        icon: Icon(Icons.sort_rounded), // Keeps the sort icon
                      ),
                    ),

                    // IconButton(
                    //   onPressed: () {
                    //     _openRangeDatePicker(context);
                    //   },
                    //   icon: Icon(Icons.calendar_month),
                    // ),
                  ],
                ),
              ),
              height20,
              Text(
                "Auction Overview".tr,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              height10,
              Obx(() {
                if (overViewController.isloading.value) {
                  return Center(child: CircularProgressIndicator());
                }
                if (overViewController.data.value.error != '' ||
                    overViewController.data.value.error != null) {
                  return MzaccomOverview(
                    overviewData: overViewController.data.value.data!,
                  );
                }
                return MzaccomOverview(
                  overviewData: overViewController.data.value.data!,
                );
              }),

              height35,
              Text(
                "Project Summary".tr,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              height10,
              Obx(() {
                if (projectOverviewController.isloading.value) {
                  return Center(child: CircularProgressIndicator());
                }
                if (projectOverviewController.data.value.projectSummary ==
                        null ||
                    projectOverviewController.data.value.vatSummary == null) {
                  return Text("Error");
                }
                return ProjectSummary();
              }),

              height35,
              Text(
                "Profit and Vat Summary".tr,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              height10,
              ProfitAndVat(),

              Text(
                "Wallet Summary".tr,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              WalletSummery(),
            ],
          ),
        ),
      ),
    );
  }

  void _openRangeDatePicker(BuildContext context) {
    BottomPicker.range(
      dismissable: true,
      headerBuilder: (context) {
        return Column(
          children: [
            Text(
              'Set date range',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.black,
              ),
            ),
            Text(
              'Please select a first date and an end date',
              style: TextStyle(color: Colors.black),
            ),
          ],
        );
      },
      dateOrder: DatePickerDateOrder.dmy,
      initialSecondDate: DateTime.now().add(Duration(days: 230)),
      itemExtent: 20,
      onRangeDateSubmitPressed: (firstDate, secondDate) {
        print(firstDate);
        print(secondDate);
      },
      onRangePickerDismissed: (p0, p1) {
        print(p0);
        print(p1);
      },
      bottomPickerTheme: BottomPickerTheme.plumPlate,
    ).show(context);
  }
}
