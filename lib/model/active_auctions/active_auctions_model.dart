import 'package:json_annotation/json_annotation.dart';
part 'active_auctions_model.g.dart';

@JsonSerializable()
class AuctionResponse {
  final bool success;
  @JsonKey(name: 'data')
  final List<AuctionData>? auctionData; // Nullable
  @JsonKey(name: 'extra_data')
  final List<dynamic>? extraData; // Nullable
  final String? message; // Nullable

  AuctionResponse({
    required this.success,
    this.auctionData,
    this.extraData,
    this.message,
  });

  factory AuctionResponse.fromJson(Map<String, dynamic> json) =>
      _$AuctionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuctionResponseToJson(this);
}

@JsonSerializable()
class AuctionData {
  final dynamic id;
  @JsonKey(name: 'auction_number')
  final String? auctionNumber;
  final dynamic category;
  @JsonKey(name: 'categoryDetails')
  final CategoryDetails? categoryDetails;
  final dynamic organization;
  @JsonKey(name: 'organizationDetails')
  final OrganizationDetails? organizationDetails;
  @JsonKey(name: 'has_auto_bidding')
  final dynamic hasAutoBidding;
  final dynamic order;
  final String? title;
  @JsonKey(name: 'title_ar')
  final String? titleAr;
  final String? description;
  @JsonKey(name: 'description_ar')
  final String? descriptionAr;
  final dynamic details;
  final dynamic downloads;
  final String? terms;
  @JsonKey(name: 'terms_arabic')
  final String? termsArabic;
  @JsonKey(name: 'file_terms')
  final dynamic fileTerms;
  @JsonKey(name: 'file_payment_terms')
  final dynamic filePaymentTerms;
  final dynamic package;
  final dynamic group;
  @JsonKey(name: 'group_info')
  final GroupInfo? groupInfo;
  @JsonKey(name: 'phone_number')
  final dynamic phoneNumber;
  final dynamic mask;
  @JsonKey(name: 'class')
  final dynamic class_;
  @JsonKey(name: 'start_amount')
  final dynamic startAmount;
  @JsonKey(name: 'target_amount_ind')
  final String? targetAmountInd;
  @JsonKey(name: 'guarantee_amount')
  final dynamic guaranteeAmount;
  @JsonKey(name: 'visit_amount')
  final String? visitAmount;
  @JsonKey(name: 'is_visit_active')
  final bool? isVisitActive;
  @JsonKey(name: 'current_amount')
  final dynamic currentAmount;
  @JsonKey(name: 'bid_increment')
  final dynamic bidIncrement;
  @JsonKey(name: 'increment_numbers')
  final List<String>? incrementNumbers;
  @JsonKey(name: 'bid_count')
  final dynamic bidCount;
  @JsonKey(name: 'start_date')
  final String? startDate;
  @JsonKey(name: 'start_date_ar')
  final StartDateAr? startDateAr;
  @JsonKey(name: 'end_date')
  final String? endDate;
  @JsonKey(name: 'end_date_ar')
  final EndDateAr? endDateAr;
  @JsonKey(name: 'start_date_formatted')
  final String? startDateFormatted;
  @JsonKey(name: 'end_date_formatted')
  final String? endDateFormatted;
  @JsonKey(name: 'reg_start_date')
  final String? regStartDate;
  @JsonKey(name: 'reg_end_date')
  final String? regEndDate;
  @JsonKey(name: 'reg_start_date_formatted')
  final String? regStartDateFormatted;
  @JsonKey(name: 'reg_start_date_ar')
  final RegStartDateAr? regStartDateAr;
  @JsonKey(name: 'reg_end_date_formatted')
  final String? regEndDateFormatted;
  @JsonKey(name: 'reg_end_date_ar')
  final RegEndDateAr? regEndDateAr;
  @JsonKey(name: 'is_grouped')
  final dynamic isGrouped;
  @JsonKey(name: 'is_grouped_enroll')
  final dynamic isGroupedEnroll;
  @JsonKey(name: 'enroll_close_date')
  final String? enrollCloseDate;
  @JsonKey(name: 'is_featured')
  final dynamic isFeatured;
  @JsonKey(name: 'is_direct_sale')
  final dynamic isDirectSale;
  @JsonKey(name: 'is_zakath')
  final dynamic isZakath;
  @JsonKey(name: 'is_vehicle')
  final dynamic isVehicle;
  @JsonKey(name: 'vehicle_info')
  final dynamic vehicleInfo;
  final String? vat;
  final dynamic status;
  @JsonKey(name: 'status_dis')
  final String? statusDis;
  @JsonKey(name: 'status_label')
  final StatusLabel? statusLabel;
  final List<dynamic>? images;
  @JsonKey(name: 'main_image')
  final String? mainImage;
  @JsonKey(name: 'video_file')
  final dynamic videoFile;
  final bool? video;
  @JsonKey(name: 'total_likes')
  final dynamic totalLikes;
  @JsonKey(name: 'total_wishlist')
  final dynamic totalWishlist;
  @JsonKey(name: 'auction_liked')
  final bool? auctionLiked;
  @JsonKey(name: 'auction_wishlisted')
  final bool? auctionWishlisted;
  final bool? calendar;
  @JsonKey(name: 'total_views')
  final dynamic totalViews;
  final dynamic latitude;
  final dynamic longitude;
  @JsonKey(name: 'contract_number')
  final dynamic contractNumber;
  @JsonKey(name: 'payment_type')
  final String? paymentType;
  @JsonKey(name: 'payment_amount')
  final dynamic paymentAmount;
  @JsonKey(name: 'auto_approval')
  final dynamic autoApproval;
  @JsonKey(name: 'is_a_group')
  final bool? isAGroup;
  @JsonKey(name: 'group_image')
  final String? groupImage;
  @JsonKey(name: 'group_name')
  final String? groupName;
  @JsonKey(name: 'group_name_ar')
  final String? groupNameAr;
  @JsonKey(name: 'auctions_count')
  final dynamic auctionsCount;
  @JsonKey(name: 'registartion_status')
  final String? registartionStatus;
  @JsonKey(name: 'my_rank')
  final dynamic myRank;
  @JsonKey(name: 'days_remaining')
  final dynamic daysRemaining;
  // @JsonKey(name: 'winner_file')
  // final bool? winnerFile;
  final dynamic location;
  @JsonKey(name: 'location_ar')
  final dynamic locationAr;
  @JsonKey(name: 'is_enrolled')
  final bool? isEnrolled;
  @JsonKey(name: 'is_enroll_requested')
  final bool? isEnrollRequested;
  @JsonKey(name: 'is_visit_initiated')
  final bool? isVisitInitiated;
  @JsonKey(name: 'visit_status')
  final String? visitStatus;
  @JsonKey(name: 'first_auction_id')
  final dynamic firstAuctionId;
  final dynamic invoice;
  @JsonKey(name: 'client_name')
  final dynamic clientName;
  @JsonKey(name: 'bank_name')
  final dynamic bankName;
  @JsonKey(name: 'bank_account')
  final dynamic bankAccount;
  @JsonKey(name: 'inv_amount_words')
  final dynamic invAmountWords;
  @JsonKey(name: 'inv_title')
  final dynamic invTitle;
  @JsonKey(name: 'inv_remarks')
  final dynamic invRemarks;
  @JsonKey(
    name: 'file_additional_information',
    fromJson: AuctionData._toStringOrNull,
  )
  final dynamic? fileAdditionalInformation;
  @JsonKey(name: 'client_paid_amount')
  final dynamic clientPaidAmount;
  @JsonKey(name: 'approve_status')
  final dynamic approveStatus;
  @JsonKey(name: 'rejected_date')
  final dynamic rejectedDate;
  @JsonKey(name: 'approved_by')
  final dynamic approvedBy;
  @JsonKey(name: 'approved_date')
  final dynamic approvedDate;
  @JsonKey(name: 'target_amount', fromJson: _stringFromIntOrString)
  final String? targetAmount;
  @JsonKey(name: 'auto_bid_increment')
  final dynamic autoBidIncrement;
  @JsonKey(name: 'enabled_auto_bidding')
  final bool? enabledAutoBidding;
  // @JsonKey(name: 'file_approved_doc', fromJson: AuctionData._toStringOrNull)
  // final bool? fileApprovedDoc;
  // @JsonKey(name: 'file_reauction_doc', fromJson: AuctionData._toStringOrNull)
  // final bool? fileReauctionDoc;
  // @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  @JsonKey(name: 'server_time')
  final String? serverTime;
  @JsonKey(name: 'is_vat_included')
  final dynamic isVatIncluded;
  @JsonKey(name: 'is_service_charge_included')
  final dynamic isServiceChargeIncluded;
  @JsonKey(name: 'is_service_charge_vat_included')
  final dynamic isServiceChargeVatIncluded;
  @JsonKey(name: 'withdraw_status')
  final dynamic withdrawStatus;
  @JsonKey(name: 'withdrawn_amount_client')
  final dynamic withdrawnAmountClient;
  final List<dynamic>? participants;
  @JsonKey(name: 'location_id')
  final dynamic locationId;
  @JsonKey(name: 'loc_info')
  final dynamic locInfo;
  @JsonKey(name: 'department_id')
  final dynamic departmentId;
  @JsonKey(name: 'dep_info')
  final dynamic depInfo;
  @JsonKey(name: 'no_of_days')
  final dynamic noOfDays;

