import 'dart:convert';

import 'package:chatapp/models/login_response.dart';
import 'package:chatapp/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:chatapp/utils/environment.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService with ChangeNotifier {
  Usuario usuario; // Inicializamos
  String msg;
  final _storage = new FlutterSecureStorage();

  bool _autenticando =
      false; // Es privado por lo tanto debesmos crear getter y setter
  bool get autenticando => this._autenticando;
  set autenticando(bool valor) {
    this._autenticando = valor;
    notifyListeners();
  }

  // Getters token de forma static para no tener que estanciar el PROVIDER
  // Para poder llamar a authServer.token
  static Future<String> getToken() async {
    final _storage = new FlutterSecureStorage(); // Por estar en static
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage(); // Por estar en static
    await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    final data = {
      'email': email,
      'password': password,
    };

    final answer = await http.post(
      '${Environment.apiURL}/usuario/login',
      body: jsonEncode(data),
      headers: {'Content-type': 'application/json'},
    );

    print(answer.body);
    this.autenticando = false;
    if (answer.statusCode == 200) {
      final loginResponse = loginResponseFromJson(answer.body);
      this.usuario = loginResponse.usuario;
      print('Usuario UID: ${this.usuario.uid}');
      await this._guardarToken(loginResponse.token);
      return true;
    } else {
      /*
      FIXME
      Esto es feo que te cagas, perooooooo por fin leo bien una respuesta en oldSchool
      */
      Map bodyResponse = jsonDecode(answer.body);
      this.msg = bodyResponse['msg'];
      return false;
    }
  }

  Future _guardarToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    return await _storage.delete(key: 'token');
  }
}
