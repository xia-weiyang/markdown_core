library markdown_core;

import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart';

class Markdown extends StatefulWidget {
  const Markdown({
    Key key,
    this.data,
  }) : super(key: key);

  final String data;

  @override
  MarkdownState createState() => MarkdownState();
}

class MarkdownState extends State<Markdown> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _parseMarkdown(),
    );
  }

  List<Widget> _parseMarkdown() {
    print(markdownToHtml(widget.data));
    var nodeList = Document().parseInline(widget.data);
    for (var node in nodeList) {
      print(node.textContent);
    }

    return [];
  }
}
