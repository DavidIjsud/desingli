import '../../../../services/network/network_request.dart';

class SymbolLookUpRequest extends NetworkRequest {
  SymbolLookUpRequest({
    required String url,
    required this.symbol,
    required this.token,
  }) : super(
            url: url.replaceAll('{symbol}', symbol).replaceAll(
                  '{token}',
                  token,
                ));

  final String symbol;
  final String token;

  @override
  String? get body => '';
}
