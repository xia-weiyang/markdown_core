import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:markdown_core/text_style.dart';

/// 递归解析标签
/// [_elementList] 每个标签依次放入该集合
/// 在[visitElementBefore]时添加
/// 在[visitElementAfter]时将其移除

class MarkdownBuilder implements md.NodeVisitor {
  MarkdownBuilder(
    this.context,
    this.linkTap,
  );

  final _widgets = <Widget>[];
  int _level = 0;
  List<_Element> _elementList = <_Element>[];
  TextStyle _textStyle = defaultTextStyle;

  final BuildContext context;
  final LinkTap linkTap;

  @override
  bool visitElementBefore(md.Element element) {
    _level++;
    debugPrint('visitElementBefore $_level ${element.textContent}');

    var textStyle = getTextStyle(
        _elementList.isNotEmpty ? _elementList.last.textStyle : _textStyle,
        element.tag);

    // 超级自定义一些特殊样式
    if (_elementList.isNotEmpty) {
      if (_elementList.last.tag == 'p' && element.tag == 'code') {
        textStyle = textStyle.copyWith(
          color: Colors.red.shade800,
        );
      }
    }

    _elementList.add(_Element(
      element.tag,
      textStyle,
      element.attributes,
    ));

    return true;
  }

  @override
  void visitText(md.Text text) {
    debugPrint('text ${text.text}');

    var last = _elementList.last;
    last.textSpans ??= [];

    if (last.tag == 'a') {
      last.textSpans.add(TextSpan(
        text: text.text,
        style: last.textStyle,
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            if (linkTap != null && last.attributes != null) {
              debugPrint(last.attributes.toString());
              linkTap(last.attributes['href']);
            }
          },
      ));
      return;
    }

    last.textSpans.add(TextSpan(
      text: text.text,
      style: last.textStyle,
    ));
  }

  @override
  void visitElementAfter(md.Element element) {
    debugPrint('visitElementAfter $_level ${element.tag}');
    _level--;

    if (_elementList.isEmpty) return;
    var last = _elementList.last;
    _elementList.removeLast();
    var tempWidget;
    if (kTextTags.indexOf(element.tag) != -1) {
      if (_elementList.isNotEmpty &&
          kTextTags.indexOf(_elementList.last.tag) != -1) {
        // 内联标签处理
        _elementList.last.textSpans ??= [];
        _elementList.last.textSpans.addAll(last.textSpans);
      } else {
        tempWidget = RichText(
          text: TextSpan(
            children: last.textSpans,
            style: last.textStyle,
          ),
        );
      }
    } else if ('li' == element.tag) {
      tempWidget = _resolveToLi(last, context);
    } else if ('pre' == element.tag) {
      tempWidget = _resolveToPre(last);
    } else if (last.widgets != null && last.widgets.isNotEmpty) {
      if (last.widgets.length == 1) {
        tempWidget = last.widgets[0];
      } else {
        tempWidget = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: last.widgets,
        );
      }
    }

    if (tempWidget != null) {
      if (_elementList.isEmpty) {
        _widgets.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: tempWidget,
          ),
        );
      } else {
        _elementList.last.widgets ??= [];
        _elementList.last.widgets.add(tempWidget);
      }
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
    this.attributes,
  );

  final String tag;
  List<Widget> widgets;
  List<TextSpan> textSpans;
  TextStyle textStyle;
  Map<String, String> attributes;
}

/// 链接点击
typedef LinkTap(String link);

Widget _resolveToLi(_Element last, BuildContext context) {
  final temp = <Widget>[];
  temp.add(Padding(
    padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
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
      width: MediaQuery.of(context).size.width - 26 * 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: last.widgets,
      ),
    ));
  }
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: temp,
  );
}

Widget _resolveToPre(_Element last) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
    child: Container(
      width: double.infinity,
      color: const Color(0xffeeeeee),
      padding: const EdgeInsets.fromLTRB(8, 14, 8, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: last.widgets,
      ),
    ),
  );
}
