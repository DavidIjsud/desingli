import 'package:designli/components/widgets/loaders/load_page.dart';
import 'package:designli/modules/selection_stock/presentation/selection_stock_view_model.dart';
import 'package:designli/modules/watching_list/presentation/watch_list_viewmodel.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResultStocksCard extends StatefulWidget {
  const ResultStocksCard({
    super.key,
    required this.stockSelectionController,
  });

  final TextEditingController stockSelectionController;

  @override
  State<ResultStocksCard> createState() => _ResultStocksCardState();
}

class _ResultStocksCardState extends State<ResultStocksCard> {
  late final WatchListViewModel _watchListViewModel;

  @override
  void initState() {
    super.initState();
    _watchListViewModel = context.read<WatchListViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectionStockViewModel>(
      builder: (BuildContext context, viewModel, Widget? child) {
        if (viewModel.state?.productsObtainedSuccessfull == true) {
          final productsStock = viewModel.state?.listOfStocksSymbolsFound;
          return Positioned(
              top: 60.0,
              left: 60.0,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ]),
                child: ListView.builder(
                    itemCount: productsStock?.length,
                    itemBuilder: (_, index) {
                      return InkWell(
                        onTap: () {
                          viewModel
                              .addValueToSymbolSelected(productsStock[index]);
                          viewModel.resetState();
                          _watchListViewModel.assignSymbolSelectedForAlert(
                              productsStock[index]);
                          final symbolSelected =
                              productsStock[index].displaySymbol;
                          widget.stockSelectionController.text = symbolSelected;
                        },
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              "${productsStock![index].description}, ${productsStock[index].symbol}",
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            const Divider(
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      );
                    }),
              ));
        }

        if (viewModel.state?.isSearchingStock == true) {
          return const Positioned(
              top: 50, left: 160.0, child: CircularProgressIndicator());
        }

        return const SizedBox();
      },
    );
  }
}