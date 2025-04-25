import 'dart:developer';
import 'package:get_storage/get_storage.dart';
import 'package:nss/model/volunteer_model.dart';

class LocalStorage {
  final _box = GetStorage();

  writeUser(Users user) {
    try {
      _box.write('user', user.toJson());
    } catch (e) {
      log(e.toString());
    }
  }

  Users readUser() {
    final data = _box.read('user');
    return Users.fromJson(data);
  }

  clearAll() {
    _box.erase();
  }
}
