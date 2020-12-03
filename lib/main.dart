import 'package:chatapp/pages/chat.dart';
import 'package:chatapp/pages/loading.dart';
import 'package:chatapp/pages/login.dart';
import 'package:chatapp/pages/register.dart';
import 'package:chatapp/pages/usuarios.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/socket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => SocketService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'loading',
        routes: {
          'usuarios': (_) => UsuariosPage(),
          'chat': (_) => ChatPage(),
          'login': (_) => LoginPage(),
          'register': (_) => RegisterPage(),
          'loading': (_) => LoadingPage(),
        },
      ),
    );
  }
}
