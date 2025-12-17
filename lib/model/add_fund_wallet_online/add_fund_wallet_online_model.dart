import 'package:json_annotation/json_annotation.dart';

part 'add_fund_wallet_online_model.g.dart'; // Will be generated

@JsonSerializable()
class TransactionModel {
  @JsonKey(name: 'credit')
  final double credit;
  @JsonKey(name: 'account_number')
  final int accountNumber;
  @JsonKey(name: 'bank')
  final String bank;
  @JsonKey(name: 'method')
  final String method;
  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'type')
  final String type;
  @JsonKey(name: 'user')
  final int user;

  TransactionModel({
    required this.credit,
    required this.accountNumber,
    required this.bank,
    required this.method,
    required this.status,
    required this.type,
    required this.user,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);
}
