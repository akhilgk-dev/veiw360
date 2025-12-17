// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'online_payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OnlinePaymentModel _$OnlinePaymentModelFromJson(Map<String, dynamic> json) =>
    OnlinePaymentModel(
      auctionId: (json['auction'] as num).toInt(),
      enrollName: json['enroll_name'] as String,
      identityType: json['identity_type'] as String,
      receiptNo: json['receipt_number'] as String,
      bank: json['bank'] as String,
      accountNumber: json['account_number'] as String,
      beneficiary: json['beneficiary'] as String,
      isCompany: json['is_company'] as bool,
      isOffline: json['is_offline'] as bool,
      ptype: json['ptype'] as String,
      amount: (json['amount'] as num).toDouble(),
    );

Map<String, dynamic> _$OnlinePaymentModelToJson(OnlinePaymentModel instance) =>
    <String, dynamic>{
      'auction': instance.auctionId,
      'enroll_name': instance.enrollName,
      'identity_type': instance.identityType,
      'receipt_number': instance.receiptNo,
      'bank': instance.bank,
      'account_number': instance.accountNumber,
      'beneficiary': instance.beneficiary,
      'is_company': instance.isCompany,
      'is_offline': instance.isOffline,
      'ptype': instance.ptype,
      'amount': instance.amount,
    };
