import 'dart:developer';

import 'package:designli/modules/selection_stock/presentation/selection_stock_view_model.dart';
import 'package:designli/modules/watching_list/presentation/watch_list_viewmodel.dart';
import 'package:designli/modules/watching_list/presentation/widgets/card_stock.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WatchListPage extends StatefulWidget {
  const WatchListPage({super.key});

  @override
  State<WatchListPage> createState() => _WatchListPageState();
}

class _WatchListPageState extends State<WatchListPage> {
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
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer<WatchListViewModel>(
            builder: (_, viewModel, Widget? w) {
              log("Called to refresh list");
              final listStock = viewModel.state?.listSymbols;
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: listStock != null ? listStock.length : 0,
                  itemBuilder: (_, index) {
                    final stock = listStock?[index];
                    return StockCard(
                      name: stock?.displaySymbol ?? "",
                      currentPrice: stock?.currentPrice ?? 0.0,
                      percentageChange: stock?.porcentChange ?? 0.0,
                    );
                  });
            },
          ),
        )),
      ),
    );
  }
}
