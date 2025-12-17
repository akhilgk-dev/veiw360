import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:view360/api/PDO_auctions.dart/pdo_auctions.dart';
import 'package:view360/api/active_auctions/active_auctions_api.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/common/theme/colors.dart';
import 'package:view360/common/theme/constants.dart';
import 'package:view360/common/utils/formatter/amount_formate.dart';
import 'package:view360/model/profile_details/profile_details_model.dart';
import 'package:view360/view/auction_details/components/images_list_row.dart';
import 'package:view360/view/authentication/registration/registration.dart';
import 'package:view360/view/widgets/skeletonizer/list_homepage_skeleton.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:view360/api/profile_details_api/profile_details_api.dart';
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/common/text/text_static.dart';
import 'package:view360/common/theme/sized_box.dart';
import 'package:view360/common/theme/style.dart';
import 'package:view360/common/utils/helpers/navigation_helper.dart';
import 'package:view360/common/utils/helpers/snackbar.dart';
import 'package:view360/language/language_controller.dart';
import 'package:view360/main.dart';
import 'package:view360/view/auction_details/url_launcher/make_phone_call.dart';
import 'package:view360/view/auction_details/url_launcher/whatsapp.dart';
import 'package:view360/view/enroll_live_bidding_screen/enroll_live_bidding_screen.dart';
import 'package:view360/view/enrollment_payment_screen/registration_for_bidders.dart';
import 'package:view360/view/auction_details/components/auction_details_card.dart';
import 'package:view360/view/home/controller/count_down.dart';
import 'package:view360/view/home/controller/favourite_notifier.dart';
import 'package:view360/view/widgets/appbar_widget/appbar_widget.dart';
import 'package:view360/view/widgets/diologue_box/diologue_box.dart';
import 'package:share_plus/share_plus.dart';
import '../../api/auction_details_api/auction_details_all_api.dart';
import '../../api/live_bidding_apis/user_validity_check.dart';
import '../widgets/token/token_checking.dart';
import 'state/image_updation_state.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class AuctionDetailsPage extends ConsumerStatefulWidget {
  final int auctionId;
  final String? mainImage;
  final List<dynamic> imageUrl;
  final String token;
  final int index;

  const AuctionDetailsPage({
    super.key,
    required this.auctionId,
    required this.imageUrl,
    required this.token,
    required this.index,
    this.mainImage,
  });

  @override
  ConsumerState<AuctionDetailsPage> createState() => _AuctionDetailsPageState();
}

