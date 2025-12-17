// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banktransfer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EnrollBanktransferModel _$EnrollBanktransferModelFromJson(
  Map<String, dynamic> json,
) => EnrollBanktransferModel(
  auctionId: (json['auction'] as num).toInt(),
  enrollName: json['enroll_name'] as String,
  identityType: json['identity_type'] as String,
  civilId: json['civil_id'] as String,
  bank: json['bank'] as String,
  accountNumber: json['account_number'] as String,
  beneficiary: json['beneficiary'] as String,
  receiptNumber: json['receipt_number'] as String,
  isCompany: (json['is_company'] as num).toInt(),
  isOffline: json['is_offline'] as bool,
  ptype: json['ptype'] as String,
  amount: (json['amount'] as num).toDouble(),
  fileReceipt: json['file_receipt'] as String,
);

Map<String, dynamic> _$EnrollBanktransferModelToJson(
  EnrollBanktransferModel instance,
) => <String, dynamic>{
  'auction': instance.auctionId,
  'enroll_name': instance.enrollName,
  'identity_type': instance.identityType,
  'civil_id': instance.civilId,
  'bank': instance.bank,
  'account_number': instance.accountNumber,
  'beneficiary': instance.beneficiary,
  'receipt_number': instance.receiptNumber,
  'is_company': instance.isCompany,
  'is_offline': instance.isOffline,
  'ptype': instance.ptype,
  'amount': instance.amount,
  'file_receipt': instance.fileReceipt,
};
