# sliver_stream_builder

A new Flutter package project.

## Usage

Simple usage example
```dart
SliverStreamBuilder<NewsModel>(
    stream: NewsNetwork.getNews(),
    builder: (ctx,item) => NewsItem(news: item),
)
```
