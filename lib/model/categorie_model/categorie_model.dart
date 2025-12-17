import 'package:json_annotation/json_annotation.dart';

part 'categorie_model.g.dart'; // This line is important!

@JsonSerializable()
class CategoryModel {
  @JsonKey(name: 'success')
  bool success;

  @JsonKey(name: 'data')
  List<CategoryData> data;

  CategoryModel({required this.success, required this.data});

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}

@JsonSerializable()
class CategoryData {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'category_name')
  String categoryName;

  @JsonKey(name: 'category_name_ar')
  String categoryNameAr;

  // @JsonKey(name: 'description')
  // String? description;

  // @JsonKey(name: 'description_ar')
  // String? descriptionAr;

  @JsonKey(name: 'file_category_image')
  String fileCategoryImage;

  @JsonKey(name: 'total_auctions')
  int totalActiveAuctions;

  // @JsonKey(name: 'icon')
  // String? icon;

  // @JsonKey(name: 'is_multiple')
  // dynamic isMultiple;

  // @JsonKey(name: 'is_number')
  // int isNumber;

  // @JsonKey(name: 'is_vehicle')
  // dynamic isVehicle;

  // @JsonKey(name: 'total_auctions')
  // int totalAuctions;

  // @JsonKey(name: 'created_at')
  // String createdAt;

  // @JsonKey(name: 'updated_at')
  // String updatedAt;

  CategoryData({
    required this.id,
    required this.categoryName,
    required this.categoryNameAr,
    // this.description,
    // this.descriptionAr,
    required this.fileCategoryImage,
    required this.totalActiveAuctions,
    // this.icon,
    // this.isMultiple,
    // required this.isNumber,
    // this.isVehicle,
    // required this.totalAuctions,
    // required this.createdAt,
    // required this.updatedAt,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) =>
      _$CategoryDataFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryDataToJson(this);
}
