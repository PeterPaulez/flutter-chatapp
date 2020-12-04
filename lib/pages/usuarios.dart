import 'package:chatapp/models/usuario.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/chat.dart';
import 'package:chatapp/services/socket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsuariosPage extends StatefulWidget {
  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final chatService = ChatService();

  /*
  final usuarios = [
    Usuario(uid: '1', nombre: 'María', email: 'maria@test.com', online: true),
    Usuario(uid: '2', nombre: 'Pepe', email: 'pepe@test.com', online: false),
    Usuario(uid: '3', nombre: 'Juana', email: 'juana@test.com', online: false),
    Usuario(uid: '4', nombre: 'Pedro', email: 'pedro@test.com', online: true),
  ];
  */
  List<Usuario> usuarios = [];
  @override
  void initState() {
    this._cargarUsuarios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final usuario = authService.usuario;
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              usuario.nombre,
              style: TextStyle(color: Colors.black87),
            ),
            Text(
              usuario.email,
              style: TextStyle(color: Colors.black54, fontSize: 12),
            ),
          ],
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.exit_to_app,
            color: Colors.black87,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, 'login');
            AuthService.deleteToken();
            socketService.disconnect();
          },
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: (socketService.serverStatus == ServerStatus.Online)
                ? Icon(Icons.check_circle, color: Colors.green)
                : Icon(Icons.offline_bolt, color: Colors.red),
          ),
        ],
      ),
      body: SmartRefresher(
        onRefresh: _cargarUsuarios,
        controller: _refreshController,
        child: _usuariosListView(),
        header: WaterDropHeader(
          complete: Icon(Icons.check, color: Colors.blue[400]),
          waterDropColor: Colors.blue[400],
        ),
        enablePullDown: true,
      ),
    );
  }

  ListView _usuariosListView() {
    return ListView.separated(
        physics: BouncingScrollPhysics(),
        itemBuilder: (_, index) => _usuarioListTile(usuarios[index]),
        separatorBuilder: (_, index) => Divider(),
        itemCount: usuarios.length);
  }

  ListTile _usuarioListTile(Usuario usuarioCHAT) {
    return ListTile(
      title: Text(usuarioCHAT.nombre),
      subtitle: Text(usuarioCHAT.email),
      leading: CircleAvatar(
        child: Text(usuarioCHAT.nombre.substring(0, 2)),
        backgroundColor: Colors.blue[100],
      ),
      onTap: () {
        Navigator.pushNamed(context, 'chat', arguments: usuarioCHAT);
        print(usuarioCHAT.uid);
      },
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: (usuarioCHAT.online) ? Colors.green : Colors.red),
      ),
    );
  }

  _cargarUsuarios() async {
    this.usuarios = await chatService.getUsuarios(context);
    setState(() {});
    //await Future.delayed(Duration(milliseconds: 500));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}
