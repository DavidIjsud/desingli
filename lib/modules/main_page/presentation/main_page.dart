import 'package:designli/components/widgets/buttons/primary_button.dart';
import 'package:designli/modules/graph_plotting/presentation/graph_plotting.dart';
import 'package:designli/modules/selection_stock/presentation/selection_stock_presentation.dart';
import 'package:designli/modules/selection_stock/presentation/selection_stock_view_model.dart';
import 'package:designli/modules/watching_list/presentation/watch_list_page.dart';
import 'package:designli/modules/watching_list/presentation/watch_list_viewmodel.dart';
import 'package:designli/services/authentication/auth0_authentication.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPageMultipleSelection extends StatefulWidget {
  const MainPageMultipleSelection({super.key});

  @override
  State<MainPageMultipleSelection> createState() =>
      _MainPageMultipleSelectionState();
}

class _MainPageMultipleSelectionState extends State<MainPageMultipleSelection> {
  late final Auth0AuthenticaionViewModel _auth0authenticaionViewModel;

  @override
  void initState() {
    super.initState();
    _auth0authenticaionViewModel = context.read<Auth0AuthenticaionViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ButtonPrimary(
              isActive: true,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return const SelectionStockSymbolPage();
                }));
              },
              text: "Listen for alert",
              width: MediaQuery.of(context).size.width * 0.5,
              height: 100,
            ),
            const SizedBox(
              height: 20.0,
            ),
            ButtonPrimary(
              isActive: true,
              onPressed: () {
                final selectStockViewModel =
                    context.read<SelectionStockViewModel>();
                final symbolSelected = selectStockViewModel.getSymbolSelected;
                final priceSelected = selectStockViewModel.getPriceSelected;
                if (symbolSelected != null && priceSelected != null) {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return const WatchListPage();
                  }));
                } else {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: Colors.red,
                      content: Text("Must select stock and price first")));
                }
              },
              text: "Watching List",
              width: MediaQuery.of(context).size.width * 0.5,
              height: 100,
            ),
            const SizedBox(
              height: 20.0,
            ),
            ButtonPrimary(
              isActive: true,
              onPressed: () {
                final selectStockViewModel =
                    context.read<SelectionStockViewModel>();
                final symbolSelected = selectStockViewModel.getSymbolSelected;
                final priceSelected = selectStockViewModel.getPriceSelected;
                if (symbolSelected != null && priceSelected != null) {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return const GrahpPlotting();
                  }));
                } else {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: Colors.red,
                      content: Text("Must select stock and price first")));
                }
              },
              text: "Graph Plotting",
              width: MediaQuery.of(context).size.width * 0.5,
              height: 100,
            ),
            const SizedBox(
              height: 20.0,
            ),
            ButtonPrimary(
              isActive: true,
              onPressed: () {
                _auth0authenticaionViewModel.logoutAuth0();
                context.read<WatchListViewModel>().disconnectSocket();
                Navigator.pop(context);
              },
              text: "Logout",
              width: MediaQuery.of(context).size.width * 0.5,
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
