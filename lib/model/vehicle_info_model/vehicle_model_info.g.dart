// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_model_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleInfoModel _$VehicleInfoModelFromJson(Map<String, dynamic> json) =>
    VehicleInfoModel(
      id: (json['id'] as num?)?.toInt(),
      auction: (json['auction'] as num?)?.toInt(),
      vehicleCategory: (json['vehicle_category'] as num?)?.toInt(),
      vehicleNumber: json['vehicle_number'] as String?,
      make: json['make'],
      model: json['model'] as String?,
      modelAr: json['model_ar'] as String?,
      mileage: json['mileage'] as String?,
      mileageAr: json['mileage_ar'] as String?,
      informationNumber: json['information_number'],
      transmissionType: json['transmission_type'],
      transmissionTypeAr: json['transmission_type_ar'],
      extras: json['extras'],
      bodyType: json['body_type'],
      bodyTypeAr: json['body_type_ar'],
      fuelType: json['fuel_type'],
      fuelTypeAr: json['fuel_type_ar'],
      warranty: json['warranty'],
      color: json['color'],
      colorAr: json['color_ar'],
      engineSize: json['engine_size'],
      noOfKeys: json['no_of_keys'],
      documentType: json['document_type'],
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$VehicleInfoModelToJson(VehicleInfoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'auction': instance.auction,
      'vehicle_category': instance.vehicleCategory,
      'vehicle_number': instance.vehicleNumber,
      'make': instance.make,
      'model': instance.model,
      'model_ar': instance.modelAr,
      'mileage': instance.mileage,
      'mileage_ar': instance.mileageAr,
      'information_number': instance.informationNumber,
      'transmission_type': instance.transmissionType,
      'transmission_type_ar': instance.transmissionTypeAr,
      'extras': instance.extras,
      'body_type': instance.bodyType,
      'body_type_ar': instance.bodyTypeAr,
      'fuel_type': instance.fuelType,
      'fuel_type_ar': instance.fuelTypeAr,
      'warranty': instance.warranty,
      'color': instance.color,
      'color_ar': instance.colorAr,
      'engine_size': instance.engineSize,
      'no_of_keys': instance.noOfKeys,
      'document_type': instance.documentType,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
