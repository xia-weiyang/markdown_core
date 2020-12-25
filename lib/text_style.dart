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
  'del',
  'a',
];

TextStyle defaultTextStyle(BuildContext context) => TextStyle(
      color: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xffaaaaaa)
          : const Color(0xff444444),
    );

TextStyle getTextStyle(TextStyle textStyle, String tag) {
  switch (tag) {
    case 'h1':
      textStyle = textStyle.copyWith(
        fontSize: 27,
      );
      break;
    case 'h2':
      textStyle = textStyle.copyWith(
        fontSize: 25,
      );
      break;
    case 'h3':
      textStyle = textStyle.copyWith(
        fontSize: 23,
      );
      break;
    case 'h4':
      textStyle = textStyle.copyWith(
        fontSize: 21,
      );
      break;
    case 'h5':
      textStyle = textStyle.copyWith(
        fontSize: 20,
      );
      break;
    case 'h6':
      textStyle = textStyle.copyWith(
        fontSize: 19,
      );
      break;
    case 'p':
      textStyle = textStyle.copyWith(
        fontSize: 17.5,
      );
      break;
    case 'li':
      textStyle = textStyle.copyWith(
        fontSize: 17.5,
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
    case 'del':
      textStyle = textStyle.copyWith(
        decoration: TextDecoration.lineThrough,
      );
      break;
    case 'a':
      textStyle = textStyle.copyWith(
        color: Colors.blue,
      );
      break;
  }
  return textStyle;
}