  AuctionData({
    required this.id,
    this.auctionNumber,
    this.category,
    this.categoryDetails,
    this.organization,
    this.organizationDetails,
    this.hasAutoBidding,
    this.order,
    this.title,
    this.titleAr,
    this.description,
    this.descriptionAr,
    this.details,
    this.downloads,
    this.terms,
    this.termsArabic,
    this.fileTerms,
    this.filePaymentTerms,
    this.package,
    this.group,
    this.groupInfo,
    this.phoneNumber,
    this.mask,
    this.class_,
    this.startAmount,
    this.targetAmountInd,
    this.guaranteeAmount,
    this.visitAmount,
    this.isVisitActive,
    this.currentAmount,
    this.bidIncrement,
    this.incrementNumbers,
    this.bidCount,
    this.startDate,
    this.startDateAr,
    this.endDate,
    this.endDateAr,
    this.startDateFormatted,
    this.endDateFormatted,
    this.regStartDate,
    this.regEndDate,
    this.regStartDateFormatted,
    this.regStartDateAr,
    this.regEndDateFormatted,
    this.regEndDateAr,
    this.isGrouped,
    this.isGroupedEnroll,
    this.enrollCloseDate,
    this.isFeatured,
    this.isDirectSale,
    this.isZakath,
    this.isVehicle,
    this.vehicleInfo,
    this.vat,
    this.status,
    this.statusDis,
    this.statusLabel,
    this.images,
    this.mainImage,
    this.videoFile,
    this.video,
    this.totalLikes,
    this.totalWishlist,
    this.auctionLiked,
    this.auctionWishlisted,
    this.calendar,
    this.totalViews,
    this.latitude,
    this.longitude,
    this.contractNumber,
    this.paymentType,
    this.paymentAmount,
    this.autoApproval,
    this.isAGroup,
    this.groupImage,
    this.groupName,
    this.groupNameAr,
    this.auctionsCount,
    this.registartionStatus,
    this.myRank,
    this.daysRemaining,
    // this.winnerFile,
    this.location,
    this.locationAr,
    this.isEnrolled,
    this.isEnrollRequested,
    this.isVisitInitiated,
    this.visitStatus,
    this.firstAuctionId,
    this.invoice,
    this.clientName,
    this.bankName,
    this.bankAccount,
    this.invAmountWords,
    this.invTitle,
    this.invRemarks,
    this.fileAdditionalInformation,
    this.clientPaidAmount,
    this.approveStatus,
    this.rejectedDate,
    this.approvedBy,
    this.approvedDate,
    this.targetAmount,
    this.autoBidIncrement,
    this.enabledAutoBidding,
    // this.fileApprovedDoc,
    // this.fileReauctionDoc,
    this.createdAt,
    this.updatedAt,
    this.serverTime,
    this.isVatIncluded,
    this.isServiceChargeIncluded,
    this.isServiceChargeVatIncluded,
    this.withdrawStatus,
    this.withdrawnAmountClient,
    this.participants,
    this.locationId,
    this.locInfo,
    this.departmentId,
    this.depInfo,
    this.noOfDays,
  });

