import 'package:hive/hive.dart';
import 'package:notes/Features/Auth/Data/Model/user_model.dart';

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    return UserModel(
      uid: reader.readString(),
      email: reader.readString(),
      name: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer.writeString(obj.uid);
    writer.writeString(obj.email);
    writer.writeString(obj.name);
  }
}
