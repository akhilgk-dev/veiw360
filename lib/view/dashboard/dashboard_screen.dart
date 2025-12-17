import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:view360/api/profile_details_api/profile_details_api.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/common/theme/colors.dart';
import 'package:view360/common/theme/sized_box.dart';
import 'package:view360/model/profile_details/profile_details_model.dart';
import 'package:view360/view/authentication/login/login_page.dart';
import 'package:view360/view/authentication/registration/registration.dart';
import 'package:view360/view/calendar/calender_screen.dart';
import 'package:view360/view/dashboard/my_auctions/my_auction.dart';
import 'package:view360/view/dashboard/my_bids/my_bids.dart';
import 'package:view360/view/dashboard/my_winnings/my_winnings.dart';
import 'package:view360/view/dashboard/widgets/dashboard_grid.dart';
import 'package:view360/view/dashboard/winning_bids.dart/winning_bids_screen.dart';
import 'package:view360/view/home/controller/count_down.dart';
import 'package:view360/view/mzadcom_payment/mzadcom_payment_screen.dart';
import 'package:view360/view/widgets/diologue_box/diologue_box.dart';
import 'package:view360/view/widgets/token/token_checking.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../bottomNav/bottom_nav.dart';

class DashboardScreen extends ConsumerWidget {
  DashboardScreen({super.key});

  final TokenCheckingState tokenCheckingState = Get.put(TokenCheckingState());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    tokenCheckingState.checkToken();
    final notifier = ref.read(bottomNavProvider.notifier);

    return PopScope<Object>(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }

