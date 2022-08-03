# sliver_stream_builder

Package to transform data `stream` to sliver list or sliver grid, with helper to create stream from next function

## Usage

### Simple usage example
```dart
CustomScrollView(
  slivers: [
    SliverStreamBuilder<NewsModel>(
      stream: NewsNetwork.getNews(),
      builder: (ctx, item) => NewsItem(news: item),
    )
  ],
);
```

### With custom sliver builder
```dart
CustomScrollView(
  slivers: [
    SliverStreamBuilder<String>(
      stream: ImageNetwork.getImages(),
      sliverBuilder: (context, delegate) => SliverGrid(
        delegate: delegate,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 150,
        ),
      ),
      itemBuilder: (ctx, url) => CachedNetworkImage(imageUrl: url),
    ),
  ],
);
```

### With empty builder
```dart
CustomScrollView(
  slivers: [
    SliverStreamBuilder<NewsModel>(
      stream: NewsNetwork.getNews(),
      builder: (ctx, item) => NewsItem(news: item),
      // display when stream done, and not emit any elements
      emptyBuilder: (_) => Center(child: Text('Nothing new here :(')),
    )
  ],
);
```

### Create stream from next function
`dataStreamWrapper` function that manage stream controller and transform next function to stream. Implements pause, resume logic and error processing 
```dart
Stream<NewsModel> getNews() {
  int page = 0;
  return dataStreamWrapper(() async {
    final ans = await dio.get('/news?page=$page');
    final ansList = (ans.data as List);
    if (ansList.isEmpty) return null;
    final ret = ansList.map((e) => NewsModel.fromJson(e)).toList();
    // increment page only here for allow to refetch same data if exception was throw
    // all errors throw inside this function is captured and added to stream
    page += 1;
    return ret;
  });
}
```