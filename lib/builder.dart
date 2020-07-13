import 'package:flutter/widgets.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:markdown_core/text_style.dart';

class MarkdownBuilder implements md.NodeVisitor {
  final _widgets = <Widget>[];
  final _inlines = <_InlineElement>[];
  List<TextSpan> _textSpans;
  var _textStyle = defaultTextStyle;
  int level = 0;

  @override
  bool visitElementBefore(md.Element element) {
    print('visitElementBefore ${element.textContent}');
    level++;

    if (level >= 2) {
      var lastTextStyle =
          _inlines.isEmpty ? _textStyle : _inlines.last.textStyle;
      _inlines.add(_InlineElement(
        tag: element.tag,
        textStyle: getTextStyle(lastTextStyle, element.tag),
      ));
    } else {
      _textStyle = getTextStyle(defaultTextStyle, element.tag);
    }

    return true;
  }

  @override
  void visitText(md.Text text) {
    print('text ${text.text}');
    _textSpans.add(TextSpan(
      text: text.text,
      style: _inlines.isEmpty ? _textStyle : _inlines.last.textStyle,
    ));
  }

  @override
  void visitElementAfter(md.Element element) {
    print('visitElementAfter ${element.textContent}');
    level--;
    if (_inlines.isNotEmpty && _inlines.last.tag == element.tag) {
      _inlines.removeLast();
    }

    if (_kBlockTags.indexOf(element.tag) != -1) {
      _widgets.add(SizedBox(
        height: 3,
      ));
      _widgets.add(RichText(
        text: TextSpan(
          children: _textSpans,
          style: _textStyle,
        ),
      ));
      _widgets.add(SizedBox(
        height: 3,
      ));
    }
  }

  List<Widget> build(
    List<md.Node> nodes, {
    TextStyle textStyle,
  }) {
    _textStyle = textStyle ?? defaultTextStyle;
    _widgets.clear();

    for (md.Node node in nodes) {
      _inlines.clear();
      _textSpans = [];
      level = 0;

      node.accept(this);
    }
    return _widgets;
  }
}

class _InlineElement {
  _InlineElement({
    this.tag,
    this.textStyle,
  });

  final String tag;
  final TextStyle textStyle;
}

const List<String> _kBlockTags = const <String>[
  'h1',
  'h2',
  'h3',
  'h4',
  'h5',
  'h6',
  'p',
];
