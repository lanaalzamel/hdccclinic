import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  MyButton({
    required this.titleColor,
    required this.color,
    required this.title,
    required this.onTap,
    required this.height,
    required this.width,
    this.child, // Add this parameter for optional child widget
  });

  final Color color;
  final String title;
  final double width;
  final double height;
  final Function() onTap;
  final Color titleColor;
  final Widget? child; // Optional child widget

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: height,
        width: width,
        child: Material(
          elevation: 5,
          color: color,
          borderRadius: BorderRadius.circular(25),
          child: Container(
            width: width,
            height: height,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: child ?? // Render child if provided, otherwise render text
                    Text(
                      title,
                      style: TextStyle(color: titleColor),
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
