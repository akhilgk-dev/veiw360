import 'package:json_annotation/json_annotation.dart';

part 'locations_model.g.dart';

@JsonSerializable()
class LocationResponse {
  @JsonKey(name: 'success')
  bool success;

  @JsonKey(name: 'data')
  List<Location> data;

  LocationResponse({required this.success, required this.data});

  factory LocationResponse.fromJson(Map<String, dynamic> json) =>
      _$LocationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LocationResponseToJson(this);
}

@JsonSerializable()
class Location {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'name_ar')
  String nameAr;

  @JsonKey(name: 'latitude')
  String latitude;

  @JsonKey(name: 'longitude')
  String longitude;

  @JsonKey(name: 'department')
  int department;

  @JsonKey(name: 'department_info')
  DepartmentInfo departmentInfo;

  @JsonKey(name: 'created_at')
  String createdAt;

  @JsonKey(name: 'updated_at')
  String updatedAt;

  @JsonKey(name: 'can_delete')
  bool canDelete;

  Location({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.latitude,
    required this.longitude,
    required this.department,
    required this.departmentInfo,
    required this.createdAt,
    required this.updatedAt,
    required this.canDelete,
  });

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}

@JsonSerializable()
class DepartmentInfo {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'name_ar')
  String nameAr;

  @JsonKey(name: 'region')
  String region;

  @JsonKey(name: 'region_ar')
  String regionAr;

  @JsonKey(name: 'deleted')
  int deleted;

  @JsonKey(name: 'created_at')
  String createdAt;

  @JsonKey(name: 'updated_at')
  String updatedAt;

  DepartmentInfo({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.region,
    required this.regionAr,
    required this.deleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DepartmentInfo.fromJson(Map<String, dynamic> json) =>
      _$DepartmentInfoFromJson(json);

  Map<String, dynamic> toJson() => _$DepartmentInfoToJson(this);
}
