library markdown_core;

import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart';
import 'package:markdown_core/builder.dart';

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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _parseMarkdown(),
    );
  }

  List<Widget> _parseMarkdown() {
    print(markdownToHtml(widget.data));
    final List<String> lines = widget.data.split(RegExp(r'\r?\n'));
    final nodes = Document().parseLines(lines);
    print(nodes.length);
    return MarkdownBuilder().build(nodes);
  }
}
