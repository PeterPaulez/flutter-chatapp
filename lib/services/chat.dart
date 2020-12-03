import 'package:chatapp/models/usuario.dart';
import 'package:chatapp/models/usuarios_response.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/utils/environment.dart';
import 'package:chatapp/utils/mostrarAlertas.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatService {
  Future<List<Usuario>> getUsuarios(BuildContext context) async {
    try {
      final answer = await http.get(
        '${Environment.apiURL}/chat/list',
        headers: {
          'Content-type': 'application/json',
          'x-token': await AuthService.getToken(),
        },
      );
      final usuariosResponse = usuariosResponseFromJson(answer.body);
      return usuariosResponse.usuarios;
    } catch (e) {
      print('Server Down');
      mostrarAlertaForm(context, 'Something goes wrong', 'Server is Down');
      return [];
    }
  }
}
