import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:view360/api/all_auctions_list/all_auction_list_api.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/common/theme/sized_box.dart';
import 'package:view360/language/language_controller.dart';
import 'package:view360/model/categorie_model/categorie_model.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:view360/api/filter_home_api.dart/categorie_api.dart';
import 'package:view360/common/theme/style.dart';

import '../../../../common/theme/colors.dart';

final selectedCategoryProvider = StateProvider<int?>((ref) => null);

class CategoriesWidget extends ConsumerStatefulWidget {
  CategoriesWidget({super.key, this.isDrawer = false, this.selectedCategoryId});
  bool isDrawer;
  int? selectedCategoryId;
  @override
  ConsumerState<CategoriesWidget> createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends ConsumerState<CategoriesWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(auctionResponseCategory);
      if (widget.selectedCategoryId != null) {
        ref.read(selectedCategoryProvider.notifier).state =
            widget.selectedCategoryId;
      }
    });
  }

  final LanguageController languageController = Get.find();

  @override
  Widget build(BuildContext context) {
    final selectedLanguage = languageController.selectedLanguage.value;
    final categoryState = ref.watch(auctionResponseCategory);
    final selectedCategoryId = ref.watch(
      selectedCategoryProvider,
    ); // <-- watch provider

    bool isLtr = selectedLanguage == 0 ? true : false;

    return categoryState.when(
      data: (categories) {
        List<CategoryData> reorderedCategories = List<CategoryData>.from(
          categories.data,
        );

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 241, 250, 250),
                Color.fromARGB(255, 247, 252, 252),
              ],
            ),
          ),
          child: widget.isDrawer
              ? GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemCount: reorderedCategories.length,
                  itemBuilder: (context, index) {
                    final category =
                        reorderedCategories[index % reorderedCategories.length];
                    final isSelected = selectedCategoryId == category.id;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4.0,
                        vertical: 3,
                      ),
                      child: InkWell(
                        onTap: () {
                          ref.invalidate(auctionResponseAllAuctions);

                          if (selectedCategoryId == category.id) {
                            ref.read(selectedCategoryProvider.notifier).state =
                                null;
                          } else {
                            ref.read(selectedCategoryProvider.notifier).state =
                                category.id;
                          }
                          widget.isDrawer ? Navigator.of(context).pop() : null;
                        },
                        child: categorie(
                          category,
                          selectedLanguage,
                          isLtr,
                          isSelected,
                          index,
                        ),
                      ),
                    );
                  },
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(reorderedCategories.length, (
                      index,
                    ) {
                      final category = reorderedCategories[index];
                      final isSelected = selectedCategoryId == category.id;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4.0,
                          vertical: 3,
                        ),
                        child: InkWell(
                          onTap: () {
                            widget.isDrawer
                                ? Navigator.of(context).pop()
                                : null;
                            ref.invalidate(auctionResponseAllAuctions);
                            print(selectedCategoryId);
                            if (selectedCategoryId == category.id) {
                              ref
                                      .read(selectedCategoryProvider.notifier)
                                      .state =
                                  null;
                            } else {
                              widget.isDrawer
                                  ? Navigator.of(context).pop()
                                  : null;
                              ref
                                      .read(selectedCategoryProvider.notifier)
                                      .state =
                                  category.id;
                            }

                            // Get.to(
                            //   () => FilteredResultScreen(
                            //     categoryID: category.id,
                            //     pageFrom: languageController.selectedLanguage.value == 0
                            //         ? categories.data[index].categoryName
                            //         : categories.data[index].categoryNameAr,
                            //   ),
                            // );
                            // Get.to(() => CategorySortList(
                            //       categoryName: selectedLanguage == 0
                            //           ? category.categoryName
                            //           : category.categoryNameAr,
                            //       categoryId: category.id,
                            //     ));
                          },
                          child: categorie(
                            category,
                            selectedLanguage,
                            isLtr,
                            isSelected,
                            index,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
        );
      },
      loading: () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            5,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 3),
              child: Skeletonizer(
                enableSwitchAnimation: true,
                enabled: true,
                child: categorie(
                  CategoryData(
                    totalActiveAuctions: 0,
                    fileCategoryImage: 'categoryState.value!\naaaaaaaa',
                    id: 1,
                    categoryName: "categoryName",
                    categoryNameAr: "categoryNameAr",
                  ),
                  selectedLanguage,
                  isLtr,
                  false,
                  index,
                ),
              ),
            ),
          ),
        ),
      ),
      error: (err, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: darkBlue),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('No internet connection, please try again.'),
            ),
          ),
        ),
      ),
    );
  }

  //
  Widget categorie(
    CategoryData category,
    int selectedLanguage,
    bool isLtr,
    bool isSelected,
    int index,
  ) {
    return Stack(
      alignment: isLtr ? Alignment.topRight : Alignment.topLeft,
      children: [
        Container(
          height: 70,
          width: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: AppStyle.white,
            border: Border.all(
              color: isSelected ? AppStyle.primary : Colors.grey,
              width: isSelected ? 2.5 : 0.1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppStyle.secondary.withAlpha(20),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                height05,
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: AppStyle.white,
                    ),
                    child: CachedNetworkImage(
                      errorWidget: (context, url, error) =>
                          Center(child: Icon(Icons.error)),
                      imageUrl: category.fileCategoryImage,

                      width: 40,
                      placeholder: (context, url) => Center(child: SizedBox()),
                      // fit: BoxFit.cover,
                      color: AppStyle.primary,
                    ),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: selectedLanguage == 0
                        ? category.categoryName
                        : category.categoryNameAr,
                    style: whiteStyle.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: black,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        // Container(
        //   height: 20,
        //   width: 50,
        //   decoration: BoxDecoration(
        //     color: AppStyle.primary,
        //     borderRadius: BorderRadius.circular(5),
        //     border: Border.all(color: AppStyle.white, width: 1.5),
        //   ),
        //   child: Center(
        //     child: Text(
        //       category.totalActiveAuctions.toString(),
        //       style: whiteStyle.copyWith(
        //         fontSize: 10,
        //         fontWeight: FontWeight.w600,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
