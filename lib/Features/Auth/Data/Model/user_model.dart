import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes/Features/Auth/Domain/Entity/user_entity.dart';

class UserModel extends HiveObject {
  final String uid;
  final String email;
  final String name;

  UserModel({required this.uid, required this.email, required this.name});

  factory UserModel.fromEntity(UserEntity entity) =>
      UserModel(uid: entity.uid, email: entity.email, name: entity.name);

  UserEntity toEntity() => UserEntity(uid: uid, email: email, name: name);
}
