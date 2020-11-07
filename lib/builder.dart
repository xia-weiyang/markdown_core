import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:markdown_core/text_style.dart';

class MarkdownBuilder implements md.NodeVisitor {
  final _widgets = <Widget>[];
  int _level = 0;
  List<_Element> _elementList = <_Element>[];
  TextStyle _textStyle = defaultTextStyle;

  @override
  bool visitElementBefore(md.Element element) {
    _level++;
    debugPrint('visitElementBefore $_level ${element.textContent}');

    _elementList.add(_Element(
      element.tag,
      getTextStyle(
          _elementList.isNotEmpty ? _elementList.last.textStyle : _textStyle,
          element.tag),
    ));

    return true;
  }

  @override
  void visitText(md.Text text) {
    print('text ${text.text}');

    var last = _elementList.last;
    last.textSpans ??= [];

    last.textSpans.add(TextSpan(
      text: text.text,
      style: last.textStyle,
    ));
  }

  @override
  void visitElementAfter(md.Element element) {
    debugPrint('visitElementAfter $_level ${element.textContent}');
    _level--;

    if (_elementList.isEmpty) return;
    var last = _elementList.last;
    _elementList.removeLast();
    var tempWidget;
    if (_kTextTags.indexOf(element.tag) != -1) {
      tempWidget = RichText(
        text: TextSpan(
          children: last.textSpans,
          style: last.textStyle,
        ),
      );
    } else if ('li' == element.tag) {
      final temp = <Widget>[];
      temp.add(Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: Icon(
          Icons.circle,
          size: 10,
        ),
      ));
      temp.add(RichText(
        text: TextSpan(
          children: last.textSpans,
          style: last.textStyle,
        ),
      ));
      if (last.widgets != null) {
        temp.add(Container(
          width: 200,
          child: Column(
            children: last.widgets,
          ),
        ));
      }
      tempWidget = Row(
        children: temp,
      );
    } else if (last.widgets != null && last.widgets.isNotEmpty) {
      tempWidget = last.widgets[0];
    }

    if (_elementList.isEmpty) {
      _widgets.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
          child: tempWidget,
        ),
      );
    } else {
      _elementList.last.widgets ??= [];
      _elementList.last.widgets.add(tempWidget);
    }
  }

  List<Widget> build(
    List<md.Node> nodes, {
    TextStyle textStyle,
  }) {
    _textStyle = textStyle ?? defaultTextStyle;
    _widgets.clear();

    for (md.Node node in nodes) {
      _level = 0;
      _elementList.clear();

      node.accept(this);
    }
    return _widgets;
  }
}

class _Element {
  _Element(
    this.tag,
    this.textStyle,
  );

  final String tag;
  List<Widget> widgets;
  List<TextSpan> textSpans;
  TextStyle textStyle;
}

const List<String> _kTextTags = const <String>[
  'h1',
  'h2',
  'h3',
  'h4',
  'h5',
  'h6',
  'p',
  'pre'
];
