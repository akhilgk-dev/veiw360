// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'police_station_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PoliceStationResponse _$PoliceStationResponseFromJson(
  Map<String, dynamic> json,
) => PoliceStationResponse(
  success: json['success'] as bool,
  data: (json['data'] as List<dynamic>)
      .map((e) => PoliceStation.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PoliceStationResponseToJson(
  PoliceStationResponse instance,
) => <String, dynamic>{'success': instance.success, 'data': instance.data};

PoliceStation _$PoliceStationFromJson(Map<String, dynamic> json) =>
    PoliceStation(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      nameAr: json['name_ar'] as String,
      region: json['region'] as String,
      regionAr: json['region_ar'] as String,
      deleted: (json['deleted'] as num).toInt(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      canDelete: json['can_delete'] as bool,
    );

Map<String, dynamic> _$PoliceStationToJson(PoliceStation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'name_ar': instance.nameAr,
      'region': instance.region,
      'region_ar': instance.regionAr,
      'deleted': instance.deleted,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'can_delete': instance.canDelete,
    };
