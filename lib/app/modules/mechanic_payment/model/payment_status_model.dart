class PaymentStatusResponse {
  final bool? success;
  final int? statusCode;
  final String? message;
  final List<PaymentRequest>? data;

  PaymentStatusResponse({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory PaymentStatusResponse.fromJson(Map<String, dynamic> json) {
    return PaymentStatusResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => PaymentRequest.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class PaymentRequest {
  final String? id;
  final String? status;
  final int? amount;
  final String? user;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PaymentRequest({
    this.id,
    this.status,
    this.amount,
    this.user,
    this.createdAt,
    this.updatedAt,
  });

  factory PaymentRequest.fromJson(Map<String, dynamic> json) {
    return PaymentRequest(
      id: json['_id'] ?? '',
      status: json['status'] ?? '',
      amount: json['amount'] ?? 0,
      user: json['user'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }
}