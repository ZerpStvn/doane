import 'package:doane/utils/const.dart';
import 'package:flutter/material.dart';

class GlobalButton extends StatelessWidget {
  final Function oncallback;
  final String title;
  const GlobalButton(
      {super.key, required this.oncallback, required this.title});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: maincolor, shape: const RoundedRectangleBorder()),
      onPressed: () {
        oncallback();
      },
      child: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
