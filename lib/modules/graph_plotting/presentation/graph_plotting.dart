import 'package:designli/modules/graph_plotting/presentation/widgets/card_for_plotting.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../selection_stock/presentation/selection_stock_view_model.dart';
import '../../watching_list/presentation/watch_list_viewmodel.dart';
import '../../watching_list/presentation/widgets/card_stock.dart';

class GrahpPlotting extends StatefulWidget {
  const GrahpPlotting({super.key});

  @override
  State<GrahpPlotting> createState() => _GrahpPlottingState();
}

class _GrahpPlottingState extends State<GrahpPlotting> {
  late final SelectionStockViewModel _selectionStockViewModel;
  late final WatchListViewModel _watchListViewModel;

  @override
  void initState() {
    super.initState();
    _selectionStockViewModel = context.read<SelectionStockViewModel>();
    _watchListViewModel = context.read<WatchListViewModel>();
    _watchListViewModel.disconnectSocket();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _watchListViewModel.assignListSearchedSymbols(
        _selectionStockViewModel.getSymbolsResultOfSearch,
      );
      _watchListViewModel.connectSocket();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvoked: (value) {},
        child: Scaffold(
          body: SafeArea(
              child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SafeArea(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Consumer<WatchListViewModel>(
                builder: (_, viewModel, Widget? w) {
                  final listStock = viewModel.state?.listSymbols;
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: listStock != null ? listStock.length : 0,
                      itemBuilder: (_, index) {
                        final stock = listStock?[index];
                        return StockCardPlotting(
                          name: stock?.displaySymbol ?? "",
                          currentPrice: stock?.currentPrice ?? 0.0,
                          data: stock?.prices ?? const [],
                          percentageChange: stock?.porcentChange ?? 0.0,
                        );
                      });
                },
              ),
            )),
          )),
        ));
  }
}
