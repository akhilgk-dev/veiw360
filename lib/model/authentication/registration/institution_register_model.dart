import 'package:json_annotation/json_annotation.dart';

part 'institution_register_model.g.dart';

@JsonSerializable()
class InstitutionRegisterModel {
  final String name;
  @JsonKey(name: 'country_code')
  final String countryCode;
  final String mobile;
  final String email;
  final String username;
  final String password;
  @JsonKey(name: 'confirm_password')
  final String confirmPassword;
  final String residentCardNumber;
  final String accountNumber;
  final String bank;
  final String authorityName;
  final String crNumber;
  final String vatNumber;
  final int isCompany;
  final String fileIdNumber;
  final String fileAuthLetter;
  final String fileCrNumber;
  final String fileVatCertificate;

  InstitutionRegisterModel({
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
    required this.authorityName,
    required this.crNumber,
    required this.vatNumber,
    required this.isCompany,
    required this.fileIdNumber,
    required this.fileAuthLetter,
    required this.fileCrNumber,
    required this.fileVatCertificate,
  });

  /// A factory constructor to create an instance from JSON
  factory InstitutionRegisterModel.fromJson(Map<String, dynamic> json) =>
      _$InstitutionRegisterModelFromJson(json);

  /// A method to convert an instance into JSON
  Map<String, dynamic> toJson() => _$InstitutionRegisterModelToJson(this);
}
