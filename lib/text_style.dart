import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const List<String> kTextTags = const <String>[
  'h1',
  'h2',
  'h3',
  'h4',
  'h5',
  'h6',
  'p',
  'code',
  'strong',
  'em',
];

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
    case 'li':
      textStyle = textStyle.copyWith(
        fontSize: 18,
      );
      break;
    case 'code':
      textStyle = textStyle.copyWith(
        fontSize: 15,
        color: textStyle.color.withAlpha(200),
      );
      break;
    case 'strong':
      textStyle = textStyle.copyWith(
        fontWeight: FontWeight.bold,
      );
      break;
    case 'em':
      textStyle = textStyle.copyWith(
        fontStyle: FontStyle.italic,
      );
      break;
  }
  return textStyle;
}
