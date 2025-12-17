// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackingModel _$TrackingModelFromJson(Map<String, dynamic> json) =>
    TrackingModel(
      success: json['success'] as bool,
      data: (json['data'] as List<dynamic>)
          .map((e) => TrackingData.fromJson(e as Map<String, dynamic>))
          .toList(),
      extraData: json['extra_data'] as List<dynamic>?,
      message: json['message'] as String?,
      meta: json['meta'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$TrackingModelToJson(TrackingModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'extra_data': instance.extraData,
      'message': instance.message,
      'meta': instance.meta,
    };

TrackingData _$TrackingDataFromJson(Map<String, dynamic> json) => TrackingData(
  auctionId: (json['auction_id'] as num).toInt(),
  auctionTitle: json['auction_title'] as String,
  auctionTitleAr: json['auction_title_ar'] as String,
  siteVisit: json['site_visit'] == null
      ? null
      : TrackingStatus.fromJson(json['site_visit'] as Map<String, dynamic>),
  registration: json['registration'] == null
      ? null
      : TrackingStatus.fromJson(json['registration'] as Map<String, dynamic>),
  auctionStart: json['auction_start'] == null
      ? null
      : TrackingStatus.fromJson(json['auction_start'] as Map<String, dynamic>),
  auctionEnd: json['auction_end'] == null
      ? null
      : TrackingStatus.fromJson(json['auction_end'] as Map<String, dynamic>),
  clientApproval: json['client_approval'] == null
      ? null
      : TrackingStatus.fromJson(
          json['client_approval'] as Map<String, dynamic>,
        ),
  clientPayment: json['client_payment'] == null
      ? null
      : TrackingStatus.fromJson(json['client_payment'] as Map<String, dynamic>),
  completed: json['completed'] == null
      ? null
      : TrackingStatus.fromJson(json['completed'] as Map<String, dynamic>),
  meta: json['meta'],
);

Map<String, dynamic> _$TrackingDataToJson(TrackingData instance) =>
    <String, dynamic>{
      'auction_id': instance.auctionId,
      'auction_title': instance.auctionTitle,
      'auction_title_ar': instance.auctionTitleAr,
      'site_visit': instance.siteVisit,
      'registration': instance.registration,
      'auction_start': instance.auctionStart,
      'auction_end': instance.auctionEnd,
      'client_approval': instance.clientApproval,
      'client_payment': instance.clientPayment,
      'completed': instance.completed,
      'meta': instance.meta,
    };

TrackingStatus _$TrackingStatusFromJson(Map<String, dynamic> json) =>
    TrackingStatus(
      date: json['date'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$TrackingStatusToJson(TrackingStatus instance) =>
    <String, dynamic>{'date': instance.date, 'status': instance.status};
