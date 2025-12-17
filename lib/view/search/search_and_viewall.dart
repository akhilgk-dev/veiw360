import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:view360/api/search_all/search_all_auction_api.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/common/theme/colors.dart';
import 'package:view360/common/theme/sized_box.dart';
import 'package:view360/language/language_controller.dart';
import 'package:view360/view/home/widgets/categorie_list_auctions/categerie_widget.dart';
import 'package:view360/view/search/filter_drawer.dart';
import 'package:view360/view/search/grid_view_all.dart';
import 'package:view360/view/search/view_all_widget.dart';
import 'package:view360/view/widgets/empty_message/empty_message_widget.dart';
import 'package:view360/view/widgets/skeletonizer/list_homepage_skeleton.dart';

final searchAllProvider = StateProvider<String>((ref) => "");
final searchCategoryProvider = StateProvider<int>((ref) => 0);

class SearchViewAll extends ConsumerStatefulWidget {
  const SearchViewAll({
    super.key,
    this.isSearch = true,
    this.selectedCategoryId,
  });
  final bool isSearch;
  final int? selectedCategoryId;
  @override
  ConsumerState<SearchViewAll> createState() => _SearchViewAllState();
}

class _SearchViewAllState extends ConsumerState<SearchViewAll> {
  final TextEditingController searchController = TextEditingController();
  final LanguageController languageController = Get.find();
  Timer? _debounce;

  // Add a state variable to track the current view mode
  bool isGridView = false;

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      ref.read(searchAllProvider.notifier).state = value;
    });
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final padding = 10.0;
    final screenWidth = MediaQuery.of(context).size.width;

    final AsyncValue<dynamic> activity = ref.watch(searchAllResponseProvider);
    bool isRtl = languageController.selectedLanguage.value == 1;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color.fromARGB(255, 248, 251, 251),
      endDrawer: FilterDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: AppStyle.secondary.withAlpha(15),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 2), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    widget.isSearch
                        ? GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child:
                                Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.black,
                                  size: 20,
                                ).paddingOnly(
                                  left: isRtl ? 0 : padding,
                                  right: isRtl ? padding : 0,
                                ),
                          )
                        : SizedBox(width: 2, height: 2),
                    Expanded(
                      flex: 5,
                      child: TextFormField(
                        controller: searchController,
                        onChanged: (value) {
                          _onSearchChanged(value);
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
                              left: Radius.circular(isRtl ? 20 : 20),
                              right: Radius.circular(isRtl ? 20 : 20),
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
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: InkWell(
                        onTap: () {
                          scaffoldKey.currentState?.openEndDrawer();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: SvgPicture.asset(
                            'assets/images/filter_icon.svg',
                            colorFilter: ColorFilter.mode(
                              AppStyle.primary,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              CategoriesWidget(selectedCategoryId: widget.selectedCategoryId),
              height05,
              ref
                  .watch(searchAllResponseProvider)
                  .when(
                    loading: () => ListWidgetSkeleton(),
                    error: (error, stackTrace) => Padding(
                      padding: const EdgeInsets.all(17.0),
                      child: Center(
                        child: EmptyMessageWidget(
                          message: "No Auctions Available right now".tr,
                        ),
                      ),
                    ),
                    data: (auctionResponse) {
                      return Expanded(
                        child: isGridView
                            ? GridViewAllWidget(
                                auctionResponse: auctionResponse,
                                ref: ref,
                              )
                            : ViewAllWidget(
                                auctionResponse: auctionResponse,
                                ref: ref,
                              ),
                      );
                    },
                  ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
        decoration: BoxDecoration(
          color: AppStyle.liteRed,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppStyle.bidButtonGradient,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isGridView ? Colors.white38 : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
              ),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    isGridView = true; // Switch to grid view
                  });
                },
                icon: Icon(
                  Icons.grid_view,
                  color: isGridView
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.5),
                  size: isGridView ? 24 : 20,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: isGridView ? Colors.transparent : Colors.white38,
                borderRadius: BorderRadius.circular(14),
              ),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    isGridView = false; // Switch to list view
                  });
                },
                icon: Icon(
                  Icons.list,
                  color: !isGridView
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.5),
                  size: !isGridView ? 26 : 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
