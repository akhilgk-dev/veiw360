// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_auctions_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuctionResponse _$AuctionResponseFromJson(Map<String, dynamic> json) =>
    AuctionResponse(
      success: json['success'] as bool,
      auctionData: (json['data'] as List<dynamic>?)
          ?.map((e) => AuctionData.fromJson(e as Map<String, dynamic>))
          .toList(),
      extraData: json['extra_data'] as List<dynamic>?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$AuctionResponseToJson(AuctionResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.auctionData,
      'extra_data': instance.extraData,
      'message': instance.message,
    };

AuctionData _$AuctionDataFromJson(Map<String, dynamic> json) => AuctionData(
  id: json['id'],
  auctionNumber: json['auction_number'] as String?,
  category: json['category'],
  categoryDetails: json['categoryDetails'] == null
      ? null
      : CategoryDetails.fromJson(
          json['categoryDetails'] as Map<String, dynamic>,
        ),
  organization: json['organization'],
  organizationDetails: json['organizationDetails'] == null
      ? null
      : OrganizationDetails.fromJson(
          json['organizationDetails'] as Map<String, dynamic>,
        ),
  hasAutoBidding: json['has_auto_bidding'],
  order: json['order'],
  title: json['title'] as String?,
  titleAr: json['title_ar'] as String?,
  description: json['description'] as String?,
  descriptionAr: json['description_ar'] as String?,
  details: json['details'],
  downloads: json['downloads'],
  terms: json['terms'] as String?,
  termsArabic: json['terms_arabic'] as String?,
  fileTerms: json['file_terms'],
  filePaymentTerms: json['file_payment_terms'],
  package: json['package'],
  group: json['group'],
  groupInfo: json['group_info'] == null
      ? null
      : GroupInfo.fromJson(json['group_info'] as Map<String, dynamic>),
  phoneNumber: json['phone_number'],
  mask: json['mask'],
  class_: json['class'],
  startAmount: json['start_amount'],
  targetAmountInd: json['target_amount_ind'] as String?,
  guaranteeAmount: json['guarantee_amount'],
  visitAmount: json['visit_amount'] as String?,
  isVisitActive: json['is_visit_active'] as bool?,
  currentAmount: json['current_amount'],
  bidIncrement: json['bid_increment'],
  incrementNumbers: (json['increment_numbers'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  bidCount: json['bid_count'],
  startDate: json['start_date'] as String?,
  startDateAr: json['start_date_ar'] == null
      ? null
      : StartDateAr.fromJson(json['start_date_ar'] as Map<String, dynamic>),
  endDate: json['end_date'] as String?,
  endDateAr: json['end_date_ar'] == null
      ? null
      : EndDateAr.fromJson(json['end_date_ar'] as Map<String, dynamic>),
  startDateFormatted: json['start_date_formatted'] as String?,
  endDateFormatted: json['end_date_formatted'] as String?,
  regStartDate: json['reg_start_date'] as String?,
  regEndDate: json['reg_end_date'] as String?,
  regStartDateFormatted: json['reg_start_date_formatted'] as String?,
  regStartDateAr: json['reg_start_date_ar'] == null
      ? null
      : RegStartDateAr.fromJson(
          json['reg_start_date_ar'] as Map<String, dynamic>,
        ),
  regEndDateFormatted: json['reg_end_date_formatted'] as String?,
  regEndDateAr: json['reg_end_date_ar'] == null
      ? null
      : RegEndDateAr.fromJson(json['reg_end_date_ar'] as Map<String, dynamic>),
  isGrouped: json['is_grouped'],
  isGroupedEnroll: json['is_grouped_enroll'],
  enrollCloseDate: json['enroll_close_date'] as String?,
  isFeatured: json['is_featured'],
  isDirectSale: json['is_direct_sale'],
  isZakath: json['is_zakath'],
  isVehicle: json['is_vehicle'],
  vehicleInfo: json['vehicle_info'],
  vat: json['vat'] as String?,
  status: json['status'],
  statusDis: json['status_dis'] as String?,
  statusLabel: json['status_label'] == null
      ? null
      : StatusLabel.fromJson(json['status_label'] as Map<String, dynamic>),
  images: json['images'] as List<dynamic>?,
  mainImage: json['main_image'] as String?,
  videoFile: json['video_file'],
  video: json['video'] as bool?,
  totalLikes: json['total_likes'],
  totalWishlist: json['total_wishlist'],
  auctionLiked: json['auction_liked'] as bool?,
  auctionWishlisted: json['auction_wishlisted'] as bool?,
  calendar: json['calendar'] as bool?,
  totalViews: json['total_views'],
  latitude: json['latitude'],
  longitude: json['longitude'],
  contractNumber: json['contract_number'],
  paymentType: json['payment_type'] as String?,
  paymentAmount: json['payment_amount'],
  autoApproval: json['auto_approval'],
  isAGroup: json['is_a_group'] as bool?,
  groupImage: json['group_image'] as String?,
  groupName: json['group_name'] as String?,
  groupNameAr: json['group_name_ar'] as String?,
  auctionsCount: json['auctions_count'],
  registartionStatus: json['registartion_status'] as String?,
  myRank: json['my_rank'],
  daysRemaining: json['days_remaining'],
  location: json['location'],
  locationAr: json['location_ar'],
  isEnrolled: json['is_enrolled'] as bool?,
  isEnrollRequested: json['is_enroll_requested'] as bool?,
  isVisitInitiated: json['is_visit_initiated'] as bool?,
  visitStatus: json['visit_status'] as String?,
  firstAuctionId: json['first_auction_id'],
  invoice: json['invoice'],
  clientName: json['client_name'],
  bankName: json['bank_name'],
  bankAccount: json['bank_account'],
  invAmountWords: json['inv_amount_words'],
  invTitle: json['inv_title'],
  invRemarks: json['inv_remarks'],
  fileAdditionalInformation: AuctionData._toStringOrNull(
    json['file_additional_information'],
  ),
  clientPaidAmount: json['client_paid_amount'],
  approveStatus: json['approve_status'],
  rejectedDate: json['rejected_date'],
  approvedBy: json['approved_by'],
  approvedDate: json['approved_date'],
  targetAmount: AuctionData._stringFromIntOrString(json['target_amount']),
  autoBidIncrement: json['auto_bid_increment'],
  enabledAutoBidding: json['enabled_auto_bidding'] as bool?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updated_at'] as String?,
  serverTime: json['server_time'] as String?,
  isVatIncluded: json['is_vat_included'],
  isServiceChargeIncluded: json['is_service_charge_included'],
  isServiceChargeVatIncluded: json['is_service_charge_vat_included'],
  withdrawStatus: json['withdraw_status'],
  withdrawnAmountClient: json['withdrawn_amount_client'],
  participants: json['participants'] as List<dynamic>?,
  locationId: json['location_id'],
  locInfo: json['loc_info'],
  departmentId: json['department_id'],
  depInfo: json['dep_info'],
  noOfDays: json['no_of_days'],
);

Map<String, dynamic> _$AuctionDataToJson(AuctionData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'auction_number': instance.auctionNumber,
      'category': instance.category,
      'categoryDetails': instance.categoryDetails,
      'organization': instance.organization,
      'organizationDetails': instance.organizationDetails,
      'has_auto_bidding': instance.hasAutoBidding,
      'order': instance.order,
      'title': instance.title,
      'title_ar': instance.titleAr,
      'description': instance.description,
      'description_ar': instance.descriptionAr,
      'details': instance.details,
      'downloads': instance.downloads,
      'terms': instance.terms,
      'terms_arabic': instance.termsArabic,
      'file_terms': instance.fileTerms,
      'file_payment_terms': instance.filePaymentTerms,
      'package': instance.package,
      'group': instance.group,
      'group_info': instance.groupInfo,
      'phone_number': instance.phoneNumber,
      'mask': instance.mask,
      'class': instance.class_,
      'start_amount': instance.startAmount,
      'target_amount_ind': instance.targetAmountInd,
      'guarantee_amount': instance.guaranteeAmount,
      'visit_amount': instance.visitAmount,
      'is_visit_active': instance.isVisitActive,
      'current_amount': instance.currentAmount,
      'bid_increment': instance.bidIncrement,
      'increment_numbers': instance.incrementNumbers,
      'bid_count': instance.bidCount,
      'start_date': instance.startDate,
      'start_date_ar': instance.startDateAr,
      'end_date': instance.endDate,
      'end_date_ar': instance.endDateAr,
      'start_date_formatted': instance.startDateFormatted,
      'end_date_formatted': instance.endDateFormatted,
      'reg_start_date': instance.regStartDate,
      'reg_end_date': instance.regEndDate,
      'reg_start_date_formatted': instance.regStartDateFormatted,
      'reg_start_date_ar': instance.regStartDateAr,
      'reg_end_date_formatted': instance.regEndDateFormatted,
      'reg_end_date_ar': instance.regEndDateAr,
      'is_grouped': instance.isGrouped,
      'is_grouped_enroll': instance.isGroupedEnroll,
      'enroll_close_date': instance.enrollCloseDate,
      'is_featured': instance.isFeatured,
      'is_direct_sale': instance.isDirectSale,
      'is_zakath': instance.isZakath,
      'is_vehicle': instance.isVehicle,
      'vehicle_info': instance.vehicleInfo,
      'vat': instance.vat,
      'status': instance.status,
      'status_dis': instance.statusDis,
      'status_label': instance.statusLabel,
      'images': instance.images,
      'main_image': instance.mainImage,
      'video_file': instance.videoFile,
      'video': instance.video,
      'total_likes': instance.totalLikes,
      'total_wishlist': instance.totalWishlist,
      'auction_liked': instance.auctionLiked,
      'auction_wishlisted': instance.auctionWishlisted,
      'calendar': instance.calendar,
      'total_views': instance.totalViews,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'contract_number': instance.contractNumber,
      'payment_type': instance.paymentType,
      'payment_amount': instance.paymentAmount,
      'auto_approval': instance.autoApproval,
      'is_a_group': instance.isAGroup,
      'group_image': instance.groupImage,
      'group_name': instance.groupName,
      'group_name_ar': instance.groupNameAr,
      'auctions_count': instance.auctionsCount,
      'registartion_status': instance.registartionStatus,
      'my_rank': instance.myRank,
      'days_remaining': instance.daysRemaining,
      'location': instance.location,
      'location_ar': instance.locationAr,
      'is_enrolled': instance.isEnrolled,
      'is_enroll_requested': instance.isEnrollRequested,
      'is_visit_initiated': instance.isVisitInitiated,
      'visit_status': instance.visitStatus,
      'first_auction_id': instance.firstAuctionId,
      'invoice': instance.invoice,
      'client_name': instance.clientName,
      'bank_name': instance.bankName,
      'bank_account': instance.bankAccount,
      'inv_amount_words': instance.invAmountWords,
      'inv_title': instance.invTitle,
      'inv_remarks': instance.invRemarks,
      'file_additional_information': instance.fileAdditionalInformation,
      'client_paid_amount': instance.clientPaidAmount,
      'approve_status': instance.approveStatus,
      'rejected_date': instance.rejectedDate,
      'approved_by': instance.approvedBy,
      'approved_date': instance.approvedDate,
      'target_amount': instance.targetAmount,
      'auto_bid_increment': instance.autoBidIncrement,
      'enabled_auto_bidding': instance.enabledAutoBidding,
      'createdAt': instance.createdAt,
      'updated_at': instance.updatedAt,
      'server_time': instance.serverTime,
      'is_vat_included': instance.isVatIncluded,
      'is_service_charge_included': instance.isServiceChargeIncluded,
      'is_service_charge_vat_included': instance.isServiceChargeVatIncluded,
      'withdraw_status': instance.withdrawStatus,
      'withdrawn_amount_client': instance.withdrawnAmountClient,
      'participants': instance.participants,
      'location_id': instance.locationId,
      'loc_info': instance.locInfo,
      'department_id': instance.departmentId,
      'dep_info': instance.depInfo,
      'no_of_days': instance.noOfDays,
    };

CategoryDetails _$CategoryDetailsFromJson(Map<String, dynamic> json) =>
    CategoryDetails(
      id: (json['id'] as num).toInt(),
      categoryName: json['category_name'] as String?,
      categoryNameAr: json['category_name_ar'] as String?,
      description: json['description'] as String?,
      descriptionAr: json['description_ar'] as String?,
      fileCategoryImage: json['file_category_image'] as String?,
      icon: json['icon'] as String?,
      isMultiple: json['isMultiple'] as bool?,
      isVehicle: json['isVehicle'] as bool?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$CategoryDetailsToJson(CategoryDetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category_name': instance.categoryName,
      'category_name_ar': instance.categoryNameAr,
      'description': instance.description,
      'description_ar': instance.descriptionAr,
      'file_category_image': instance.fileCategoryImage,
      'icon': instance.icon,
      'isMultiple': instance.isMultiple,
      'isVehicle': instance.isVehicle,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

OrganizationDetails _$OrganizationDetailsFromJson(Map<String, dynamic> json) =>
    OrganizationDetails(
      id: (json['id'] as num?)?.toInt(),
      organizationName: json['organization_name'] as String?,
      organizationNameAr: json['organization_name_ar'] as String?,
      fileOrganizationImage: json['file_organization_image'] as String?,
      description: json['description'] as String?,
      descriptionAr: json['description_ar'] as String?,
      terms: json['terms'] as String?,
      isClient: (json['is_client'] as num?)?.toInt(),
      clientType: json['client_type'] as String?,
      contactNumber: json['contact_number'] as String?,
      focalPointName: json['focal_point_name'] as String?,
      user: (json['user'] as num?)?.toInt(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      fileOrganizationImageFull:
          json['file_organization_image_full'] as String?,
    );

Map<String, dynamic> _$OrganizationDetailsToJson(
  OrganizationDetails instance,
) => <String, dynamic>{
  'id': instance.id,
  'organization_name': instance.organizationName,
  'organization_name_ar': instance.organizationNameAr,
  'file_organization_image': instance.fileOrganizationImage,
  'description': instance.description,
  'description_ar': instance.descriptionAr,
  'terms': instance.terms,
  'is_client': instance.isClient,
  'client_type': instance.clientType,
  'contact_number': instance.contactNumber,
  'focal_point_name': instance.focalPointName,
  'user': instance.user,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
  'file_organization_image_full': instance.fileOrganizationImageFull,
};

GroupInfo _$GroupInfoFromJson(Map<String, dynamic> json) => GroupInfo(
  id: (json['id'] as num?)?.toInt(),
  requestId: (json['request_id'] as num?)?.toInt(),
  organization: (json['organization'] as num?)?.toInt(),
  hasAutoBidding: (json['has_auto_bidding'] as num?)?.toInt(),
  groupName: json['group_name'] as String?,
  groupNameAr: json['group_name_ar'] as String?,
  image: json['image'] as String?,
  vat: json['vat'] as String?,
  serviceCharge: json['service_charge'] as String?,
  clientServiceCharge: json['client_service_charge'] as String?,
  manager: (json['manager'] as num?)?.toInt(),
  hse: (json['hse'] as num?)?.toInt(),
  isAuctionsGrouped: (json['is_auctions_grouped'] as num?)?.toInt(),
  isGroupedEnroll: (json['is_grouped_enroll'] as num?)?.toInt(),
  startDate: json['start_date'] as String?,
  regStartDate: json['reg_start_date'] as String?,
  regEndDate: json['reg_end_date'] as String?,
  endDate: json['end_date'] as String?,
  description: json['description'] as String?,
  descriptionAr: json['description_ar'] as String?,
  terms: json['terms'] as String?,
  termsArabic: json['terms_arabic'] as String?,
  fileTerms: AuctionData._toStringOrNull(json['file_terms']),
  filePaymentTerms: AuctionData._toStringOrNull(json['file_payment_terms']),
  amount: json['amount'] as String?,
  startAmount: json['start_amount'],
  guaranteeAmount: json['guarantee_amount'] as String?,
  targetAmount: json['target_amount'] as String?,
  visitAmount: json['visit_amount'] as String?,
  paymentType: json['payment_type'] as String?,
  extraTime: json['extra_time'] as String?,
  isExtraTime: json['is_extra_time'],
  isVatIncluded: (json['is_vat_included'] as num?)?.toInt(),
  isServiceChargeIncluded: (json['is_service_charge_included'] as num?)
      ?.toInt(),
  isServiceChargeVatIncluded: (json['is_service_charge_vat_included'] as num?)
      ?.toInt(),
  invoice: json['invoice'] as String?,
  clientName: json['client_name'] as String?,
  bankName: json['bank_name'] as String?,
  bankAccount: json['bank_account'] as String?,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
  canOnline: json['can_online'] as bool?,
  canWallet: json['can_wallet'] as bool?,
  canOffline: json['can_offline'] as bool?,
);

Map<String, dynamic> _$GroupInfoToJson(GroupInfo instance) => <String, dynamic>{
  'id': instance.id,
  'request_id': instance.requestId,
  'organization': instance.organization,
  'has_auto_bidding': instance.hasAutoBidding,
  'group_name': instance.groupName,
  'group_name_ar': instance.groupNameAr,
  'image': instance.image,
  'vat': instance.vat,
  'service_charge': instance.serviceCharge,
  'client_service_charge': instance.clientServiceCharge,
  'manager': instance.manager,
  'hse': instance.hse,
  'is_auctions_grouped': instance.isAuctionsGrouped,
  'is_grouped_enroll': instance.isGroupedEnroll,
  'start_date': instance.startDate,
  'reg_start_date': instance.regStartDate,
  'reg_end_date': instance.regEndDate,
  'end_date': instance.endDate,
  'description': instance.description,
  'description_ar': instance.descriptionAr,
  'terms': instance.terms,
  'terms_arabic': instance.termsArabic,
  'file_terms': instance.fileTerms,
  'file_payment_terms': instance.filePaymentTerms,
  'amount': instance.amount,
  'start_amount': instance.startAmount,
  'guarantee_amount': instance.guaranteeAmount,
  'target_amount': instance.targetAmount,
  'visit_amount': instance.visitAmount,
  'payment_type': instance.paymentType,
  'extra_time': instance.extraTime,
  'is_extra_time': instance.isExtraTime,
  'is_vat_included': instance.isVatIncluded,
  'is_service_charge_included': instance.isServiceChargeIncluded,
  'is_service_charge_vat_included': instance.isServiceChargeVatIncluded,
  'invoice': instance.invoice,
  'client_name': instance.clientName,
  'bank_name': instance.bankName,
  'bank_account': instance.bankAccount,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
  'can_online': instance.canOnline,
  'can_wallet': instance.canWallet,
  'can_offline': instance.canOffline,
};

EndDateAr _$EndDateArFromJson(Map<String, dynamic> json) => EndDateAr(
  day: json['day'] as String?,
  date: json['date'] as String?,
  time: json['time'] as String?,
);

Map<String, dynamic> _$EndDateArToJson(EndDateAr instance) => <String, dynamic>{
  'day': instance.day,
  'date': instance.date,
  'time': instance.time,
};

StartDateAr _$StartDateArFromJson(Map<String, dynamic> json) => StartDateAr(
  day: json['day'] as String?,
  date: json['date'] as String?,
  time: json['time'] as String?,
);

Map<String, dynamic> _$StartDateArToJson(StartDateAr instance) =>
    <String, dynamic>{
      'day': instance.day,
      'date': instance.date,
      'time': instance.time,
    };

RegEndDateAr _$RegEndDateArFromJson(Map<String, dynamic> json) => RegEndDateAr(
  day: json['day'] as String?,
  date: json['date'] as String?,
  time: json['time'] as String?,
);

Map<String, dynamic> _$RegEndDateArToJson(RegEndDateAr instance) =>
    <String, dynamic>{
      'day': instance.day,
      'date': instance.date,
      'time': instance.time,
    };

RegStartDateAr _$RegStartDateArFromJson(Map<String, dynamic> json) =>
    RegStartDateAr(
      day: json['day'] as String?,
      date: json['date'] as String?,
      time: json['time'] as String?,
    );

Map<String, dynamic> _$RegStartDateArToJson(RegStartDateAr instance) =>
    <String, dynamic>{
      'day': instance.day,
      'date': instance.date,
      'time': instance.time,
    };

StatusLabel _$StatusLabelFromJson(Map<String, dynamic> json) => StatusLabel(
  status: json['status'] as String?,
  en: json['en'] as String?,
  ar: json['ar'] as String?,
  dt: json['dt'] as String?,
);

Map<String, dynamic> _$StatusLabelToJson(StatusLabel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'en': instance.en,
      'ar': instance.ar,
      'dt': instance.dt,
    };
