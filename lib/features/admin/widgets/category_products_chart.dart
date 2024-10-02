import 'package:d_chart/d_chart.dart';

import 'package:ecommerce_app_fluterr_nodejs/features/admin/models/sales.dart';
import 'package:flutter/material.dart';

class BarChartAnalytics extends StatelessWidget {
  final List<Sales> salesData;

  const BarChartAnalytics({super.key, required this.salesData});

  @override
  Widget build(BuildContext context) {
    List<OrdinalData> ordinalList = salesData
        .map(
            (sales) => OrdinalData(domain: sales.label, measure: sales.earning))
        .toList();
    final ordinalGroup = [
      OrdinalGroup(
        id: '1',
        data: ordinalList,
        seriesCategory: 'Sales',
        chartType: ChartType.bar,
      ),
    ];

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: DChartBarO(
        groupList: ordinalGroup,
        animate: true,
      ),
    );
  }
}
