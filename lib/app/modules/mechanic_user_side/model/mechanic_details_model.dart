class MechanicDetailsModel {
  bool? success;
  int? statusCode;
  String? message;
  MechanicData? data;

  MechanicDetailsModel(
      {this.success, this.statusCode, this.message, this.data});

  MechanicDetailsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? MechanicData.fromJson(json['data']) : null;
  }
}

class MechanicData {
  MechanicAttributes? mechanic;
  ServiceWithRate? serviceWithRate;

  MechanicData({this.mechanic, this.serviceWithRate});

  MechanicData.fromJson(Map<String, dynamic> json) {
    mechanic = json['mechanic'] != null
        ? MechanicAttributes.fromJson(json['mechanic'])
        : null;
    serviceWithRate = json['serviceWithRate'] != null
        ? ServiceWithRate.fromJson(json['serviceWithRate'])
        : null;
  }
}

class MechanicAttributes {
  String? sId;
  UserAttributes? user;
  double? rating;
  double? experience;
  String? description;
  bool? isAvailable;
  int? iV;

  MechanicAttributes(
      {this.sId,
        this.user,
        this.rating,
        this.experience,
        this.description,
        this.isAvailable,
        this.iV});

  MechanicAttributes.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'] != null ? UserAttributes.fromJson(json['user']) : null;
    if(json['rating'] is int){
      rating = (json['rating'] as int).toDouble();
    }else{
      rating = json['rating'];
    }

    if(json['experience'] is int){
      experience = (json['experience'] as int).toDouble();
    }else{
      experience = json['experience'];
    }
    description = json['description'];
    isAvailable = json['isAvailable'];
    iV = json['__v'];
  }
}

class UserAttributes {
  Location? location;
  String? sId;
  String? name;
  String? email;
  String? image;
  String? role;
  String? createdAt;
  String? updatedAt;
  int? iV;
  bool? isActive;

  UserAttributes(
      {this.location,
        this.sId,
        this.name,
        this.email,
        this.image,
        this.role,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.isActive,

      });

  UserAttributes.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? Location.fromJson(json['location'])
        : null;
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    image = json['image'];
    role = json['role'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    isActive = json['isActive'];
  }
}

class Location {
  String? type;
  List<double>? coordinates;

  Location({this.type, this.coordinates});

  Location.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }
}

class ServiceWithRate {
  String? sId;
  String? mechanic;
  List<Services>? services;
  int? iV;

  ServiceWithRate({this.sId, this.mechanic, this.services, this.iV});

  ServiceWithRate.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    mechanic = json['mechanic'];
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(Services.fromJson(v));
      });
    }
    iV = json['__v'];
  }
}

class Services {
  Service? service;
  double? price;
  String? sId;

  Services({this.service, this.price, this.sId});

  Services.fromJson(Map<String, dynamic> json) {
    service =
    json['service'] != null ? Service.fromJson(json['service']) : null;
    if(json['price'] is int){
      price = (json['price'] as int).toDouble();
    }else{
      price = json['price'];
    }
    sId = json['_id'];
  }
}

class Service {
  String? sId;
  String? image;
  String? name;
  int? iV;

  Service({this.sId, this.image, this.name, this.iV});

  Service.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    image = json['image'];
    name = json['name'];
    iV = json['__v'];
  }

}
