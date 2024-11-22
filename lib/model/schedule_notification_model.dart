class ScheduleNotificationModel {
  int notificationId;
  String id;
  ScheduleNotificationModel({
    required this.notificationId,
    required this.id,
  });
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'notificationId': notificationId,
      'id': id,
    };
  }

  factory ScheduleNotificationModel.fromJson(Map<String, dynamic> map) {
    return ScheduleNotificationModel(
      notificationId: map['notificationId'],
      id: map['id'],
    );
  }
}
