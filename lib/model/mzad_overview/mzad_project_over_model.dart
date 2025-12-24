class MzadProjectOverModel {
  List<ProjectSummary>? projectSummary;
  VatSummary? vatSummary;

  MzadProjectOverModel({
    required this.projectSummary,
    required this.vatSummary,
  });

  factory MzadProjectOverModel.fromJson(Map<String, dynamic> json) {
    return MzadProjectOverModel(
      projectSummary: (json['project_summary'] as List)
          .map((item) => ProjectSummary.fromJson(item))
          .toList(),
      vatSummary: VatSummary.fromJson(json['vat_summary']),
    );
  }
}

class ProjectSummary {
  final int deliveryStatus;
  final int auctionsCount;
  final double totalBidAmount;
  final double finalBidAmount;

  ProjectSummary({
    required this.deliveryStatus,
    required this.auctionsCount,
    required this.totalBidAmount,
    required this.finalBidAmount,
  });

  factory ProjectSummary.fromJson(Map<String, dynamic> json) {
    return ProjectSummary(
      deliveryStatus: json['delivery_status'],
      auctionsCount: json['auctions_count'],
      totalBidAmount: (json['total_bid_amount'] as num).toDouble(),
      finalBidAmount: (json['final_bid_amount'] as num).toDouble(),
    );
  }
}

class VatSummary {
  final VatDetail bidAmountVat;
  final VatDetail serviceChargeVat;
  final VatDetail serviceCharge;

  VatSummary({
    required this.bidAmountVat,
    required this.serviceChargeVat,
    required this.serviceCharge,
  });

  factory VatSummary.fromJson(Map<String, dynamic> json) {
    return VatSummary(
      bidAmountVat: VatDetail.fromJson(json['bid_amount_vat']),
      serviceChargeVat: VatDetail.fromJson(json['service_charge_vat']),
      serviceCharge: VatDetail.fromJson(json['service_charge']),
    );
  }
}

class VatDetail {
  final double value;
  final double preValue;
  final String trend;
  final double percentage;
  final String timeframe;

  VatDetail({
    required this.value,
    required this.preValue,
    required this.trend,
    required this.percentage,
    required this.timeframe,
  });

  factory VatDetail.fromJson(Map<String, dynamic> json) {
    return VatDetail(
      value: (json['value'] as num).toDouble(),
      preValue: (json['pre_value'] as num).toDouble(),
      trend: json['trend'],
      percentage: (json['percentage'] as num).toDouble(),
      timeframe: json['timeframe'],
    );
  }
}
