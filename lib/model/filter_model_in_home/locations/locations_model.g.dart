// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locations_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationResponse _$LocationResponseFromJson(Map<String, dynamic> json) =>
    LocationResponse(
      success: json['success'] as bool,
      data: (json['data'] as List<dynamic>)
          .map((e) => Location.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LocationResponseToJson(LocationResponse instance) =>
    <String, dynamic>{'success': instance.success, 'data': instance.data};

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  nameAr: json['name_ar'] as String,
  latitude: json['latitude'] as String,
  longitude: json['longitude'] as String,
  department: (json['department'] as num).toInt(),
  departmentInfo: DepartmentInfo.fromJson(
    json['department_info'] as Map<String, dynamic>,
  ),
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
  canDelete: json['can_delete'] as bool,
);

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'name_ar': instance.nameAr,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'department': instance.department,
  'department_info': instance.departmentInfo,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
  'can_delete': instance.canDelete,
};

DepartmentInfo _$DepartmentInfoFromJson(Map<String, dynamic> json) =>
    DepartmentInfo(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      nameAr: json['name_ar'] as String,
      region: json['region'] as String,
      regionAr: json['region_ar'] as String,
      deleted: (json['deleted'] as num).toInt(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$DepartmentInfoToJson(DepartmentInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'name_ar': instance.nameAr,
      'region': instance.region,
      'region_ar': instance.regionAr,
      'deleted': instance.deleted,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