        notifier.updateIndex(0);
      },
      child: Scaffold(
        backgroundColor: AppStyle.scaffoldBg,
        //   appBar: AppbarWidgetWithoutBackButton(title: 'Dashboard'.tr),
        body: SingleChildScrollView(
          //  padding: EdgeInsets.all(16),
          child: Column(
            children: [
              tokenCheckingState.token.value.isNotEmpty
                  ? _buildProfileCard()
                  : Center(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: AppStyle.lightGradient,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 35),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: LottieBuilder.asset(
                                'assets/json/login_to_see.json',
                              ),
                            ),

                            SizedBox(
                              height: MediaQuery.of(context).size.height / 40,
                            ),
                            InkWell(
                              onTap: () {
                                Get.offAll(() {
                                  return LoginPage();
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    'Please Login to see details'.tr,
                                    style: TextStyle(color: AppStyle.secondary),
                                  ),
                                ),
                              ),
                            ),
                            height10,
                          ],
                        ),
                      ),
                    ),
              SizedBox(height: 20),

              // _buildActionButtons(context, ref),
              // height10,
              DashboardGrid(
                actions: [
                  {
                    "label": "Winning Auctions".tr,
                    "icon": "assets/dashboard/winning_icon.png",
                    "route": () {
                      tokenCheckingState.token.value.isNotEmpty
                          ? Get.to(() => WinningBidsScreen())
                          : diologueBoxLogin('Please Login to see details'.tr);
                    },
                  },
                  // {
                  //   "label": "Winning Auctions".tr,
                  //   "icon": "assets/dashboard/winner.png",
                  //   "route": () {
                  //     tokenCheckingState.token.value.isNotEmpty
                  //         ? Get.to(() => MyWinnings())
                  //         : diologueBoxLogin('Please Login to see details'.tr);
                  //   },
                  // },
                  {
                    "label": "My Auctions".tr,
                    "icon": "assets/dashboard/my_auction_icon.png",
                    "route": () {
                      ref.invalidate(auctionResponseMYAuctions);

                      tokenCheckingState.token.value.isNotEmpty
                          ? Get.to(() => MyAuction())
                          : diologueBoxLogin('Please Login to see details'.tr);
                    },
                  },
                  {
                    "label": "Mzadcom Payment".tr,
                    "icon": "assets/dashboard/mzadcom_payment_icon.png",
                    "route": () {
                      tokenCheckingState.token.value.isNotEmpty
                          ? Get.to(() => MzadcomPaymentScreen())
                          : diologueBoxLogin('Please Login to see details'.tr);
                    },
                  },
                  //this tracking is
                  // {
                  //   "label": "Tracking".tr,
                  //   "icon": "assets/dashboard/tracking_icon.png",
                  //   "route": () {
                  //     ref.invalidate(auctionResponseMYBids);
                  //     tokenCheckingState.token.value.isNotEmpty
                  //         ? Get.to(() {
                  //             return TrackingScreen();
                  //           })
                  //         : diologueBoxLogin('Please Login to see details'.tr);
                  //   },
                  // },
                  // {
                  //   "label": "My Bids".tr,
                  //   "icon": "assets/dashboard/mybids.png",
                  //   "route": () {
                  //     ref.invalidate(auctionResponseMYBids);
                  //     tokenCheckingState.token.value.isNotEmpty
                  //         ? Get.to(() {
                  //             return MyBids();
                  //           })
                  //         : diologueBoxLogin('Please Login to see details'.tr);
                  //   },
                  // },
                  {
                    "label": "Enrolled Auctions".tr,
                    "icon": "assets/dashboard/enrolled_auctions_icon.png",
                    "route": () {
                      ref.invalidate(auctionResponseMYBids);
                      tokenCheckingState.token.value.isNotEmpty
                          ? Get.to(() {
                              return MyBids();
                            })
                          : diologueBoxLogin('Please Login to see details'.tr);
                    },
                  },

                  {
                    "label": "Auction Calendar".tr,
                    "icon": "assets/dashboard/auction_calender_icon.png",
                    "route": () {
                      ref.invalidate(auctionResponseMYBids);
                      tokenCheckingState.token.value.isNotEmpty
                          ? Get.to(() {
                              return CalendarScreen();
                            })
                          : diologueBoxLogin('Please Login to see details'.tr);
                    },
                  },
                  {
                    "label": "Edit Profile".tr,
                    "icon": "assets/dashboard/edit_profile_icon.png",
                    "route": () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      ref.invalidate(auctionResponseMYBids);
                      tokenCheckingState.token.value.isNotEmpty
                          ? (Get.to(
                              () => RegistrationScreen(
                                token: prefs.getString('token'),
                                checkPageID: 1,
                              ),
                            ))
                          : diologueBoxLogin('Please Login to see details'.tr);
                    },
                  },
                ],
              ),
              // Container(
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(10),
              //   ),
              //   child: Column(
              //     children: [
              //       Container(
              //         decoration: BoxDecoration(
              //           color: darkBlue,
              //           borderRadius: BorderRadius.only(
              //             topLeft: Radius.circular(10),
              //             topRight: Radius.circular(10),
              //           ),
              //         ),
              //         width: double.infinity,
              //         child: Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: Text(
              //             "Dashboard".tr,
              //             style: TextStyle(
              //               fontSize: 17,
              //               fontWeight: FontWeight.bold,
              //               color: Colors.white,
              //             ),
              //           ),
              //         ),
              //       ),
              //       height10,
              //       ListTile(
              //         minTileHeight: 50,
              //         onTap: () {
              //           Get.to(() => UpcomingAuctionDashboard());
              //         },
              //         leading: Image.asset(
              //           'assets/images/upcoming.png',
              //           height: 20,
              //           width: 20,
              //         ),
              //         title: Text("Upcoming Auctions".tr),
              //         trailing: Icon(Icons.arrow_right),
              //       ),

              //       //*active auction
              //       Divider(color: Colors.black12),
              //       ListTile(
              //         minTileHeight: 50,
              //         onTap: () {
              //           Get.to(() => ActiveAuctionDashboard());
              //         },
              //         leading: Image.asset(
              //           'assets/images/mybids.png',
              //           height: 20,
              //           color: const Color.fromARGB(255, 8, 78, 125),
              //           width: 20,
              //         ),
              //         title: Text("Active Auctions".tr),
              //         trailing: Icon(Icons.arrow_right),
              //       ),
              //       Divider(color: Colors.black12),
              //       ListTile(
              //         minTileHeight: 50,
              //         onTap: () {
              //           Get.to(() => PreviousAuctionDashboard());
              //         },
              //         leading: Image.asset(
              //           'assets/images/previus.png',
              //           height: 15,
              //           width: 15,
              //         ),
              //         title: Text("Previous Auctions".tr),
              //         trailing: Icon(Icons.arrow_right),
              //       ),
              //       Divider(color: Colors.black12),
              //       ListTile(
              //         minTileHeight: 50,
              //         onTap: () {
              //           tokenCheckingState.token.value.isNotEmpty
              //               ? Get.to(() => FeaturedAuctionDashboard())
              //               : diologueBoxLogin(
              //                   'Please Login to see details'.tr,
              //                 );
              //         },
              //         leading: Icon(Icons.favorite_border),
              //         title: Text("Featured Auctions".tr),
              //         trailing: Icon(Icons.arrow_right),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  String mobileNumberConvert(String? mobile) {
    if (mobile != null && mobile.length > 2) {
      return '******${mobile.substring(mobile.length - 2)}';
    }
    return mobile ?? '';
  }

  String emailIdConvert(String? email) {
    if (email != null && email.contains('@')) {
      final parts = email.split('@');
      if (parts[0].length > 2) {
        return '${parts[0].substring(0, 2)}******@${parts[1]}';
      }
      return email; // Return the original email if the local part is too short
    }
    return email ?? '';
  }

  Widget _buildProfileCard() {
    return Consumer(
      builder: (context, ref, child) {
        final AsyncValue<ProfileDetailsModel> profileState = ref.watch(
          auctionResponseProviderProfile,
        );

        return profileState.when(
          data: (value) {
            return Card(
              margin: EdgeInsets.zero,
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,

                    colors: [
                      AppStyle.secondColor,
                      AppStyle.secondary,
                      AppStyle.primary,
                      AppStyle.darkPrimary,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      height20,
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            height: 90,
                            width: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/dashboard/profile_icon.png",
                                ),
                              ),
                            ),
                          ),
                          // CircleAvatar(
                          //   radius: 40,
                          //   backgroundColor: Colors.white,
                          //   backgroundImage: NetworkImage(
                          //     'https://i.pinimg.com/1200x/fb/52/8f/fb528f44ff535b55f3f04a09aaaffd25.jpg',
                          //     // 'https://static.vecteezy.com/system/resources/thumbnails/005/544/718/small_2x/profile-icon-design-free-vector.jpg',
                          //   ),
                          // ),
                          SizedBox(height: 12),
                          // IconButton(
                          //   icon: Icon(Icons.edit, color: Colors.blueAccent),
                          //   tooltip: "Edit Profile".tr,
                          //   onPressed: () async {
                          //     SharedPreferences prefs =
                          //         await SharedPreferences.getInstance();
                          //     Get.to(
                          //       () => RegistrationScreen(
                          //         token: prefs.getString('token'),
                          //         checkPageID: 1,
                          //       ),
                          //     );
                          //   },
                          // ),
                        ],
                      ),

                      // SizedBox(height: 18),
                      // _infoBox(
                      //   "Phone Number:".tr,
                      //   "${value.data.countryCode} ${mobileNumberConvert(value.data.mobile)}",
                      // ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            value.data.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 4),
                          Text(
                            emailIdConvert(value.data.email),
                            style: TextStyle(fontSize: 14, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          height10,
                          _infoBox(
                            '${"Bidder number".tr}:',
                            ("B0${value.data.id}" ?? "N/A").toString(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          loading: () => Card(
            elevation: 4,
            child: Skeletonizer(enabled: true, child: loading()),
          ),
          error: (err, stack) => Card(
            elevation: 4,
            child: Skeletonizer(enabled: true, child: loading()),
          ),
        );
      },
    );
  }

  Container loading() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 10),
              CircleAvatar(radius: 35, backgroundColor: Colors.white),
              width10,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 100, height: 20, color: Colors.grey[300]),
                  SizedBox(height: 5),
                  Container(width: 150, height: 20, color: Colors.grey[300]),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          _infoBox("Phone Number:".tr, "Loading...".tr),
          SizedBox(height: 7),
          _infoBox("National ID:".tr, "Loading...".tr),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: darkBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
              minimumSize: Size(double.infinity, 40),
            ),
            child: Text(
              "Edit Profile".tr,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoBox(String label, String value) {
    return Card(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        decoration: _boxDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: _infoTextStyle()),
            SizedBox(width: 5),
            Text(value, style: _infoTextStyle()),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref) {
    final actions = [
      {
        "label": "Winning Auctions".tr,
        "icon": "assets/images/winning_.png",
        "route": () {
          tokenCheckingState.token.value.isNotEmpty
              ? Get.to(() => MyWinnings())
              : diologueBoxLogin('Please Login to see details'.tr);
        },
      },
      {
        "label": "My Auctions".tr,
        "icon": "assets/images/my_auctions.png",
        "route": () {
          ref.invalidate(auctionResponseMYAuctions);
          ref.invalidate(countdownProvider);
          tokenCheckingState.token.value.isNotEmpty
              ? Get.to(() => MyAuction())
              : diologueBoxLogin('Please Login to see details'.tr);
        },
      },
      {
        "label": "My Bids".tr,
        "icon": "assets/images/mybids.png",
        "route": () {
          ref.invalidate(auctionResponseMYBids);
          tokenCheckingState.token.value.isNotEmpty
              ? Get.to(() {
                  return MyBids();
                })
              : diologueBoxLogin('Please Login to see details'.tr);
        },
      },
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: actions.map((action) => _actionButton(action)).toList(),
    );
  }

  Widget _actionButton(Map<String, dynamic> action) {
    return Column(
      children: [
        GestureDetector(
          onTap: action["route"],
          child: Card(
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: _boxDecoration(),
              child: action["icon"] is String
                  ? Image.asset(action["icon"], height: 40)
                  : action["icon"],
            ),
          ),
        ),
        SizedBox(height: 5),
        Text(
          action["label"],
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: AppStyle.secondary.withAlpha(50),
      borderRadius: BorderRadius.circular(4),
    );
  }

  TextStyle _boldTextStyle() {
    return TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  }

  TextStyle _infoTextStyle() {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: darkBlue,
    );
  }
}
