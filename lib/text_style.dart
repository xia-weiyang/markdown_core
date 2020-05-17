import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

final defaultTextStyle = TextStyle(
  color: Colors.black,
);

TextStyle getTextStyle(TextStyle textStyle, String tag) {
  if ('h1' == tag) {
    textStyle = textStyle.copyWith(
      fontSize: 28,
    );
  } else if ('h2' == tag) {
    textStyle = textStyle.copyWith(
      fontSize: 24,
    );
  } else if ('strong' == tag) {
    textStyle = textStyle.copyWith(
      fontWeight: FontWeight.bold,
    );
  } else if ('em' == tag) {
    textStyle = textStyle.copyWith(
      fontStyle: FontStyle.italic,
    );
  }
  return textStyle;
}
