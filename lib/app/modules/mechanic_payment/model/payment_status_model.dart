class PaymentStatusResponse {
  final bool success;
  final int statusCode;
  final String message;
  final List<PaymentRequest> data;

  PaymentStatusResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
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
  final String id;
  final String status;
  final int amount;
  final String user;
  final DateTime createdAt;
  final DateTime updatedAt;

  PaymentRequest({
    required this.id,
    required this.status,
    required this.amount,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PaymentRequest.fromJson(Map<String, dynamic> json) {
    return PaymentRequest(
      id: json['_id'] ?? '',
      status: json['status'] ?? '',
      amount: json['amount'] ?? 0,
      user: json['user'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
