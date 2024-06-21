import 'package:designli/components/widgets/buttons/primary_button.dart';
import 'package:designli/modules/selection_stock/presentation/selection_stock_presentation.dart';
import 'package:flutter/material.dart';

class MainPageMultipleSelection extends StatelessWidget {
  const MainPageMultipleSelection({super.key});

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
                onPressed: () {},
                text: "Watching List",
                width: MediaQuery.of(context).size.width * 0.5,
                height: 100),
            const SizedBox(
              height: 20.0,
            ),
            ButtonPrimary(
                isActive: true,
                onPressed: () {},
                text: "Graph Plotting",
                width: MediaQuery.of(context).size.width * 0.5,
                height: 100),
          ],
        ),
      ),
    );
  }
}
