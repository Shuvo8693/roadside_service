class VehicleResponse {
  bool? success;
  int? statusCode;
  String? message;
  List<Vehicle>? data;

  VehicleResponse({this.success, this.statusCode, this.message, this.data});

  factory VehicleResponse.fromJson(Map<String, dynamic> json) {
    return VehicleResponse(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: (json['data'] as List?)?.map((e) => Vehicle.fromJson(e)).toList(),
    );
  }
}

class Vehicle {
  String? id;
  String? user;
  String? model;
  String? brand;
  String? number;

  Vehicle({this.id, this.user, this.model, this.brand, this.number});

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['_id'],
      user: json['user'],
      model: json['model'],
      brand: json['brand'],
      number: json['number'],
    );
  }
}
