import 'package:json_annotation/json_annotation.dart';

part 'tracking_model.g.dart';

@JsonSerializable()
class TrackingModel {
  @JsonKey(name: 'success')
  bool success;

  @JsonKey(name: 'data')
  List<TrackingData> data;

  @JsonKey(name: 'extra_data')
  List<dynamic>? extraData;

  @JsonKey(name: 'message')
  String? message;

  @JsonKey(name: 'meta')
  Map<String, dynamic>? meta;

  TrackingModel({
    required this.success,
    required this.data,
    this.extraData,
    this.message,
    this.meta,
  });

  factory TrackingModel.fromJson(Map<String, dynamic> json) =>
      _$TrackingModelFromJson(json);

  Map<String, dynamic> toJson() => _$TrackingModelToJson(this);
}

@JsonSerializable()
class TrackingData {
  @JsonKey(name: 'auction_id')
  int auctionId;

  @JsonKey(name: 'auction_title')
  String auctionTitle;

  @JsonKey(name: 'auction_title_ar')
  String auctionTitleAr;

  @JsonKey(name: 'site_visit')
  TrackingStatus? siteVisit;

  @JsonKey(name: 'registration')
  TrackingStatus? registration;

  @JsonKey(name: 'auction_start')
  TrackingStatus? auctionStart;

  @JsonKey(name: 'auction_end')
  TrackingStatus? auctionEnd;

  @JsonKey(name: 'client_approval')
  TrackingStatus? clientApproval;

  @JsonKey(name: 'client_payment')
  TrackingStatus? clientPayment;

  @JsonKey(name: 'completed')
  TrackingStatus? completed;

  @JsonKey(name: 'meta')
  dynamic meta;

  TrackingData({
    required this.auctionId,
    required this.auctionTitle,
    required this.auctionTitleAr,
    this.siteVisit,
    this.registration,
    this.auctionStart,
    this.auctionEnd,
    this.clientApproval,
    this.clientPayment,
    this.completed,
    this.meta,
  });

  factory TrackingData.fromJson(Map<String, dynamic> json) =>
      _$TrackingDataFromJson(json);

  Map<String, dynamic> toJson() => _$TrackingDataToJson(this);
}

@JsonSerializable()
class TrackingStatus {
  @JsonKey(name: 'date')
  String? date;

  @JsonKey(name: 'status')
  String? status;

  TrackingStatus({this.date, this.status});

  factory TrackingStatus.fromJson(Map<String, dynamic> json) =>
      _$TrackingStatusFromJson(json);

  Map<String, dynamic> toJson() => _$TrackingStatusToJson(this);
}
