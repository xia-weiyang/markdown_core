# markdown_core

Parse markdown and render it into rich text.

<video controls width="400" height="802">
    <source src="https://xia-weiyang.github.io/video/markdown_core.mov"
            type="video/mov">
</video>

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

