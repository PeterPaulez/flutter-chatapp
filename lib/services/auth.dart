import 'dart:convert';

import 'package:chatapp/models/login_response.dart';
import 'package:chatapp/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:chatapp/utils/environment.dart';

class AuthService with ChangeNotifier {
  Usuario usuario;
  Future login(String email, String password) async {
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
    if (answer.statusCode == 200) {
      final loginResponse = loginResponseFromJson(answer.body);
      this.usuario = loginResponse.usuario;
      print('Usuario UID: ${this.usuario.uid}');
    }
  }
}
