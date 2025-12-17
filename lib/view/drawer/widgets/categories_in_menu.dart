import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:view360/api/filter_home_api.dart/categorie_api.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/language/language_controller.dart';
import 'package:view360/view/search/search_and_viewall.dart';

class CategoriesInMenu extends ConsumerWidget {
  CategoriesInMenu({super.key});
  final LanguageController languageController = Get.find();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryState = ref.watch(auctionResponseCategory);
    final selectedLanguage = languageController.selectedLanguage.value;

    return categoryState.when(
      data: (data) => Column(
        children: [
          for (int i = 0; i < data.data.length; i++)
            ListTile(
              leading: SizedBox(
                height: 20,
                width: 40,
                child: CachedNetworkImage(
                  imageUrl: data.data[i].fileCategoryImage,
                  color: AppStyle.black,
                ),
              ),
              title: Text(
                selectedLanguage == 1
                    ? data.data[i].categoryNameAr
                    : data.data[i].categoryName,
                style: TextStyle(
                  fontSize: 14,
                  color: AppStyle.darkGolden,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  color: AppStyle.black,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  data.data[i].totalActiveAuctions.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SearchViewAll(selectedCategoryId: data.data[i].id),
                  ),
                );
              },
            ),
        ],
      ),

      error: (err, s) => Center(child: Text('Error: $err')),
      loading: () =>
          Center(child: SizedBox(width: 200, child: LinearProgressIndicator())),
    );
  }

  final List<String> drawerText = ['Cars'.tr, 'Mobiles'.tr, 'Real Estate'.tr];
}
