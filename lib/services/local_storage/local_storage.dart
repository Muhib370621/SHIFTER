import 'dart:developer';

import 'package:get_storage/get_storage.dart';

import 'local_storage_keys.dart';

class LocalStorage {

  static init() async {
    // log("access token 1 "+LocalStorage.readJson(key: LocalStorageKeys.accessToken).toString());
     await GetStorage.init();
    // log("access token 2 "+LocalStorage.readJson(key: LocalStorageKeys.accessToken).toString());
  }

  static saveJson({required String key, required String value}) {
    final getStorage = GetStorage();
    var res = getStorage.write(key, value);
   // print("check after save : ${ readJson(key: key)}");
    return res;
  }

  static readJson({required String key}) {
    final getStorage = GetStorage();
    var res = getStorage.read(key);
    return res;
  }

  static deleteJson({required key}) {
    final getStorage = GetStorage();
    var res = getStorage.remove("$key");
    return res;
  }

}