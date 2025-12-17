import 'package:json_annotation/json_annotation.dart';

part 'individual_register_model.g.dart';

@JsonSerializable()
class IndividualRegisterModel {
  final String name;
  @JsonKey(name: 'country_code')
  final String countryCode;
  final String mobile;
  final String email;
  final String username;
  final String password;
  @JsonKey(name: 'confirm_password')
  final String confirmPassword;
  @JsonKey(name: 'resident_card_number')
  final String residentCardNumber;
  @JsonKey(name: 'account_number')
  final String accountNumber;
  final String bank;
  @JsonKey(name: 'is_company')
  final int isCompany; // 0 for bidder, 1 for client
  @JsonKey(name: 'file_id_number')
  final String fileIdNumber;

  IndividualRegisterModel({
    required this.name,
    required this.countryCode,
    required this.mobile,
    required this.email,
    required this.username,
    required this.password,
    required this.confirmPassword,
    required this.residentCardNumber,
    required this.accountNumber,
    required this.bank,
    required this.isCompany,
    required this.fileIdNumber,
  });

  /// Factory constructor for creating an instance from JSON
  factory IndividualRegisterModel.fromJson(Map<String, dynamic> json) =>
      _$IndividualRegisterModelFromJson(json);

  /// Method for converting an instance to JSON
  Map<String, dynamic> toJson() => _$IndividualRegisterModelToJson(this);
}
