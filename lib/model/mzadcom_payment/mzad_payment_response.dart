class MzadPaymentResponse {
  final bool success;
  final String message;
  final List<PaymentData> data;
  final Meta meta;

  MzadPaymentResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory MzadPaymentResponse.fromJson(Map<String, dynamic> json) {
    return MzadPaymentResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? "",
      data:
          (json['data'] as List<dynamic>?)
              ?.map((item) => PaymentData.fromJson(item))
              .toList() ??
          [],
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : Meta.empty(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((item) => item.toJson()).toList(),
      'meta': meta.toJson(),
    };
  }
}

class PaymentData {
  final int id;
  final String title;
  final String titleAr;
  final String approvedDate;
  final String auctionVat;
  final int deliveryStatus;
  final String approveStatus;
  final int financeApproved;
  final dynamic clientPaymentType;
  final double bidAmount;
  final int userId;
  final String winner;
  final String walletAmount;
  final String clientAmount;
  final int groupId;
  final String groupName;
  final String groupNameAr;
  final String vat;
  final String serviceCharge;
  final String clientName;
  final String bankName;
  final String bankAccount;
  final int isVatIncluded;
  final int isServiceChargeIncluded;
  final int isServiceChargeVatIncluded;
  final int organizationId;
  final String organizationName;
  final String organizationNameAr;
  final String organizationUrl;
  final double serviceChargeAmount;
  final double itemAmountVat;
  final double vatServiceCharge;
  final double totalAmount;
  final double paidAmount;
  final double balanceAmount;

  PaymentData({
    required this.id,
    required this.title,
    required this.titleAr,
    required this.approvedDate,
    required this.auctionVat,
    required this.deliveryStatus,
    required this.approveStatus,
    required this.financeApproved,
    required this.clientPaymentType,
    required this.bidAmount,
    required this.userId,
    required this.winner,
    required this.walletAmount,
    required this.clientAmount,
    required this.groupId,
    required this.groupName,
    required this.groupNameAr,
    required this.vat,
    required this.serviceCharge,
    required this.clientName,
    required this.bankName,
    required this.bankAccount,
    required this.isVatIncluded,
    required this.isServiceChargeIncluded,
    required this.isServiceChargeVatIncluded,
    required this.organizationId,
    required this.organizationName,
    required this.organizationNameAr,
    required this.organizationUrl,
    required this.serviceChargeAmount,
    required this.itemAmountVat,
    required this.vatServiceCharge,
    required this.totalAmount,
    required this.paidAmount,
    required this.balanceAmount,
  });

