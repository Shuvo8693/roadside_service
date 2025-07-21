class ProfileModel {
  final bool? success;
  final int? statusCode;
  final String? message;
  final ProfileData? data;

  ProfileModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: json['data'] != null ? ProfileData.fromJson(json['data']) : null,
    );
  }
}

class ProfileData {
  final User? user;
  final int? notificationCount;

  ProfileData({
    this.user,
    this.notificationCount,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      notificationCount: json['notificationCount'],
    );
  }
}

class User {
  final String? id;
  final String? name;
  final String? email;
  final String? role;
  final String? phone;
  final String? image;
  final Location? location;
  final double? serviceRadius;
  final String? bio;
  final int? experience;

  User({
    this.id,
    this.name,
    this.email,
    this.role,
    this.phone,
    this.image,
    this.location,
    this.serviceRadius,
    this.bio,
    this.experience,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      phone: json['phone'],
      image: json['image'],
      location: json['location'] != null ? Location.fromJson(json['location']) : null,
      serviceRadius: json['serviceRadius']?.toDouble(),
      bio: json['bio'],
      experience: json['experience'],
    );
  }
}

class Location {
  final String? type;
  final List<double>? coordinates;

  Location({
    this.type,
    this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'],
      coordinates: (json['coordinates'] is List<double>) ? (json['coordinates'] as List<double>).map((x) => x.toDouble()).toList() : [],
    );
  }
}
