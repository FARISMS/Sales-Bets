import 'package:dio/dio.dart';

class NetworkModule {
  static Dio get dio {
    final dio = Dio();

    // Base configuration
    dio.options.baseUrl = 'https://api.example.com';
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);

    // Interceptors
    dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, error: true),
    );

    return dio;
  }
}
