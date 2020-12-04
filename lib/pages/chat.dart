import 'dart:io';

import 'package:chatapp/models/mensajes_response.dart';
import 'package:chatapp/models/usuario.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/chat.dart';
import 'package:chatapp/services/socket.dart';
import 'package:chatapp/widgets/chatMessage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();
  bool _escribiendo = false;
  List<ChatMessage> _messages = [];
  ChatService chatService;
  SocketService socketService;
  AuthService authService;
  Usuario usuarioChat;

  @override
  void initState() {
    super.initState();
    this.chatService = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);
    this.socketService.socket.on('mensaje-personal', _escucharMensajes);
    _cargarHistorial();
  }

  void _escucharMensajes(dynamic payload) {
    ChatMessage socketMessage = new ChatMessage(
      texto: payload['mensaje'],
      uid: payload['de'],
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 300)),
    );

    setState(() {
      _messages.insert(0, socketMessage);
    });

    socketMessage.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    this.usuarioChat = chatService.usuarioChat;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //COLOR del BACK BUtton
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        actions: [],
        title: Column(
          children: [
            CircleAvatar(
              child: Text(this.usuarioChat.nombre.substring(0, 2),
                  style: TextStyle(fontSize: 12)),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            SizedBox(height: 3),
            Text(
              this.usuarioChat.nombre,
              style: TextStyle(color: Colors.black87, fontSize: 12),
            ),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            // Widget capaz de expandirse sin problemas para los ListTiles
            Flexible(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder: (_, index) => _messages[index],
                reverse: true,
              ),
            ),
            Divider(height: 1),
            Container(
              color: Colors.white,
              child: _inputChatBox(),
            )
          ],
        ),
      ),
    );
  }

  Widget _inputChatBox() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (String texto) {
                  setState(() {
                    if (texto.trim().length > 0)
                      _escribiendo = true;
                    else
                      _escribiendo = false;
                  });
                },
                decoration: InputDecoration.collapsed(
                  hintText: 'Enviar mensaje',
                ),
                focusNode: _focusNode,
              ),
            ),
            // Boton de enviar
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: Platform.isIOS
                  ? CupertinoButton(
                      child: Text('Enviar'),
                      onPressed: (_escribiendo)
                          ? () => _handleSubmit(_textController.text.trim())
                          : null,
                    )
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      child: IconTheme(
                        data: IconThemeData(color: Colors.blue[400]),
                        child: IconButton(
                          // Poner transparente el circulo del 'click'
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          icon: Icon(Icons.send),
                          onPressed: (_escribiendo)
                              ? () => _handleSubmit(_textController.text.trim())
                              : null,
                        ),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  _handleSubmit(String texto) {
    if (texto.length == 0) return;
    _textController.clear();
    _focusNode.requestFocus();
    _escribiendo = false;
    // Creamos el mensaje para meterlo en el ListTile como uno más
    // Lo hacemos con modelo y como widget de una tirada, 2 por el precio de 1
    final newMessage = new ChatMessage(
      uid: authService.usuario.uid,
      texto: texto,
      animationController: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 400),
      ),
    );
    newMessage.animationController.forward();

    setState(() {
      _messages.insert(0, newMessage);
    });
    this.socketService.emitir('mensaje-personal', {
      'de': this.authService.usuario.uid,
      'para': this.usuarioChat.uid,
      'mensaje': texto,
    });
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }

    this.socketService.socket.off('mensaje-personal');
    super.dispose();
  }

  _cargarHistorial() async {
    List<Mensaje> chat = await this
        .chatService
        .getMensajes(context, chatService.usuarioChat.uid);
    final history = chat.map((m) => new ChatMessage(
          texto: m.mensaje,
          uid: m.de,
          animationController: AnimationController(
            vsync: this,
            duration: Duration(milliseconds: 400),
          )..forward(),
        ));

    setState(() {
      _messages.insertAll(0, history);
    });
  }
}
