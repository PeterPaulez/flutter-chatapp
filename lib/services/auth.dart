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
    this.autenticando = true;
    final answer = await doRequest(
      '/usuario/login',
      {'email': email, 'password': password},
      {'Content-type': 'application/json'},
      'post',
    );

    if (answer != null) print('BODY: ${answer.body}');
    this.autenticando = false;
    if (answer != null && answer.statusCode == 200) {
      final loginResponse = loginResponseFromJson(answer.body);
      this.usuario = loginResponse.usuario;
      await this._guardarToken(loginResponse.token);
      return true;
    } else {
      /*
      FIXME
      Esto es feo que te cagas, perooooooo por fin leo bien una respuesta en oldSchool
      */
      if (answer != null) {
        Map bodyResponse = jsonDecode(answer.body);
        String msgerror;
        this.msg = (bodyResponse.containsKey('msg'))
            ? bodyResponse['msg']
            : 'No answer';
        // Gestión de los errores y pintado en el DIALOG
        if (bodyResponse.containsKey('errors')) {
          bodyResponse['errors'].forEach((key, value) {
            if (msgerror == null) {
              msgerror = bodyResponse['errors'][key]['msg'];
            } else {
              msgerror = msgerror + '\n' + bodyResponse['errors'][key]['msg'];
            }
          });
        }
        if (msgerror != null) this.msg = msgerror;
      } else {
        this.msg = 'Server Down';
      }
      return false;
    }
  }

  Future<bool> register(String email, String password, String nombre) async {
    this.autenticando = true;
    final answer = await doRequest(
      '/usuario/new',
      {'email': email, 'password': password, 'nombre': nombre},
      {'Content-type': 'application/json'},
      'post',
    );

    if (answer != null) print('BODY: ${answer.body}');
    this.autenticando = false;
    if (answer != null && answer.statusCode == 200) {
      final loginResponse = loginResponseFromJson(answer.body);
      this.usuario = loginResponse.usuario;
      await this._guardarToken(loginResponse.token);
      return true;
    } else {
      if (answer != null) {
        Map bodyResponse = jsonDecode(answer.body);
        String msgerror;
        this.msg = (bodyResponse.containsKey('msg'))
            ? bodyResponse['msg']
            : 'No answer';
        // Gestión de los errores y pintado en el DIALOG
        if (bodyResponse.containsKey('errors')) {
          bodyResponse['errors'].forEach((key, value) {
            if (msgerror == null) {
              msgerror = bodyResponse['errors'][key]['msg'];
            } else {
              msgerror = msgerror + '\n' + bodyResponse['errors'][key]['msg'];
            }
          });
        }
        if (msgerror != null) this.msg = msgerror;
      } else {
        this.msg = 'Server Down';
      }
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await this._storage.read(key: 'token');
    final answer = await doRequest(
      '/usuario/renew',
      null,
      {'Content-type': 'application/json', 'x-token': token},
      'get',
    );

    if (answer != null && answer.statusCode == 200) {
      final loginResponse = loginResponseFromJson(answer.body);
      this.usuario = loginResponse.usuario;
      print('Usuario UID: ${this.usuario.uid}');
      await this._guardarToken(loginResponse.token);
      return true;
    } else {
      this.logout();
      return false;
    }
  }

  Future doRequest(
      String url, data, Map<String, String> headers, String method) async {
    try {
      if (method == 'get') {
        final answer = await http.get(
          '${Environment.apiURL}$url',
          headers: headers,
        );
        return answer;
      } else {
        final answer = await http.post(
          '${Environment.apiURL}$url',
          body: jsonEncode(data),
          headers: headers,
        );
        return answer;
      }
    } catch (e) {
      print('Error => $e');
      return;
    }
  }

  Future _guardarToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    return await _storage.delete(key: 'token');
  }
}
