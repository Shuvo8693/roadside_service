class PaymentMethodsResponse {
  bool? success;
  int? statusCode;
  String? message;
  List<PaymentMethod>? data;

  PaymentMethodsResponse({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  PaymentMethodsResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['data'] != null) {
      data = List<PaymentMethod>.from(
        json['data'].map((item) => PaymentMethod.fromJson(item)),
      );
    }
  }
}

class PaymentMethod {
  String? id;
  String? user;
  String? bankName;
  String? accountHolderName;
  String? accountNumber;
  String? createdAt;
  String? updatedAt;
  int? v;

  PaymentMethod({
    this.id,
    this.user,
    this.bankName,
    this.accountHolderName,
    this.accountNumber,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  PaymentMethod.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    user = json['user'];
    bankName = json['bankName'];
    accountHolderName = json['accountHolderName'];
    accountNumber = json['accountNumber'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }
}