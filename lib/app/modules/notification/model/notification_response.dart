class NotificationResponse {
  final bool? success;
  final int? statusCode;
  final String? message;
  final NotificationData? data;

  NotificationResponse({this.success, this.statusCode, this.message, this.data});

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: json['data'] != null ? NotificationData.fromJson(json['data']) : null,
    );
  }
}

class NotificationData {
  final List<NotificationItem>? notifications;
  final Pagination? pagination;

  NotificationData({this.notifications, this.pagination});

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      notifications: json['notifications'] != null
          ? List<NotificationItem>.from(
          json['notifications'].map((x) => NotificationItem.fromJson(x)))
          : null,
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }
}

class NotificationItem {
  final String? id;
  final String? orderId;
  final String? msg;
  final DateTime? createdAt;
  final String? updatedAt;

  NotificationItem({
    this.id,
    this.orderId,
    this.msg,
    this.createdAt,
    this.updatedAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['_id'],
      orderId: json['orderId'],
      msg: json['msg'],
      createdAt:DateTime.parse(json['createdAt'] as String) ,
      updatedAt: json['updatedAt'],
    );
  }
}

class Pagination {
  final int? totalPages;
  final int? currentPage;
  final int? prevPage;
  final int? nextPage;
  final int? limit;
  final int? totalNotifications;

  Pagination({
    this.totalPages,
    this.currentPage,
    this.prevPage,
    this.nextPage,
    this.limit,
    this.totalNotifications,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      totalPages: json['totalPages'],
      currentPage: json['currentPage'],
      prevPage: json['prevPage'],
      nextPage: json['nextPage'],
      limit: json['limit'],
      totalNotifications: json['totalNotifications'],
    );
  }
}
