import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:view360/api/authentication/login/login_api.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/common/theme/colors.dart';
import 'package:view360/common/theme/style.dart';
import 'package:view360/common/utils/helpers/navigation_helper.dart';
import 'package:view360/common/utils/helpers/shared_pref.dart';
import 'package:view360/view/authentication/login/login_page.dart';
import 'package:view360/view/authentication/registration/registration.dart';
import 'package:view360/view/authentication/sign_up/signup_page.dart';
import 'package:view360/view/calendar/calender_screen.dart';
import 'package:view360/view/drawer/about_us/about_us_screen.dart';
import 'package:view360/view/drawer/faqs/faqs_screen.dart';
import 'package:view360/view/drawer/favourites/favourites_screen.dart';
import 'package:view360/view/drawer/settings/settings.dart';
import 'package:view360/view/drawer/widgets/auctions_in_menu.dart';
import 'package:view360/view/drawer/widgets/categories_in_menu.dart';
import 'package:view360/view/widgets/diologue_box/diologue_box.dart';
import 'package:view360/view/widgets/url_launcher/refirect_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/theme/sized_box.dart';
import '../widgets/token/token_checking.dart';

class DrawerWidget extends StatelessWidget {
  DrawerWidget({super.key});
  final TokenCheckingState tokenCheckingState = Get.put(TokenCheckingState());

