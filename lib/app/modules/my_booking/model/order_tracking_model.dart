class TrackingModel {
  LocationData? userLocation;
  LocationData? mechanicLocation;
  String? id;
  String? orderId;
  String? userId;
  String? mechanicId;
  num? distance;
  num? estimatedArrival;
  String? status;
  String? lastUpdated;
  List<dynamic>? trackingHistory;
  String? createdAt;
  String? updatedAt;
  int? v;

  TrackingModel({
    this.userLocation,
    this.mechanicLocation,
    this.id,
    this.orderId,
    this.userId,
    this.mechanicId,
    this.distance,
    this.estimatedArrival,
    this.status,
    this.lastUpdated,
    this.trackingHistory,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory TrackingModel.fromJson(Map<String, dynamic> json) {
    return TrackingModel(
      userLocation: json['userLocation'] != null ? LocationData.fromJson(json['userLocation']) : null,
      mechanicLocation: json['mechanicLocation'] != null ? LocationData.fromJson(json['mechanicLocation']) : null,
      id: json['_id'],
      orderId: json['orderId'],
      userId: json['userId'],
      mechanicId: json['mechanicId'],
      distance: json['distance'],
      estimatedArrival: json['estimatedArrival'],
      status: json['status'],
      lastUpdated: json['lastUpdated'],
      trackingHistory: json['trackingHistory'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
    );
  }
}

class LocationData {
  String? type;
  List<double>? coordinates;

  LocationData({this.type, this.coordinates});

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      type: json['type'],
      coordinates: (json['coordinates'] as List?)?.map((e) => (e as num).toDouble()).toList(),
    );
  }
}
