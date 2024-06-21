import 'package:http/http.dart' as http;

class NetworkClient {
  final _client = http.Client();

  Future<http.Response> get(
    Uri uri, {
    Map<String, String>? headers,
  }) async {
    final response = await _client.get(
      uri,
    );

    return response;
  }
}
