import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
class TeethModel extends StatelessWidget {
  const  TeethModel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/Human_dental_arches.svg',
      width: 300,
      height: 300,
      color: Colors.black, // default color
      colorFilter: ColorFilter.mode(
        Colors.red, // Target color
        BlendMode.srcIn, // Apply the color
      ),
    );
  }
}
