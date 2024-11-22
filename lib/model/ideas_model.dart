import 'package:flutter_quill/quill_delta.dart';

class IdeasModel {
  String id;
  String title;
  Delta subTitle;
  IdeasModel({
    required this.id,
    required this.title,
    required this.subTitle,
  });
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'subTitle': subTitle.toJson(),
    };
  }

  factory IdeasModel.fromJson(Map<String, dynamic> map) {
    return IdeasModel(
      id: map['id'],
      title: map['title'],
      subTitle: Delta.fromJson(map['subTitle']),
    );
  }
}
