import '../../modules/selection_stock/data/models/symbol_look_up.dart';

abstract class FinnhubWebSocketService {
  void connect(Function(Map<String, dynamic>) onMessage);
  void subscribe(
    List<SymbolLookUp> listOfSymbols,
  );
  void unsubscribe(
    List<SymbolLookUp> listOfSymbols,
  );
  void disconnect();
}
