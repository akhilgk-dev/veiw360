// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'institution_register_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstitutionRegisterModel _$InstitutionRegisterModelFromJson(
  Map<String, dynamic> json,
) => InstitutionRegisterModel(
  name: json['name'] as String,
  countryCode: json['country_code'] as String,
  mobile: json['mobile'] as String,
  email: json['email'] as String,
  username: json['username'] as String,
  password: json['password'] as String,
  confirmPassword: json['confirm_password'] as String,
  residentCardNumber: json['residentCardNumber'] as String,
  accountNumber: json['accountNumber'] as String,
  bank: json['bank'] as String,
  authorityName: json['authorityName'] as String,
  crNumber: json['crNumber'] as String,
  vatNumber: json['vatNumber'] as String,
  isCompany: (json['isCompany'] as num).toInt(),
  fileIdNumber: json['fileIdNumber'] as String,
  fileAuthLetter: json['fileAuthLetter'] as String,
  fileCrNumber: json['fileCrNumber'] as String,
  fileVatCertificate: json['fileVatCertificate'] as String,
);

Map<String, dynamic> _$InstitutionRegisterModelToJson(
  InstitutionRegisterModel instance,
) => <String, dynamic>{
  'name': instance.name,
  'country_code': instance.countryCode,
  'mobile': instance.mobile,
  'email': instance.email,
  'username': instance.username,
  'password': instance.password,
  'confirm_password': instance.confirmPassword,
  'residentCardNumber': instance.residentCardNumber,
  'accountNumber': instance.accountNumber,
  'bank': instance.bank,
  'authorityName': instance.authorityName,
  'crNumber': instance.crNumber,
  'vatNumber': instance.vatNumber,
  'isCompany': instance.isCompany,
  'fileIdNumber': instance.fileIdNumber,
  'fileAuthLetter': instance.fileAuthLetter,
  'fileCrNumber': instance.fileCrNumber,
  'fileVatCertificate': instance.fileVatCertificate,
};
