import 'dart:io';

class Environment {
  static String apiURL = Platform.isAndroid
      ? 'http://192.168.1.33:3000/api'
      : 'http://192.168.1.33:3000/api';
  static String socketURL = Platform.isAndroid
      ? 'http://192.168.1.33:3000'
      : 'http://192.168.1.33:3000';
}
