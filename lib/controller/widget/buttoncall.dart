import 'package:doane/utils/const.dart';
import 'package:flutter/material.dart';

class ButtonCallback extends StatelessWidget {
  final Function function;
  final String title;
  final Color? bgcolor;
  final Color? fcolor;
  const ButtonCallback(
      {super.key,
      required this.function,
      required this.title,
      this.bgcolor,
      this.fcolor});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: bgcolor ?? Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      onPressed: () {
        function();
      },
      child: PrimaryFont(
        title: title,
        color: fcolor ?? Colors.black,
      ),
    );
  }
}
