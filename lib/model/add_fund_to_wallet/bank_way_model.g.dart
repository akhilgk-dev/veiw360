// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_way_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BankWayModel _$BankWayModelFromJson(Map<String, dynamic> json) => BankWayModel(
  credit: (json['credit'] as num).toInt(),
  accountNumber: (json['account_number'] as num).toInt(),
  bank: json['bank'] as String,
  receiptNumber: json['receipt_number'] as String,
  method: json['method'] as String,
  status: json['status'] as String,
  type: json['type'] as String,
  user: (json['user'] as num).toInt(),
  fileReceipt: json['file_receipt'] as String?,
);

Map<String, dynamic> _$BankWayModelToJson(BankWayModel instance) =>
    <String, dynamic>{
      'credit': instance.credit,
      'account_number': instance.accountNumber,
      'bank': instance.bank,
      'receipt_number': instance.receiptNumber,
      'method': instance.method,
      'status': instance.status,
      'type': instance.type,
      'user': instance.user,
      'file_receipt': instance.fileReceipt,
    };
