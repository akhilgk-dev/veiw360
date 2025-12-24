class MzadOverviewModel {
  final int previousAuctionCount;
  final int runningAuctionCount;
  final int totalWinnersCount;
  final int enrollmentCount;
  final int strategyCount;

  MzadOverviewModel({
    required this.previousAuctionCount,
    required this.runningAuctionCount,
    required this.totalWinnersCount,
    required this.enrollmentCount,
    required this.strategyCount,
  });

  factory MzadOverviewModel.fromJson(Map<String, dynamic> json) {
    return MzadOverviewModel(
      previousAuctionCount: json['previous_auciton_count'] as int,
      runningAuctionCount: json['running_auction_count'] as int,
      totalWinnersCount: json['total_winners_count'] as int,
      enrollmentCount: json['enrollment_count'] as int,
      strategyCount: json['strategy_count'] as int,
    );
  }
}

class MzadOverviewModelResponse {
  final String? error;
  final MzadOverviewModel? data;

  MzadOverviewModelResponse({required this.error, this.data});

  factory MzadOverviewModelResponse.fromJson(Map<String, dynamic> json) {
    return MzadOverviewModelResponse(
      error: json['error'],
      data: json['data'] != null
          ? MzadOverviewModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}
