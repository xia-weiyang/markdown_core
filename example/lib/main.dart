import 'package:flutter/material.dart';
import 'package:markdown_core/markdown.dart';

void main() => runApp(MyApp());

const String _markdownData = """
## 1.标题
行首加井号表示不同级别的标题(H1-H6),例如：# H1,## H2,### H3,#### H4(注意：#号后边应有英文空格)。
# 一级标题
## 二级标题
### 三级标题
#### 四级标题
##### 五级标题
###### 六级标题

## 2.文本

#### 普通文本

直接输入的文字就是普通文本。

#### 单行文本

        使用两个Tab(或八个空格)符实现单行文本.

#### 多行文本

        多行文本和
        单行文本异曲同工，只要在
        每行行首加两个Tab(或八个空格)。

#### 文字高亮

如果你想使一段话中部分文字高亮显示，来起到突出强调的作用，那么可以把它用\\`包围起来，`注意`这不是单引号，而是``Tab``上方，``数字1``左边的按键（注意使用``英文``输入法）。

#### 斜体、粗体

使用 * 或 ** 将文字包围起来表示斜体和粗体。这是 *斜体*，这是 **粗体**，这是~~删除线~~。
""";

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Markdown(
            data: _markdownData,
          ),
        ),
      ),
    );
  }
}
