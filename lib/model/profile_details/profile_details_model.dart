// import 'package:json_annotation/json_annotation.dart';

// part 'profile_details_model.g.dart'; // This will be generated


// @JsonSerializable()
// class ProfileDetailsModel {
//   @JsonKey(name: 'success')
//   dynamic success;
//   @JsonKey(name: 'data')
//   UserData data;
//   @JsonKey(name: 'extra_data')
//   dynamic extraData;
//   @JsonKey(name: 'message')
//   dynamic message;
//   @JsonKey(name: 'meta')
//   dynamic meta;

//   ProfileDetailsModel({
//     this.success,
//     required this.data,
//     this.extraData,
//     this.message,
//     this.meta,
//   });

//   factory ProfileDetailsModel.fromJson(Map<String, dynamic> json) =>
//       _$ProfileDetailsModelFromJson(json);
//   Map<String, dynamic> toJson() => _$ProfileDetailsModelToJson(this);
// }

// @JsonSerializable()
// class UserData {
//   @JsonKey(name: 'id')
//   dynamic id;
//   @JsonKey(name: 'name')
//   dynamic name;
//   @JsonKey(name: 'username')
//   dynamic username;
//   @JsonKey(name: 'email')
//   dynamic email;
//   @JsonKey(name: 'email_verified_at')
//   dynamic emailVerifiedAt;
//   @JsonKey(name: 'country_code')
//   dynamic countryCode;
//   @JsonKey(name: 'mobile')
//   dynamic mobile;
//   @JsonKey(name: 'mobile_verified_at')
//   dynamic mobileVerifiedAt;
//   @JsonKey(name: 'role')
//   dynamic role;
//   @JsonKey(name: 'department')
//   dynamic department;
//   @JsonKey(name: 'designaton')
//   dynamic designation;
//   @JsonKey(name: 'otp')
//   dynamic otp;
//   @JsonKey(name: 'otp_verified')
//   dynamic otpVerified;
//   @JsonKey(name: 'thawani_id')
//   dynamic thawaniId;
//   @JsonKey(name: 'google_id')
//   dynamic googleId;
//   @JsonKey(name: 'fb_id')
//   dynamic fbId;
//   @JsonKey(name: 'avatar')
//   dynamic avatar;
//   @JsonKey(name: 'signature')
//   dynamic signature;
//   @JsonKey(name: 'is_company')
//   dynamic isCompany;
//   @JsonKey(name: 'is_client')
//   dynamic isClient;
//   @JsonKey(name: 'authority_name')
//   dynamic authorityName;
//   @JsonKey(name: 'file_auth_letter')
//   dynamic fileAuthLetter;
//   @JsonKey(name: 'resident_card_number')
//   dynamic residentCardNumber;
//   @JsonKey(name: 'file_id_number')
//   dynamic fileIdNumber;
//   @JsonKey(name: 'bank')
//   dynamic bank;
//   @JsonKey(name: 'account_number')
//   dynamic accountNumber;
//   @JsonKey(name: 'beneficiary')
//   dynamic beneficiary;
//   @JsonKey(name: 'cr_number')
//   dynamic crNumber;
//   @JsonKey(name: 'cr_expiry_date')
//   dynamic crExpiryDate;
//   @JsonKey(name: 'file_cr_number')
//   dynamic fileCrNumber;
//   @JsonKey(name: 'vat_number')
//   dynamic vatNumber;
//   @JsonKey(name: 'file_vat_certificate')
//   dynamic fileVatCertificate;
//   @JsonKey(name: 'file_additional_doc')
//   dynamic fileAdditionalDoc;
//   @JsonKey(name: 'wallet_amount')
//   dynamic walletAmount;
//   @JsonKey(name: 'hold_amount')
//   dynamic holdAmount;
//   @JsonKey(name: 'is_rop_staff')
//   dynamic isRopStaff;
//   @JsonKey(name: 'department_id')
//   dynamic departmentId;
//   @JsonKey(name: 'last_seen_at')
//   dynamic lastSeenAt;
//   @JsonKey(name: 'status')
//   dynamic status;
//   @JsonKey(name: 'deleted')
//   dynamic deleted;
//   @JsonKey(name: 'deleted_at')
//   dynamic deletedAt;
//   @JsonKey(name: 'created_at')
//   dynamic createdAt;
//   @JsonKey(name: 'updated_at')
//   dynamic updatedAt;

//   UserData({
//     this.id,
//     this.name,
//     this.username,
//     this.email,
//     this.emailVerifiedAt,
//     this.countryCode,
//     this.mobile,
//     this.mobileVerifiedAt,
//     this.role,
//     this.department,
//     this.designation,
//     this.otp,
//     this.otpVerified,
//     this.thawaniId,
//     this.googleId,
//     this.fbId,
//     this.avatar,
//     this.signature,
//     this.isCompany,
//     this.isClient,
//     this.authorityName,
//     this.fileAuthLetter,
//     this.residentCardNumber,
//     this.fileIdNumber,
//     this.bank,
//     this.accountNumber,
//     this.beneficiary,
//     this.crNumber,
//     this.crExpiryDate,
//     this.fileCrNumber,
//     this.vatNumber,
//     this.fileVatCertificate,
//     this.fileAdditionalDoc,
//     this.walletAmount,
//     this.holdAmount,
//     this.isRopStaff,
//     this.departmentId,
//     this.lastSeenAt,
//     this.status,
//     this.deleted,
//     this.deletedAt,
//     this.createdAt,
//     this.updatedAt,
//   });

