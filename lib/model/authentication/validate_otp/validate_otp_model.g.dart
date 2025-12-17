// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validate_otp_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ValidateOtpModel _$ValidateOtpModelFromJson(Map<String, dynamic> json) =>
    ValidateOtpModel(
      dialCode: json['dial_code'] as String,
      phone: json['phone'] as String,
      otp: json['otp'] as String,
    );

Map<String, dynamic> _$ValidateOtpModelToJson(ValidateOtpModel instance) =>
    <String, dynamic>{
      'dial_code': instance.dialCode,
      'phone': instance.phone,
      'otp': instance.otp,
    };
