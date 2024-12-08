import 'package:flutter/material.dart';

class PaymentDetailsDialog extends StatelessWidget {
  final double originalAmount;
  final double shippingFee;
  final VoidCallback onConfirm;

  const PaymentDetailsDialog({
    Key? key,
    required this.originalAmount,
    required this.shippingFee,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalAmount = originalAmount + shippingFee;

    return AlertDialog(
      title: const Text('Payment Details'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Original Amount: \$${originalAmount.toStringAsFixed(2)}'),
          Text('Shipping Fee: \$${shippingFee.toStringAsFixed(2)}'),
          const Divider(),
          Text(
            'Total Amount: \$${totalAmount.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}