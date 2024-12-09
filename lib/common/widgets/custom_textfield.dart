import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController textController;
  final String hintText;
  final int maxLines;
  final bool isPass;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.textController,
    required this.hintText,
    this.maxLines = 1,
    this.isPass = false,
    required this.keyboardType,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isHidden = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textController,
      keyboardType: widget.keyboardType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        hintText: widget.hintText,
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black54),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black54),
        ),
        // Thêm prefixIcon dựa vào loại input
        prefixIcon: Icon(
          widget.isPass
              ? Icons.lock_outline
              : widget.hintText.toLowerCase().contains('email')
                  ? Icons.email_outlined
                  : widget.hintText.toLowerCase().contains('name')
                      ? Icons.person_outline
                      : Icons.text_fields,
          color: Colors.grey,
        ),
        // Thêm suffixIcon cho trường password
        suffixIcon: widget.isPass
            ? IconButton(
                icon: Icon(
                  _isHidden ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _isHidden = !_isHidden;
                  });
                },
              )
            : null,
      ),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return "Enter your ${widget.hintText}";
        }
        switch (widget.keyboardType) {
          case TextInputType.emailAddress:
            final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
            if (!emailRegExp.hasMatch(val)) {
              return 'Please enter a valid email';
            }
            break;
          case TextInputType.number:
            if (double.tryParse(val) == null) {
              return 'Please enter a valid number';
            }
            break;
          default:
            break;
        }
        return null;
      },
      obscureText: widget.isPass && _isHidden,
      maxLines: widget.maxLines,
    );
  }
}
