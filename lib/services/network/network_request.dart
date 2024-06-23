abstract class NetworkRequest {
  NetworkRequest({required this.url});

  final String url;

  String? get body;

  Map<String, String>? get headers => {
        'Accept': 'application/json',
        'charset': 'UTF-8',
        'Content-Type': 'application/json',
      };
}
