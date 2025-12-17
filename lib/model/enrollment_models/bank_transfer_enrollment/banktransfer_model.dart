import 'package:json_annotation/json_annotation.dart';

part 'banktransfer_model.g.dart';

@JsonSerializable()
class EnrollBanktransferModel {
  @JsonKey(name: 'auction')
  final int auctionId;
  @JsonKey(name: 'enroll_name')
  final String enrollName;
  @JsonKey(name: 'identity_type')
  final String identityType;
  @JsonKey(name: 'civil_id')
  final String civilId;
  @JsonKey(name: 'bank')
  final String bank;
  @JsonKey(name: 'account_number')
  final String accountNumber;
  @JsonKey(name: 'beneficiary')
  final String beneficiary;
  @JsonKey(name: 'receipt_number')
  final String receiptNumber;
  @JsonKey(name: 'is_company')
  final int isCompany;
  @JsonKey(name: 'is_offline')
  final bool isOffline;
  @JsonKey(name: 'ptype')
  final String ptype;
  @JsonKey(name: 'amount')
  final double amount;
  @JsonKey(name: 'file_receipt')
  final String fileReceipt;

  EnrollBanktransferModel({
    required this.auctionId,
    required this.enrollName,
    required this.identityType,
    required this.civilId,
    required this.bank,
    required this.accountNumber,
    required this.beneficiary,
    required this.receiptNumber,
    required this.isCompany,
    required this.isOffline,
    required this.ptype,
    required this.amount,
    required this.fileReceipt,
  });

  factory EnrollBanktransferModel.fromJson(Map<String, dynamic> json) =>
      _$EnrollBanktransferModelFromJson(json);
  Map<String, dynamic> toJson() => _$EnrollBanktransferModelToJson(this);
}
