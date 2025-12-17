class TrackingStep {
  final String? label;
  final String? date;
  final String? status;

  TrackingStep({this.label, this.date, this.status});

  factory TrackingStep.fromJson(Map<String, dynamic>? json) {
    if (json == null) return TrackingStep();
    return TrackingStep(
      label: json['label'] as String?,
      date: json['date'] as String?,
      status: json['status'] as String?,
    );
  }
}

class GroupRelation {
  final int? id;
  final String? groupName;
  final String? groupNameAr;

  GroupRelation({this.id, this.groupName, this.groupNameAr});

  factory GroupRelation.fromJson(Map<String, dynamic>? json) {
    if (json == null) return GroupRelation();
    return GroupRelation(
      id: json['id'] as int?,
      groupName: json['group_name'] as String?,
      groupNameAr: json['group_name_ar'] as String?,
    );
  }
}

class OrganizationRelation {
  final int? id;
  final String? organizationName;
  final String? organizationNameAr;

  OrganizationRelation({
    this.id,
    this.organizationName,
    this.organizationNameAr,
  });

  factory OrganizationRelation.fromJson(Map<String, dynamic>? json) {
    if (json == null) return OrganizationRelation();
    return OrganizationRelation(
      id: json['id'] as int?,
      organizationName: json['organization_name'] as String?,
      organizationNameAr: json['organization_name_ar'] as String?,
    );
  }
}

class Tracking {
  final int? id;
  final String? title;
  final String? titleAr;
  final String? description;
  final String? descriptionAr;
  final String? location;
  final String? locationAr;
  final String? regStartDate;
  final String? regEndDate;
  final String? startDate;
  final String? endDate;
  final String? status;
  final int? deliveryStatus;
  final String? clientApprovedAt;
  final String? rejectedDate;
  final String? fundAddedAt;
  final String? financeApprovedAt;
  final int? group;
  final int? organization;
  final bool? isWinner;
  final GroupRelation? groupRelation;
  final OrganizationRelation? organizationRelation;
  final List<TrackingStep>? steps;

  Tracking({
    this.id,
    this.title,
    this.titleAr,
    this.description,
    this.descriptionAr,
    this.location,
    this.locationAr,
    this.regStartDate,
    this.regEndDate,
    this.startDate,
    this.endDate,
    this.status,
    this.deliveryStatus,
    this.clientApprovedAt,
    this.rejectedDate,
    this.fundAddedAt,
    this.financeApprovedAt,
    this.group,
    this.organization,
    this.isWinner,
    this.groupRelation,
    this.organizationRelation,
    this.steps,
  });

  factory Tracking.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Tracking();
    return Tracking(
      id: json['id'] as int?,
      title: json['title'] as String?,
      titleAr: json['title_ar'] as String?,
      description: json['description'] as String?,
      descriptionAr: json['description_ar'] as String?,
      location: json['location'] as String?,
      locationAr: json['location_ar'] as String?,
      regStartDate: json['reg_start_date'] as String?,
      regEndDate: json['reg_end_date'] as String?,
      startDate: json['start_date'] as String?,
      endDate: json['end_date'] as String?,
      status: json['status'] as String?,
      deliveryStatus: json['delivery_status'] as int?,
      clientApprovedAt: json['client_approved_at'] as String?,
      rejectedDate: json['rejected_date'] as String?,
      fundAddedAt: json['fund_added_at'] as String?,
      financeApprovedAt: json['finance_approved_at'] as String?,
      group: json['group'] as int?,
      organization: json['organization'] as int?,
      isWinner: json['is_winner'] as bool?,
      groupRelation: GroupRelation.fromJson(
        json['group_relation'] as Map<String, dynamic>?,
      ),
      organizationRelation: OrganizationRelation.fromJson(
        json['organization_relation'] as Map<String, dynamic>?,
      ),
      steps: (json['tracking'] as Map<String, dynamic>?)?.entries.map((entry) {
        return TrackingStep.fromJson(entry.value as Map<String, dynamic>?);
      }).toList(),
    );
  }
}
