class OrderStatusModel {
  final bool? success;
  final int? statusCode;
  final String? message;
  final OrderData? data;

  OrderStatusModel({this.success, this.statusCode, this.message, this.data});

  factory OrderStatusModel.fromJson(Map<String, dynamic> json) {
    return OrderStatusModel(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: json['data'] != null ? OrderData.fromJson(json['data']) : null,
    );
  }
}

class OrderData {
  final List<Order>? orders;
  final int? processingCount;
  final int? completedCount;
  final int? cancelledCount;

  OrderData({
    this.orders,
    this.processingCount,
    this.completedCount,
    this.cancelledCount,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      orders: (json['orders'] as List?)
          ?.map((e) => Order.fromJson(e))
          .toList(),
      processingCount: json['processingCount'],
      completedCount: json['completedCount'],
      cancelledCount: json['cancelledCount'],
    );
  }
}

class Order {
  final String? id;
  final Location? location;
  final User? user;
  final List<Service>? services;
  final Vehicle? vehicle;
  final String? status;
  final num? total;
  final String? distance;

  Order({
    this.id,
    this.location,
    this.user,
    this.services,
    this.vehicle,
    this.status,
    this.total,
    this.distance,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'],
      location: json['location'] != null
          ? Location.fromJson(json['location'])
          : null,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      services: (json['services'] as List?)
          ?.map((e) => Service.fromJson(e))
          .toList(),
      vehicle: json['vehicle'] != null
          ? Vehicle.fromJson(json['vehicle'])
          : null,
      status: json['status'],
      total: json['total'],
      distance: json['distance'],
    );
  }
}

class Location {
  final String? type;
  final List<num>? coordinates;

  Location({this.type, this.coordinates});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'],
      coordinates: (json['coordinates'] as List?)
          ?.map((e) => e as num)
          .toList(),
    );
  }
}

class User {
  final String? id;
  final String? name;

  User({this.id, this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
    );
  }
}

class Service {
  final String? id;
  final String? name;

  Service({this.id, this.name});

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['_id'],
      name: json['name'],
    );
  }
}

class Vehicle {
  final String? id;
  final String? model;
  final String? brand;
  final String? number;

  Vehicle({this.id, this.model, this.brand, this.number});

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['_id'],
      model: json['model'],
      brand: json['brand'],
      number: json['number'],
    );
  }
}
