class Endpoints {
  Endpoints({
    required this.symbolLookApi,
    required this.tokenFinhub,
  });

  factory Endpoints.fromMap(Map<String, dynamic> map) => Endpoints(
        symbolLookApi: map[_AttributesKeys.symbolLookUp],
        tokenFinhub: map[_AttributesKeys.tokenFinhub],
      );

  final String symbolLookApi;
  final String tokenFinhub;
}

abstract class _AttributesKeys {
  static const symbolLookUp = "symbolLookUp";
  static const tokenFinhub = "tokenFinhub";
}
