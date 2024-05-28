import 'package:dio/dio.dart';

BaseOptions options = BaseOptions(
  baseUrl: MyConst.myUrl,
  connectTimeout: Duration(seconds: 8),
  receiveTimeout: Duration(seconds: 8),
);

class MyConst {
  static const myUrl = 'http://127.0.0.1:8080';
  static Dio dio = Dio(options);
  static bool isTesting = false;
}
