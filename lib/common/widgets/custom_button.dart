import 'package:ecommerce_app_fluterr_nodejs/constants/global_variables.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? function;
  final Color? color;
  final Color? textColor;
  const CustomButton({
    super.key,
    required this.text,
    this.function,
    this.color = GlobalVariables.secondaryColor,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: ElevatedButton(
        onPressed: function,
        style: ElevatedButton.styleFrom(
          backgroundColor: color, // Background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), // Rounded corners
          ),
          minimumSize: const Size(double.infinity, 50),
        ),
        child: Text(
          text,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
