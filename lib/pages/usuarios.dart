import 'package:chatapp/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsuariosPage extends StatefulWidget {
  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final usuarios = [
    Usuario(uid: '1', nombre: 'María', email: 'maria@test.com', online: true),
    Usuario(uid: '2', nombre: 'Pepe', email: 'pepe@test.com', online: false),
    Usuario(uid: '3', nombre: 'Juana', email: 'juana@test.com', online: false),
    Usuario(uid: '4', nombre: 'Pedro', email: 'pedro@test.com', online: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mi nombre',
          style: TextStyle(color: Colors.black87),
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.exit_to_app,
            color: Colors.black87,
          ),
          onPressed: () {},
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.check_circle,
              color: Colors.green,
            ),
            /*
            child: Icon(
              Icons.offline_bolt,
              color: Colors.red,
            ),
            */
          )
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

  ListTile _usuarioListTile(Usuario usuario) {
    return ListTile(
      title: Text(usuario.nombre),
      subtitle: Text(usuario.email),
      leading: CircleAvatar(
        child: Text(usuario.nombre.substring(0, 2)),
        backgroundColor: Colors.blue[100],
      ),
      onTap: () {
        print(usuario.uid);
      },
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: (usuario.online) ? Colors.green : Colors.red),
      ),
    );
  }

  _cargarUsuarios() async {
    await Future.delayed(Duration(milliseconds: 500));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}
