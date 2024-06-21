import 'dart:async';

import 'package:designli/components/viewmodel/based_view_model.dart';
import 'package:designli/modules/selection_stock/data/repository/stock_selection_repository.dart';

import '../../../components/exceptions/server_exceptions.dart';
import '../data/models/symbol_look_up.dart';
import '../data/repository/stock_selection_repository.dart';

class SelectionStockState {
  bool? isSearchingStock;
  List<SymbolLookUp>? listOfStocksSymbolsFound;
  bool? ocurredError;
  String? errorMessage;
  bool? productsObtainedSuccessfull;
  SelectionStockState({
    this.isSearchingStock,
    this.listOfStocksSymbolsFound,
    this.ocurredError,
    this.errorMessage,
    this.productsObtainedSuccessfull,
  });

  SelectionStockState copyWith({
    bool? isSearchingStock,
    List<SymbolLookUp>? listOfStocksSymbolsFound,
    bool? ocurredError,
    String? errorMessage,
    bool? productsObtainedSuccessfull,
  }) {
    return SelectionStockState(
      isSearchingStock: isSearchingStock ?? this.isSearchingStock,
      listOfStocksSymbolsFound:
          listOfStocksSymbolsFound ?? this.listOfStocksSymbolsFound,
      ocurredError: ocurredError ?? this.ocurredError,
      errorMessage: errorMessage ?? this.errorMessage,
      productsObtainedSuccessfull:
          productsObtainedSuccessfull ?? this.productsObtainedSuccessfull,
    );
  }
}

class SelectionStockViewModel extends BaseViewModel<SelectionStockState> {
  SelectionStockViewModel({required StockRepository stockRepository})
      : _stockRepository = stockRepository;

  final StockRepository _stockRepository;

  SymbolLookUp? _symbolLookUpSelected;
  double? _priceSelected;
  List<SymbolLookUp>? _listOfStocksSymbolsFound;
  Timer? _debounce;

  SymbolLookUp? get getSymbolSelected => _symbolLookUpSelected;
  double? get getPriceSelected => _priceSelected;
  List<SymbolLookUp>? get getSymbolsResultOfSearch => _listOfStocksSymbolsFound;

  addValueToSymbolSelected(SymbolLookUp symbolLookUp) {
    _symbolLookUpSelected = symbolLookUp;
  }

  addValueToPriceForAlert(double price) {
    _priceSelected = price;
  }

  Future<void> initViewModel() async {
    super.initialize(SelectionStockState());
  }

  void disposeTimerDebounce() {
    _debounce?.cancel();
  }

  resetState() {
    setState(state!.copyWith(
      isSearchingStock: false,
      ocurredError: false,
      errorMessage: '',
      productsObtainedSuccessfull: false,
    ));
  }

  Future<void> searchSymbol({required String symbol}) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    setState(state!.copyWith(
      isSearchingStock: true,
      ocurredError: false,
      errorMessage: '',
      productsObtainedSuccessfull: false,
    ));
    _debounce = Timer(const Duration(milliseconds: 600), () async {
      try {
        final response = await _stockRepository.searchSymbol(symbol: symbol);
        response.fold((l) {
          setState(state!.copyWith(
            isSearchingStock: false,
            ocurredError: true,
            errorMessage: "An error ocurred",
            productsObtainedSuccessfull: false,
          ));
        }, (listOfSymbols) {
          if (state?.isSearchingStock == true) {
            _listOfStocksSymbolsFound = listOfSymbols;
            setState(state!.copyWith(
              isSearchingStock: false,
              listOfStocksSymbolsFound: listOfSymbols,
              ocurredError: false,
              productsObtainedSuccessfull: true,
            ));
          }
        });
      } on ServerException catch (e) {
        setState(state!.copyWith(
          isSearchingStock: false,
          ocurredError: true,
          errorMessage: "An error ocurred $e",
          productsObtainedSuccessfull: false,
        ));
      }
    });
  }
}
