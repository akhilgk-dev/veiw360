import 'package:json_annotation/json_annotation.dart';

part 'vehicle_model_info.g.dart';

@JsonSerializable()
class VehicleInfoModel {
  final int? id;
  final int? auction;

  @JsonKey(name: 'vehicle_category')
  final int? vehicleCategory;

  @JsonKey(name: 'vehicle_number')
  final String? vehicleNumber;

  final dynamic make;
  final String? model;

  @JsonKey(name: 'model_ar')
  final String? modelAr;

  final String? mileage;

  @JsonKey(name: 'mileage_ar')
  final String? mileageAr;

  @JsonKey(name: 'information_number')
  final dynamic informationNumber;

  @JsonKey(name: 'transmission_type')
  final dynamic transmissionType;

  @JsonKey(name: 'transmission_type_ar')
  final dynamic transmissionTypeAr;

  final dynamic extras;

  @JsonKey(name: 'body_type')
  final dynamic bodyType;

  @JsonKey(name: 'body_type_ar')
  final dynamic bodyTypeAr;

  @JsonKey(name: 'fuel_type')
  final dynamic fuelType;

  @JsonKey(name: 'fuel_type_ar')
  final dynamic fuelTypeAr;

  final dynamic warranty;

  final dynamic color;

  @JsonKey(name: 'color_ar')
  final dynamic colorAr;

  @JsonKey(name: 'engine_size')
  final dynamic engineSize;

  @JsonKey(name: 'no_of_keys')
  final dynamic noOfKeys;

  @JsonKey(name: 'document_type')
  final dynamic documentType;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  VehicleInfoModel({
    this.id,
    this.auction,
    this.vehicleCategory,
    this.vehicleNumber,
    this.make,
    this.model,
    this.modelAr,
    this.mileage,
    this.mileageAr,
    this.informationNumber,
    this.transmissionType,
    this.transmissionTypeAr,
    this.extras,
    this.bodyType,
    this.bodyTypeAr,
    this.fuelType,
    this.fuelTypeAr,
    this.warranty,
    this.color,
    this.colorAr,
    this.engineSize,
    this.noOfKeys,
    this.documentType,
    this.createdAt,
    this.updatedAt,
  });

  factory VehicleInfoModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleInfoModelToJson(this);
}
