import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart' as intl;
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/common/theme/sized_box.dart';
import 'package:view360/common/theme/style.dart';
import 'package:view360/common/utils/formatter/amount_formate.dart';
import 'package:view360/common/utils/formatter/date_formate.dart';
import 'package:view360/common/utils/helpers/snackbar.dart';
import 'package:view360/view/auction_details/pdf_web_view/pdf_view.dart';
import 'package:view360/view/auction_details/vehicle_info/specification_page.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../common/theme/colors.dart';

class AuctionCard extends StatefulWidget {
  final String categoryType;
  final int auctionId;
  final String? auctionNumber;
  final String? auctionCode;
  final String? vat;
  final String? startingAuctionDate;
  final String? endingAuctionDate;
  final String? startingTimeAuction;
  final String? endingTimeAuction;
  final String? startBidAmount;
  final String? visitAmount;
  final String? insuranceAmount;
  final String? location;
  final dynamic fileTerms;
  final dynamic filePaymentTerms;
  final String guaranteeAmount;
  final String? latitude;
  final String? longitude;
  final String endDay;
  final String startDay;
  final bool isArabic;

  const AuctionCard({
    super.key,
    required this.categoryType,
    required this.auctionId,
    required this.fileTerms,
    required this.filePaymentTerms,
    this.auctionNumber,
    this.location,
    this.auctionCode,
    this.vat,
    this.startingAuctionDate,
    this.endingAuctionDate,
    this.startingTimeAuction,
    this.endingTimeAuction,
    this.startBidAmount,
    this.visitAmount,
    this.latitude,
    this.longitude,
    this.insuranceAmount,
    required this.guaranteeAmount,
    required this.endDay,
    required this.startDay,
    required this.isArabic,
  });

  @override
  _AuctionCardState createState() => _AuctionCardState();
}

