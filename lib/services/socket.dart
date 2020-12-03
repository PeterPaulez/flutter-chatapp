import 'package:chatapp/services/auth.dart';
import 'package:chatapp/utils/environment.dart';
import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting,
}

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket =>
      this._socket; // Para escuchar y poder terminar con un OFF
  Function get emitir => this._socket.emit; // Sino queremos hacer un OFF

  /*
  SocketService() {
    this._initConfig();
  }
  // No quiero conectarme siempre
  */

  void connect() async {
    final token = await AuthService.getToken();
    // Dart client
    //final url = 'https://bandnames-backend.herokuapp.com/';
    // final url = 'http://localhost:3000';
    this._socket = IO.io(Environment.socketURL, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      // Trataba de hacer la misma conexión anteriormente, de esta forma forzamos una nueva.
      'forceNew': true,
      'extraHeaders': {
        'x-token': token,
      }
    });

    this._socket.on('connect', (_) {
      print('Connected');
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    this._socket.on('disconnect', (_) {
      print('Disconnected');
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    // Mejor no poner tipado al PAYLOAD
    this._socket.on('nuevo-mensaje', (payload) {
      String nombre =
          (payload.containsKey('nombre')) ? payload['nombre'] : 'Sin nombre';
      print('nuevo-mensaje: $nombre');
      notifyListeners();
    });
  }

  void disconnect() {
    this._socket.disconnect();
  }
}
