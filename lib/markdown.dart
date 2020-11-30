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
    // debugPrint(markdownToHtml(
    //   widget.data,
    //   extensionSet: ExtensionSet.gitHubWeb,
    // ));
    final List<String> lines = widget.data.split(RegExp(r'\r?\n'));
    final nodes = Document(
      extensionSet: ExtensionSet.gitHubWeb,
    ).parseLines(lines);
    return MarkdownBuilder(context).build(nodes);
  }
}
