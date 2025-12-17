import 'package:json_annotation/json_annotation.dart';

part 'bank_way_model.g.dart';

@JsonSerializable()
class BankWayModel {
  @JsonKey(name: 'credit')
  final int credit;
  @JsonKey(name: 'account_number')
  final int accountNumber;
  @JsonKey(name: 'bank')
  final String bank;
  @JsonKey(name: 'receipt_number')
  final String receiptNumber;
  @JsonKey(name: 'method')
  final String method;
  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'type')
  final String type;
  @JsonKey(name: 'user')
  final int user;
  @JsonKey(name: 'file_receipt')
  final String? fileReceipt; // Representing binary data as List<int>

  BankWayModel({
    required this.credit,
    required this.accountNumber,
    required this.bank,
    required this.receiptNumber,
    required this.method,
    required this.status,
    required this.type,
    required this.user,
    required this.fileReceipt,
  });

  factory BankWayModel.fromJson(Map<String, dynamic> json) =>
      _$BankWayModelFromJson(json);

  Map<String, dynamic> toJson() => _$BankWayModelToJson(this);
}
