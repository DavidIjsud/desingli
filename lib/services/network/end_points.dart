class Endpoints {
  Endpoints({
    required this.symbolLookApi,
    required this.tokenFinhub,
    required this.socketUrlBase,
    required this.domainUrl,
    required this.clientIdAuth0,
  });

  factory Endpoints.fromMap(Map<String, dynamic> map) => Endpoints(
        symbolLookApi: map[_AttributesKeys.symbolLookUp],
        tokenFinhub: map[_AttributesKeys.tokenFinhub],
        socketUrlBase: map[_AttributesKeys.socketUrlBase],
        domainUrl: map[_AttributesKeys.domainUrlAuth0],
        clientIdAuth0: map[_AttributesKeys.clientIdAuth0],
      );

  final String symbolLookApi;
  final String tokenFinhub;
  final String socketUrlBase;
  final String domainUrl;
  final String clientIdAuth0;
}

abstract class _AttributesKeys {
  static const symbolLookUp = "symbolLookUp";
  static const tokenFinhub = "tokenFinhub";
  static const socketUrlBase = "socketUrlBase";
  static const domainUrlAuth0 = "domainUrlAuth0";
  static const clientIdAuth0 = "clientIdAuth0";
}
