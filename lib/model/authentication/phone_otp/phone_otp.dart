import 'package:json_annotation/json_annotation.dart';

part 'phone_otp.g.dart';

@JsonSerializable()
class OtpRequest {
  final String label;
  @JsonKey(name: 'dial_code')
  final String dialCode;
  final String code;
  @JsonKey(name: 'captcha_token')
  final String captchaToken;
  final String type;
  final String phone;

  OtpRequest({
    required this.label,
    required this.dialCode,
    required this.code,
    required this.captchaToken,
    required this.type,
    required this.phone,
  });

  // From JSON to OtpRequest
  factory OtpRequest.fromJson(Map<String, dynamic> json) =>
      _$OtpRequestFromJson(json);

  // From OtpRequest to JSON
  Map<String, dynamic> toJson() => _$OtpRequestToJson(this);
}
