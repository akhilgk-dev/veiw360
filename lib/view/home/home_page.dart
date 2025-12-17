import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:view360/api/PDO_auctions.dart/pdo_auctions.dart';
import 'package:view360/api/banner/banner_api.dart';
import 'package:view360/api/previus_auctions/previous_auction_api.dart';
import 'package:view360/api/profile_details_api/profile_details_api.dart';
import 'package:view360/api/server_time/server_time.dart';
import 'package:view360/api/type_auction_count/type_auction_count.dart';
import 'package:view360/common/get_device_info/get_device_info.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/common/theme/colors.dart';
import 'package:view360/common/theme/sized_box.dart';
import 'package:view360/common/theme/style.dart';
import 'package:view360/common/utils/helpers/shared_pref.dart';
import 'package:view360/language/language_controller.dart';
import 'package:view360/main.dart';
import 'package:view360/model/active_auctions/active_auctions_model.dart';
import 'package:view360/model/categorie_model/categorie_model.dart';
import 'package:view360/view/auction_details/auction_details_page.dart';
import 'package:view360/view/authentication/login/widgets/carosal_widget.dart';
import 'package:view360/view/home/controller/count_down.dart';
import 'package:view360/view/home/widgets/live_auctions.dart';
import 'package:view360/view/home/widgets/types_auctions/PDO_auction.dart/PDO_auctions.dart';
import 'package:view360/view/home/widgets/types_auctions/active_auctions/active_auction.dart';
import 'package:view360/view/home/widgets/types_auctions/direct_sale/direct_sale.dart';
import 'package:view360/view/drawer/drawer_widget.dart';
import 'package:view360/view/home/widgets/types_auctions/previus_auctions/previous_action.dart';
import 'package:view360/view/home/widgets/types_auctions/upcoming_auctions/upcoming_auction.dart';
import 'package:view360/view/home/widgets/filtered_result_screen/filtered_result_screen.dart';
import 'package:view360/view/search/search_and_viewall.dart';
import 'package:view360/view/widgets/appbar_widget/appbar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../api/active_auctions/active_auctions_api.dart';
import '../../api/filter_home_api.dart/categorie_api.dart';
import '../../common/utils/helpers/snackbar.dart';
import '../widgets/token/token_checking.dart';
import 'dart:developer' as developer;

