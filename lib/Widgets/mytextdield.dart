import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final Color? color;
  final String? hintText;
  final String? labelText;
  final TextInputType? keyboard;
  final Function(String) onChanged;
  final Function(String?)? validator;
  final Icon? icon;
  final bool obscureText;
  final Widget? icon1;
  const MyTextField({
    Key? key,
    this.color,
    this.hintText,
    this.keyboard,
    required this.onChanged,
    this.labelText,
    this.icon,
    this.icon1,
    this.validator,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        keyboardType: keyboard ?? TextInputType.text,
        textAlign: TextAlign.start,
        onChanged: onChanged,
        obscureText: obscureText,
        decoration: InputDecoration(
           // labelText: labelText,
            hintText: hintText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            prefixIcon: icon,
            suffixIcon: icon1,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 42,
              vertical: 20,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.grey),
              gapPadding: 10,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.grey),
              gapPadding: 10,
            )));
  }
}
