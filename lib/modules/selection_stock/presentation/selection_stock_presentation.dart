import 'package:designli/components/widgets/buttons/primary_button.dart';
import 'package:designli/modules/selection_stock/presentation/selection_stock_view_model.dart';
import 'package:designli/modules/selection_stock/presentation/widgets/result_stocks_card.dart';
import 'package:designli/modules/watching_list/presentation/watch_list_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CustomCommaRemover extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text.replaceAll(',', '');
    int periodCount = newText.split('.').length - 1;
    if (periodCount > 1) {
      return oldValue;
    }
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class SelectionStockSymbolPage extends StatefulWidget {
  const SelectionStockSymbolPage({super.key});

  @override
  State<SelectionStockSymbolPage> createState() =>
      _SelectionStockSymbolPageState();
}

class _SelectionStockSymbolPageState extends State<SelectionStockSymbolPage> {
  late final SelectionStockViewModel _selectionStockViewModel;
  late final WatchListViewModel _watchListViewModel;
  late TextEditingController _stockController, _priceController;

  @override
  void initState() {
    super.initState();
    _stockController = TextEditingController();
    _priceController = TextEditingController();
    _watchListViewModel = context.read<WatchListViewModel>();
    _selectionStockViewModel = context.read<SelectionStockViewModel>();
    _selectionStockViewModel.disposeTimerDebounce();
    _watchListViewModel.disconnectSocket();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _selectionStockViewModel.requestPostNotificationsPermission();
    });
  }

  _startWatchingChangesAndNotifications() {
    _watchListViewModel.assignListSearchedSymbols(
      _selectionStockViewModel.getSymbolsResultOfSearch,
    );
    _watchListViewModel.connectSocket();
  }

  bool areDataEnteredCorrect() {
    return _stockController.value.text.isNotEmpty &&
        _priceController.value.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Column(
                  children: [
                    TextField(
                      controller: _stockController,
                      keyboardType: TextInputType.text,
                      maxLength: 30,
                      onChanged: (String newQuery) {
                        if (newQuery.isNotEmpty) {
                          _selectionStockViewModel.searchSymbol(
                              symbol: newQuery);
                        } else {
                          _selectionStockViewModel.resetState();
                        }
                      },
                      decoration: const InputDecoration(
                          hintText: "Search stock for alert",
                          counter: Offstage()),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    TextField(
                      controller: _priceController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        CustomCommaRemover(),
                      ],
                      maxLength: 30,
                      onChanged: (String price) {
                        _selectionStockViewModel.addValueToPriceForAlert(
                            price.isNotEmpty ? double.parse(price) : null);
                      },
                      decoration: const InputDecoration(
                          hintText: "Add price", counter: Offstage()),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    ButtonPrimary(
                      isActive: true,
                      onPressed: () {
                        if (areDataEnteredCorrect()) {
                          context
                              .read<WatchListViewModel>()
                              .assignPriceForAlert(
                                  double.parse(_priceController.value.text));
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  backgroundColor: const Color(0xFFE18274),
                                  content: Text("Alert for stock activated")));
                          _startWatchingChangesAndNotifications();
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text("Add a stock and price")));
                        }
                      },
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: 80,
                      text: "Add to alert",
                    ),
                  ],
                ),
                ResultStocksCard(
                  stockSelectionController: _stockController,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
