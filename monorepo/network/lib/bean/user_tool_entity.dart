import 'package:network/generated/json/base/json_field.dart';
import 'package:network/generated/json/user_tool_entity.g.dart';
import 'dart:convert';
export 'package:network/generated/json/user_tool_entity.g.dart';

@JsonSerializable()
class UserToolEntity {
  late String desc;
  late String icon;
  late int id;
  late String link;
  late String name;
  late int order;
  late int userId;
  late int visible;

  UserToolEntity();

  factory UserToolEntity.fromJson(Map<String, dynamic> json) =>
      $UserToolEntityFromJson(json);

  Map<String, dynamic> toJson() => $UserToolEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
