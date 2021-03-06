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
    this.widgetImage,
    this.maxWidth, {
    this.defaultTextStyle,
  });

  final _widgets = <Widget>[];
  int _level = 0;
  List<_Element> _elementList = <_Element>[];

  final TextStyle defaultTextStyle;

  final BuildContext context;
  final LinkTap linkTap;
  final WidgetImage widgetImage;
  final double maxWidth;

  @override
  bool visitElementBefore(md.Element element) {
    _level++;
    debugPrint('visitElementBefore $_level ${element.textContent}');

    var textStyle = getTextStyle(
        _elementList.isNotEmpty
            ? _elementList.last.textStyle
            : defaultTextStyle,
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

    if (_elementList.isEmpty) return;
    var last = _elementList.last;
    last.textSpans ??= [];

    // 替换特定字符串
    var content = text.text?.replaceAll('&gt;', '>');
    content = content?.replaceAll('&lt;', '<');

    if (last.tag == 'a') {
      last.textSpans.add(TextSpan(
        text: content,
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
      text: content,
      style: last.textStyle,
    ));
  }

  final padding = const EdgeInsets.fromLTRB(0, 5, 0, 5);

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
          kTextParentTags.indexOf(_elementList.last.tag) != -1) {
        // 内联标签处理
        _elementList.last.textSpans ??= [];
        if (last != null && last.textSpans != null) {
          _elementList.last.textSpans.addAll(last.textSpans);
        }
      } else {
        if (last.textSpans != null && last.textSpans.isNotEmpty) {
          tempWidget = RichText(
            text: TextSpan(
              children: last.textSpans,
              style: last.textStyle,
            ),
          );
        }
      }
    } else if ('li' == element.tag) {
      tempWidget = _resolveToLi(last);
    } else if ('pre' == element.tag) {
      tempWidget = _resolveToPre(last);
    } else if ('blockquote' == element.tag) {
      tempWidget = _resolveToBlockquote(last);
    } else if ('img' == element.tag) {
      if (_elementList.isNotEmpty &&
          _elementList.last.textSpans != null &&
          _elementList.last.textSpans.isNotEmpty) {
        _widgets.add(
          Padding(
            padding: padding,
            child: RichText(
              text: TextSpan(
                children: _elementList.last.textSpans,
                style: _elementList.last.textStyle,
              ),
            ),
          ),
        );
        _elementList.last.textSpans = null;
      }
      if (widgetImage != null) {
        if (element.attributes != null) {
          debugPrint(element.attributes.toString());
          //_elementList.clear();
          _widgets.add(
            Padding(
              padding: padding,
              child: widgetImage(element.attributes['src']),
            ),
          );
        }
      }
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
            padding: padding,
            child: tempWidget,
          ),
        );
      } else {
        _elementList.last.widgets ??= [];
        _elementList.last.widgets.add(tempWidget);
      }
    }
  }

  List<Widget> build(List<md.Node> nodes) {
    _widgets.clear();

    for (md.Node node in nodes) {
      _level = 0;
      _elementList.clear();

      node.accept(this);
    }
    return _widgets;
  }

  Widget _resolveToLi(_Element last) {
    final temp = <Widget>[];
    final temp1 = <Widget>[];
    int liNum = 1;
    _elementList?.forEach((element) {
      if (element.tag == 'li') liNum++;
    });
    temp.add(Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
      child: Icon(
        Icons.circle,
        size: 10,
        color: defaultTextStyle.color,
      ),
    ));
    if (last.widgets == null) {
      temp.add(Container(
        width: maxWidth - (26 * liNum),
        child: RichText(
          text: TextSpan(
            children: last.textSpans,
            style: last.textStyle,
          ),
        ),
      ));
    } else {
      temp1.add(RichText(
        text: TextSpan(
          children: last.textSpans,
          style: last.textStyle,
        ),
      ));
      temp1.addAll(last.widgets);
      temp.add(
        Container(
          width: maxWidth - (26 * liNum),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: temp1,
          ),
        ),
      );
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
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xff111111)
            : const Color(0xffeeeeee),
        padding: const EdgeInsets.fromLTRB(8, 14, 8, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: last.widgets,
        ),
      ),
    );
  }

  Widget _resolveToBlockquote(_Element last) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 7,
            height: double.infinity,
            color: Colors.grey.shade400,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: last.widgets,
            ),
          ),
        ],
      ),
    );
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
typedef void LinkTap(String link);

typedef Widget WidgetImage(String imageUrl);