  factory AuctionData.fromJson(Map<String, dynamic> json) =>
      _$AuctionDataFromJson(json);

  Map<String, dynamic> toJson() => _$AuctionDataToJson(this);

  static String? _stringFromIntOrString(dynamic value) {
    if (value is int) {
      return value.toString();
    } else if (value is String) {
      return value;
    }
    return null;
  }

  static String? _toStringOrNull(dynamic value) {
    if (value == null || value == false) return null;
    if (value is String && value.isNotEmpty) return value;
    return null;
  }
}

@JsonSerializable()
class CategoryDetails {
  final int id;
  @JsonKey(name: 'category_name')
  final String? categoryName; // Nullable
  @JsonKey(name: 'category_name_ar')
  final String? categoryNameAr; // Nullable
  final String? description; // Nullable
  @JsonKey(name: 'description_ar')
  final String? descriptionAr; // Nullable
  @JsonKey(name: 'file_category_image')
  final String? fileCategoryImage; // Nullable
  final String? icon; // Nullable
  final bool? isMultiple; // Nullable
  // final int? isNumber; // Nullable
  final bool? isVehicle; // Nullable
  @JsonKey(name: 'created_at')
  final String? createdAt; // Nullable
  @JsonKey(name: 'updated_at')
  final String? updatedAt; // Nullable

