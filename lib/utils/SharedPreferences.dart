import 'dart:convert';

import 'package:dart_des/dart_des.dart';
import 'package:gcrs/utils/cipher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cipher.dart';

class PrefKey {
  static final id = "uid";
  static final pw = "upw";
  static final starred = "usr";
}

class PreferencesManager {
  PreferencesManager._();
  static PreferencesManager _instance = PreferencesManager._();
  static PreferencesManager get instance => _instance;

  late SharedPreferences _prefs;

  String _userId = "";
  List<String> _userPassword = [];
  List<String> _starredClassroom = [];

  //
  //
  //
  //
  //
  String get userId => _userId;

  String get userPassword {
    if (_userPassword.length == 0) return "";
    return decrypt(input: _userPassword);
  }

  List<String> get starredClassroom => _starredClassroom;

  //
  //
  //
  //
  //
  set userId(String userId) {
    _prefs.setString(PrefKey.id, userId);
    _userId = userId;
  }

  set userPassword(String password) {
    if (password.length == 0) return;
    List<String> result = encrypt(input: password);
    _prefs.setStringList(PrefKey.pw, result);
  }

  set starredClassroom(List<String> starred) {
    _prefs.setStringList(PrefKey.starred, starred);
    _userId = userId;
  }

  //
  //
  //
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    print("========================");
    _userId = _prefs.getString(PrefKey.id) ?? "";
    _userPassword = _prefs.getStringList(PrefKey.pw) ?? [];
    _starredClassroom = _prefs.getStringList(PrefKey.starred) ?? [];
    print("_userId: $_userId");
    print("_userPw: $_userPassword");
    print("_starredClassroom: $_starredClassroom");
  }

  //
  //
  //
  //
  //
  List<String> encrypt({required String input}) {
    DES3 crypto = DES3(
      key: Cipher.key.codeUnits,
      mode: DESMode.CBC,
      iv: Cipher.iv.codeUnits,
    );
    List<int> crypted = crypto.encrypt(input.codeUnits);
    List<String> result = [];
    for (var i in crypted) result.add(i.toString());

    return result;
  }

  String decrypt({required List<String> input}) {
    List<int> target = [];
    for (String i in input) target.add(int.parse(i));

    DES3 crypto = DES3(
      key: Cipher.key.codeUnits,
      mode: DESMode.CBC,
      iv: Cipher.iv.codeUnits,
    );

    List<int> decrypted = crypto.decrypt(target);

    return utf8.decode(decrypted);
  }
}
