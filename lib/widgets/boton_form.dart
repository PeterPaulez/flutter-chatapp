import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {
  final String placeHolder;
  final Map printData;
  final Function onPressed;

  const BotonAzul({
    Key key,
    @required this.placeHolder,
    @required this.printData,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      elevation: 2,
      highlightElevation: 5,
      color: Colors.blue,
      shape: StadiumBorder(),
      child: Container(
        width: double.infinity,
        height: 55,
        child: Center(
          child: Text(
            this.placeHolder,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      onPressed: this.onPressed,
      /*
      onPressed: () {
        printData.forEach((key, value) {
          print('KEY: $key');
          print('VALUE: $value');
        });
      },
      */
    );
  }
}