class _AuctionDetailsPageState extends ConsumerState<AuctionDetailsPage>
    with RouteAware {
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
    ref.invalidate(auctionAllDetailsResponseProvider(widget.auctionId));

    print('Refreshed once on first appearance');
  }

  // Called when user navigates **back to this screen**
  @override
  void didPopNext() {
    ref.invalidate(auctionAllDetailsResponseProvider(widget.auctionId));
    print('Refreshed on return to screen');
  }

  @override
  void initState() {
    print(widget.auctionId);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final selectedPageNotifier = ref.read(selectedPageProvider.notifier);

      if (widget.mainImage != null && widget.mainImage!.isNotEmpty) {
        selectedPageNotifier.updateImage(widget.mainImage ?? '');
      } else {
        selectedPageNotifier.updateImage('');
      }
    });
  }

  String buildAuctionUrl() {
    final baseUrl = '$baseUrlMini/auction';

    final pathPart = widget.index == 0 ? '' : '/${widget.index}';

    final queryParams = {
      'auctionID': widget.auctionId.toString(),
      'index': widget.index.toString(),
      if (widget.mainImage != null) 'auctionImage': widget.mainImage!,
    };

    final queryString = Uri(queryParameters: queryParams).query;

    return '$baseUrl$pathPart?$queryString';
  }

  final UserValidityCheckApi userValidityCheckApi = Get.put(
    UserValidityCheckApi(),
  );

  final TokenCheckingState tokenCheckingState = Get.put(TokenCheckingState());
  final LanguageController languageController = Get.find();

  String countDownDigit(String datetime, int ind) {
    List<String> parts = datetime.split(' ');

    if (ind >= parts.length) {
      return "0";
    }
    return parts[ind];
  }

  List<String> getImageUrls(auctionData) {
    List<String> imageUrls = [];
    for (var imageData in auctionData['images']) {
      if (imageData.containsKey('image')) {
        if (imageData['image'] != null && imageData['image'].isNotEmpty) {
          imageUrls.add(imageData['image']);
        }
      }
    }
    return imageUrls;
  }

  List<String> imageRearrange(List<dynamic> images, String mainImage) {
    // Create a new list to store the rearranged image URLs
    List<String> imageUrls = [];

    // Add the mainImage as the first element if it's not empty
    if (mainImage.isNotEmpty) {
      imageUrls.add(mainImage);
    }

    // Iterate through the images list and add only unique images (excluding duplicates of mainImage)
    for (var image in images) {
      if (image != mainImage && !imageUrls.contains(image)) {
        imageUrls.add(image);
      }
    }

    return imageUrls;
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = languageController.selectedLanguage.value == 1;
    tokenCheckingState.checkToken();
    //--------------------------------------------------------------------------
    final AsyncValue<dynamic> auctionDetails = ref.watch(
      auctionAllDetailsResponseProvider(widget.auctionId),
    );

    final profileData = widget.token.isNotEmpty
        ? ref.watch(auctionResponseProviderProfile)
        : null;

    final useridEmailverifiedAt =
        profileData?.asData?.value.data.emailVerifiedAt ?? '';
    final useridphoneverifiedAt =
        profileData?.asData?.value.data.mobileVerifiedAt ?? '';

    //---------------------------------------------------------------------------------------------------------------------------

    return Scaffold(
      //need watsapp floating auction button,
      backgroundColor: AppStyle.scaffoldBg,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'whatsapp',
            onPressed: () async {
              whatsapp();
            },
            mini: true, // makes the button smaller
            backgroundColor: Colors.green,
            child: Image.asset(
              'assets/bottomNavIcon/download.png',
              height: 35,
              width: 30,
            ),
          ),
          // SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'call',
            onPressed: () async {
              makePhoneCall('+96894370339');
            },
            mini: true,
            backgroundColor: AppStyle.secondColor,
            child: Icon(Icons.phone, color: Colors.white, size: 22),
          ),
        ],
      ),

      appBar: AppbarWidget(
        title: 'Auction Details'.tr,
        onBackPress: () {
          ref.invalidate(auctionResponseProvider);
          ref.invalidate(pdoAuctionResponseProvider);
        },
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(auctionAllDetailsResponseProvider(widget.auctionId));
        },
        child: auctionDetails.when(
          data: (auctionData) {
            //-----------------------------------------------------------------------------------------------------------------------
            final regStart = parseBackendTime(
              (auctionData['reg_start_date_ar'] != null &&
                      auctionData['reg_start_date_ar'] != [])
                  ? DateFormat("dd/MM/yyyy hh:mm:ss a")
                        .parse(
                          "${auctionData['reg_start_date_ar']['date'] ?? ''} ${auctionData['reg_start_date_ar']['time'] ?? ''}",
                        )
                        .toString()
                  : DateTime.now().subtract(Duration(days: 365)).toString(),
            );
            final regEnd = parseBackendTime(
              (auctionData['reg_end_date_ar'] != null &&
                      auctionData['reg_end_date_ar'] != [])
                  ? DateFormat("dd/MM/yyyy hh:mm:ss a")
                        .parse(
                          "${auctionData['reg_end_date_ar']['date'] ?? ''} ${auctionData['reg_end_date_ar']['time'] ?? ''}",
                        )
                        .toString()
                  : DateTime.now().subtract(Duration(days: 365)).toString(),
            );

            final auctionStart = parseBackendTime(
              (auctionData['start_date_ar'] != null &&
                      auctionData['start_date_ar'] != [] &&
                      auctionData['start_date_ar']['time'] != null)
                  ? DateFormat("dd/MM/yyyy hh:mm:ss a")
                        .parse(
                          "${auctionData['start_date_ar']['date'] ?? ''} ${auctionData['start_date_ar']['time'] ?? ''}",
                        )
                        .toString()
                  : DateTime.now().subtract(Duration(days: 365)).toString(),
            );

            final auctionEnd = parseBackendTime(
              (auctionData['end_date_ar'] != null &&
                      auctionData['end_date_ar'] != [])
                  ? DateFormat(
                      "yyyy-MM-dd HH:mm:ss",
                    ).parse(auctionData['end_date'] ?? '').toString()
                  : DateTime.now().subtract(Duration(days: 365)).toString(),
            );

            final countdown = ref.watch(
              countdownProvider((regStart, regEnd, auctionStart, auctionEnd)),
            );
            final isActive = auctionData['status_label']['status'] == 'A';
            final isEnded = auctionData['status_label']['status'] == 'E';
            final favorites = ref.watch(favoritesProvider);
            final isFavorite = favorites.contains(0);
            final selectedPage = ref.watch(selectedPageProvider);

            //-----------------------------------------------------------------------------------------------------
            final imageUrls = getImageUrls(auctionData);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        SafeArea(
                          top: false,
                          bottom: true,
                          child:
                              // ClipRRect(
                              //   borderRadius: BorderRadius.circular(14),
                              //   child: CarouselSlider(
                              //     options: CarouselOptions(
                              //       height:
                              //           MediaQuery.of(context).size.height * 0.3,
                              //       autoPlay: true,
                              //       padEnds: true,
                              //       viewportFraction: 1.0,
                              //     ),
                              //     items: imageUrls.map((item) {
                              //       return Builder(
                              //         builder: (BuildContext context) {
                              //           return
                              //           InkWell(
                              //             onTap: () {
                              //               showDialog(
                              //                 context: context,
                              //                 builder: (context) {
                              //                   return Dialog(
                              //                     backgroundColor:
                              //                         Colors.transparent,
                              //                     insetPadding: EdgeInsets.all(16),
                              //                     child: ClipRRect(
                              //                       borderRadius:
                              //                           BorderRadius.circular(16),
                              //                       child: Container(
                              //                         height:
                              //                             MediaQuery.of(
                              //                               context,
                              //                             ).size.height *
                              //                             0.5,
                              //                         color: Colors.black,
                              //                         child: PhotoView(
                              //                           imageProvider:
                              //                               CachedNetworkImageProvider(
                              //                                 errorListener: (p0) {
                              //                                   debugPrint(
                              //                                     "Error loading image $p0",
                              //                                   );
                              //                                 },
                              //                                 selectedPage,
                              //                               ),
                              //                           backgroundDecoration:
                              //                               BoxDecoration(
                              //                                 color: Colors.black,
                              //                               ),
                              //                           minScale:
                              //                               PhotoViewComputedScale
                              //                                   .contained,
                              //                           maxScale:
                              //                               PhotoViewComputedScale
                              //                                   .covered *
                              //                               2,
                              //                         ),
                              //                       ),
                              //                     ),
                              //                   );
                              //                 },
                              //               );
                              //             },
                              //             child: Container(
                              //               decoration: BoxDecoration(
                              //                 borderRadius: BorderRadius.circular(
                              //                   14,
                              //                 ),
                              //                 image: DecorationImage(
                              //                   image: CachedNetworkImageProvider(
                              //                     item,
                              //                   ),
                              //                   fit: BoxFit.cover,
                              //                 ),
                              //               ),
                              //               margin: const EdgeInsets.symmetric(
                              //                 horizontal: 5.0,
                              //               ),
                              //               //child: item,
                              //             ),
                              //           );
                              //         },
                              //       );
                              //     }).toList(),
                              //   ),
                              // ),
                              GestureDetector(
                                onTap: () {
                                  final List<String> imageUrlsSelected =
                                      imageRearrange(imageUrls, selectedPage);

                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        backgroundColor: Colors.transparent,
                                        insetPadding: EdgeInsets.all(16),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          child: CarouselSlider(
                                            options: CarouselOptions(
                                              height:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.height *
                                                  0.4,
                                              autoPlay: true,
                                              padEnds: true,
                                              viewportFraction: 1.0,
                                            ),
                                            items: imageUrlsSelected.map((
                                              item,
                                            ) {
                                              return Builder(
                                                builder: (BuildContext context) {
                                                  return Container(
                                                    height:
                                                        MediaQuery.of(
                                                          context,
                                                        ).size.height *
                                                        0.5,
                                                    color: Colors.black,
                                                    child: PhotoView(
                                                      imageProvider:
                                                          CachedNetworkImageProvider(
                                                            item,
                                                          ),
                                                      backgroundDecoration:
                                                          BoxDecoration(
                                                            color: Colors.black,
                                                          ),
                                                      minScale:
                                                          PhotoViewComputedScale
                                                              .contained,
                                                      maxScale:
                                                          PhotoViewComputedScale
                                                              .covered *
                                                          2,
                                                    ),
                                                  );
                                                  //  Container(
                                                  //   decoration: BoxDecoration(
                                                  //     borderRadius:
                                                  //         BorderRadius.circular(
                                                  //           14,
                                                  //         ),
                                                  //     image: DecorationImage(
                                                  //       image:
                                                  //           CachedNetworkImageProvider(
                                                  //             item,
                                                  //           ),
                                                  //       fit: BoxFit.cover,
                                                  //     ),
                                                  //   ),
                                                  //   margin:
                                                  //       const EdgeInsets.symmetric(
                                                  //         horizontal: 5.0,
                                                  //       ),
                                                  //   //child: item,
                                                  // );
                                                },
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Hero(
                                        tag: "auctionImage",
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                (selectedPage != null &&
                                                    selectedPage.isNotEmpty)
                                                ? selectedPage
                                                : auctionData['images']?[0]['image'] ??
                                                      '',
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(
                                                      color: Colors.grey[200],
                                                      height: 200,
                                                      child: const Icon(
                                                        Icons.image,
                                                        size: 50,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        ),

                        //rop logo
                        //  RopLogo(),

                        //
                        Positioned(
                          right: 10,
                          top: 15,
                          child: Container(
                            width: 100,
                            decoration: BoxDecoration(
                              color:
                                  auctionData['status_label']['status'] == 'A'
                                  ? Colors.green
                                  : auctionData['status_label']['status'] == 'U'
                                  ? Colors.green
                                  : Colors.red,
                              // border: Border.all(color: Colors.green),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  auctionData['status_label']['status'] == 'A'
                                      ? 'Active'.tr
                                      : auctionData['status_label']?['status'] ==
                                            'U'
                                      ? 'Upcoming'.tr
                                      : 'Ended'.tr,
                                  style: whiteStyle,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          left: 10,
                          child: GestureDetector(
                            onTap: () async {
                              final auctionUrl = buildAuctionUrl();

                              final shareText =
                                  '${"Check out this auction:".tr} $auctionUrl';
                              final imageUrlToShare = widget.mainImage ?? '';

                              try {
                                if (imageUrlToShare.isNotEmpty) {
                                  final response = await http.get(
                                    Uri.parse(imageUrlToShare),
                                  );
                                  final documentDirectory =
                                      await getApplicationDocumentsDirectory();
                                  final file = File(
                                    '${documentDirectory.path}/auction_image.jpg',
                                  );
                                  await file.writeAsBytes(response.bodyBytes);

                                  await Share.shareXFiles(
                                    [XFile(file.path)],
                                    text: shareText,
                                    subject: 'Auction Details'.tr,
                                  );
                                } else {
                                  await Share.share(
                                    shareText,
                                    subject: 'Auction Details'.tr,
                                  );
                                }
                              } catch (e) {
                                debugPrint('Error sharing auction: $e');
                                Get.snackbar(
                                  'Error'.tr,
                                  'Failed to share auction'.tr,
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              }
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(Icons.share),
                            ),
                          ),
                        ),
                        // FavouriteLikeWidget(
                        //   auctionName: auctionData['title'],
                        //   ref: ref,
                        //   isFavorite: isFavorite,
                        //   index: 0,
                        //   auctionID: widget.auctionId,
                        // ),
                      ],
                    ),
                    height05,

                    //*image listing row----below mainimage
                    ImageListingRow(
                      widget: widget,
                      ref: ref,
                      images: auctionData['images'],
                    ),

                    //*Auction details//
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 18,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withAlpha(220),
                            AppStyle.secondary.withAlpha(30),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueAccent.withAlpha(30),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.blueAccent.withAlpha(40),
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 12,
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Left: Auction info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Title
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withAlpha(200),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: Colors.blueAccent.withAlpha(
                                              30,
                                            ),
                                            width: 0.8,
                                          ),
                                        ),
                                        child: Text(
                                          isArabic
                                              ? auctionData['title_ar']
                                              : auctionData['title'],
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      // Auction number
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/images/mybids.png',
                                            height: 18,
                                            color: AppStyle.primary,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            auctionData['auction_number']
                                                .toString(),
                                            style: smallFontSize12.copyWith(
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      // Views
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.remove_red_eye_outlined,
                                            size: 17,
                                            color: Colors.grey[700],
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            auctionData['total_views']
                                                .toString(),
                                            style: smallFontSize12.copyWith(
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                          Spacer(),
                                          // Icon(
                                          //   Icons.gavel,
                                          //   size: 17,
                                          //   color: AppStyle.liteRed,
                                          // ),
                                          Text(
                                            "${"Bid Count".tr}:",
                                            style: smallFontSize12.copyWith(
                                              color: Colors.black87,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppStyle.lightGray3,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              (auctionData['bid_count'] ?? 0)
                                                  .toString(),
                                              style: smallFontSize12.copyWith(
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // Right: Countdown
                                Container(
                                  margin: const EdgeInsets.only(left: 12),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    gradient: LinearGradient(
                                      colors: AppStyle.darkGradient,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppStyle.primary.withAlpha(30),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Timer
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.timer_outlined,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            "${countDownDigit(countdown, 0)} ${countDownDigit(countdown, 1)}",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (countDownDigit(countdown, 1) !=
                                              "Ended" &&
                                          auctionData['status'] == 'A') ...[
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: List.generate(4, (index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 2.0,
                                                  ),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: 36,
                                                    width: 30,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white
                                                          .withAlpha(40),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      countDownDigit(
                                                        countdown,
                                                        index + 3,
                                                      ),
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    timesStrings[index],
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 12),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.white,
                              ),

                              child: Row(
                                children: [
                                  Text(
                                    '${"Current amount".tr}:  ',
                                    style: smallFontSize12.copyWith(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${AmountFormate().currencyFormat(auctionData['current_amount'].toString())} OMR',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppStyle.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // height05,

                    // Container(
                    //   width: double.infinity,
                    //   decoration: BoxDecoration(
                    //     color: Colors.white70,
                    //     borderRadius: BorderRadius.circular(8),
                    //     border: Border.all(
                    //       color: Colors.grey.withAlpha(100),
                    //       width: 0.8,
                    //     ),
                    //   ),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Expanded(
                    //         child: Padding(
                    //           padding: const EdgeInsets.all(8.0),
                    //           child: Column(
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               Container(
                    //                 padding: EdgeInsets.symmetric(
                    //                   horizontal: 3,
                    //                   vertical: 4,
                    //                 ),
                    //                 decoration: BoxDecoration(
                    //                   color: Colors.white70,
                    //                   borderRadius: BorderRadius.circular(6),
                    //                   border: Border.all(
                    //                     color: Colors.grey.withAlpha(100),
                    //                     width: 0.8,
                    //                   ),
                    //                 ),
                    //                 child: Text(
                    //                   isArabic
                    //                       ? auctionData['title_ar']
                    //                       : auctionData['title'],
                    //                   style: TextStyle(
                    //                     fontSize: 14,
                    //                     fontWeight: FontWeight.bold,
                    //                   ),
                    //                 ),
                    //               ),
                    //               height05,
                    //               Row(
                    //                 children: [
                    //                   Image.asset(
                    //                     'assets/images/mybids.png',
                    //                     height: 20,
                    //                     color: black,
                    //                   ),
                    //                   width05,
                    //                   Text(
                    //                     auctionData['auction_number']
                    //                         .toString(),
                    //                     style: smallFontSize12,
                    //                   ),
                    //                 ],
                    //               ),
                    //               height05,
                    //               Row(
                    //                 children: [
                    //                   Text(
                    //                     auctionData['total_views'].toString(),
                    //                     style: smallFontSize12,
                    //                   ),
                    //                   width05,
                    //                   Icon(
                    //                     Icons.remove_red_eye_outlined,
                    //                     size: 17,
                    //                   ),
                    //                   width10,
                    //                 ],
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //       Container(
                    //         padding: EdgeInsets.only(left: 6),
                    //         margin: EdgeInsets.all(6),
                    //         decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.circular(8),
                    //           border: Border.all(
                    //             color: Colors.grey.withAlpha(50),
                    //             width: 0.8,
                    //           ),
                    //           gradient: LinearGradient(
                    //             colors: AppStyle.blueButtonGradient,
                    //           ),
                    //         ),
                    //         child: Column(
                    //           children: [
                    //             height05,
                    //             Row(
                    //               mainAxisAlignment: MainAxisAlignment.center,
                    //               children: [
                    //                 Icon(
                    //                   Icons.timer_outlined,
                    //                   size: 15,
                    //                   color: Colors.white,
                    //                 ),
                    //                 SizedBox(width: 3),
                    //                 RichText(
                    //                   text: TextSpan(
                    //                     text:
                    //                         "${countDownDigit(countdown, 0)} ${countDownDigit(countdown, 1)}",
                    //                     style: TextStyle(
                    //                       fontSize: 13,
                    //                       color: Colors.white,
                    //                       fontWeight: FontWeight.bold,
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),

                    //             if (countDownDigit(countdown, 1) != "Ended")
                    //               Row(
                    //                 mainAxisAlignment: MainAxisAlignment.center,
                    //                 children: List.generate(4, (index) {
                    //                   return Column(
                    //                     crossAxisAlignment:
                    //                         CrossAxisAlignment.start,
                    //                     children: [
                    //                       Container(
                    //                         height: 40,
                    //                         width: 35,
                    //                         padding: EdgeInsets.all(6),
                    //                         margin: EdgeInsets.only(
                    //                           right: 12,
                    //                           top: 4,
                    //                         ),
                    //                         decoration: BoxDecoration(
                    //                           color: AppStyle.white.withAlpha(
                    //                             100,
                    //                           ),
                    //                           borderRadius:
                    //                               BorderRadius.circular(10),
                    //                           // border: Border.all(
                    //                           //   color: darkBlue,
                    //                           //   width: 0.8,
                    //                           // ),
                    //                         ),

                    //                         child: Center(
                    //                           child: Text(
                    //                             countDownDigit(
                    //                               countdown,
                    //                               index + 3,
                    //                             ),
                    //                             style: TextStyle(
                    //                               color: Colors.white,
                    //                               fontSize: 14,
                    //                               fontWeight: FontWeight.bold,
                    //                             ),
                    //                           ),
                    //                         ),
                    //                       ),
                    //                       height05,
                    //                       Text(
                    //                         timesStrings[index],
                    //                         style: TextStyle(
                    //                           fontSize: 11,
                    //                           color: white,
                    //                           fontWeight: FontWeight.bold,
                    //                         ),
                    //                       ),
                    //                     ],
                    //                   );
                    //                 }),
                    //               ),
                    //             height05,
                    //           ],
                    //         ),
                    //       ),
                    //       // Padding(
                    //       //   padding: const EdgeInsets.all(8.0),
                    //       //   child: Column(
                    //       //     crossAxisAlignment: CrossAxisAlignment.start,
                    //       //     children: [
                    //       //       Container(
                    //       //         decoration: BoxDecoration(
                    //       //           color: darkBlue,
                    //       //           borderRadius: BorderRadius.circular(5),
                    //       //         ),
                    //       //         padding: EdgeInsets.symmetric(
                    //       //           horizontal: 8,
                    //       //           vertical: 4,
                    //       //         ),
                    //       //         child: Text(
                    //       //           '${'Current amount'.tr}: ${auctionData['current_amount'].toString()} OMR',
                    //       //           style: TextStyle(
                    //       //             fontSize: 14,
                    //       //             fontWeight: FontWeight.bold,
                    //       //             color: white,
                    //       //           ),
                    //       //         ),
                    //       //       ),
                    //       //       height05,
                    //       //       if (isActive)
                    //       //         // Text('Auction starts from'.tr,
                    //       //         //     style: smallFontSize12),
                    //       //         if (isEnded)
                    //       //           Text(
                    //       //             'Auction ended'.tr,
                    //       //             style: smallFontSize12,
                    //       //           ),
                    //       //       if (isActive)
                    //       //         Row(
                    //       //           children: [
                    //       //             Icon(Icons.timelapse_outlined, size: 17),
                    //       //             width05,
                    //       //             Text(
                    //       //               countdown.toString(),
                    //       //               style: smallFontSize12.copyWith(
                    //       //                 color: Colors.green,
                    //       //                 fontWeight: FontWeight.bold,
                    //       //               ),
                    //       //             ),
                    //       //           ],
                    //       //         ),
                    //       //       if (isEnded)
                    //       //         Row(
                    //       //           children: [
                    //       //             Icon(Icons.timelapse_outlined, size: 17),
                    //       //             width05,
                    //       //             Text(
                    //       //               '${auctionData['reg_end_date_ar']['date'].toString()}\n${auctionData['reg_end_date_ar']['time'].toString()}',
                    //       //               style: smallFontSize12.copyWith(
                    //       //                 color: Colors.red,
                    //       //                 fontWeight: FontWeight.bold,
                    //       //               ),
                    //       //             ),
                    //       //           ],
                    //       //         ),
                    //       //     ],
                    //       //   ),
                    //       // ),
                    //     ],
                    //   ),
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          //  height: 20,
                          margin: EdgeInsets.only(top: 6, bottom: 6),
                          padding: EdgeInsets.symmetric(
                            horizontal: 38,
                            vertical: 4,
                          ),
                          //   width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppStyle.red,
                            borderRadius: BorderRadius.circular(50),

                            // gradient: LinearGradient(
                            //   colors: AppStyle.redGradient,
                            // ),
                          ),

                          child: Center(
                            child: Text(
                              "Final approved by Owner".tr,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppStyle.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    //* auction card
                    AuctionCard(
                      startBidAmount: auctionData['start_amount'].toString(),
                      guaranteeAmount: auctionData['guarantee_amount']
                          .toString(),
                      auctionId: widget.auctionId,
                      categoryType:
                          auctionData['categoryDetails']?['category_name']
                              ?.toString() ??
                          '',
                      fileTerms: auctionData['file_terms']?.toString() ?? '',
                      filePaymentTerms:
                          auctionData['file_payment_terms']?.toString() ?? '',
                      auctionNumber:
                          auctionData['auction_number']?.toString() ?? '',
                      auctionCode:
                          auctionData['auction_number']?.toString() ?? '',
                      vat: auctionData['vat']?.toString() ?? '',
                      startingAuctionDate:
                          auctionData['start_date_ar']?['date']?.toString() ??
                          '',
                      startingTimeAuction:
                          auctionData['start_date_ar']?['time']?.toString() ??
                          '',
                      endingAuctionDate:
                          auctionData['end_date_ar']?['date']?.toString() ?? '',
                      endingTimeAuction:
                          auctionData['end_date_ar']?['time']?.toString() ?? '',
                      visitAmount:
                          auctionData['visit_amount']?.toString() ?? '',
                      insuranceAmount:
                          auctionData['guarantee_amount']?.toString() ?? '',
                      location: auctionData['location']?.toString() ?? '',
                      latitude: auctionData['latitude']?.toString() ?? '',
                      longitude: auctionData['longitude']?.toString() ?? '',
                      endDay:
                          auctionData['end_date_ar']?['day']?.toString() ?? '',
                      startDay:
                          auctionData['start_date_ar']?['day']?.toString() ??
                          '',
                      isArabic: isArabic,
                    ),
                    // AuctionCard(
                    //   startBidAmount: auctionData['start_amount'].toString(),
                    //   guaranteeAmount: auctionData['guarantee_amount'],
                    //   auctionId: widget.auctionId,
                    //   categoryType:
                    //       auctionData['categoryDetails']['category_name'],
                    //   fileTerms: auctionData['file_terms'],
                    //   filePaymentTerms: auctionData['file_payment_terms'],
                    //   auctionNumber: auctionData['auction_number'],
                    //   auctionCode: auctionData['auction_number'],
                    //   vat: auctionData['vat'],
                    //   startingAuctionDate: auctionData['start_date_ar']['date'],
                    //   startingTimeAuction: auctionData['start_date_ar']['time'],
                    //   endingAuctionDate: auctionData['end_date_ar']['date'],
                    //   endingTimeAuction: auctionData['end_date_ar']['time'],
                    //   visitAmount: auctionData['visit_amount'],
                    //   insuranceAmount: auctionData['guarantee_amount'],
                    //   location: auctionData['location'],
                    //   latitude: auctionData['latitude'],
                    //   longitude: auctionData['longitude'],
                    // ),
                    height05,

                    //*Enroll now button------------------------------------------
                    // The enrollAndBidNowLiveWidget is now placed in the bottomNavigationBar.
                  ],
                ),
              ),
            );
          },
          loading: () => Center(child: ListSkeleton()),
          error: (error, stack) => Center(child: Text('Error: $error'.tr)),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Add the enroll and bid now widget
            auctionDetails.when(
              data: (auctionData) {
                final regStart =
                    (auctionData['reg_start_date_ar'] != null &&
                        auctionData['reg_start_date_ar'] != [])
                    ? DateFormat("dd/MM/yyyy hh:mm:ss a").parse(
                        "${auctionData['reg_start_date_ar']['date'] ?? ''} ${auctionData['reg_start_date_ar']['time'] ?? ''}",
                      )
                    : DateTime.now().subtract(Duration(days: 365));
                final regEnd =
                    (auctionData['reg_end_date_ar'] != null &&
                        auctionData['reg_end_date_ar'] != [])
                    ? DateFormat("dd/MM/yyyy hh:mm:ss a").parse(
                        "${auctionData['reg_end_date_ar']['date'] ?? ''} ${auctionData['reg_end_date_ar']['time'] ?? ''}",
                      )
                    : DateTime.now().subtract(Duration(days: 365));
                final auctionStart =
                    (auctionData['start_date_ar'] != null &&
                        auctionData['start_date_ar'] != [])
                    ? DateFormat("dd/MM/yyyy hh:mm:ss a").parse(
                        "${auctionData['start_date_ar']['date'] ?? ''} ${auctionData['start_date_ar']['time'] ?? ''}",
                      )
                    : DateTime.now().subtract(Duration(days: 365));
                final auctionEnd =
                    (auctionData['end_date_ar'] != null &&
                        auctionData['end_date_ar'] != [])
                    ? DateFormat("dd/MM/yyyy hh:mm:ss a").parse(
                        "${auctionData['end_date_ar']['date'] ?? ''} ${auctionData['end_date_ar']['time'] ?? ''}",
                      )
                    : DateTime.now().subtract(Duration(days: 365));
                final isActive = auctionData['status_label']['status'] == 'A';
                final isEnded = auctionData['status_label']['status'] == 'E';
                // final profileData = widget.token.isNotEmpty
                //     ? ref.watch(auctionResponseProviderProfile)
                //     : null;
                // final useridEmailverifiedAt =
                //     profileData?.asData?.value.data.emailVerifiedAt;
                // final useridphoneverifiedAt =
                //     profileData?.asData?.value.data.mobileVerifiedAt;

                return isActive
                    ? Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: enrollAndBidNowLiveWidget(
                          useridEmailverifiedAt,
                          useridphoneverifiedAt,
                          auctionEnd,
                          auctionStart,
                          context,
                          auctionData,
                          isActive,
                          isEnded,
                          regEnd,
                          regStart,
                          tokenCheckingState,
                          profileData?.value,
                        ),
                      )
                    : SizedBox();
              },
              loading: () => SizedBox.shrink(),
              error: (error, stack) => SizedBox.shrink(),
            ),
            SizedBox(height: 8),
            //   UrlLauncherWhatsappAndPhoneButton(),
          ],
        ),
      ),
    );
  }

  //-----------------Enroll and bid now button----------------------
  Row enrollAndBidNowLiveWidget(
    String? useridEmailverifiedAt,
    String? useridphoneverifiedAt,
    DateTime auctionEnd,
    DateTime auctionStart,
    BuildContext context,
    auctionData,
    bool isActive,
    bool isEnded,
    DateTime regEnd,
    DateTime regStart,
    TokenCheckingState tokenCheckingState,
    ProfileDetailsModel? profileData,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (auctionData['status'] == 'A' &&
            (auctionData['is_enrolled'] != true))
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: darkBlue,
                borderRadius: BorderRadius.circular(6),
                // border: Border.all(color: darkBlue, width: 0.8),
                gradient: LinearGradient(colors: AppStyle.bidButtonGradient),
              ),
              child: InkWell(
                // style: ButtonStyle(
                //   backgroundColor: WidgetStateProperty.all<Color>(darkBlue),
                //   shape: WidgetStateProperty.all(
                //     ContinuousRectangleBorder(
                //       borderRadius: BorderRadius.circular(10),
                //     ),
                //   ),

                // ),
                onTap: () {
                  if (widget.token.isEmpty) {
                    diologueBoxLogin(
                      'You need to login to enroll this auction'.tr,
                    );
                    return;
                  }

                  if (auctionData['is_enrolled'] == true) {
                    if (context.mounted) {
                      SnackbarHelperTop.showSnackBar(
                        context,
                        alreadyEnrolledMessage.tr,
                        color: darkBlue,
                      );
                    }
                    return;
                  }

                  final now = DateTime.now();

                  if (now.isAfter(regEnd)) {
                    if (context.mounted) {
                      SnackbarHelperTop.showSnackBar(
                        context,
                        'Registration completed'.tr,
                        color: darkRed,
                      );
                    }
                    return;
                  }
                  if (now.isBefore(regStart)) {
                    if (context.mounted) {
                      SnackbarHelperTop.showSnackBar(
                        context,
                        'Registration not started yet'.tr,
                        color: darkRed,
                      );
                    }
                    return;
                  }
                  print('VAT: ${profileData?.data.fileIdNumber}');
                  if ((profileData?.data.isCompany == 0 &&
                              profileData?.data.fileIdNumber == null ||
                          profileData?.data.fileIdNumber == '' ||
                          profileData?.data.residentCardNumber == null) ||
                      (profileData?.data.isCompany == 1 &&
                          (profileData?.data.fileCrNumber == null ||
                              profileData?.data.fileCrNumber == '' ||
                              profileData?.data.crNumber == null))) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Profile Update Required'.tr),
                          content: Text(
                            'Please update your profile to enroll.'.tr,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                NavigationHelper.navigateTo(
                                  context,
                                  RegistrationScreen(
                                    checkPageID: 1,
                                    token: widget.token,
                                  ), // Replace with your profile edit screen widget
                                );
                              },
                              child: Text('Edit Profile'.tr),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel'.tr),
                            ),
                          ],
                        );
                      },
                    );
                    return;
                  } else {
                    NavigationHelper.navigateTo(
                      context,
                      RegistrationForBidders(
                        auctionNumber: auctionData['auction_number'],
                        auctionName:
                            languageController.selectedLanguage.value == 1
                            ? auctionData['title_ar'].toString()
                            : auctionData['title'].toString(),
                        filePaymentterms: auctionData['file_payment_terms'],
                        auctionID: widget.auctionId,
                        guranteeAmount: auctionData['payment_amount'],
                        groupid: auctionData['group_info'] != null
                            ? (auctionData['group_info']['id']).toString()
                            : null,
                        paymentTypes: [
                          auctionData['group_info']?['can_online'] ?? true,
                          auctionData['group_info']?['can_wallet'] ?? true,
                          auctionData['group_info']?['can_offline'] ?? true,
                        ],
                      ),
                    );
                  }
                },
                child: Center(child: Text('Enroll Now'.tr, style: whiteStyle)),
              ),
            ),
          ),
        width10,

        //* Bidnow button------------------------------------------------------------------------------------
        Expanded(
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: darkBlue,
              borderRadius: BorderRadius.circular(6),
              // border: Border.all(color: darkBlue, width: 0.8),
              gradient: LinearGradient(colors: AppStyle.orangeGradient),
            ),
            child: InkWell(
              onTap: () async {
                if (tokenCheckingState.token.value.isEmpty) {
                  diologueBoxLogin('Login required for bid'.tr);
                  return;
                }
                //

                // if (isActive) {
                //   if (useridphoneverifiedAt == null) {
                //     diologueBox();
                //     return;
                //   }
                // }

                //* request ----------------------------------------------------

                await userValidityCheckApi.checkUserValidity(auctionData['id']);

                //
                final now = DateTime.now();
                if (userValidityCheckApi.enrollstatus.value != 'A' &&
                    now.isBefore(auctionStart)) {
                  if (profileData?.data.fileIdNumber == null ||
                      profileData?.data.fileIdNumber == "" ||
                      profileData?.data.accountNumber == null ||
                      profileData?.data.accountNumber == "") {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Profile Update Required'.tr),
                          content: Text(
                            'Please update your profile to enroll.'.tr,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                NavigationHelper.navigateTo(
                                  context,
                                  RegistrationScreen(
                                    checkPageID: 1,
                                    token: widget.token,
                                  ), // Replace with your profile edit screen widget
                                );
                              },
                              child: Text('Edit Profile'.tr),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel'.tr),
                            ),
                          ],
                        );
                      },
                    );
                    return;
                  }
                  Get.to(
                    () => RegistrationForBidders(
                      auctionNumber: auctionData['auction_number'],
                      auctionName:
                          languageController.selectedLanguage.value == 1
                          ? auctionData['title_ar'].toString()
                          : auctionData['title'].toString(),
                      filePaymentterms: auctionData['file_payment_terms'],
                      auctionID: widget.auctionId,
                      guranteeAmount: auctionData['payment_amount'],
                      paymentTypes: [
                        auctionData['group_info']?['can_online'] ?? true,
                        auctionData['group_info']?['can_wallet'] ?? true,
                        auctionData['group_info']?['can_offline'] ?? true,
                      ],
                    ),
                  );
                  if (context.mounted) {
                    SnackbarHelperTop.showSnackBar(
                      context,
                      'You are not enrolled, please enroll to bid'.tr,
                      color: black,
                    );
                  }
                  return;
                }

                // if (userValidityCheckApi.valid.value == false &&
                //     userValidityCheckApi.enrollstatus.value == 'A') {
                //   if (context.mounted) {
                //     SnackbarHelperTop.showSnackBar(
                //         context,
                //         'You are not verified, please wait for approval to bid'
                //             .tr,
                //         color: darkRed);
                //   }
                //   return;
                // }
                //
                if (isActive
                //userValidityCheckApi.enrollstatus.value == 'A'
                ) {
                  showModalBottomSheet(
                    // showDragHandle: true,
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return FractionallySizedBox(
                        heightFactor: 0.9,
                        child: EnrollLiveBiddingScreen(
                          filePaymentterms: auctionData['file_payment_terms'],
                          guranteeAmount: auctionData['payment_amount'] ?? "0,",
                          auctionNumber: auctionData['auction_number'],
                          isEnrolled: auctionData['is_enrolled'],
                          auctionStart: auctionStart,
                          auctionEndTime: auctionEnd,
                          auctionID: auctionData['id'],
                          incrementNumbers: auctionData['increment_numbers'],
                          auctionName:
                              languageController.selectedLanguage.value == 1
                              ? auctionData['title_ar']
                              : auctionData['title'].toString(),
                          startingPrice: auctionData['start_amount'].toString(),
                          countdown:
                              "${auctionData['end_date_ar']['date']} ${auctionData['end_date_ar']['time']}",
                        ),
                      );
                    },
                  ).then((val) {
                    print("this is value : $val");
                    ref.invalidate(
                      auctionAllDetailsResponseProvider(widget.auctionId),
                    );
                  });
                }
              },
              child: Center(child: Text('Bid Now'.tr, style: whiteStyle)),
            ),
          ),
        ),
      ],
    );
  }

  // Future<dynamic> bidNowBottomSheetLive(
  //   BuildContext context,
  //   auctionData,
  //   DateTime auctionEnd,
  //   DateTime auctionStart,
  // ) {
  //   return showModalBottomSheet(
  //     showDragHandle: true,
  //     scrollControlDisabledMaxHeightRatio: 225,
  //     context: context,
  //     builder: (context) {
  //       return EnrollLiveBiddingScreen(
  //         filePaymentterms: auctionData['file_payment_terms'],
  //         guranteeAmount: auctionData['guarantee_amount'],
  //         auctionNumber: auctionData['auction_number'],
  //         isEnrolled: auctionData['is_enrolled'],
  //         auctionStart: auctionStart,
  //         auctionEndTime: auctionEnd,
  //         auctionID: auctionData['id'],
  //         incrementNumbers: auctionData['increment_numbers'],
  //         auctionName: languageController.selectedLanguage.value == 1
  //             ? auctionData['title_ar']
  //             : auctionData['title'].toString(),
  //         startingPrice: auctionData['start_amount'].toString(),
  //         countdown:
  //             "${auctionData['end_date_ar']['date']} ${auctionData['end_date_ar']['time']}",
  //       );
  //     },
  //   );
  // }
}
