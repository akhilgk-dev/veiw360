// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phone_otp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtpRequest _$OtpRequestFromJson(Map<String, dynamic> json) => OtpRequest(
  label: json['label'] as String,
  dialCode: json['dial_code'] as String,
  code: json['code'] as String,
  captchaToken: json['captcha_token'] as String,
  type: json['type'] as String,
  phone: json['phone'] as String,
);

Map<String, dynamic> _$OtpRequestToJson(OtpRequest instance) =>
    <String, dynamic>{
      'label': instance.label,
      'dial_code': instance.dialCode,
      'code': instance.code,
      'captcha_token': instance.captchaToken,
      'type': instance.type,
      'phone': instance.phone,
    };
