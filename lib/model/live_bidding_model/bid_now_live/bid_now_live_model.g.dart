// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bid_now_live_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BidResponse _$BidResponseFromJson(Map<String, dynamic> json) => BidResponse(
  success: json['success'] as bool,
  data: BidDataResponseLive.fromJson(json['data'] as Map<String, dynamic>),
  extraData: json['extraData'] as List<dynamic>,
  message: json['message'] as String,
  meta: json['meta'] as String,
);

Map<String, dynamic> _$BidResponseToJson(BidResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'extraData': instance.extraData,
      'message': instance.message,
      'meta': instance.meta,
    };

BidDataResponseLive _$BidDataResponseLiveFromJson(Map<String, dynamic> json) =>
    BidDataResponseLive(currentAmount: (json['current_amount'] as num).toInt());

Map<String, dynamic> _$BidDataResponseLiveToJson(
  BidDataResponseLive instance,
) => <String, dynamic>{'current_amount': instance.currentAmount};