  factory PaymentData.fromJson(Map<String, dynamic> json) {
    return PaymentData(
      id: _parseInt(json['id']),
      title: json['title'] ?? "",
      titleAr: json['title_ar'] ?? "",
      approvedDate: json['approved_date'] ?? "",
      auctionVat: json['auction_vat'] ?? "",
      deliveryStatus: _parseInt(json['delivery_status']),
      approveStatus: json['approve_status'] ?? "",
      financeApproved: _parseInt(json['finance_approved']),
      clientPaymentType: json['client_payment_type'],
      bidAmount: _parseDouble(json['bid_amount']),
      userId: _parseInt(json['user_id']),
      winner: json['winner'] ?? "",
      walletAmount: json['wallet_amount'] ?? "",
      clientAmount: json['client_amount'] ?? "",
      groupId: _parseInt(json['group_id']),
      groupName: json['group_name'] ?? "",
      groupNameAr: json['group_name_ar'] ?? "",
      vat: json['vat'] ?? "",
      serviceCharge: json['service_charge'] ?? "",
      clientName: json['client_name'] ?? "",
      bankName: json['bank_name'] ?? "",
      bankAccount: json['bank_account'] ?? "",
      isVatIncluded: _parseInt(json['is_vat_included']),
      isServiceChargeIncluded: _parseInt(json['is_service_charge_included']),
      isServiceChargeVatIncluded: _parseInt(
        json['is_service_charge_vat_included'],
      ),
      organizationId: _parseInt(json['organization_id']),
      organizationName: json['organization_name'] ?? "",
      organizationNameAr: json['organization_name_ar'] ?? "",
      organizationUrl: json['organization_url'] ?? "",
      serviceChargeAmount: _parseDouble(json['service_charge_amount']),
      itemAmountVat: _parseDouble(json['item_amount_vat']),
      vatServiceCharge: _parseDouble(json['vat_service_charge']),
      totalAmount: _parseDouble(json['total_amount']),
      paidAmount: _parseDouble(json['total_paid']),
      balanceAmount: _parseDouble(json['balance_amount']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'title_ar': titleAr,
      'approved_date': approvedDate,
      'auction_vat': auctionVat,
      'delivery_status': deliveryStatus,
      'approve_status': approveStatus,
      'finance_approved': financeApproved,
      'client_payment_type': clientPaymentType,
      'bid_amount': bidAmount,
      'user_id': userId,
      'winner': winner,
      'wallet_amount': walletAmount,
      'client_amount': clientAmount,
      'group_id': groupId,
      'group_name': groupName,
      'group_name_ar': groupNameAr,
      'vat': vat,
      'service_charge': serviceCharge,
      'client_name': clientName,
      'bank_name': bankName,
      'bank_account': bankAccount,
      'is_vat_included': isVatIncluded,
      'is_service_charge_included': isServiceChargeIncluded,
      'is_service_charge_vat_included': isServiceChargeVatIncluded,
      'organization_id': organizationId,
      'organization_name': organizationName,
      'organization_name_ar': organizationNameAr,
      'organization_url': organizationUrl,
      'service_charge_amount': serviceChargeAmount,
      'item_amount_vat': itemAmountVat,
      'vat_service_charge': vatServiceCharge,
      'total_amount': totalAmount,
      'paid_amount': paidAmount,
      'balance_amount': balanceAmount,
    };
  }
}

class Meta {
  final int total;
  final double paidPendingAmount;
  final Summary pending;
  final Summary approved;
  final Summary all;
  final Summary paid;

  Meta({
    required this.total,
    required this.paidPendingAmount,
    required this.pending,
    required this.approved,
    required this.all,
    required this.paid,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      total: _parseInt(json['total']),
      paidPendingAmount: _parseDouble(json['paid_pending_amount']),
      pending: json['pending'] != null
          ? Summary.fromJson(json['pending'])
          : Summary.empty(),
      approved: json['approved'] != null
          ? Summary.fromJson(json['approved'])
          : Summary.empty(),
      all: json['all'] != null
          ? Summary.fromJson(json['all'])
          : Summary.empty(),
      paid: json['paid'] != null
          ? Summary.fromJson(json['paid'])
          : Summary.empty(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'paid_pending_amount': paidPendingAmount,
      'pending': pending.toJson(),
      'approved': approved.toJson(),
      'all': all.toJson(),
      'paid': paid.toJson(),
    };
  }

  static Meta empty() {
    return Meta(
      total: 0,
      paidPendingAmount: 0.0,
      pending: Summary.empty(),
      approved: Summary.empty(),
      all: Summary.empty(),
      paid: Summary.empty(),
    );
  }
}

class Summary {
  final int count;
  final double total;
  final double paid;
  final double balance;

  Summary({
    required this.count,
    required this.total,
    required this.paid,
    required this.balance,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      count: _parseInt(json['count']),
      total: _parseDouble(json['total']),
      paid: _parseDouble(json['paid']),
      balance: _parseDouble(json['balance']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'count': count, 'total': total, 'paid': paid, 'balance': balance};
  }

  static Summary empty() {
    return Summary(count: 0, total: 0.0, paid: 0.0, balance: 0.0);
  }
}

// Utility functions for safe parsing
int _parseInt(dynamic value) {
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

double _parseDouble(dynamic value) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}
