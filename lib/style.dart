import 'package:flutter/material.dart';

ButtonStyle mainBtnStyle(Color background, Color borderColor, Color overlay) {
  return ButtonStyle(
      elevation: MaterialStateProperty.all<double>(0),
      backgroundColor: MaterialStateProperty.all<Color>(background),
      overlayColor: MaterialStateProperty.all<Color>(overlay),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
              side: BorderSide(
                width: 2,
                color: borderColor,
              ))));
}

InputDecoration normalTextFieldStyle(String labelText, String hintText) {
  return InputDecoration(
      contentPadding: const EdgeInsets.fromLTRB(12, 6, 6, 6),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelText: labelText,
      labelStyle: const TextStyle(color: Colors.grey),
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Colors.grey,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
          color: Colors.black87,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.grey,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
          width: 1,
        ),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
          width: 1,
        ),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      filled: false);
}
