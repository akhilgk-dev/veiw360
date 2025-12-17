import 'package:json_annotation/json_annotation.dart';
part 'upcoming_auctions_model.g.dart';

@JsonSerializable()
class UpcomingAuctionResponse {
  final bool success;
  @JsonKey(name: 'data')
  final List<AuctionData>? auctionData; // Nullable
  @JsonKey(name: 'extra_data')
  final List<dynamic>? extraData; // Nullable
  final String? message; // Nullable

  UpcomingAuctionResponse({
    required this.success,
    this.auctionData,
    this.extraData,
    this.message,
  });

  factory UpcomingAuctionResponse.fromJson(Map<String, dynamic> json) =>
      _$UpcomingAuctionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UpcomingAuctionResponseToJson(this);
}

@JsonSerializable()
class AuctionData {
  final int id;
  @JsonKey(name: 'auction_number')
  final String? auctionNumber; // Nullable
  final dynamic category; // Already nullable
  @JsonKey(name: 'categoryDetails')
  final CategoryDetails? categoryDetails; // Nullable
  final int? organization; // Nullable
  @JsonKey(name: 'organizationDetails')
  final OrganizationDetails? organizationDetails; // Nullable
  @JsonKey(name: 'has_auto_bidding')
  final int? hasAutoBidding; // Nullable
  final dynamic order; // Already nullable
  final String? title; // Nullable
  @JsonKey(name: 'title_ar')
  final String? titleAr; // Nullable
  final String? description; // Nullable
  @JsonKey(name: 'description_ar')
  final String? descriptionAr; // Nullable
  final dynamic details; // Already nullable
  final dynamic downloads; // Already nullable
  final String? terms; // Nullable
  @JsonKey(name: 'terms_arabic')
  final String? termsArabic; // Nullable
  @JsonKey(name: 'file_terms')
  final dynamic fileTerms; // Nullable
  @JsonKey(name: 'file_payment_terms')
  final dynamic filePaymentTerms; // Nullable
  final dynamic package; // Already nullable
  final int? group; // Nullable
  @JsonKey(name: 'group_info')
  final GroupInfo? groupInfo; // Nullable
  @JsonKey(name: 'phone_number')
  final dynamic phoneNumber; // Already nullable
  final dynamic mask; // Already nullable
  @JsonKey(name: 'class')
  final dynamic class_; // Already nullable
  @JsonKey(name: 'start_amount')
  final int? startAmount; // Nullable
  @JsonKey(name: 'target_amount_ind')
  final String? targetAmountInd; // Nullable
  @JsonKey(name: 'guarantee_amount')
  final dynamic guaranteeAmount; // Already nullable
  @JsonKey(name: 'visit_amount')
  final String? visitAmount; // Nullable
  @JsonKey(name: 'is_visit_active')
  final bool? isVisitActive; // Nullable
  @JsonKey(name: 'current_amount')
  final int? currentAmount; // Nullable
  @JsonKey(name: 'bid_increment')
  final dynamic bidIncrement; // Already nullable
  @JsonKey(name: 'increment_numbers')
  final List<String>? incrementNumbers; // Nullable
  @JsonKey(name: 'bid_count')
  final int? bidCount; // Nullable
  @JsonKey(name: 'start_date')
  final String? startDate; // Nullable
  @JsonKey(name: 'start_date_ar')
  final StartDateAr? startDateAr; // Nullable
  @JsonKey(name: 'end_date')
  final String? endDate; // Nullable
  @JsonKey(name: 'end_date_ar')
  final EndDateAr? endDateAr; // Nullable
  @JsonKey(name: 'start_date_formatted')
  final String? startDateFormatted; // Nullable
  @JsonKey(name: 'end_date_formatted')
  final String? endDateFormatted; // Nullable
  @JsonKey(name: 'reg_start_date')
  final String? regStartDate; // Nullable
  @JsonKey(name: 'reg_end_date')
  final String? regEndDate; // Nullable
  @JsonKey(name: 'reg_start_date_formatted')
  final String? regStartDateFormatted; // Nullable
  @JsonKey(name: 'reg_start_date_ar')
  final RegStartDateAr? regStartDateAr; // Nullable
  @JsonKey(name: 'reg_end_date_formatted')
  final String? regEndDateFormatted; // Nullable
  @JsonKey(name: 'reg_end_date_ar')
  final RegEndDateAr? regEndDateAr; // Nullable
  @JsonKey(name: 'is_grouped')
  final int? isGrouped; // Nullable
  @JsonKey(name: 'is_grouped_enroll')
  final int? isGroupedEnroll; // Nullable
  @JsonKey(name: 'enroll_close_date')
  final String? enrollCloseDate; // Nullable
  @JsonKey(name: 'is_featured')
  final dynamic isFeatured; // Already nullable
  @JsonKey(name: 'is_direct_sale')
  final dynamic isDirectSale; // Already nullable
  @JsonKey(name: 'is_zakath')
  final dynamic isZakath; // Already nullable
  @JsonKey(name: 'is_vehicle')
  final dynamic isVehicle; // Already nullable
  @JsonKey(name: 'vehicle_info')
  final dynamic vehicleInfo; // Already nullable
  final String? vat; // Nullable
  final dynamic status; // Already nullable
  @JsonKey(name: 'status_dis')
  final String? statusDis; // Nullable
  @JsonKey(name: 'status_label')
  final StatusLabel? statusLabel; // Nullable
  final List<dynamic>? images; // Nullable
  @JsonKey(name: 'main_image')
  final String? mainImage; // Nullable
  @JsonKey(name: 'video_file')
  final dynamic videoFile; // Already nullable
  final bool? video; // Nullable
  @JsonKey(name: 'total_likes')
  final int? totalLikes; // Nullable
  @JsonKey(name: 'total_wishlist')
  final int? totalWishlist; // Nullable
  @JsonKey(name: 'auction_liked')
  final bool? auctionLiked; // Nullable
  @JsonKey(name: 'auction_wishlisted')
  final bool? auctionWishlisted; // Nullable
  final bool? calendar; // Nullable
  @JsonKey(name: 'total_views')
  final int? totalViews; // Nullable
  final dynamic latitude; // Already nullable
  final dynamic longitude; // Already nullable
  @JsonKey(name: 'contract_number')
  final dynamic contractNumber; // Already nullable
  @JsonKey(name: 'payment_type')
  final String? paymentType; // Nullable
  @JsonKey(name: 'payment_amount')
  final dynamic paymentAmount; // Already nullable
  @JsonKey(name: 'auto_approval')
  final dynamic autoApproval; // Already nullable
  @JsonKey(name: 'is_a_group')
  final bool? isAGroup; // Nullable
  @JsonKey(name: 'group_image')
  final String? groupImage; // Nullable
  @JsonKey(name: 'group_name')
  final String? groupName; // Nullable
  @JsonKey(name: 'group_name_ar')
  final String? groupNameAr; // Nullable
  @JsonKey(name: 'auctions_count')
  final int? auctionsCount; // Nullable
  @JsonKey(name: 'registartion_status')
  final String? registartionStatus; // Nullable
  @JsonKey(name: 'my_rank')
  final dynamic myRank; // Already nullable
  @JsonKey(name: 'days_remaining')
  final int? daysRemaining; // Nullable
  // final List<dynamic>? winner; // Nullable
  @JsonKey(name: 'winner_file')
  final bool? winnerFile; // Nullable
  final dynamic location; // Already nullable
  @JsonKey(name: 'location_ar')
  final dynamic locationAr; // Already nullable
  @JsonKey(name: 'is_enrolled')
  final bool? isEnrolled; // Nullable
  @JsonKey(name: 'is_enroll_requested')
  final bool? isEnrollRequested; // Nullable
  @JsonKey(name: 'is_visit_initiated')
  final bool? isVisitInitiated; // Nullable
  @JsonKey(name: 'visit_status')
  final String? visitStatus; // Nullable
  @JsonKey(name: 'first_auction_id')
  final int? firstAuctionId; // Nullable
  final dynamic invoice; // Already nullable
  @JsonKey(name: 'client_name')
  final dynamic clientName; // Already nullable
  @JsonKey(name: 'bank_name')
  final dynamic bankName; // Already nullable
  @JsonKey(name: 'bank_account')
  final dynamic bankAccount; // Already nullable
  @JsonKey(name: 'inv_amount_words')
  final dynamic invAmountWords; // Already nullable
  @JsonKey(name: 'inv_title')
  final dynamic invTitle; // Already nullable
  @JsonKey(name: 'inv_remarks')
  final dynamic invRemarks; // Already nullable
  @JsonKey(name: 'file_additional_information')
  final bool? fileAdditionalInformation; // Nullable
  @JsonKey(name: 'client_paid_amount')
  final int? clientPaidAmount; // Nullable
  @JsonKey(name: 'approve_status')
  final dynamic approveStatus; // Already nullable
  @JsonKey(name: 'rejected_date')
  final dynamic rejectedDate; // Already nullable
  @JsonKey(name: 'approved_by')
  final dynamic approvedBy; // Already nullable
  @JsonKey(name: 'approved_date')
  final dynamic approvedDate; // Already nullable
  @JsonKey(name: 'target_amount')
  final String? targetAmount; // Nullable
  @JsonKey(name: 'auto_bid_increment')
  final int? autoBidIncrement; // Nullable
  @JsonKey(name: 'enabled_auto_bidding')
  final bool? enabledAutoBidding; // Nullable
  @JsonKey(name: 'file_approved_doc')
  final bool? fileApprovedDoc; // Nullable
  @JsonKey(name: 'file_reauction_doc')
  final bool? fileReauctionDoc; // Nullable
  @JsonKey(name: 'created_at')
  final String? createdAt; // Nullable
  @JsonKey(name: 'updated_at')
  final String? updatedAt; // Nullable
  @JsonKey(name: 'server_time')
  final String? serverTime; // Nullable
  @JsonKey(name: 'is_vat_included')
  final int? isVatIncluded; // Nullable
  @JsonKey(name: 'is_service_charge_included')
  final int? isServiceChargeIncluded; // Nullable
  @JsonKey(name: 'is_service_charge_vat_included')
  final int? isServiceChargeVatIncluded; // Nullable
  @JsonKey(name: 'withdraw_status')
  final dynamic withdrawStatus; // Already nullable
  @JsonKey(name: 'withdrawn_amount_client')
  final int? withdrawnAmountClient; // Nullable
  final List<dynamic>? participants; // Nullable
  @JsonKey(name: 'location_id')
  final dynamic locationId; // Already nullable
  @JsonKey(name: 'loc_info')
  final dynamic locInfo; // Already nullable
  @JsonKey(name: 'department_id')
  final dynamic departmentId; // Already nullable
  @JsonKey(name: 'dep_info')
  final dynamic depInfo; // Already nullable
  @JsonKey(name: 'no_of_days')
  final int? noOfDays; // Nullable

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
    // this.winner,
    this.winnerFile,
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
    this.fileApprovedDoc,
    this.fileReauctionDoc,
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
  final int? isNumber; // Nullable
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
    this.isNumber,
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

  @JsonKey(name: 'enquiry')
  final String? enquiry;

  @JsonKey(name: 'terms')
  final String? terms;

  @JsonKey(name: 'terms_arabic')
  final String? termsArabic;

  @JsonKey(name: 'file_terms')
  final String? fileTerms;

  @JsonKey(name: 'file_payment_terms')
  final String? filePaymentTerms;

  @JsonKey(name: 'amount')
  final String? amount;

  @JsonKey(name: 'start_amount')
  final String? startAmount;

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
  final int? isExtraTime;

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
    this.enquiry,
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

  EndDateAr({
    this.day,
    this.date,
    this.time,
  });

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

  StartDateAr({
    this.day,
    this.date,
    this.time,
  });

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

  RegEndDateAr({
    this.day,
    this.date,
    this.time,
  });

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

  RegStartDateAr({
    this.day,
    this.date,
    this.time,
  });

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

  StatusLabel({
    this.status,
    this.en,
    this.ar,
    this.dt,
  });

  factory StatusLabel.fromJson(Map<String, dynamic> json) =>
      _$StatusLabelFromJson(json);

  Map<String, dynamic> toJson() => _$StatusLabelToJson(this);
}
