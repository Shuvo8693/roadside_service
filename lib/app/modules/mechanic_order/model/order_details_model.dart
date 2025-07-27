class OrderDetailResponse {
  final bool? success;
  final int? statusCode;
  final String? message;
  final OrderData? data;

  OrderDetailResponse({this.success, this.statusCode, this.message, this.data});

  factory OrderDetailResponse.fromJson(Map<String, dynamic> json) {
    return OrderDetailResponse(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: json['data'] != null ? OrderData.fromJson(json['data']) : null,
    );
  }
}

class OrderData {
  final Result? result;
  final num? appService;
  final MechanicServiceRate? mechanicServiceRate;

  OrderData({this.result, this.appService, this.mechanicServiceRate});

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      result: json['result'] != null ? Result.fromJson(json['result']) : null,
      appService: json['appService'],
      mechanicServiceRate: json['mechanicServiceRate'] != null
          ? MechanicServiceRate.fromJson(json['mechanicServiceRate'])
          : null,
    );
  }
}

class Result {
  final Location? location;
  final String? additionalNotes;
  final String? id;
  final User? user;
  final Mechanic? mechanic;
  final List<String>? services;
  final Vehicle? vehicle;
  final String? status;
  final num? total;
  final String? address;
  final String? streetNo;
  final String? payment;
  final String? createdAt;
  final String? updatedAt;
  final String? uniqueOrderId;
  final int? v;

  Result({
    this.location,
    this.additionalNotes,
    this.id,
    this.user,
    this.mechanic,
    this.services,
    this.vehicle,
    this.status,
    this.total,
    this.address,
    this.streetNo,
    this.payment,
    this.createdAt,
    this.updatedAt,
    this.uniqueOrderId,
    this.v,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      location: json['location'] != null ? Location.fromJson(json['location']) : null,
      additionalNotes: json['additionalNotes'],
      id: json['_id'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      mechanic: json['mechanic'] != null ? Mechanic.fromJson(json['mechanic']) : null,
      services: json['services'] != null ? List<String>.from(json['services']) : null,
      vehicle: json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null,
      status: json['status'],
      total: json['total'],
      address: json['address'],
      streetNo: json['streetNo'],
      payment: json['payment'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      uniqueOrderId: json['uniqueOrderId'],
      v: json['__v'],
    );
  }
}

class Location {
  final String? type;
  final List<double>? coordinates;

  Location({this.type, this.coordinates});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'],
      coordinates: json['coordinates'] != null
          ? List<double>.from(json['coordinates'].map((e) => e.toDouble()))
          : null,
    );
  }
}

class User {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? image;

  User({this.id, this.name, this.email, this.phone, this.image});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      image: json['image'],
    );
  }
}

class Mechanic {
  final int? rating;
  final String? id;
  final String? name;
  final String? email;
  final String? image;
  final int? experience;
  final String? bio;

  Mechanic({
    this.rating,
    this.id,
    this.name,
    this.email,
    this.image,
    this.experience,
    this.bio,
  });

  factory Mechanic.fromJson(Map<String, dynamic> json) {
    return Mechanic(
      rating: json['rating'],
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      image: json['image'],
      experience: json['experience'],
      bio: json['bio'],
    );
  }
}

class Vehicle {
  final String? id;
  final String? user;
  final String? model;
  final String? brand;
  final String? number;
  final int? v;

  Vehicle({this.id, this.user, this.model, this.brand, this.number, this.v});

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['_id'],
      user: json['user'],
      model: json['model'],
      brand: json['brand'],
      number: json['number'],
      v: json['__v'],
    );
  }
}

class MechanicServiceRate {
  final String? id;
  final String? mechanic;
  final List<ServiceItem>? services;

  MechanicServiceRate({this.id, this.mechanic, this.services});

  factory MechanicServiceRate.fromJson(Map<String, dynamic> json) {
    return MechanicServiceRate(
      id: json['_id'],
      mechanic: json['mechanic'],
      services: json['services'] != null
          ? List<ServiceItem>.from(json['services'].map((x) => ServiceItem.fromJson(x)))
          : null,
    );
  }
}

class ServiceItem {
  final ServiceDetail? service;
  final num? price;
  final String? id;

  ServiceItem({this.service, this.price, this.id});

  factory ServiceItem.fromJson(Map<String, dynamic> json) {
    return ServiceItem(
      service: json['service'] != null ? ServiceDetail.fromJson(json['service']) : null,
      price: json['price'],
      id: json['_id'],
    );
  }
}

class ServiceDetail {
  final String? id;
  final String? name;

  ServiceDetail({this.id, this.name});

  factory ServiceDetail.fromJson(Map<String, dynamic> json) {
    return ServiceDetail(
      id: json['_id'],
      name: json['name'],
    );
  }
}
