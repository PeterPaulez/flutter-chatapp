import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  final String route;
  final String titulo;
  final String subtitulo;

  const Footer({
    Key key,
    @required this.route,
    @required this.titulo,
    @required this.subtitulo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            this.titulo,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 15,
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, this.route);
            },
            child: Text(
              this.subtitulo,
              style: TextStyle(
                color: Colors.blue[600],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
