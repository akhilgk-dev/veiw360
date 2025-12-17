// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'top_bidders_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopBiddersModel _$TopBiddersModelFromJson(Map<String, dynamic> json) =>
    TopBiddersModel(
      success: json['success'] as bool,
      data: (json['data'] as List<dynamic>)
          .map((e) => BidData.fromJson(e as Map<String, dynamic>))
          .toList(),
      extraData: json['extra_data'] as List<dynamic>,
      message: json['message'] as String,
      meta: Meta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TopBiddersModelToJson(TopBiddersModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'extra_data': instance.extraData,
      'message': instance.message,
      'meta': instance.meta,
    };

BidData _$BidDataFromJson(Map<String, dynamic> json) => BidData(
  id: (json['id'] as num).toInt(),
  userId: (json['user_id'] as num).toInt(),
  auctionId: (json['auction_id'] as num).toInt(),
  groupId: (json['group_id'] as num?)?.toInt(),
  enrollNumber: json['enroll_number'] as String?,
  bidAmount: (json['bid_amount'] as num).toInt(),
  winner: (json['winner'] as num).toInt(),
  winnerStatus: json['winner_status'] as String?,
  isNotificationSent: (json['is_notification_sent'] as num).toInt(),
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
);

Map<String, dynamic> _$BidDataToJson(BidData instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'auction_id': instance.auctionId,
  'group_id': instance.groupId,
  'enroll_number': instance.enrollNumber,
  'bid_amount': instance.bidAmount,
  'winner': instance.winner,
  'winner_status': instance.winnerStatus,
  'is_notification_sent': instance.isNotificationSent,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};

Meta _$MetaFromJson(Map<String, dynamic> json) => Meta(
  userId: (json['user_id'] as num).toInt(),
  auctionId: (json['auction_id'] as num).toInt(),
  bidAmount: (json['bid_amount'] as num).toInt(),
  winner: (json['winner'] as num).toInt(),
  bidCount: (json['bid_count'] as num).toInt(),
  myPosition: MyPosition.fromJson(json['myPosition'] as Map<String, dynamic>),
  totalEnrolls: (json['total_enrolls'] as num).toInt(),
  extraTime: json['extra_time'] as String,
);

Map<String, dynamic> _$MetaToJson(Meta instance) => <String, dynamic>{
  'user_id': instance.userId,
  'auction_id': instance.auctionId,
  'bid_amount': instance.bidAmount,
  'winner': instance.winner,
  'bid_count': instance.bidCount,
  'myPosition': instance.myPosition,
  'total_enrolls': instance.totalEnrolls,
  'extra_time': instance.extraTime,
};

MyPosition _$MyPositionFromJson(Map<String, dynamic> json) =>
    MyPosition(position: json['position'], bidAmount: json['bid_amount']);

Map<String, dynamic> _$MyPositionToJson(MyPosition instance) =>
    <String, dynamic>{
      'position': instance.position,
      'bid_amount': instance.bidAmount,
    };
