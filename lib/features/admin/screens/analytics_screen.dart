import 'package:ecommerce_app_fluterr_nodejs/features/admin/models/sales.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/admin/services/admin_services.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/admin/widgets/category_products_chart.dart';
import 'package:flutter/material.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final AdminServices _adminServices = AdminServices();
  int? totalSales;
  List<Sales>? earnings;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEarnings();
  }

  getEarnings() async {
    var earningData = await _adminServices.getEarnings(context);
    totalSales = earningData['totalEarnings'];
    earnings = earningData['sales'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return earnings == null || totalSales == null
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Text(
                'Total \$$totalSales',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                height: 250,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: BarChartAnalytics(salesData: earnings!),
              )
            ],
          );
  }
}
