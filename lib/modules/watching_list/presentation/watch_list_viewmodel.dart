import 'dart:convert';
import 'dart:developer';

import 'package:designli/components/native_channel/channel.dart';
import 'package:designli/components/viewmodel/based_view_model.dart';
import 'package:designli/services/sockets/finnhub_web_socket_service.dart';
import 'package:collection/collection.dart';
import '../../selection_stock/data/models/symbol_look_up.dart';

class WatchListState {
  List<SymbolLookUp>? listSymbols;

  WatchListState({this.listSymbols});

  WatchListState copyWith({
    List<SymbolLookUp>? listSymbols,
  }) {
    return WatchListState(
      listSymbols: listSymbols ?? this.listSymbols,
    );
  }
}

class WatchListViewModel extends BaseViewModel<WatchListState> {
  final FinnhubWebSocketService _finnhubWebSocketService;

  WatchListViewModel({required FinnhubWebSocketService finnhubWebSocketService})
      : _finnhubWebSocketService = finnhubWebSocketService;

  List<SymbolLookUp>? _listOfSymbolsSearched;
  SymbolLookUp? _symbolSelectedForAlert;
  double? _priceForAlert;

  void initViewModel() {
    super.initialize(WatchListState());
  }

  List<SymbolLookUp>? get getListSymbolsSearched => _listOfSymbolsSearched;

  assignListSearchedSymbols(List<SymbolLookUp>? listSymbols) {
    _listOfSymbolsSearched = listSymbols;
    setState(state!.copyWith(
      listSymbols: _listOfSymbolsSearched,
    ));
  }

  assignPriceForAlert(double? priceForAlert) {
    _priceForAlert = priceForAlert;
  }

  assignSymbolSelectedForAlert(SymbolLookUp? symbolSelectedForAlert) {
    _symbolSelectedForAlert = symbolSelectedForAlert;
  }

  double _marginalPorcentage(double? currentPrice, double? previusPrice) {
    if (currentPrice == null || previusPrice == null) {
      return 0.0;
    }

    double percentageChange =
        ((currentPrice - previusPrice) / previusPrice) * 100;
    return percentageChange;
  }

  bool containsData(Map<String, dynamic> data) {
    final containsData = data.containsKey('data') && data['data'] != null;
    if (containsData) {
      final dataList = data['data'] as List<dynamic>;
      if (dataList.isNotEmpty) {
        final Map<String, dynamic> firstData = dataList.first;
        if (firstData.containsKey('p') &&
            firstData.containsKey('s') &&
            firstData['p'] != null &&
            firstData['s'] != null) {
          return true;
        }
      }
    }

    return false;
  }

  SymbolLookUp assingNewPrices(double newPrice, SymbolLookUp newUpdatedSymbol) {
    List<double> pricesOfSymbolUpdated = List.from(newUpdatedSymbol.prices!);
    if (newUpdatedSymbol.prices!.length >= 25) {
      pricesOfSymbolUpdated.removeAt(0);
    }

    pricesOfSymbolUpdated.add(newPrice);
    return newUpdatedSymbol.copyWith(
      prices: pricesOfSymbolUpdated,
    );
  }

  _checkForAlert(String symbol, double newPrice) {
    log("Symbol to search ${_symbolSelectedForAlert?.symbol} and symbol received $symbol, price for alert $_priceForAlert and price received $newPrice ");
    if (_symbolSelectedForAlert != null &&
        _priceForAlert != null &&
        _symbolSelectedForAlert!.symbol == symbol &&
        newPrice > _priceForAlert!) {
      log("Notification sent");
      ChannelNative.platform.invokeMethod('launchLocalNotification', {
        "title": "Price changed",
        "message":
            "The price for $symbol has changed \n the new price is $newPrice"
      }).then((value) {
        log("Returned notification $value");
      }).catchError((error) {
        log('Ocurred error on sending notification 2 $error');
      });
    }
  }

  void _verifyDataOnListToUpdate(Map<String, dynamic> data) {
    log("New data $data");
    if (containsData(data)) {
      final String symbol = (data['data'] as List<dynamic>).first['s'];
      final double newPrice = (data['data'] as List<dynamic>).first['p'];
      _checkForAlert(symbol, newPrice);
      final symbolStockToUpdate = _listOfSymbolsSearched
          ?.firstWhereOrNull((stock) => symbol == stock.symbol);
      if (symbolStockToUpdate != null) {
        final indexOfStockSymbolToUdpte = _listOfSymbolsSearched
            ?.indexWhere((stock) => symbol == stock.symbol);
        var newSymbolStockUpdated = symbolStockToUpdate.copyWith(
          currentPrice: newPrice,
          porcentChange:
              _marginalPorcentage(newPrice, symbolStockToUpdate.currentPrice),
        );
        newSymbolStockUpdated = assingNewPrices(
          newPrice,
          newSymbolStockUpdated,
        );
        _listOfSymbolsSearched?.removeAt(indexOfStockSymbolToUdpte!);
        _listOfSymbolsSearched?.insert(
            indexOfStockSymbolToUdpte!, newSymbolStockUpdated);
        setState(state!.copyWith(
          listSymbols: _listOfSymbolsSearched,
        ));
      }
    }
  }

  disconnectSocket() {
    _finnhubWebSocketService.disconnect();
  }

  connectSocket() {
    _finnhubWebSocketService.connect((Map<String, dynamic> data) {
      _verifyDataOnListToUpdate(data);
    });

    _finnhubWebSocketService.subscribe(_listOfSymbolsSearched ?? []);
  }
}
