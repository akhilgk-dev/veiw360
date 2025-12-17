// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditProfileModel _$EditProfileModelFromJson(Map<String, dynamic> json) =>
    EditProfileModel(
      name: json['name'] as String?,
      countryCode: json['country_code'] as String?,
      mobile: json['mobile'] as String?,
      email: json['email'] as String?,
      username: json['username'] as String?,
      password: json['password'] as String?,
      confirmPassword: json['confirm_password'] as String?,
      residentCardNumber: json['resident_card_number'] as String?,
      accountNumber: json['account_number'] as String?,
      bank: json['bank'] as String?,
      isCompany: (json['is_company'] as num?)?.toInt(),
      fileIdNumber: json['file_id_number'] as String?,
    );

Map<String, dynamic> _$EditProfileModelToJson(EditProfileModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'country_code': instance.countryCode,
      'mobile': instance.mobile,
      'email': instance.email,
      'username': instance.username,
      'password': instance.password,
      'confirm_password': instance.confirmPassword,
      'resident_card_number': instance.residentCardNumber,
      'account_number': instance.accountNumber,
      'bank': instance.bank,
      'is_company': instance.isCompany,
      'file_id_number': instance.fileIdNumber,
    };
