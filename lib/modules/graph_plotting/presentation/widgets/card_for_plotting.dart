import 'package:flutter/material.dart';

import 'line_chart.dart';

class StockCardPlotting extends StatelessWidget {
  final String name;
  final double currentPrice;
  final double percentageChange;
  final List<double> data;

  const StockCardPlotting({
    Key? key,
    required this.name,
    required this.currentPrice,
    required this.percentageChange,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Current Price: \$${currentPrice.toStringAsFixed(4)}',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${percentageChange >= 0 ? '+' : ''}${percentageChange.toStringAsFixed(2)}%',
              style: TextStyle(
                fontSize: 18,
                color: percentageChange >= 0 ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            GraphItem(
              data: data,
            ),
          ],
        ),
      ),
    );
  }
}
