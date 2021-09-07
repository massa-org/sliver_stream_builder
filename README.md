# sliver_stream_builder

Package to transform data `stream` to sliver list or sliver grid

## Usage

### Simple usage example
```dart
SliverStreamBuilder<NewsModel>(
    stream: NewsNetwork.getNews(),
    builder: (ctx,item) => NewsItem(news: item),
)
```

### With custom sliver builder
```dart
SliverStreamBuilder<String>(
    stream: ImageNetwork.getImages(),
    sliverBuilder: (context, delegate) => SliverGrid(
        delegate: delegate,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 150,
        ),
    ),
    itemBuilder: (ctx,url) => CachedNetworkImage(imageUrl: url),
),
```

### With empty builder
```dart
SliverStreamBuilder<NewsModel>(
    stream: NewsNetwork.getNews(),
    builder: (ctx,item) => NewsItem(news: item),
    // display when stream done, and not emit any elements
    emptyBuilder: (_) => Center(child: Text('Nothing new here :(')),
)
```