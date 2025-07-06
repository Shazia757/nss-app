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

  writeToken(String toc) {
    try {
      _box.write('token', toc);
    } catch (e) {
      log(e.toString());
    }
  }

  String? readToken() {
    try {
      final token = _box.read('token');
      return token;
    } catch (e) {
      log(e.toString());
      return null;
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