final searchQueryProvider = StateProvider<String>((ref) => '');

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with RouteAware {
  //

  bool _hasRunInitialLogic = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasRunInitialLogic) {
      routeObserver.subscribe(this, ModalRoute.of(context)!);
      _hasRunInitialLogic = true;
      _runOneTimeLogic(); // first time
    }
  }

  void _runOneTimeLogic() {
    ref.invalidate(auctionResponseProvider);
    print('Refreshed once on first appearance');
  }

  // Called when user navigates **back to this screen**
  @override
  void didPopNext() {
    ref.invalidate(auctionResponseProvider);
    print('Refreshed on return to screen');
  }

  //--------------------------------------------------------------------------------------------------
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();

  //riverpod selectable state --------------------------------------------------
  final selectedPage = StateProvider<int>((ref) => 0);
  final categorieId = StateProvider<int>((ref) => 0);
  final locationId = StateProvider<int>((ref) => 0);
  final departmentId = StateProvider<int>((ref) => 0);
  final LanguageController languageController = Get.find();
  final TokenCheckingState tokenCheckingState = Get.put(TokenCheckingState());
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  final TypeAuctionCountAPI typeAuctionCountAPI = Get.put(
    TypeAuctionCountAPI(),
  );
  final ServerTime serverTime = Get.put(ServerTime());
  String userName = '';
  final BannerApi banners = Get.put(BannerApi());

  @override
  @override
  void initState() {
    banners.fetchBanners();
    typeAuctionCountAPI.countRequest();
    serverTime.serverTimeNow();

    super.initState();
    initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(auctionResponseProvider);
    });
    typeAuctionCountAPI.countRequest();
    SharedPrefsHelper.getString("username").then((value) {
      setState(() {
        userName = value ?? '';
      });
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    routeObserver.unsubscribe(this);

    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result.isNotEmpty
          ? result.first
          : ConnectivityResult.none;
    });
    // ignore: avoid_print
    print('Connectivity changed: $_connectionStatus');
  }

  @override
  Widget build(BuildContext context) {
    bool isRtl = languageController.selectedLanguage.value == 1;
    final token = tokenCheckingState.token;
    //riverpod -----------------------------------------------------------------

    final AsyncValue<AuctionResponse> activity = ref.watch(
      auctionResponseProvider,
    );
    // final AsyncValue<UpcomingAuctionResponse> activityUpcoming =
    //     ref.watch(auctionResponseProviderUpcoming);
    // final AsyncValue<PreviousAuctionModel> activityPrevious =
    //     ref.watch(auctionResponseProviderPrevious);

    //--------------------------------------------------------------------------

    int activelength = activity.asData?.value.auctionData?.length ?? 0;
    // int upcominglength =
    //     activityUpcoming.asData?.value.auctionData?.length ?? 0;
    // int previouslength =
    //     activityPrevious.asData?.value.auctionData?.length ?? 0;
    List<int> length = [
      typeAuctionCountAPI.activeCount.value,
      typeAuctionCountAPI.upcomingCount.value,
      typeAuctionCountAPI.previusCount.value,
      0,
    ];
    final selectedPageIndex = ref.watch(selectedPage);

    int popCount = 0;

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(auctionResponseProviderProfile);
        ref.invalidate(auctionResponseProviderPrevious);
        ref.invalidate(pdoAuctionResponseProvider);
      },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) {
            return;
          }

          popCount++;

          if (popCount == 1) {
            SnackbarHelper.showSnackBar(context, 'Press again to exit');
          }
          if (popCount == 2) {
            SystemNavigator.pop();
          }
        },
        child: Scaffold(
          backgroundColor: AppStyle.scaffoldBg,
          key: scaffoldKey,
          drawer: DrawerWidget(),
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                scaffoldKey.currentState?.openDrawer();
              },
              icon: Icon(CupertinoIcons.list_dash, color: black),
            ),
            automaticallyImplyLeading: false,
            scrolledUnderElevation: 0,
            backgroundColor: Colors.white,
            actions: [
              TransalatorIcon(),
              width15,
              // CircleAvatar(
              //   radius: 18,
              //   backgroundColor: AppStyle.primary.withAlpha(20),
              //   child: Center(
              //     child: IconButton(
              //       onPressed: () {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) => SearchViewAll(),
              //           ),
              //         );
              //       },
              //       icon: Icon(Icons.search, size: 20, color: Colors.grey),
              //     ),
              //   ),
              // ),
              // width15,
            ],
            title: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Image.asset(
                'assets/splash/mzad-footer-logo.png',
                height: 27,
                color: AppStyle.primary,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    width: double.infinity,

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Welcome".tr,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  width05,
                                  SvgPicture.asset(
                                    'assets/svgs/hi_icon.svg',
                                    height: 18,
                                  ),
                                ],
                              ),

                              if (token != null && token.isNotEmpty)
                                Text(
                                  "${"Dear".tr} $userName",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.clip,
                                ),
                            ],
                          ),
                        ),
                        SizedBox(width: 25),

                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SearchViewAll(),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.search,
                                      size: 24,
                                      color: Colors.grey,
                                    ),
                                    Text(
                                      '${"Interested in".tr}...',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black45,
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
                  ),

                  // CarosalWidget(page: 'HOMEPAGE'),

                  //* categorie section-------------------------------------------
                  height05,
                  Obx(() {
                    if (banners.isLoading.value) {
                      return Center(child: CarosalWidget(page: 'HOMEPAGE'));
                    } else if (banners.success.value &&
                        banners.bannerResponse != null) {
                      return BannersCarosal(
                        page: 'HOMEPAGE',
                        bannerResponse: banners.bannerResponse!,
                      );
                    }
                    return CarosalWidget(page: 'HOMEPAGE');
                  }),

                  //  CategoriesWidget(),
                  ActiveAuctions(title: "Today's Auctions".tr, isToday: true),

                  height20,
                  PdoAuctions(title: "Special Auctions".tr),
                  height20,
                  ActiveAuctions(title: "Active Auctions".tr),
                  height20,

                  PreviousAuctions(),
                  height20,
                  // VisionCard(),
                  // height20,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Our Partners".tr,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  height10,
                  PartnersCarousel(),
                  height30,
                  height20,

                  //commented for now
                ],
              ),
            ),
          ),
          floatingActionButton: LiveAuctions(),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        ),
      ),
    );
  }

  //------------------------------------------------------------------------------
  Card endSoonMethodWidget(
    auctions,
    String countdown,
    int index,
    int language,
  ) {
    return Card(
      elevation: 4,
      child: ListTile(
        onTap: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('token');

          Get.to(() {
            return AuctionDetailsPage(
              index: index,
              token: token ?? '',
              auctionId: auctions['id'],
              imageUrl: auctions['images'] ?? [],
              mainImage: auctions['main_image']?.toString() ?? 'N/A',
            );
          });
        },
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: CachedNetworkImage(
            imageUrl: auctions['main_image'] ?? '',
            height: 100,
            width: 110,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
        title: Text(
          language == 0
              ? auctions['title'] ?? ''
              : auctions['title_ar'] ?? 'No Title'.tr,
          style: bold.copyWith(fontSize: 10),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              auctions['auction_number'] ?? 'Unknown ID'.tr,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
            Text(
              '${"Guarantee amount".tr}: ${auctions['start_amount']} OMR',
              style: TextStyle(fontSize: 10),
            ),
            // Text('${"Visit amount".tr}: ${auctions['visit_amount']} OMR',
            //     style: TextStyle(fontSize: 10)),
          ],
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${auctions['start_amount'] ?? 'N/A'} OMR',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
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
  }

  //----------------------------------------------------------------------------
  Future<dynamic> filterBottomSheet(BuildContext context, WidgetRef ref) {
    // final categoryData = ref.watch(auctionResponseCategory);

    return showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Filter Options".tr,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 12),

              // Categories Dropdown
              Consumer(
                builder: (context, ref, child) {
                  final AsyncValue<CategoryModel> categoryData = ref.watch(
                    auctionResponseCategory,
                  );
                  return categoryData.when(
                    data: (data) {
                      if (data.data.isEmpty) {
                        return Text('No categories available'.tr);
                      }
                      return _buildDropdown(
                        "Categories".tr,
                        data.data
                            .map(
                              (e) =>
                                  languageController.selectedLanguage.value == 1
                                  ? e.categoryNameAr
                                  : e.categoryName,
                            )
                            .toList(),
                        (value) {
                          if (value != null) {
                            ref.read(categorieId.notifier).state = data.data
                                .firstWhere(
                                  (e) =>
                                      languageController
                                              .selectedLanguage
                                              .value ==
                                          1
                                      ? e.categoryNameAr == value
                                      : e.categoryName == value,
                                )
                                .id;
                          }
                        },
                      );
                    },
                    loading: () => Skeletonizer(
                      enabled: true,
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'loading....',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    error: (error, stackTrace) =>
                        Text('Error loading categories'.tr),
                  );
                },
              ),
              SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Close".tr),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(darkBlue),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        ref.invalidate(countdownProvider);
                        final categorieID = ref.read(categorieId);
                        // final departmentID = ref.read(departmentId);
                        // final locationID = ref.read(locationId);
                        Get.to(
                          () => FilteredResultScreen(
                            categoryID: categorieID,
                            // departmentID: departmentID,
                            // locationID: locationID,
                          ),
                        );
                      },
                      child: Text("Apply".tr, style: TextStyle(color: white)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

//----------------------------------------------------------------------------

Widget _buildDropdown(
  String title,
  List<String> items,
  ValueChanged<String?>? onChanged,
) {
  return DropdownButtonFormField<String>(
    menuMaxHeight: 270,
    decoration: InputDecoration(
      labelText: title,
      labelStyle: TextStyle(fontSize: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    ),
    items: items.map((item) {
      return DropdownMenuItem(
        value: item,
        child: Text(item, style: TextStyle(fontSize: 13)),
      );
    }).toList(),
    onChanged: onChanged,
  );
}

//----------------------------------------------------------------------------

Widget _buildSelectedPage(int selectedPageIndex, WidgetRef ref) {
  // ref.invalidate(auctionResponseProviderUpcoming);
  // ref.invalidate(auctionResponseProviderPrevious);

  switch (selectedPageIndex) {
    case 0:
      return ActiveAuctions(title: 'asd');
    case 1:
      return UpcomingAuction();
    case 2:
      return PreviousAuctions();
    case 3:
      return DirectSaleAuctions();
    default:
      return ActiveAuctions(title: 'asdf');
  }
}
