import 'package:flutter/material.dart';

const maincolor = Color(0xff0B192C);

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
      overflow: TextOverflow.ellipsis,
      title.length > 25 ? '${title.substring(0, 20)}...' : title,
      textAlign: textAlign,
      style: TextStyle(
          fontSize: size ?? 16,
          fontWeight: fontWeight,
          color: color ?? Colors.black),
    );
  }
}

class PrimaryFont2 extends StatelessWidget {
  final String title;
  final double? size;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final Color? color;
  const PrimaryFont2(
      {super.key,
      required this.title,
      this.size,
      this.fontWeight,
      this.textAlign,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      overflow: TextOverflow.ellipsis,
      title,
      textAlign: textAlign,
      style: TextStyle(
          fontSize: size ?? 16,
          fontWeight: fontWeight,
          color: color ?? Colors.black),
    );
  }
}