class _AuctionCardState extends State<AuctionCard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  LatLng? _auctionLocation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _getAuctionLocation();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _getAuctionLocation() async {
    debugPrint("================================${widget.location}");
    if (widget.location != null && widget.location!.isNotEmpty) {
      try {
        List<Location> locations = await locationFromAddress(widget.location!);
        if (locations.isNotEmpty) {
          setState(() {
            _auctionLocation = LatLng(
              double.parse(widget.latitude.toString()),
              double.parse(widget.longitude.toString()),
            );
          });
        }
      } catch (e) {
        debugPrint('Error occurred while getting location: $e');
      }
    }
  }

  final decoration = BoxDecoration(
    color: AppStyle.white,
    borderRadius: BorderRadius.circular(8),
    // border: Border.all(color: AppStyle.gray, width: 0.5),
    boxShadow: List.generate(
      1,
      (index) =>
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Container(
          //   decoration: BoxDecoration(
          //     color: AppStyle.secondary.withValues(alpha: .15),
          //     borderRadius: BorderRadius.circular(50),
          //   ),
          //   child: TabBar(
          //     controller: _tabController,
          //     labelColor: Colors.white,
          //     unselectedLabelColor: Colors.black,
          //     indicator: BoxDecoration(
          //       borderRadius: BorderRadius.circular(50),
          //       color: AppStyle.secondary,
          //     ),
          //     indicatorSize: TabBarIndicatorSize.tab,
          //     tabs: [
          //       Tab(text: 'Description'.tr),
          //       Tab(text: 'Documents'.tr),
          //       Tab(text: 'Location'.tr),
          //     ],
          //     indicatorColor: Colors.transparent,

          //     //  overlayColor: MaterialStateProperty.all(AppStyle.secondColor),
          //   ),
          // ),
          SizedBox(height: 10),

          Column(
            //  controller: _tabController,
            children: [
              // Description Tab Content
              Container(
                padding: EdgeInsets.all(5),
                decoration: decoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "Auction number".tr,
                                    style: smallFontSize12,
                                  ),
                                ],
                              ),
                              Text(
                                widget.auctionNumber ?? "",
                                style: TextStyle(
                                  color: darkBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              height05,
                              Text("VAT".tr, style: smallFontSize12),
                              Text(
                                "${widget.vat} %".tr,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: darkBlue,
                                ),
                              ),
                              height05,
                              Text(
                                "Starting date of Auction".tr,
                                style: smallFontSize12,
                              ),
                              Text(
                                widget.startingAuctionDate ?? "",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: darkBlue,
                                ),
                              ),
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: Text(
                                  "(${widget.startingTimeAuction ?? ""})".tr,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: darkBlue,
                                  ),
                                ),
                              ),
                              Text(
                                widget.isArabic
                                    ? DateHelper.getArabicDay(widget.startDay)
                                    : widget.startDay,
                                style: TextStyle(fontSize: 10, color: darkBlue),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Start bid amount".tr,
                                style: smallFontSize12,
                              ),
                              Text(
                                "${AmountFormate().currencyFormat(widget.startBidAmount ?? '0.00')} OMR"
                                    .tr,
                                style: TextStyle(
                                  color: darkBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              height10,
                              Text(
                                "Guarantee Amount".tr,
                                style: smallFontSize12,
                              ),
                              Text(
                                "${AmountFormate().currencyFormat(widget.guaranteeAmount.toString())} OMR"
                                    .tr,
                                style: TextStyle(
                                  color: darkBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              height05,
                              Text(
                                "Ending date of Auction".tr,
                                style: smallFontSize12,
                              ),
                              Text(
                                widget.endingAuctionDate ?? "",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: darkBlue,
                                ),
                              ),
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: Text(
                                  "( ${widget.endingTimeAuction ?? ""})".tr,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: darkBlue,
                                  ),
                                ),
                              ),
                              Text(
                                widget.isArabic
                                    ? DateHelper.getArabicDay(widget.endDay)
                                    : widget.endDay,
                                style: TextStyle(fontSize: 10, color: darkBlue),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    height20,
                    widget.categoryType == 'Vehicles'
                        ? InkWell(
                            onTap: () {
                              Get.to(
                                () => SpecificationPage(
                                  auctionId: widget.auctionId,
                                ),
                              );
                            },
                            child: Card(
                              elevation: 4,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: darkBlue,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Vehicle Specification'.tr,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
              height30,

              // Location Tab Content
              Container(
                decoration: decoration,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on, color: AppStyle.liteRed),
                          Text(
                            "${"Auction Location:".tr} ${widget.location ?? "N/A"}"
                                .tr,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      AspectRatio(
                        aspectRatio: 1.8,
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: GoogleMap(
                                initialCameraPosition: CameraPosition(
                                  target:
                                      _auctionLocation ??
                                      LatLng(
                                        double.tryParse(
                                              widget.latitude ?? '23.5880',
                                            ) ??
                                            23.5880,
                                        double.tryParse(
                                              widget.longitude ?? '58.3829',
                                            ) ??
                                            58.3829,
                                      ),
                                  zoom: 15,
                                ),
                                markers: {
                                  Marker(
                                    markerId: MarkerId('auctionLocation'),
                                    position:
                                        _auctionLocation ??
                                        LatLng(
                                          double.tryParse(
                                                widget.latitude ?? '23.5880',
                                              ) ??
                                              23.5880,
                                          double.tryParse(
                                                widget.longitude ?? '58.3829',
                                              ) ??
                                              58.3829,
                                        ),
                                  ),
                                },
                                gestureRecognizers: {
                                  Factory<OneSequenceGestureRecognizer>(
                                    () => EagerGestureRecognizer(),
                                  ),
                                },
                                zoomControlsEnabled: false,
                                myLocationButtonEnabled: false,
                                compassEnabled: false,
                              ),
                            ),
                            Positioned.fill(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  splashColor: Colors.black12,
                                  onTap: () {
                                    final lat =
                                        double.tryParse(
                                          widget.latitude ?? '23.5880',
                                        ) ??
                                        23.5880;
                                    final lng =
                                        double.tryParse(
                                          widget.longitude ?? '58.3829',
                                        ) ??
                                        58.3829;
                                    openGoogleMaps(lat, lng);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Documents Tab Content
              height15,
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(colors: AppStyle.lightGradient),
                ),

                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (widget.fileTerms == false ||
                              widget.fileTerms == null) {
                            SnackbarHelper.showSnackBar(
                              context,
                              "No Terms & Conditions Available".tr,
                            );
                          } else {
                            final url = Uri.parse(widget.fileTerms);
                            Get.to(
                              () => PdfViewerScreen(
                                pdfUrl: url.toString(),
                                page: 'Terms & Conditions'.tr,
                              ),
                            );
                          }
                        },
                        child: Container(
                          decoration: decoration,
                          padding: EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Icon(Icons.picture_as_pdf, color: AppStyle.red),
                              Text('Terms & Conditions'.tr),
                            ],
                          ),
                        ),
                      ),
                      width10,
                      GestureDetector(
                        onTap: () {
                          // Handle tap for Payment terms
                          if (widget.filePaymentTerms == false) {
                            SnackbarHelper.showSnackBar(
                              context,
                              "No Payment Terms Available".tr,
                            );
                          } else {
                            final url = Uri.parse(widget.filePaymentTerms);
                            Get.to(
                              () => PdfViewerScreen(
                                pdfUrl: url.toString(),
                                page: 'Payment terms'.tr,
                              ),
                            );
                          }
                        },
                        child: Container(
                          decoration: decoration,
                          padding: EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Icon(Icons.picture_as_pdf, color: AppStyle.red),
                              Text("Payment terms".tr),
                            ],
                          ),
                        ),
                      ),
                      width10,
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            print(widget.fileTerms);
                            if (widget.fileTerms == false ||
                                widget.fileTerms == null) {
                              SnackbarHelper.showSnackBar(
                                context,
                                "No Terms & Conditions Available".tr,
                              );
                            } else {
                              final url = Uri.parse(widget.fileTerms);
                              Get.to(
                                () => PdfViewerScreen(
                                  pdfUrl: url.toString(),
                                  page: 'Contracts'.tr,
                                ),
                              );
                            }
                          },
                          child: Container(
                            decoration: decoration,
                            padding: EdgeInsets.all(8),
                            child: Column(
                              children: [
                                Icon(Icons.picture_as_pdf, color: AppStyle.red),
                                Text("Contracts".tr),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 80),

              // Padding(
              //   padding: EdgeInsets.all(8.0),
              //   child: Column(
              //     children: [
              //       Text(
              //           "${"Auction Location:".tr} ${widget.location ?? "N/A"}"
              //               .tr),
              //       SizedBox(height: 10),
              //       Expanded(
              //         child: InkWell(
              //           onTap: () {
              //             if (_auctionLocation == null) {
              //               openGoogleMaps(23.5880, 58.3829);
              //             } else {
              //               final lat = double.tryParse(
              //                       widget.latitude ?? '23.5880') ??
              //                   23.5880;
              //               final lng = double.tryParse(
              //                       widget.longitude ?? '58.3829') ??
              //                   58.3829;
              //               openGoogleMaps(lat, lng);
              //             }
              //           },
              //           child: Card(
              //             elevation: 4,
              //             child: _auctionLocation == null
              //                 ? GoogleMap(
              //                     initialCameraPosition: CameraPosition(
              //                       target: LatLng(23.5880, 58.3829),
              //                       zoom: 15,
              //                     ),
              //                     markers: {
              //                       Marker(
              //                         markerId:
              //                             MarkerId('auctionLocation'),
              //                         position: LatLng(23.5880, 58.3829),
              //                       ),
              //                     },
              //                     gestureRecognizers: <Factory<
              //                         OneSequenceGestureRecognizer>>{
              //                       Factory<OneSequenceGestureRecognizer>(
              //                           () => EagerGestureRecognizer()),
              //                     },
              //                   )
              //                 : GoogleMap(
              //                     initialCameraPosition: CameraPosition(
              //                       target: _auctionLocation!,
              //                       zoom: 15,
              //                     ),
              //                     markers: {
              //                       Marker(
              //                         markerId:
              //                             MarkerId('auctionLocation'),
              //                         position: _auctionLocation!,
              //                       ),
              //                     },
              //                   ),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}

void openGoogleMaps(double latitude, double longitude) async {
  final url = Uri.parse(
    "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude",
  );

  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch Google Maps';
  }
}

// void openGoogleMaps(double latitude, double longitude) async {
//   final String googleMapsUrl =
//       "geo:$latitude,$longitude?q=$latitude,$longitude";
//   final String appleMapsUrl = "https://maps.apple.com/?q=$latitude,$longitude";
//   final String webUrl =
//       "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";

//   if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
//     await launchUrl(Uri.parse(googleMapsUrl));
//   } else if (await canLaunchUrl(Uri.parse(appleMapsUrl))) {
//     await launchUrl(Uri.parse(appleMapsUrl));
//   } else {
//     await launchUrl(Uri.parse(webUrl),
//         mode: LaunchMode.externalNonBrowserApplication);
//   }
// }

class CoveringWidget extends StatelessWidget {
  const CoveringWidget({super.key, required this.caption, required this.child});
  final String caption;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      margin: EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            caption,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 8),
          Expanded(child: child),
        ],
      ),
    );
  }
}
