class MechanicModel {
  bool? success;
  int? statusCode;
  String? message;
  MechanicData? data;

  MechanicModel({this.success, this.statusCode, this.message, this.data});

  MechanicModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? MechanicData.fromJson(json['data']) : null;
  }
}

class MechanicData {
  Pagination? pagination;
  List<MechanicAttributes>? data;

  MechanicData({this.pagination, this.data});

  MechanicData.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <MechanicAttributes>[];
      json['data'].forEach((v) {
        data!.add(MechanicAttributes.fromJson(v));
      });
    }
  }
}

class Pagination {
  int? totalPage;
  int? currentPage;
  int? prevPage;
  int? nextPage;
  int? totalData;

  Pagination(
      {this.totalPage,
        this.currentPage,
        this.prevPage,
        this.nextPage,
        this.totalData});

  Pagination.fromJson(Map<String, dynamic> json) {
    totalPage = json['totalPage'];
    currentPage = json['currentPage'];
    prevPage = json['prevPage'];
    nextPage = json['nextPage'];
    totalData = json['totalData'];
  }
}

class MechanicAttributes {
  String? mechanicId;
  String? mechanicName;
  String? mechanicImage;
  String? distance;
  String? eta;
  double? rating;
  double? experience;
  bool? isFavourite;

  MechanicAttributes(
      {this.mechanicId,
        this.mechanicName,
        this.mechanicImage,
        this.distance,
        this.eta,
        this.rating,
        this.experience});

  MechanicAttributes.fromJson(Map<String, dynamic> json) {
    mechanicId = json['mechanicId'];
    mechanicName = json['mechanicName'];
    mechanicImage = json['mechanicImage'];
    distance = json['distance'];
    isFavourite = json['isFavourite'];
    eta = json['eta'];
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

  }
}
