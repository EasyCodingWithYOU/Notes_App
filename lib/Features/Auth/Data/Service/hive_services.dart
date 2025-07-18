import 'package:hive/hive.dart';
import 'package:notes/Features/Auth/Data/Model/user_model.dart';

class HiveService {
  static const String boxName = 'userBox';

  Future<void> saveUser(UserModel user) async {
    final box = await Hive.openBox<UserModel>(boxName);
    await box.put('user', user);
  }

  Future<UserModel?> getUser() async {
    final box = await Hive.openBox<UserModel>(boxName);
    return box.get('user');
  }

  Future<void> clearUser() async {
    final box = await Hive.openBox<UserModel>(boxName);
    await box.clear();
  }
}
