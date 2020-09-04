import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_api_rest/api/my_api.dart';
import 'package:flutter_api_rest/pages/login_page.dart';
import 'package:meta/meta.dart' show required;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Auth {
  Auth._internal();
  static Auth _instance = Auth._internal();

  static Auth get instance => _instance;

  final _storage = FlutterSecureStorage();
  final key = 'SESSION';

  Completer _completer;

  Future<String> get accessToken async {
    if (_completer != null) {
      await _completer.future;
    }

    _completer = Completer();

    final Session session = await this.getSession();
    if (session != null) {
      final DateTime currentDate = DateTime.now();
      final DateTime createdAt = session.createdAt;
      final int expiresIn = session.expiresIn;
      final int diff = currentDate.difference(createdAt).inSeconds;
      print('${expiresIn - diff}');
      if (expiresIn - diff >= 60) {
        print('Token alive');
        _completer.complete();
        return session.token;
      } else {
        final Map<String, dynamic> data =
            await MyAPI.instance.refresh(session.token);
        print('Refresh Token');
        if (data != null) {
          await this.setSession(data);
          _completer.complete();
          return data['token'];
        }
        _completer.complete();
        return null;
      }
    }
    _completer.complete();
    print('Session null');
    return null;
  }

  Future<void> setSession(Map<String, dynamic> data) async {
    final Session session = Session(
      token: data['token'],
      expiresIn: data['expiresIn'],
      createdAt: DateTime.now(),
    );
    final String value = jsonEncode(session.toJson());
    await this._storage.write(key: key, value: value);
    print('Session saved');
  }

  Future<Session> getSession() async {
    final String value = await this._storage.read(key: key);
    if (value != null) {
      final Map<String, dynamic> json = jsonDecode(value);
      final session = Session.fromJson(json);
      return session;
    }
    return null;
  }

  Future<void> logOut(BuildContext context) async {
    await this._storage.deleteAll();
    Navigator.pushNamedAndRemoveUntil(
      context,
      LoginPage.routeName,
      (route) => false,
    );
  }
}

class Session {
  final String token;
  final int expiresIn;
  final DateTime createdAt;

  Session({
    @required this.token,
    @required this.expiresIn,
    @required this.createdAt,
  });

  static Session fromJson(Map<String, dynamic> json) {
    return Session(
      token: json['token'],
      expiresIn: json['expiresIn'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': this.token,
      'expiresIn': this.expiresIn,
      'createdAt': this.createdAt.toString(),
    };
  }
}
