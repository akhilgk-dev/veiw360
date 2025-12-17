import 'package:json_annotation/json_annotation.dart';

part 'online_payment_model.g.dart';

@JsonSerializable()
class OnlinePaymentModel {
  @JsonKey(name: 'auction')
  final int auctionId;
  @JsonKey(name: 'enroll_name')
  final String enrollName;
  @JsonKey(name: 'identity_type')
  final String identityType;
  @JsonKey(name: 'receipt_number')
  final String receiptNo;
  @JsonKey(name: 'bank')
  final String bank;
  @JsonKey(name: 'account_number')
  final String accountNumber;
  @JsonKey(name: 'beneficiary')
  final String beneficiary;
  @JsonKey(name: 'is_company')
  final bool isCompany;
  @JsonKey(name: 'is_offline')
  final bool isOffline;
  @JsonKey(name: 'ptype')
  final String ptype;
  @JsonKey(name: 'amount')
  final double amount;

  OnlinePaymentModel({
    required this.auctionId,
    required this.enrollName,
    required this.identityType,
    required this.receiptNo,
    required this.bank,
    required this.accountNumber,
    required this.beneficiary,
    required this.isCompany,
    required this.isOffline,
    required this.ptype,
    required this.amount,
  });

  factory OnlinePaymentModel.fromJson(Map<String, dynamic> json) =>
      _$OnlinePaymentModelFromJson(json);
  Map<String, dynamic> toJson() => _$OnlinePaymentModelToJson(this);
}
