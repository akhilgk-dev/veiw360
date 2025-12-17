// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categorie_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    CategoryModel(
      success: json['success'] as bool,
      data: (json['data'] as List<dynamic>)
          .map((e) => CategoryData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CategoryModelToJson(CategoryModel instance) =>
    <String, dynamic>{'success': instance.success, 'data': instance.data};

CategoryData _$CategoryDataFromJson(Map<String, dynamic> json) => CategoryData(
  id: (json['id'] as num).toInt(),
  categoryName: json['category_name'] as String,
  categoryNameAr: json['category_name_ar'] as String,
  fileCategoryImage: json['file_category_image'] as String,
  totalActiveAuctions: (json['total_auctions'] as num).toInt(),
);

Map<String, dynamic> _$CategoryDataToJson(CategoryData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category_name': instance.categoryName,
      'category_name_ar': instance.categoryNameAr,
      'file_category_image': instance.fileCategoryImage,
      'total_auctions': instance.totalActiveAuctions,
    };
