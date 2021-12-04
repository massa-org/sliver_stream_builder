import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sliver_stream_builder/sliver_stream_builder.dart';

Stream<String> load() {
  var i = 0;
  return dataStreamWrapper(
    () => Future.delayed(
      Duration(milliseconds: 300),
      () => ['https://picsum.photos/id/${i++}/200/200'],
    ),
  );
}

class DataStreamExample extends StatelessWidget {
  const DataStreamExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Stream example'),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverStreamBuilder<String>(
              sliverBuilder: (_, delegate) => SliverGrid(
                delegate: delegate,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 100,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
              ),
              stream: load(),
              builder: (ctx, url) => CachedNetworkImage(imageUrl: url),
            ),
          ],
        ),
      ),
    );
  }
}