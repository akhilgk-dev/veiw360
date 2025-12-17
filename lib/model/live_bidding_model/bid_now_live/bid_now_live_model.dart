import 'package:json_annotation/json_annotation.dart';

part 'bid_now_live_model.g.dart'; // This will be generated after running build_runner

@JsonSerializable()
class BidResponse {
  final bool success;
  final BidDataResponseLive data;
  final List<dynamic>
      extraData; // Using dynamic since extra_data is an empty array
  final String message;
  final String meta;

  BidResponse({
    required this.success,
    required this.data,
    required this.extraData,
    required this.message,
    required this.meta,
  });

  factory BidResponse.fromJson(Map<String, dynamic> json) =>
      _$BidResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BidResponseToJson(this);
}

@JsonSerializable()
class BidDataResponseLive {
  @JsonKey(name: 'current_amount')
  final int currentAmount;

  BidDataResponseLive({
    required this.currentAmount,
  });

  factory BidDataResponseLive.fromJson(Map<String, dynamic> json) =>
      _$BidDataResponseLiveFromJson(json);

  Map<String, dynamic> toJson() => _$BidDataResponseLiveToJson(this);
}
