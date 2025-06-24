class MechanicServicePriceModel {
  bool? success;
  int? statusCode;
  String? message;
  MechanicServiceData? data;

  MechanicServicePriceModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  MechanicServicePriceModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? MechanicServiceData.fromJson(json['data']) : null;
  }
}

class MechanicServiceData {
  String? id;
  List<ServiceWithPrice>? servicesWithPrice;

  MechanicServiceData({this.id, this.servicesWithPrice});

  MechanicServiceData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    if (json['services'] != null) {
      servicesWithPrice = <ServiceWithPrice>[];
      json['services'].forEach((v) {
        servicesWithPrice!.add(ServiceWithPrice.fromJson(v));
      });
    }
  }
}

class ServiceWithPrice {
  Service? service;
  double? price;
  String? id;

  ServiceWithPrice({this.service, this.price, this.id});

  ServiceWithPrice.fromJson(Map<String, dynamic> json) {
    service = json['service'] != null ? Service.fromJson(json['service']) : null;
    price = (json['price'] is int) ? (json['price'] as int).toDouble() : json['price']?.toDouble();
    id = json['_id'];
  }
}

class Service {
  String? id;
  String? image;
  String? name;
  int? v;

  Service({this.id, this.image, this.name, this.v});

  Service.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    image = json['image'];
    name = json['name'];
    v = json['__v'];
  }
}
