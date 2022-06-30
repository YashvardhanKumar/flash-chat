import 'package:flutter/material.dart';

const kColor1 = Color(0xFFF7AA00);
const kColor2 = Color(0xFF235784);
const kColor3 = Color(0xFF40A8C4);
const kColor4 = Color(0xFFBCDBDF);
const kTextBoxDecoration = InputDecoration(
    icon: null,
    labelText: null,
    focusColor: kColor2,
    border: OutlineInputBorder(
        borderSide: BorderSide(color: kColor2)),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: kColor2, width: 2)),
    labelStyle: TextStyle(
      color: kColor2,
    ),
    suffixIcon: null);