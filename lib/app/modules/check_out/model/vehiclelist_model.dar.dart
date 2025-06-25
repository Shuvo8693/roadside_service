class VehicleListModel {
  bool? success;
  int? statusCode;
  String? message;
  List<Vehicle>? data;

  VehicleListModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  VehicleListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Vehicle>[];
      json['data'].forEach((v) {
        data!.add(Vehicle.fromJson(v));
      });
    }
  }
}

class Vehicle {
  String? id;
  String? user;
  String? model;
  String? brand;
  String? number;

  Vehicle({
    this.id,
    this.user,
    this.model,
    this.brand,
    this.number,
  });

  Vehicle.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    user = json['user'];
    model = json['model'];
    brand = json['brand'];
    number = json['number'];
  }
}
