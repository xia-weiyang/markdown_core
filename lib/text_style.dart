import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

final defaultTextStyle = TextStyle(
  color: Colors.black,
);

TextStyle getTextStyle(TextStyle textStyle, String tag) {
  switch (tag) {
    case 'h1':
      textStyle = textStyle.copyWith(
        fontSize: 28,
      );
      break;
    case 'h2':
      textStyle = textStyle.copyWith(
        fontSize: 26,
      );
      break;
    case 'h3':
      textStyle = textStyle.copyWith(
        fontSize: 24,
      );
      break;
    case 'h4':
      textStyle = textStyle.copyWith(
        fontSize: 22,
      );
      break;
    case 'h5':
      textStyle = textStyle.copyWith(
        fontSize: 21,
      );
      break;
    case 'h6':
      textStyle = textStyle.copyWith(
        fontSize: 20,
      );
      break;
    case 'p':
      textStyle = textStyle.copyWith(
        fontSize: 18,
      );
      break;
  }
  return textStyle;
}
