class FavoriteToggleModel {
  final bool? success;
  final int? statusCode;
  final String? message;
  final FavoriteData? data;

  FavoriteToggleModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory FavoriteToggleModel.fromJson(Map<String, dynamic> json) {
    return FavoriteToggleModel(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: json['data'] != null ? FavoriteData.fromJson(json['data']) : null,
    );
  }
}

class FavoriteData {
  final String? id;
  final String? user;
  final String? mechanic;
  final bool? isFavorite;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  FavoriteData({
    this.id,
    this.user,
    this.mechanic,
    this.isFavorite,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory FavoriteData.fromJson(Map<String, dynamic> json) {
    return FavoriteData(
      id: json['_id'],
      user: json['user'],
      mechanic: json['mechanic'],
      isFavorite: json['isFavorite'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
    );
  }
}
