import 'package:flutter/material.dart';

const maincolor = Color(0xff6295A2);

class PrimaryFont extends StatelessWidget {
  final String title;
  final double? size;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final Color? color;
  const PrimaryFont(
      {super.key,
      required this.title,
      this.size,
      this.fontWeight,
      this.textAlign,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: textAlign,
      style: TextStyle(
          fontSize: size ?? 16,
          fontWeight: fontWeight,
          color: color ?? Colors.black),
    );
  }
}
