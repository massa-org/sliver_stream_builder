import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sliver_stream_builder/sliver_stream_builder.dart';

Stream<String> loadError() {
  return dataStreamWrapper(
    () async {
      throw 'errror';
    },
  );
}

class SliverStreamErrorExample extends StatelessWidget {
  const SliverStreamErrorExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sliver stream builder error example'),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverStreamBuilder<String>(
              stream: loadError(),
              builder: (ctx, url) => CachedNetworkImage(imageUrl: url),
            ),
          ],
        ),
      ),
    );
  }
}