  CategoryDetails({
    required this.id,
    this.categoryName,
    this.categoryNameAr,
    this.description,
    this.descriptionAr,
    this.fileCategoryImage,
    this.icon,
    this.isMultiple,
    // this.isNumber,
    this.isVehicle,
    this.createdAt,
    this.updatedAt,
  });

  factory CategoryDetails.fromJson(Map<String, dynamic> json) =>
      _$CategoryDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryDetailsToJson(this);
}

@JsonSerializable()
class OrganizationDetails {
  final int? id;
  @JsonKey(name: 'organization_name')
  final String? organizationName;
  @JsonKey(name: 'organization_name_ar')
  final String? organizationNameAr;
  @JsonKey(name: 'file_organization_image')
  final String? fileOrganizationImage;
  final String? description;
  @JsonKey(name: 'description_ar')
  final String? descriptionAr;
  final String? terms;
  @JsonKey(name: 'is_client')
  final int? isClient;
  @JsonKey(name: 'client_type')
  final String? clientType;
  @JsonKey(name: 'contact_number')
  final String? contactNumber;
  @JsonKey(name: 'focal_point_name')
  final String? focalPointName;
  final int? user;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  @JsonKey(name: 'file_organization_image_full')
  final String? fileOrganizationImageFull;

  OrganizationDetails({
    this.id,
    this.organizationName,
    this.organizationNameAr,
    this.fileOrganizationImage,
    this.description,
    this.descriptionAr,
    this.terms,
    this.isClient,
    this.clientType,
    this.contactNumber,
    this.focalPointName,
    this.user,
    this.createdAt,
    this.updatedAt,
    this.fileOrganizationImageFull,
  });

  factory OrganizationDetails.fromJson(Map<String, dynamic> json) =>
      _$OrganizationDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$OrganizationDetailsToJson(this);
}

//

