abstract class ApiService {
  Future<Map<String, dynamic>> get(
      {required String url, Map<String, dynamic>? headers});
  Future<Map<String, dynamic>> post({
    required String url,
    Map<String, dynamic>? headers,
    required Map<String, dynamic> data,
  });
  Future<Map<String, dynamic>> delete(
      {required String url, Map<String, dynamic>? headers});
  Future<Map<String, dynamic>> put(
      {required String url,
      Map<String, dynamic>? headers,
      required Map<String, dynamic> data});
  Future<Map<String, dynamic>> patch(
      {required String url, Map<String, dynamic>? headers});
}
