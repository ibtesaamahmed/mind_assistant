class BacklogModel {
  String id;
  String title;
  List<BacklogItemModel> backlogItems;

  BacklogModel({
    required this.id,
    required this.title,
    required this.backlogItems,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'backlogItems': backlogItems.map((item) => item.toJson()).toList(),
    };
  }

  factory BacklogModel.fromJson(Map<String, dynamic> map) {
    return BacklogModel(
      id: map['id'],
      title: map['title'],
      backlogItems: (map['backlogItems'] as List<dynamic>)
          .map((item) => BacklogItemModel.fromJson(item))
          .toList(),
    );
  }
}

class BacklogItemModel {
  String id;
  String title;
  String who;
  String why;
  bool isAutoDelete;
  DateTime createdAt;
  DateTime? endDate;

  BacklogItemModel({
    required this.id,
    required this.title,
    required this.who,
    required this.why,
    required this.isAutoDelete,
    required this.createdAt,
    this.endDate,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'who': who,
      'why': why,
      'isAutoDelete': isAutoDelete,
      'createdAt': createdAt.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  factory BacklogItemModel.fromJson(Map<String, dynamic> map) {
    return BacklogItemModel(
      id: map['id'],
      title: map['title'],
      who: map['who'],
      why: map['why'],
      isAutoDelete: map['isAutoDelete'],
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : map['createdAt'],
      endDate: map['endDate'] != null
          ? DateTime.parse(map['endDate'])
          : map['endDate'],
    );
  }
}
