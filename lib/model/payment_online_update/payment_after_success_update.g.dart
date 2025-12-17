// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_after_success_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Enrollment _$EnrollmentFromJson(Map<String, dynamic> json) => Enrollment(
  groupId: json['group_id'] as String,
  auctionId: json['auction_id'] as String,
  enrollId: json['enroll_id'] as String,
  amount: json['amount'] as String,
  invoice: json['invoice'] as String,
  type: json['type'] as String,
  gatePassId: json['gate_pass_id'] as String,
  isCustom: json['is_custom'] as bool,
  reference: json['reference'] as String,
);

Map<String, dynamic> _$EnrollmentToJson(Enrollment instance) =>
    <String, dynamic>{
      'group_id': instance.groupId,
      'auction_id': instance.auctionId,
      'enroll_id': instance.enrollId,
      'amount': instance.amount,
      'invoice': instance.invoice,
      'type': instance.type,
      'gate_pass_id': instance.gatePassId,
      'is_custom': instance.isCustom,
      'reference': instance.reference,
    };
