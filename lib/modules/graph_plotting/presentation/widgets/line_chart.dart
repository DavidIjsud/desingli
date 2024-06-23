import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GraphItem extends StatefulWidget {
  const GraphItem({
    super.key,
    required this.data,
  });

  final List<double> data;

  @override
  State<GraphItem> createState() => _GraphItemState();
}

class _GraphItemState extends State<GraphItem> {
  @override
  Widget build(BuildContext context) {
    var data = [];
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 100,
      color: Colors.grey,
      child: Sparkline(
        data: widget.data,
        lineWidth: 3.0,
        lineColor: const Color(0xFFE18274),
      ),
    );
  }
}
