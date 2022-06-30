import 'package:flashchat/constants.dart';
import 'package:flutter/material.dart';


class ShowPassword extends StatelessWidget {
  final Function() onPressed;
  final Icon icon;
  const ShowPassword({
    Key? key,
    required this.onPressed,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      iconSize: 20,
      icon: icon,
      splashRadius: 10,
      padding: EdgeInsets.zero,
      splashColor: kColor4,
    );
  }
}
