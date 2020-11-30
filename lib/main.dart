import 'package:chatapp/pages/chat.dart';
import 'package:chatapp/pages/loading.dart';
import 'package:chatapp/pages/login.dart';
import 'package:chatapp/pages/register.dart';
import 'package:chatapp/pages/usuarios.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'chat',
      routes: {
        'usuarios': (_) => UsuariosPage(),
        'chat': (_) => ChatPage(),
        'login': (_) => LoginPage(),
        'register': (_) => RegisterPage(),
        'loading': (_) => LoadingPage(),
      },
    );
  }
}
