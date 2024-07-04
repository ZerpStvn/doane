import 'package:doane/utils/const.dart';
import 'package:flutter/material.dart';

class Textformfield extends StatelessWidget {
  final TextEditingController textEditingController;
  final String labeltitle;
  final Icon? favicon;
  final Color? color;
  final Color? bordercolor;
  final String? Function(String?)? validator;
  const Textformfield(
      {super.key,
      required this.textEditingController,
      required this.labeltitle,
      this.favicon,
      this.color,
      this.validator,
      this.bordercolor});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: textEditingController,
      style: TextStyle(color: color ?? Colors.white),
      decoration: InputDecoration(
          label: PrimaryFont(
            title: labeltitle,
            color: color ?? Colors.white,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: bordercolor ?? Colors.white),
          ),
          prefixIcon: favicon,
          border: OutlineInputBorder(
              borderSide:
                  BorderSide(width: 1, color: bordercolor ?? Colors.white))),
    );
  }
}
