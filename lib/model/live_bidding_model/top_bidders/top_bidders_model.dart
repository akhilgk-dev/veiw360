import 'package:json_annotation/json_annotation.dart';
part 'top_bidders_model.g.dart';

// Root model
@JsonSerializable()
class TopBiddersModel {
  final bool success;
  final List<BidData> data;
  @JsonKey(name: 'extra_data')
  final List<dynamic> extraData;
  final String message;
  final Meta meta;

  TopBiddersModel({
    required this.success,
    required this.data,
    required this.extraData,
    required this.message,
    required this.meta,
  });

  factory TopBiddersModel.fromJson(Map<String, dynamic> json) =>
      _$TopBiddersModelFromJson(json);
  Map<String, dynamic> toJson() => _$TopBiddersModelToJson(this);
}

// Bid data model
@JsonSerializable()
class BidData {
  final int id;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'auction_id')
  final int auctionId;
  @JsonKey(name: 'group_id')
  final int? groupId; //  nullable
  @JsonKey(name: 'enroll_number')
  final String? enrollNumber; //  nullable
  @JsonKey(name: 'bid_amount')
  final int bidAmount;
  final int winner;
  @JsonKey(name: 'winner_status')
  final String? winnerStatus;
  @JsonKey(name: 'is_notification_sent')
  final int isNotificationSent;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  BidData({
    required this.id,
    required this.userId,
    required this.auctionId,
    required this.groupId, // now nullable
    required this.enrollNumber, // now nullable
    required this.bidAmount,
    required this.winner,
    this.winnerStatus,
    required this.isNotificationSent,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BidData.fromJson(Map<String, dynamic> json) =>
      _$BidDataFromJson(json);
  Map<String, dynamic> toJson() => _$BidDataToJson(this);
}

// Meta model
@JsonSerializable()
class Meta {
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'auction_id')
  final int auctionId;
  @JsonKey(name: 'bid_amount')
  final int bidAmount;
  final int winner;
  @JsonKey(name: 'bid_count')
  final int bidCount;
  final MyPosition myPosition;
  @JsonKey(name: 'total_enrolls')
  final int totalEnrolls;
  @JsonKey(name: 'extra_time')
  final String extraTime;

  Meta({
    required this.userId,
    required this.auctionId,
    required this.bidAmount,
    required this.winner,
    required this.bidCount,
    required this.myPosition,
    required this.totalEnrolls,
    required this.extraTime,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);
  Map<String, dynamic> toJson() => _$MetaToJson(this);
}

// MyPosition model
// @JsonSerializable()
// class MyPosition {
//   final dynamic position;
//   @JsonKey(name: 'bid_amount')
//   final dynamic bidAmount;

//   MyPosition({
//     required this.position,
//     required this.bidAmount,
//   });

//   factory MyPosition.fromJson(Map<String, dynamic> json) =>
//       _$MyPositionFromJson(json);
//   Map<String, dynamic> toJson() => _$MyPositionToJson(this);
// }
@JsonSerializable()
class MyPosition {
  final dynamic position;
  @JsonKey(name: 'bid_amount')
  final dynamic bidAmount;

  MyPosition({required this.position, required this.bidAmount});

  // Add a getter to safely convert position to int
  int get safePosition {
    if (position is int) return position as int;
    if (position is bool)
      return (position as bool) ? 1 : 0; // Convert bool to int
    return 0; // Default fallback
  }

  factory MyPosition.fromJson(Map<String, dynamic> json) =>
      _$MyPositionFromJson(json);
  Map<String, dynamic> toJson() => _$MyPositionToJson(this);
}
