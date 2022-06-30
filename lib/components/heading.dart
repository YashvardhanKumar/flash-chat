import 'package:flashchat/constants.dart';
import 'package:flutter/material.dart';

class Heading extends StatelessWidget {
  const Heading({
    Key? key, required this.text,
  }) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
          fontSize: 40,
          color: kColor1,
          fontFamily: 'Bodoni Moda',
          fontWeight: FontWeight.w600),
    );
  }
}