import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moodmonster/core/local/local_storage_keys.dart';
import 'package:moodmonster/helpers/extensions/showdialog_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

late LocalStorageBase prefs;

class LocalStorageBase {
  static SharedPreferences? _sharedPrefs;
  static FlutterSecureStorage? _secureStorage;
  static LocalStorageBase? _instance;
  static late String? _idToken;

  factory LocalStorageBase() => _instance ?? LocalStorageBase._();
  LocalStorageBase._() {
    _instance = this;
  }

  static Future<void> init() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
    _secureStorage ??= const FlutterSecureStorage();
    prefs = LocalStorageBase();
    try {
      _idToken = prefs.getString(PrefsKeys.userId);
    } catch(e) {
      _idToken = 'exception';
      prefs.clearEncrypted();
      //SignOUT HERE
      ShowDialogHelper.showAlert(
        title: '데이터 무결성 경고', 
        message: '데이터 임의수정이 감지되었습니다. 보안 이슈 트래킹을 위해 서버에 기록됩니다. '
          '\n악의적인 데이터 조작 행위가 반복되면 영구정지와는 별개로 법적 처벌을 받으실 수 있습니다.'
      );
    }
  }

  ///저장되어있는 난독화 IdToken을 await없이 들고 옵니다. 이는 이전에 LocalStorageBase가 초기화되어 있어야합니다.
  String? getIdToken() {
    return _idToken;
  }

  ///첫 로그인시 idToken 강제 지정
  Future<void> setIdToken(String idToken) async {
    await setEncrypted(PrefsKeys.userId, idToken);
    _idToken = idToken;
  }

  String? getString(String key) {
    return _sharedPrefs!.getString(key);
  }

  int? getInt(String key) {
    return _sharedPrefs!.getInt(key);
  }

  bool? getBool(String key) {
    return _sharedPrefs!.getBool(key);
  }

  double? getDouble(String key) {
    return _sharedPrefs!.getDouble(key);
  }

  Future<bool> setString(String key, String value) async {
    return await _sharedPrefs!.setString(key, value);
  }

  Future<bool> setInt(String key, int value) async {
    return await _sharedPrefs!.setInt(key, value);
  }

  Future<bool> setBool(String key, bool value) async {
    return await _sharedPrefs!.setBool(key, value);
  }

  Future<bool> setDouble(String key, bool value) {
    return _sharedPrefs!.setBool(key, value);
  }

  Future<bool> remove(String key) {
    return _sharedPrefs!.remove(key);
  }

  Future<bool> clearData() => _sharedPrefs!.clear();

  ///난독화하여 저장한 sharedPreference 키.value를 불러옵니다. await 사용하세요.
  Future<String?> getEncrypted(String key) async {
    try {
      return await _secureStorage!.read(key: key);
    } on PlatformException catch (e) {
      debugPrint('$e');
      return Future<String?>.value();
    }
  }

  ///난독화하여 키, value값을 저장합니다. await 사용하세요.
  Future<bool> setEncrypted(String key, String? value) async {
    try {
      await _secureStorage!.write(key: key, value: value);
      return Future.value(true);
    } on PlatformException catch (ex) {
      debugPrint('$ex');
      return Future.value(false);
    }
  }

  Future<bool> clearEncrypted() async {
    try {
      await _secureStorage!.deleteAll();
      return true;
    } on PlatformException catch (ex) {
      debugPrint('$ex');
      return false;
    }
  }
}