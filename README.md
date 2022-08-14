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
// manualy manage state
Stream<NewsModel> getNews() {
  int page = 0;
  return dataStreamWrapper(() async {
    final ans = await dio.get('/news', queryParameters: {'page': page});
    final data = (ans.data as List).map((e) => NewsModel.fromJson(e)).toList();
    if (data.isEmpty) return null;
    // increment page only here for allow to refetch same data if exception was throw
    // all errors throw inside this function is captured and added to stream
    page += 1;
    return data;
  });
}
```


`dataStreamHelper` more safe method to create dataStream cause it prevent some misuse
```dart
Stream<NewsModel> getNews() {
  return dataStreamHelper.state(0).next((it) async {
    final ans = await dio.get('/news', queryParameters: {'page': it.current});
    final data = (ans.data as List).map((e) => NewsModel.fromJson(e)).toList();
    if (data.isEmpty) return it.done();
    return it.next(
      data, 
      it.current + 1, // next state
    );
  });
}
```