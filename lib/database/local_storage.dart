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

  static bool get isAdmin {
    final data = GetStorage().read('user');
    if (data['role'] != 'vol') {
      return true;
    } else {
      return false;
    }
  }

  Users readUser() {
    try {
      final data = _box.read('user');
      return Users.fromJson(data);
    } catch (e) {
      log(e.toString());
    }
    return Users();
  }

  clearAll() {
    _box.erase();
  }
}
