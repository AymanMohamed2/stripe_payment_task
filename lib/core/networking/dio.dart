import 'package:dio/dio.dart';
import 'package:stripe_integration_task/core/networking/api_service.dart';

class DioService extends ApiService {
  final Dio _dio;

  DioService(this._dio);

  @override
  Future<Map<String, dynamic>> get(
      {required String url, Map<String, dynamic>? headers}) async {
    var response = await _dio.get(
      url,
      options: Options(
        headers: headers ?? {'accept': "application/json"},
      ),
    );
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> delete(
      {required String url, Map<String, dynamic>? headers, required}) {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> patch(
      {required String url, Map<String, dynamic>? headers}) {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> post(
      {required String url,
      Map<String, dynamic>? headers,
      required Map<String, dynamic> data}) async {
    var response =
        await _dio.post(url, data: data, options: Options(headers: headers));
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> put(
      {required String url,
      Map<String, dynamic>? headers,
      required Map<String, dynamic> data}) async {
    var response =
        await _dio.put(url, options: Options(headers: headers), data: data);
    return response.data;
  }
}
