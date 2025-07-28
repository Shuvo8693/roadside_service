class ReviewResponse {
  final bool? success;
  final int? statusCode;
  final String? message;
  final ReviewData? data;

  ReviewResponse({this.success, this.statusCode, this.message, this.data});

  factory ReviewResponse.fromJson(Map<String, dynamic> json) {
    return ReviewResponse(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: json['data'] != null ? ReviewData.fromJson(json['data']) : null,
    );
  }
}

class ReviewData {
  final List<Review>? reviews;
  final double? averageRating;

  ReviewData({this.reviews, this.averageRating});

  factory ReviewData.fromJson(Map<String, dynamic> json) {
    return ReviewData(
      reviews: json['reviews'] != null
          ? List<Review>.from(json['reviews'].map((x) => Review.fromJson(x)))
          : null,
      averageRating: (json['averageRating'] as num?)?.toDouble(),
    );
  }
}

class Review {
  final String? id;
  final User? user;
  final String? order;
  final String? mechanic;
  final int? rating;
  final String? comment;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  Review({
    this.id,
    this.user,
    this.order,
    this.mechanic,
    this.rating,
    this.comment,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['_id'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      order: json['order'],
      mechanic: json['mechanic'],
      rating: json['rating'],
      comment: json['comment'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
    );
  }
}

class User {
  final String? id;
  final String? name;
  final String? image;

  User({this.id, this.name, this.image});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      image: json['image'],
    );
  }
}
