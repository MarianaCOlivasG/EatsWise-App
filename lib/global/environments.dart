



import 'dart:io';

class Environments {

  static String apiUrl = Platform.isAndroid ? 'http://192.168.1.50:3500/api' : 'http://localhost:3500/api';
  static String socketUrl = Platform.isAndroid ? 'http://192.168.1.50:3500/' : 'http://localhost:3500/';

}