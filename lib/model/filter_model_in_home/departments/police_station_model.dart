import 'package:json_annotation/json_annotation.dart';

part 'police_station_model.g.dart';

@JsonSerializable()
class PoliceStationResponse {
  @JsonKey(name: 'success')
  bool success;

  @JsonKey(name: 'data')
  List<PoliceStation> data;

  PoliceStationResponse({required this.success, required this.data});

  factory PoliceStationResponse.fromJson(Map<String, dynamic> json) =>
      _$PoliceStationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PoliceStationResponseToJson(this);
}

@JsonSerializable()
class PoliceStation {
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

  @JsonKey(name: 'can_delete')
  bool canDelete;

  PoliceStation({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.region,
    required this.regionAr,
    required this.deleted,
    required this.createdAt,
    required this.updatedAt,
    required this.canDelete,
  });

  factory PoliceStation.fromJson(Map<String, dynamic> json) =>
      _$PoliceStationFromJson(json);

  Map<String, dynamic> toJson() => _$PoliceStationToJson(this);
}