  @override
  Widget build(BuildContext context) {
    final token = tokenCheckingState.token;

    List<String> drawerText = [
      'Home',
      // 'Favourites',
      // 'Terms and Conditions',
      'Auction Calendar',
      'Auctions',
      'Categories',
      'About Us',
      'Settings',
      'Logout',
    ];

    List<Icon> drawerIcon = [
      Icon(CupertinoIcons.home),
      // Icon(CupertinoIcons.heart),
      Icon(CupertinoIcons.calendar),
      Icon(Icons.gavel_rounded),
      Icon(Icons.category_outlined),
      Icon(CupertinoIcons.info),
      Icon(CupertinoIcons.settings),
      Icon(CupertinoIcons.power),
    ];

    return Drawer(
      backgroundColor: white,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(17, 147, 233, 176),
                  const Color.fromARGB(31, 244, 248, 245),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            height: token.isEmpty ? 200 : 160,
            child: DrawerHeader(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18.0,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    height10,
                    Row(
                      children: [
                        Container(
                          height: 64,
                          width: 64,
                          decoration: BoxDecoration(
                            color: AppStyle.lightGray3,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/logo/view360_logo.jpeg',
                              ),
                            ),
                          ),

                          // child: Padding(
                          //   padding: const EdgeInsets.all(6.0),
                          //   child: Image.asset(
                          //     'assets/logo/view360_logo.jpeg',
                          //     fit: BoxFit.cover,
                          //   ),
                          // ),
                        ),
                        width20,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome to'.tr,
                              style: blackStyle.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: AppStyle.primary,
                              ),
                            ),
                            Text(
                              'View 360'.tr,
                              style: blackStyle.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close, color: AppStyle.gray),
                        ),
                      ],
                    ),
                    height10,
                    FutureBuilder(
                      future: checkLogin(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(white),
                          );
                        } else if (snapshot.hasData && snapshot.data == true) {
                          return SizedBox();
                        } else {
                          return Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppStyle.secondary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    elevation: 2,
                                  ),
                                  onPressed: () {
                                    NavigationHelper.navigateAndReplace(
                                      context,
                                      LoginPage(),
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.login, color: AppStyle.white),
                                      SizedBox(width: 6),
                                      Text(
                                        'Login'.tr,
                                        style: blackStyle.copyWith(
                                          fontSize: 16,
                                          color: AppStyle.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              width10,
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppStyle.secondColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    elevation: 2,
                                  ),
                                  onPressed: () {
                                    NavigationHelper.navigateAndReplace(
                                      context,
                                      SignUpPage(),
                                      // RegistrationScreen(checkPageID: 0),
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.app_registration_outlined,
                                        color: white,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        'Signup'.tr,
                                        style: whiteStyle.copyWith(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          //  height10,
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.all(10),
              itemCount: (token != null && token.isNotEmpty)
                  ? drawerText.length
                  : drawerText.length,
              separatorBuilder: (context, idx) => Divider(
                color: AppStyle.lightGray3,
                thickness: 0.5,
                height: 0,
              ),
              itemBuilder: (context, index) => Material(
                color: Colors.transparent,
                child: (index == 2 || index == 3)
                    ? Theme(
                        data: Theme.of(
                          context,
                        ).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          leading: drawerIcon[index],
                          title: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 6,
                            ),
                            child: Text(
                              drawerText[index].tr,
                              style: blackStyle.copyWith(
                                fontSize: 16,
                                color: AppStyle.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          tilePadding: EdgeInsets.only(left: 18, right: 18),
                          childrenPadding: EdgeInsets.zero,
                          children: [
                            index == 2 ? AuctionsInMenu() : CategoriesInMenu(),
                          ],
                        ),
                      )
                    : ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minTileHeight: 48,
                        leading: drawerIcon[index],
                        title: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 6,
                          ),
                          child: Text(
                            drawerText[index].tr,
                            style: blackStyle.copyWith(
                              fontSize: 16,
                              color: AppStyle.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        onTap: () {
                          switch (drawerText[index]) {
                            case 'Home':
                              Navigator.pop(context);
                              break;
                            case 'Favourites':
                              tokenCheckingState.token.value.isNotEmpty
                                  ? NavigationHelper.navigateTo(
                                      context,
                                      FavouritesScreen(),
                                    )
                                  : diologueBoxLogin(
                                      'Please login to view your favourites'.tr,
                                    );
                              break;
                            case 'Auction Calendar':
                              NavigationHelper.navigateTo(
                                context,
                                CalendarScreen(),
                              );
                            case 'FAQs':
                              NavigationHelper.navigateTo(context, FAQScreen());
                              break;
                            case 'Terms and Conditions':
                              Navigator.pop(context);
                              // NavigationHelper.navigateTo(
                              //   context,
                              //   TermsAndConditionsScreen(),
                              // );
                              break;
                            case 'About Us':
                              // Navigator.pop(context);
                              NavigationHelper.navigateTo(
                                context,
                                AboutAppScreen(),
                              );
                              break;
                            case 'Settings':
                              //Navigator.pop(context);
                              NavigationHelper.navigateTo(
                                context,
                                SettingsDrawer(),
                              );
                              break;
                            // case 'User Guide':
                            //   NavigationHelper.navigateTo(
                            //       context, UserGuideScreen());
                            //   break;
                            case 'Logout':
                              NavigationHelper.navigateBack(context);
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: white,
                                    shape: ContinuousRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    title: Text('Logout'.tr),
                                    content: Text(
                                      'Are you sure you want to logout?'.tr,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('No'.tr),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          SharedPrefsHelper.remove('token');

                                          LoginApi().logOut();
                                          Navigator.pop(context);

                                          NavigationHelper.navigateAndReplace(
                                            context,
                                            LoginPage(),
                                          );
                                        },
                                        child: Text('Yes'.tr),
                                      ),
                                    ],
                                  );
                                },
                              );
                              break;
                            default:
                              NavigationHelper.navigateBack(context);
                          }
                        },
                      ),
              ),
            ),
          ),
          Divider(thickness: 0.2, color: white.withValues()),
          // Padding(
          //   padding: EdgeInsets.symmetric(vertical: 10),
          //   child: Column(
          //     children: [
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           Column(
          //             children: [
          //               Text(
          //                 'Follow us on'.tr,
          //                 style: whiteStyle.copyWith(
          //                   fontSize: 14,
          //                   color: AppStyle.darkGolden,
          //                 ),
          //               ),
          //               // Text(
          //               //   'Powered by Mzadcom'.tr,
          //               //   style: smallFontSize12.copyWith(color: black),
          //               // ),
          //             ],
          //           ),
          //           width05,
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: List.generate(socialmediaIcon.length, (index) {
          //               return Padding(
          //                 padding: EdgeInsets.all(8.0),
          //                 child: InkWell(
          //                   onTap: () {
          //                     debugPrint('Social Media Icon $index tapped');
          //                     // if (index == 0) {
          //                     //   instagrame(androidUrlValue: '');
          //                     // }

          //                     if (index == 0) {
          //                       instagrame(
          //                         androidUrlValue:
          //                             'https://www.instagram.com/mzadcomom',
          //                       );
          //                     }
          //                     if (index == 1) {
          //                       instagrame(
          //                         androidUrlValue:
          //                             'https://www.facebook.com/share/',
          //                       );
          //                     }
          //                     if (index == 2) {
          //                       instagrame(
          //                         androidUrlValue:
          //                             'https://x.com/mzadcomom?s=11',
          //                       );
          //                     }
          //                     // if (index == 2) {
          //                     //   instagrame(androidUrlValue: '');
          //                     // }
          //                   },
          //                   child: CircleAvatar(
          //                     backgroundColor: black.withValues(alpha: 0.05),
          //                     radius: 18,
          //                     child: CircleAvatar(
          //                       // backgroundImage: AssetImage(
          //                       //   socialmediaIcon[index],
          //                       // ),
          //                       radius: 14,
          //                       backgroundColor: white,
          //                       child: Padding(
          //                         padding: const EdgeInsets.all(3.0),
          //                         child: Image.asset(
          //                           socialmediaIcon[index],
          //                           height: 20,
          //                           //color: black.withValues(alpha: 0.8),
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //               );
          //             }),
          //           ),
          //         ],
          //       ),
          //       // height05,

          //       // height10,
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Future<bool> checkLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.containsKey('token');
  }

  List<String> socialmediaIcon = [
    // 'assets/images/mhdWAZbV_400x400.jpg',
    'assets/socialmediaIcon/instagram_icon.png',
    'assets/socialmediaIcon/facebook_icon.png',
    'assets/socialmediaIcon/twitter_icon.png',
  ];
}
