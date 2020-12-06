import 'package:flutter/material.dart';
import 'package:markdown_core/markdown.dart';
import 'package:cached_network_image/cached_network_image.dart';

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

## 2.文字效果

使用 * 将文字包围起来表示*斜体*，如：\\*斜体*。
使用 ** 将文字包围起来表示**粗体**，如：\\*\\*粗体**。
使用 ~~ 将文字包围起来表示~~删除线~~，如：\\~\\~删除线~~。

如果你想使一段话中部分文字高亮显示，来起到突出强调的作用，那么可以把它用\\`包围起来，`注意`这不是单引号，而是``Tab``上方，``数字1``左边的按键（注意使用``英文``输入法）。

##  3. 外链接

使用 \\[描述](链接地址) 为文字增加外链接。
这是去往 [旧时光网站](https://www.jiushig.com) 的链接。

## 4. 图片

使用 \\!\\[描述](图片链接地址) 插入图像，仅仅比链接前面多了一个!号。插入图片示例： 

![旧时光](https://oss.jiushig.com/oldtime/oldtime_wallpaper.png)

## 5. 列表

使用 *，+，- 表示无序列表。

- 无序列表项 一
- 无序列表项 二
- 无序列表项 三

行首加四个空格表示二级列表，以此类推。

+ 编程语言
    + 脚本语言
        + Python

## 6. 引用

## 7. 区块

## 8. 表格

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
            linkTap: (link) => print('点击了链接 $link'),
            image: (imageUrl) {
              print('imageUrl $imageUrl');
              return CachedNetworkImage(
                imageUrl: imageUrl,
                placeholder: (context, url) => Container(
                  width: double.infinity,
                  height: 300,
                  child: Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              );
            },
          ),
        ),
      ),
    );
  }
}
