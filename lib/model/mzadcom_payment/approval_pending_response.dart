class ApprovalPendingResponse {
  final bool success;
  final String message;
  final List<Data> data;

  ApprovalPendingResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ApprovalPendingResponse.fromJson(Map<String, dynamic> json) {
    return ApprovalPendingResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? "",
      data:
          (json['data'] as List<dynamic>?)
              ?.map((item) => Data.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class Data {
  final int id;
  final int user;
  final int groupId;
  final int auction;
  final String transactionId;
  final String credit;
  final String debit;
  final String holdAmount;
  final String balance;
  final dynamic tmpBalance;
  final String clientAmount;
  final String tmpClientAmount;
  final String type;
  final dynamic remarks;
  final String reference;
  final String method;
  final String bank;
  final dynamic accountNumber;
  final String receiptNumber;
  final String fileReceipt;
  final dynamic fileFm;
  final dynamic adminApprovedOn;
  final dynamic fmApprovedOn;
  final dynamic paymentDate;
  final int addedBy;
  final dynamic rejectReason;
  final String status;
  final dynamic approvedBy;
  final dynamic verifiedBy;
  final dynamic rejectedBy;
  final String createdAt;
  final String updatedAt;
  final AuctionRelation auctionRelation;

  Data({
    required this.id,
    required this.user,
    required this.groupId,
    required this.auction,
    required this.transactionId,
    required this.credit,
    required this.debit,
    required this.holdAmount,
    required this.balance,
    required this.tmpBalance,
    required this.clientAmount,
    required this.tmpClientAmount,
    required this.type,
    required this.remarks,
    required this.reference,
    required this.method,
    required this.bank,
    required this.accountNumber,
    required this.receiptNumber,
    required this.fileReceipt,
    required this.fileFm,
    required this.adminApprovedOn,
    required this.fmApprovedOn,
    required this.paymentDate,
    required this.addedBy,
    required this.rejectReason,
    required this.status,
    required this.approvedBy,
    required this.verifiedBy,
    required this.rejectedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.auctionRelation,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: _parseInt(json['id']),
      user: _parseInt(json['user']),
      groupId: _parseInt(json['group_id']),
      auction: _parseInt(json['auction']),
      transactionId: json['transaction_id'] ?? "",
      credit: json['credit'] ?? "",
      debit: json['debit'] ?? "",
      holdAmount: json['hold_amount'] ?? "",
      balance: json['balance'] ?? "",
      tmpBalance: json['tmp_balance'],
      clientAmount: json['client_amount'] ?? "",
      tmpClientAmount: json['tmp_client_amount'] ?? "",
      type: json['type'] ?? "",
      remarks: json['remarks'],
      reference: json['reference'] ?? "",
      method: json['method'] ?? "",
      bank: json['bank'] ?? "",
      accountNumber: json['account_number'],
      receiptNumber: json['receipt_number'] ?? "",
      fileReceipt: json['file_receipt'] ?? "",
      fileFm: json['file_fm'],
      adminApprovedOn: json['admin_approved_on'],
      fmApprovedOn: json['fm_approved_on'],
      paymentDate: json['payment_date'],
      addedBy: _parseInt(json['added_by']),
      rejectReason: json['reject_reason'],
      status: json['status'] ?? "",
      approvedBy: json['approved_by'],
      verifiedBy: json['verified_by'],
      rejectedBy: json['rejected_by'],
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      auctionRelation: AuctionRelation.fromJson(json['auction_relation']),
    );
  }

  get date => null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user,
      'group_id': groupId,
      'auction': auction,
      'transaction_id': transactionId,
      'credit': credit,
      'debit': debit,
      'hold_amount': holdAmount,
      'balance': balance,
      'tmp_balance': tmpBalance,
      'client_amount': clientAmount,
      'tmp_client_amount': tmpClientAmount,
      'type': type,
      'remarks': remarks,
      'reference': reference,
      'method': method,
      'bank': bank,
      'account_number': accountNumber,
      'receipt_number': receiptNumber,
      'file_receipt': fileReceipt,
      'file_fm': fileFm,
      'admin_approved_on': adminApprovedOn,
      'fm_approved_on': fmApprovedOn,
      'payment_date': paymentDate,
      'added_by': addedBy,
      'reject_reason': rejectReason,
      'status': status,
      'approved_by': approvedBy,
      'verified_by': verifiedBy,
      'rejected_by': rejectedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'auction_relation': auctionRelation.toJson(),
    };
  }
}

class AuctionRelation {
  final int id;
  final String title;
  final String titleAr;

  AuctionRelation({
    required this.id,
    required this.title,
    required this.titleAr,
  });

  factory AuctionRelation.fromJson(Map<String, dynamic> json) {
    return AuctionRelation(
      id: _parseInt(json['id']),
      title: json['title'] ?? "",
      titleAr: json['title_ar'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'title_ar': titleAr};
  }
}

// Utility functions for safe parsing
int _parseInt(dynamic value) {
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}
