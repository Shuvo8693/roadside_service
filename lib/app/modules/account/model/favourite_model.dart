
class FavouriteResponse {
  bool? success;
  int? statusCode;
  String? message;
  List<Favourite>? data;

  FavouriteResponse({this.success, this.statusCode, this.message, this.data});

  factory FavouriteResponse.fromJson(Map<String, dynamic> json) {
    return FavouriteResponse(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: (json['data'] as List?)?.map((e) => Favourite.fromJson(e)).toList(),
    );
  }
}

class Favourite {
  String? id;
  String? user;
  Mechanic? mechanic;
  bool? isFavorite;
  String? createdAt;
  String? updatedAt;
  int? v;

  Favourite({
    this.id,
    this.user,
    this.mechanic,
    this.isFavorite,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Favourite.fromJson(Map<String, dynamic> json) {
    return Favourite(
      id: json['_id'],
      user: json['user'],
      mechanic: json['mechanic'] != null ? Mechanic.fromJson(json['mechanic']) : null,
      isFavorite: json['isFavorite'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
    );
  }
}

class Mechanic {
  String? id;
  String? name;
  String? email;
  String? image;
  String? role;
  double? serviceRadius;

  Mechanic({
    this.id,
    this.name,
    this.email,
    this.image,
    this.role,
    this.serviceRadius,
  });

  factory Mechanic.fromJson(Map<String, dynamic> json) {
    return Mechanic(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      image: json['image'],
      role: json['role'],
      serviceRadius: (json['serviceRadius'] is int)? double.tryParse(json['serviceRadius'].toString()) : json['serviceRadius'],
    );
  }
}
