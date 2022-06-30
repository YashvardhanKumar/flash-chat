import 'package:flashchat/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key, required this.onPressed, required this.child,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButtonTheme(
        data: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              primary: kColor2, onPrimary: kColor1, onSurface: Colors.white),
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          child: child,
        ),
      ),
    );
  }
}

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    Key? key,
    required this.onPressed,
    required this.child,
  }) : super(key: key);
  final void Function()? onPressed;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      splashColor: kColor2.withAlpha(40),
      focusColor: kColor2.withAlpha(40),
      highlightColor: kColor2.withAlpha(40),
      elevation: 0,
      onPressed: onPressed,
      height: double.minPositive,
      minWidth: double.minPositive,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: child,
    );
  }
}

void showCustomToast(String msg) => Fluttertoast.showToast(
    msg: msg, // message
    toastLength: Toast.LENGTH_SHORT, // length
    gravity: ToastGravity.CENTER, // location
    timeInSecForIosWeb: 1 // duration
);