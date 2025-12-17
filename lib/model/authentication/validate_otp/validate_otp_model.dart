import 'package:json_annotation/json_annotation.dart';
part 'validate_otp_model.g.dart';

@JsonSerializable()
class ValidateOtpModel {
  @JsonKey(name: 'dial_code')
  final String dialCode;
  final String phone;
  final String otp;

  ValidateOtpModel(
      {required this.dialCode, required this.phone, required this.otp});

  factory ValidateOtpModel.fromJson(Map<String, dynamic> json) =>
      _$ValidateOtpModelFromJson(json);

  Map<String, dynamic> toJson() => _$ValidateOtpModelToJson(this);
}
