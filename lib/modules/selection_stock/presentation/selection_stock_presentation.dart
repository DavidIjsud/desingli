import 'package:designli/components/widgets/buttons/primary_button.dart';
import 'package:designli/modules/selection_stock/presentation/selection_stock_view_model.dart';
import 'package:designli/modules/selection_stock/presentation/widgets/result_stocks_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectionStockSymbolPage extends StatefulWidget {
  const SelectionStockSymbolPage({super.key});

  @override
  State<SelectionStockSymbolPage> createState() =>
      _SelectionStockSymbolPageState();
}

class _SelectionStockSymbolPageState extends State<SelectionStockSymbolPage> {
  late final SelectionStockViewModel _selectionStockViewModel;
  late TextEditingController _stockController, _priceController;

  @override
  void initState() {
    super.initState();
    _stockController = TextEditingController();
    _priceController = TextEditingController();
    _selectionStockViewModel = context.read<SelectionStockViewModel>();
    _selectionStockViewModel.disposeTimerDebounce();
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
                      maxLength: 30,
                      onChanged: (String price) {
                        _selectionStockViewModel
                            .addValueToPriceForAlert(double.parse(price));
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
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Alert for stock activated")));
                          Navigator.pop(context);
                        }
                      },
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: 80,
                      text: "Add to alert",
                    ),
                  ],
                ),
                const ResultStocksCard()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
