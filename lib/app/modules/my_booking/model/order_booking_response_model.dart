class OrdersResponse {
  final bool? success;
  final int? statusCode;
  final String? message;
  final List<OrderData>? data;

  OrdersResponse({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory OrdersResponse.fromJson(Map<String, dynamic> json) {
    return OrdersResponse(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => OrderData.fromJson(e))
          .toList(),
    );
  }
}

class OrderData {
  final String? id;
  final Mechanic? mechanic;
  final List<ServiceInfo>? services;
  final String? status;
  final double? total;
  final List<ServiceRate>? serviceRates;
  final int? appService;
  final double? rating;

  OrderData({
    this.id,
    this.mechanic,
    this.services,
    this.status,
    this.total,
    this.serviceRates,
    this.appService,
    this.rating,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      id: json['_id'],
      mechanic: json['mechanic'] != null
          ? Mechanic.fromJson(json['mechanic'])
          : null,
      services: (json['services'] as List<dynamic>?)
          ?.map((e) => ServiceInfo.fromJson(e))
          .toList(),
      status: json['status'],
      total: (json['total'] != null)
          ? (json['total'] as num).toDouble()
          : null,
      serviceRates: (json['serviceRates'] as List<dynamic>?)
          ?.map((e) => ServiceRate.fromJson(e))
          .toList(),
      appService: json['appService'],
      rating: (json['rating'] != null)
          ? (json['rating'] as num).toDouble()
          : null,
    );
  }
}

class Mechanic {
  final String? id;
  final String? name;
  final String? email;
  final String? image;

  Mechanic({
    this.id,
    this.name,
    this.email,
    this.image,
  });

  factory Mechanic.fromJson(Map<String, dynamic> json) {
    return Mechanic(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      image: json['image'],
    );
  }
}

class ServiceInfo {
  final String? id;
  final String? name;

  ServiceInfo({
    this.id,
    this.name,
  });

  factory ServiceInfo.fromJson(Map<String, dynamic> json) {
    return ServiceInfo(
      id: json['_id'],
      name: json['name'],
    );
  }
}

class ServiceRate {
  final String? id;
  final String? name;
  final double? price;

  ServiceRate({
    this.id,
    this.name,
    this.price,
  });

  factory ServiceRate.fromJson(Map<String, dynamic> json) {
    return ServiceRate(
      id: json['_id'],
      name: json['name'],
      price: (json['price'] != null)
          ? (json['price'] as num).toDouble()
          : null,
    );
  }
}
