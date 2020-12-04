class Environment {
  static bool test = false;
  static String apiURL = test
      ? 'http://192.168.1.33:3000/api'
      : 'https://chatappflutter-backend.herokuapp.com/api';
  static String socketURL = test
      ? 'http://192.168.1.33:3000'
      : 'https://chatappflutter-backend.herokuapp.com';
}
