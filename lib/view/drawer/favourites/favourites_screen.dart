import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:view360/api/auction_details_api/auction_details_all_api.dart';
import 'package:view360/api/favourite_auctions.dart/favourite_auction_api.dart';
import 'package:view360/common/text/text_static.dart';
import 'package:view360/common/theme/colors.dart';
import 'package:view360/common/theme/sized_box.dart';
import 'package:view360/common/theme/style.dart';
import 'package:view360/common/utils/helpers/snackbar.dart';
import 'package:view360/language/language_controller.dart';
import 'package:view360/view/auction_details/auction_details_page.dart';
import 'package:view360/view/home/controller/favourite_notifier.dart';
import 'package:view360/view/widgets/appbar_widget/appbar_widget.dart';
import 'package:view360/view/widgets/empty_message/empty_message_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../api/favourite_auctions.dart/toggle_like.dart';
import '../../enrollment_payment_screen/registration_for_bidders.dart';
import '../../home/controller/count_down.dart';
import 'dart:async';

class FavouritesScreen extends ConsumerStatefulWidget {
  const FavouritesScreen({super.key});

  @override
  _FavouritesScreenState createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends ConsumerState<FavouritesScreen> {
  final ToggleLikeGetX toggleLikeGetX = Get.put(ToggleLikeGetX());

  @override
  void dispose() {
    Get.delete<ToggleLikeGetX>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(title: 'Favourite Auctions'.tr),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Consumer(
          builder: (context, ref, _) {
            final data = ref.watch(favouriteAuctionResponseProvider);
            return data.when(
              data: (responseData) => _buildContent(context, ref, responseData),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(noInternetImage),
                    Lottie.asset(
                      'assets/json/no_data.json',
                      width: 100,
                      height: 200,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    dynamic responseData,
  ) {
    final auctions = responseData['data'] as List<dynamic>? ?? [];

    if (auctions.isEmpty) {
      return Center(
        child: EmptyMessageWidget(message: 'No favourite auctions found'.tr),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: auctions.length,
      itemBuilder: (context, index) => AuctionCard(
        key: ValueKey(auctions[index]['id']),
        auction: auctions[index],
        index: index,
        toggleLikeGetX: toggleLikeGetX,
      ),
    );
  }
}

class AuctionCard extends StatefulWidget {
  final dynamic auction;
  final int index;
  final ToggleLikeGetX toggleLikeGetX;

  const AuctionCard({
    required this.auction,
    required this.index,
    required this.toggleLikeGetX,
    super.key,
  });

  @override
  State<AuctionCard> createState() => _AuctionCardState();
}

class _AuctionCardState extends State<AuctionCard> {
  late bool isLiked;
  bool isLoading = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    isLiked = widget.auction['auction_liked'] == true;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _toggleFavorite(WidgetRef ref) {
    if (isLoading) return;

    setState(() {
      isLiked = !isLiked;
      isLoading = true;
    });

    // Debounce the network call
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      try {
        widget.toggleLikeGetX.toggleLike(
          widget.auction['id'],
          isLiked ? '1' : '',
        );
        ref.read(favoritesProvider.notifier).toggleFavorite(widget.index);
        // Only refresh provider if still mounted
        ref.invalidate(favouriteAuctionResponseProvider);
      } catch (e) {
        if (mounted) {
          setState(() {
            isLiked = !isLiked;
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) {
          setState(() => isLoading = false);
        }
      }
    });
  }

  final LanguageController languageController = Get.find();

  @override
  Widget build(BuildContext context) {
    bool isArabic = languageController.selectedLanguage.value == 1;

    return Consumer(
      builder: (context, ref, _) {
        // final countdown = ref.watch(countdownProvider(
        //   DateFormat("dd/MM/yyyy hh:mm:ss a").parse(
        //     "${widget.auction['reg_end_date_ar']['date']} ${widget.auction['reg_end_date_ar']['time']}",
        //   ),
        // ));

        final regStart = DateFormat("dd/MM/yyyy hh:mm:ss a").parse(
          "${widget.auction['reg_start_date_ar']['date']} ${widget.auction['reg_start_date_ar']['time']}",
        );

        final regEnd = DateFormat("dd/MM/yyyy hh:mm:ss a").parse(
          "${widget.auction['reg_end_date_ar']['date']} ${widget.auction['reg_end_date_ar']['time']}",
        );

        final auctionStart = DateFormat("dd/MM/yyyy hh:mm:ss a").parse(
          "${widget.auction['start_date_ar']['date']} ${widget.auction['start_date_ar']['time']}",
        );

        final auctionEnd = DateFormat("dd/MM/yyyy hh:mm:ss a").parse(
          "${widget.auction['end_date_ar']['date']} ${widget.auction['end_date_ar']['time']}",
        );

        final countdown = ref.watch(
          countdownProvider((regStart, regEnd, auctionStart, auctionEnd)),
        );

        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageSection(context, ref),
                width10,
                Expanded(
                  child: _buildDetailsSection(
                    context,
                    ref,
                    countdown,
                    isArabic,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageSection(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(8),
            child: CachedNetworkImage(
              imageUrl: widget.auction['images'][0]['image'] ?? '',
              height: 150,
              width: 250,
              fit: BoxFit.cover,
              placeholder: (_, __) =>
                  Skeletonizer(child: const SizedBox(width: 120, height: 120)),
              errorWidget: (_, __, ___) => const Icon(Icons.error),
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: _buildFavoriteButton(context, ref),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteButton(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => _toggleFavorite(ref),
      child: CircleAvatar(
        radius: 14,
        backgroundColor: white,
        child: isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                size: 16,
                color: isLiked ? Colors.red : Colors.grey,
              ),
      ),
    );
  }

  Widget _buildDetailsSection(
    BuildContext context,
    WidgetRef ref,
    String countdown,
    bool isArabic,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic
              ? widget.auction['title_ar']
              : widget.auction['title'] ?? 'No Title'.tr,
          style: smallFontSize12.copyWith(
            fontWeight: FontWeight.bold,
            color: darkBlue,
          ),
        ),
        height05,
        Text(
          '№ ${widget.auction['auction_number'] ?? 'N/A'} • ${widget.auction['current_amount']} OMR',
          style: smallFontSize12.copyWith(
            fontWeight: FontWeight.bold,
            color: darkBlue,
          ),
        ),
        height05,
        Row(
          children: [
            const Icon(Icons.timer, size: 14),
            width05,
            Text(
              countdown.tr,
              style: smallFontSize12.copyWith(
                fontWeight: FontWeight.bold,
                color: widget.auction['status_label']['status'] == 'A'
                    ? Colors.green
                    : Colors.red,
              ),
            ),
          ],
        ),
        height05,
        Text(
          '${'Guarantee amount:'.tr} ${widget.auction['guarantee_amount'] ?? 'N/A'}',
          style: smallFontSize12.copyWith(fontWeight: FontWeight.bold),
        ),
        // Text('${'Visit/Amt:'.tr} ${widget.auction['visit_amount'] ?? 'N/A'}',
        //     style: smallFontSize12.copyWith(fontWeight: FontWeight.bold)),
        _buildActionButtons(context, ref, isArabic),
      ],
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    WidgetRef ref,
    bool isArabic,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildEnrollButton(context, ref, isArabic),
        width05,
        _buildDetailsButton(context, ref),
      ],
    );
  }

  Widget _buildEnrollButton(
    BuildContext context,
    WidgetRef ref,
    bool isArabic,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: yelloAccent,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        minimumSize: const Size(0, 30),
      ),
      onPressed: () => _handleEnroll(context, ref, isArabic),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.menu, size: 16, color: white),
          width05,
          Text('Enroll'.tr, style: TextStyle(color: white)),
        ],
      ),
    );
  }

  Widget _buildDetailsButton(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        backgroundColor: darkBlue,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        minimumSize: const Size(0, 30),
      ),
      onPressed: () => _handleDetails(context, ref),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.info, size: 16, color: white),
          width05,
          Text(
            widget.auction['is_a_group'] == true
                ? 'List Auctions'.tr
                : 'View Details'.tr,
            style: const TextStyle(color: white),
          ),
        ],
      ),
    );
  }

  Future<void> _handleEnroll(
    BuildContext context,
    WidgetRef ref,
    bool isArabic,
  ) async {
    //final profileData = ref.watch(auctionResponseProviderProfile);
    //final userData = profileData.asData?.value.data;

    // if (userData?.emailVerifiedAt == null ||
    //     userData?.mobileVerifiedAt == null) {
    //   diologueBox();
    //   return;
    // }

    if (widget.auction['is_enrolled'] == true) {
      if (context.mounted) {
        SnackbarHelperTop.showSnackBar(
          context,
          alreadyEnrolledMessage.tr,
          color: darkBlue,
        );
      }
      return;
    }

    if (widget.auction['status_label']['status'] == 'A') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RegistrationForBidders(
            auctionNumber: widget.auction['auction_number'] ?? 'N/A',
            auctionName: isArabic
                ? widget.auction['title_ar']
                : widget.auction['title'] ?? 'N/A',
            filePaymentterms: widget.auction['file_payment_terms'],
            auctionID: widget.auction['id'],
            guranteeAmount: widget.auction['payment_amount'] ?? 0,
            paymentTypes: [
              widget.auction['group_info']?['can_online'] ?? true,
              widget.auction['group_info']?['can_wallet'] ?? true,
              widget.auction['group_info']?['can_offline'] ?? true,
            ],
          ),
        ),
      );
    } else {
      SnackbarHelper.showSnackBar(
        context,
        widget.auction['status_label']['status'] == 'E'
            ? 'Auction is completed'.tr
            : 'Registration closed'.tr,
        color: Colors.red,
      );
    }
  }

  Future<void> _handleDetails(BuildContext context, WidgetRef ref) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    ref.invalidate(auctionAllDetailsResponseProvider(widget.auction['id']));

    Get.to(
      () => AuctionDetailsPage(
        index: widget.index,
        token: token,
        auctionId: widget.auction['id'],
        imageUrl: widget.auction['images'] ?? [],
        mainImage: widget.auction['main_image']?.toString() ?? 'N/A',
      ),
    );
  }
}
