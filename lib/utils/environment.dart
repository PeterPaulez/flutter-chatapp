import 'dart:io';

class Environment {
  static String apiURL =
      Platform.isAndroid ? 'https://dfadfasdf' : 'http://192.168.1.33:3000/api';
  static String socketURL =
      Platform.isAndroid ? 'https://dfadfasdf' : 'http://192.168.1.33:3000';
}
