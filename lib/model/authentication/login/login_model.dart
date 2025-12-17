// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'login_model.g.dart';

@JsonSerializable()
class LoginModel {
  String login;
  String password;
  String device_name;

  LoginModel({
    required this.login,
    required this.password,
    required this.device_name,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) =>
      _$LoginModelFromJson(json);
  Map<String, dynamic> toJson() => _$LoginModelToJson(this);
}
