// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_fund_wallet_online_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    TransactionModel(
      credit: (json['credit'] as num).toDouble(),
      accountNumber: (json['account_number'] as num).toInt(),
      bank: json['bank'] as String,
      method: json['method'] as String,
      status: json['status'] as String,
      type: json['type'] as String,
      user: (json['user'] as num).toInt(),
    );

Map<String, dynamic> _$TransactionModelToJson(TransactionModel instance) =>
    <String, dynamic>{
      'credit': instance.credit,
      'account_number': instance.accountNumber,
      'bank': instance.bank,
      'method': instance.method,
      'status': instance.status,
      'type': instance.type,
      'user': instance.user,
    };
