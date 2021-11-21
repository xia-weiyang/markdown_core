# markdown_core

Parse markdown and render it into rich text.

https://xia-weiyang.github.io/video/markdown_core.mov

``` dart
Markdown(
    data: markdownDataString,
    linkTap: (link) => print('点击了链接 $link'),
    textStyle: // your text style ,
    image: (imageUrl) {
      print('imageUrl $imageUrl');
      return // Your image widget ;
    },
)
```

