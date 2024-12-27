import 'package:ecommerce_app_fluterr_nodejs/common/widgets/custom_button.dart';
import 'package:ecommerce_app_fluterr_nodejs/common/widgets/custom_textfield.dart';
import 'package:ecommerce_app_fluterr_nodejs/constants/global_variables.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/seller/services/seller_services.dart';
import 'package:ecommerce_app_fluterr_nodejs/models/product.dart';
import 'package:flutter/material.dart';

class SetDiscountScreen extends StatefulWidget {
  static const String routeName = '/set-discount';
  final Product product;

  const SetDiscountScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<SetDiscountScreen> createState() => _SetDiscountScreenState();
}

class _SetDiscountScreenState extends State<SetDiscountScreen> {
  final TextEditingController percentageController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  final SellerServices sellerServices = SellerServices();

  @override
  void dispose() {
    super.dispose();
    percentageController.dispose();
  }

  void setDiscount() {
    if (percentageController.text.isNotEmpty && startDate != null && endDate != null) {
      sellerServices.setProductDiscount(
        context: context,
        product: widget.product,
        percentage: double.parse(percentageController.text),
        startDate: startDate!.toUtc(),
        endDate: endDate!.toUtc(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: const Text(
            'Set Discount',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              CustomTextField(
                textController: percentageController,
                hintText: 'Discount Percentage',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              ListTile(
                title: const Text('Start Date'),
                subtitle: Text(startDate?.toString() ?? 'Not set'),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() => startDate = date);
                  }
                },
              ),
              ListTile(
                title: const Text('End Date'),
                subtitle: Text(endDate?.toString() ?? 'Not set'),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: startDate ?? DateTime.now(),
                    firstDate: startDate ?? DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() => endDate = date);
                  }
                },
              ),
              const SizedBox(height: 10),
              CustomButton(
                text: 'Set Discount',
                function: setDiscount,
              ),
            ],
          ),
        ),
      ),
    );
  }
}