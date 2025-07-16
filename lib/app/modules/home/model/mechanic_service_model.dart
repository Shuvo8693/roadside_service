import 'package:flutter/material.dart';

class MechanicServiceModel {
  bool? success;
  int? statusCode;
  String? message;
  List<MechanicServiceData>? data;

  MechanicServiceModel(
      {this.success, this.statusCode, this.message, this.data});

  MechanicServiceModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['data'] != null) {
      data = <MechanicServiceData>[];
      json['data'].forEach((v) {
        data!.add(MechanicServiceData.fromJson(v));
      });
    }
  }
}

class MechanicServiceData {
  String? sId;
  String? image;
  String? name;
  int? price;
  int? iV;
  TextEditingController? priceTEC;

  MechanicServiceData({this.sId, this.image, this.name, this.price, this.iV}) : priceTEC = TextEditingController(text: price.toString()) ;

  MechanicServiceData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    image = json['image'];
    name = json['name'];
    price = json['price'];
    iV = json['__v'];
    priceTEC = TextEditingController(text: price.toString());
  }
}
