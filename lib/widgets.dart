import 'package:flutter/material.dart';

InputDecoration textFieldInputDecoration(String hintText){
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(color: Colors.black26),
    focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.blue)
    ),
    enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.blue)
    ),
  );
}