import 'package:json_annotation/json_annotation.dart';

part 'payment_after_success_update.g.dart';

@JsonSerializable()
class Enrollment {
  @JsonKey(name: 'group_id')
  final String groupId;
  @JsonKey(name: 'auction_id')
  final String auctionId;
  @JsonKey(name: 'enroll_id')
  final String enrollId;
  final String amount;
  final String invoice;
  final String type;
  @JsonKey(name: 'gate_pass_id')
  final String gatePassId;
  @JsonKey(name: 'is_custom')
  final bool isCustom;
  final String reference;

  Enrollment({
    required this.groupId,
    required this.auctionId,
    required this.enrollId,
    required this.amount,
    required this.invoice,
    required this.type,
    required this.gatePassId,
    required this.isCustom,
    required this.reference,
  });

  factory Enrollment.fromJson(Map<String, dynamic> json) =>
      _$EnrollmentFromJson(json);
  Map<String, dynamic> toJson() => _$EnrollmentToJson(this);
}
