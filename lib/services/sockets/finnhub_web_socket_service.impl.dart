import 'dart:convert';

import 'package:designli/services/network/end_points.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../modules/selection_stock/data/models/symbol_look_up.dart';
import 'finnhub_web_socket_service.dart';

class FinnhubWebSocketServiceImpl implements FinnhubWebSocketService {
  Endpoints _endPoints;
  WebSocketChannel? _channel;

  FinnhubWebSocketServiceImpl({
    required Endpoints endpoints,
  }) : _endPoints = endpoints;

  @override
  connect(Function(Map<String, dynamic>) onMessage) {
    String url =
        _endPoints.socketUrlBase.replaceAll('{token}', _endPoints.tokenFinhub);
    _channel = WebSocketChannel.connect(Uri.parse(url));

    _channel?.stream.listen((message) {
      final Map<String, dynamic> data = jsonDecode(message);
      onMessage(data);
    });
  }

  @override
  void disconnect() {
    _channel?.sink.close();
  }

  @override
  subscribe(List<SymbolLookUp> listOfSymbols) {
    for (SymbolLookUp symbolLookup in listOfSymbols) {
      _channel?.sink.add(jsonEncode({
        'type': 'subscribe',
        'symbol': symbolLookup.symbol,
      }));
    }
  }

  @override
  unsubscribe(List<SymbolLookUp> listOfSymbols) {}
}
