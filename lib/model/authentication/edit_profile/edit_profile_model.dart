import 'package:json_annotation/json_annotation.dart';

part 'edit_profile_model.g.dart';

@JsonSerializable()
class EditProfileModel {
  final String? name;
  @JsonKey(name: 'country_code')
  final String? countryCode;
  final String? mobile;
  final String? email;
  final String? username;
  final String? password;
  @JsonKey(name: 'confirm_password')
  final String? confirmPassword;
  @JsonKey(name: 'resident_card_number')
  final String? residentCardNumber;
  @JsonKey(name: 'account_number')
  final String? accountNumber;
  final String? bank;
  @JsonKey(name: 'is_company')
  final int? isCompany; // 0 for bidder, 1 for client
  @JsonKey(name: 'file_id_number')
  final String? fileIdNumber;

  EditProfileModel({
    this.name,
    this.countryCode,
    this.mobile,
    this.email,
    this.username,
    this.password,
    this.confirmPassword,
    this.residentCardNumber,
    this.accountNumber,
    this.bank,
    this.isCompany,
    this.fileIdNumber,
  });

  /// Factory constructor for creating an instance from JSON
  factory EditProfileModel.fromJson(Map<String, dynamic> json) =>
      _$EditProfileModelFromJson(json);

  /// Method for converting an instance to JSON
  Map<String, dynamic> toJson() => _$EditProfileModelToJson(this);
}