@JsonSerializable()
class GroupInfo {
  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'request_id')
  final int? requestId;

  @JsonKey(name: 'organization')
  final int? organization;

  @JsonKey(name: 'has_auto_bidding')
  final int? hasAutoBidding;

  @JsonKey(name: 'group_name')
  final String? groupName;

  @JsonKey(name: 'group_name_ar')
  final String? groupNameAr;

  @JsonKey(name: 'image')
  final String? image;

  @JsonKey(name: 'vat')
  final String? vat;

  @JsonKey(name: 'service_charge')
  final String? serviceCharge;

  @JsonKey(name: 'client_service_charge')
  final String? clientServiceCharge;

  @JsonKey(name: 'manager')
  final int? manager;

  @JsonKey(name: 'hse')
  final int? hse;

  @JsonKey(name: 'is_auctions_grouped')
  final int? isAuctionsGrouped;

  @JsonKey(name: 'is_grouped_enroll')
  final int? isGroupedEnroll;

  @JsonKey(name: 'start_date')
  final String? startDate;

  @JsonKey(name: 'reg_start_date')
  final String? regStartDate;

  @JsonKey(name: 'reg_end_date')
  final String? regEndDate;

  @JsonKey(name: 'end_date')
  final String? endDate;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'description_ar')
  final String? descriptionAr;

  // @JsonKey(name: 'enquiry')
  // final String? enquiry;

  @JsonKey(name: 'terms')
  final String? terms;

  @JsonKey(name: 'terms_arabic')
  final String? termsArabic;

  @JsonKey(name: 'file_terms', fromJson: AuctionData._toStringOrNull)
  final String? fileTerms;

  @JsonKey(name: 'file_payment_terms', fromJson: AuctionData._toStringOrNull)
  final String? filePaymentTerms;

  @JsonKey(name: 'amount')
  final String? amount;

  @JsonKey(name: 'start_amount')
  final dynamic startAmount;

  @JsonKey(name: 'guarantee_amount')
  final String? guaranteeAmount;

  @JsonKey(name: 'target_amount')
  final String? targetAmount;

  @JsonKey(name: 'visit_amount')
  final String? visitAmount;

  @JsonKey(name: 'payment_type')
  final String? paymentType;

  @JsonKey(name: 'extra_time')
  final String? extraTime;

  @JsonKey(name: 'is_extra_time')
  final dynamic isExtraTime;

  @JsonKey(name: 'is_vat_included')
  final int? isVatIncluded;

  @JsonKey(name: 'is_service_charge_included')
  final int? isServiceChargeIncluded;

  @JsonKey(name: 'is_service_charge_vat_included')
  final int? isServiceChargeVatIncluded;

  @JsonKey(name: 'invoice')
  final String? invoice;

  @JsonKey(name: 'client_name')
  final String? clientName;

  @JsonKey(name: 'bank_name')
  final String? bankName;

  @JsonKey(name: 'bank_account')
  final String? bankAccount;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  @JsonKey(name: 'can_online')
  final bool? canOnline;
  @JsonKey(name: 'can_wallet')
  final bool? canWallet;
  @JsonKey(name: 'can_offline')
  final bool? canOffline;

  GroupInfo({
    required this.id,
    this.requestId,
    this.organization,
    this.hasAutoBidding,
    this.groupName,
    this.groupNameAr,
    this.image,
    this.vat,
    this.serviceCharge,
    this.clientServiceCharge,
    this.manager,
    this.hse,
    this.isAuctionsGrouped,
    this.isGroupedEnroll,
    this.startDate,
    this.regStartDate,
    this.regEndDate,
    this.endDate,
    this.description,
    this.descriptionAr,
    // this.enquiry,
    this.terms,
    this.termsArabic,
    this.fileTerms,
    this.filePaymentTerms,
    this.amount,
    this.startAmount,
    this.guaranteeAmount,
    this.targetAmount,
    this.visitAmount,
    this.paymentType,
    this.extraTime,
    this.isExtraTime,
    this.isVatIncluded,
    this.isServiceChargeIncluded,
    this.isServiceChargeVatIncluded,
    this.invoice,
    this.clientName,
    this.bankName,
    this.bankAccount,
    this.createdAt,
    this.updatedAt,
    this.canOnline,
    this.canWallet,
    this.canOffline,
  });

  factory GroupInfo.fromJson(Map<String, dynamic> json) =>
      _$GroupInfoFromJson(json);

  Map<String, dynamic> toJson() => _$GroupInfoToJson(this);
}

//
@JsonSerializable()
class EndDateAr {
  final String? day;
  final String? date;
  final String? time;

  EndDateAr({this.day, this.date, this.time});

  factory EndDateAr.fromJson(Map<String, dynamic> json) =>
      _$EndDateArFromJson(json);

  Map<String, dynamic> toJson() => _$EndDateArToJson(this);
}

//
@JsonSerializable()
class StartDateAr {
  final String? day;
  final String? date;
  final String? time;

  StartDateAr({this.day, this.date, this.time});

  factory StartDateAr.fromJson(Map<String, dynamic> json) =>
      _$StartDateArFromJson(json);

  Map<String, dynamic> toJson() => _$StartDateArToJson(this);
}

//

@JsonSerializable()
class RegEndDateAr {
  final String? day;
  final String? date;
  final String? time;

  RegEndDateAr({this.day, this.date, this.time});

  factory RegEndDateAr.fromJson(Map<String, dynamic> json) =>
      _$RegEndDateArFromJson(json);

  Map<String, dynamic> toJson() => _$RegEndDateArToJson(this);
}

//

@JsonSerializable()
class RegStartDateAr {
  final String? day;
  final String? date;
  final String? time;

  RegStartDateAr({this.day, this.date, this.time});

  factory RegStartDateAr.fromJson(Map<String, dynamic> json) =>
      _$RegStartDateArFromJson(json);

  Map<String, dynamic> toJson() => _$RegStartDateArToJson(this);
}

//
@JsonSerializable()
class StatusLabel {
  final String? status;
  final String? en;
  final String? ar;
  final String? dt;

  StatusLabel({this.status, this.en, this.ar, this.dt});

  factory StatusLabel.fromJson(Map<String, dynamic> json) =>
      _$StatusLabelFromJson(json);

  Map<String, dynamic> toJson() => _$StatusLabelToJson(this);
}