//   factory UserData.fromJson(Map<String, dynamic> json) =>
//       _$UserDataFromJson(json);
//   Map<String, dynamic> toJson() => _$UserDataToJson(this);
// }
import 'package:json_annotation/json_annotation.dart';

part 'profile_details_model.g.dart'; // This will be generated


@JsonSerializable()
class ProfileDetailsModel {
  @JsonKey(name: 'success')
  dynamic success;
  @JsonKey(name: 'data')
  UserData data;
  @JsonKey(name: 'extra_data')
  dynamic extraData;
  @JsonKey(name: 'message')
  dynamic message;
  @JsonKey(name: 'meta')
  dynamic meta;

  ProfileDetailsModel({
    this.success,
    required this.data,
    this.extraData,
    this.message,
    this.meta,
  });

  factory ProfileDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileDetailsModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileDetailsModelToJson(this);
}

@JsonSerializable()
class UserData {
  @JsonKey(name: 'id')
  dynamic id;
  @JsonKey(name: 'name')
  dynamic name;
  @JsonKey(name: 'username')
  dynamic username;
  @JsonKey(name: 'email')
  dynamic email;
  @JsonKey(name: 'email_verified_at')
  dynamic emailVerifiedAt;
  @JsonKey(name: 'country_code')
  dynamic countryCode;
  @JsonKey(name: 'mobile')
  dynamic mobile;
  @JsonKey(name: 'mobile_verified_at')
  dynamic mobileVerifiedAt;
  @JsonKey(name: 'role')
  dynamic role;
  @JsonKey(name: 'department')
  dynamic department;
  @JsonKey(name: 'designaton')
  dynamic designation;
  @JsonKey(name: 'otp')
  dynamic otp;
  @JsonKey(name: 'otp_verified')
  dynamic otpVerified;
  @JsonKey(name: 'thawani_id')
  dynamic thawaniId;
  @JsonKey(name: 'google_id')
  dynamic googleId;
  @JsonKey(name: 'fb_id')
  dynamic fbId;
  @JsonKey(name: 'avatar')
  dynamic avatar;
  @JsonKey(name: 'signature')
  dynamic signature;
  @JsonKey(name: 'is_company')
  dynamic isCompany;
  @JsonKey(name: 'is_client')
  dynamic isClient;
  @JsonKey(name: 'authority_name')
  dynamic authorityName;
  @JsonKey(name: 'file_auth_letter')
  dynamic fileAuthLetter;
  @JsonKey(name: 'resident_card_number')
  dynamic residentCardNumber;
  @JsonKey(name: 'file_id_number')
  dynamic fileIdNumber;
  @JsonKey(name: 'bank')
  dynamic bank;
  @JsonKey(name: 'account_number')
  dynamic accountNumber;
  @JsonKey(name: 'beneficiary')
  dynamic beneficiary;
  @JsonKey(name: 'cr_number')
  dynamic crNumber;
  @JsonKey(name: 'cr_expiry_date')
  dynamic crExpiryDate;
  @JsonKey(name: 'file_cr_number')
  dynamic fileCrNumber;
  @JsonKey(name: 'vat_number')
  dynamic vatNumber;
  @JsonKey(name: 'file_vat_certificate')
  dynamic fileVatCertificate;
  @JsonKey(name: 'file_additional_doc')
  dynamic fileAdditionalDoc;
  @JsonKey(name: 'wallet_amount')
  dynamic walletAmount;
  @JsonKey(name: 'hold_amount')
  dynamic holdAmount;
  @JsonKey(name: 'is_rop_staff')
  dynamic isRopStaff;
  @JsonKey(name: 'department_id')
  dynamic departmentId;
  @JsonKey(name: 'last_seen_at')
  dynamic lastSeenAt;
  @JsonKey(name: 'status')
  dynamic status;
  @JsonKey(name: 'deleted')
  dynamic deleted;
  @JsonKey(name: 'deleted_at')
  dynamic deletedAt;
  @JsonKey(name: 'created_at')
  dynamic createdAt;
  @JsonKey(name: 'updated_at')
  dynamic updatedAt;
  @JsonKey(name: 'bidder_number')
  dynamic bidderNumber;


  UserData({
    this.id,
    this.name,
    this.username,
    this.email,
    this.emailVerifiedAt,
    this.countryCode,
    this.mobile,
    this.mobileVerifiedAt,
    this.role,
    this.department,
    this.designation,
    this.otp,
    this.otpVerified,
    this.thawaniId,
    this.googleId,
    this.fbId,
    this.avatar,
    this.signature,
    this.isCompany,
    this.isClient,
    this.authorityName,
    this.fileAuthLetter,
    this.residentCardNumber,
    this.fileIdNumber,
    this.bank,
    this.accountNumber,
    this.beneficiary,
    this.crNumber,
    this.crExpiryDate,
    this.fileCrNumber,
    this.vatNumber,
    this.fileVatCertificate,
    this.fileAdditionalDoc,
    this.walletAmount,
    this.holdAmount,
    this.isRopStaff,
    this.departmentId,
    this.lastSeenAt,
    this.status,
    this.deleted,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.bidderNumber,
  });

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}
