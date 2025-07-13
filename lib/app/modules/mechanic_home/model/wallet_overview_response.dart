// Root model for the entire JSON response
class WalletOverviewResponse {
  bool? success;
  int? statusCode;
  String? message;
  WalletData? data;

  WalletOverviewResponse({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  // Factory constructor to create instance from JSON
  factory WalletOverviewResponse.fromJson(Map<String, dynamic> json) {
    return WalletOverviewResponse(
      success: json['success'] as bool?,
      statusCode: json['statusCode'] as int?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? WalletData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

// Model for the nested 'data' object
class WalletData {
  String? id;
  double? totalEarnings;
  double? availableBalance;
  double? withdrawnAmount;
  String? user;
  String? createdAt;
  String? updatedAt;
  int? v;
  int? totalCompletedOrder;
  int? activeOrders;

  WalletData({
    this.id,
    this.totalEarnings,
    this.availableBalance,
    this.withdrawnAmount,
    this.user,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.totalCompletedOrder,
    this.activeOrders,
  });

  // Factory constructor to create instance from JSON
  factory WalletData.fromJson(Map<String, dynamic> json) {
    return WalletData(
      id: json['_id'] as String?,
      totalEarnings: (json['totalEarnings'] as num?)?.toDouble(),
      availableBalance: (json['availableBalance'] as num?)?.toDouble(),
      withdrawnAmount: (json['withdrawnAmount'] as num?)?.toDouble(),
      user: json['user'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: json['__v'] as int?,
      totalCompletedOrder: json['totalCompletedOrder'] as int?,
      activeOrders: json['activeOrders'] as int?,
    );
  }
}