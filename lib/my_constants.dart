import 'package:dio/dio.dart';

BaseOptions options = BaseOptions(
  baseUrl: MyConst.myUrl,
  connectTimeout: Duration(seconds: 10),
  receiveTimeout: Duration(seconds: 10),
);

class MyConst {
  static const myUrl = 'http://127.0.0.1:8080';
  static Dio dio = Dio(options);
  static bool isTesting = false;
}
