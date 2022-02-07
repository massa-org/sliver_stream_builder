import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sliver_stream_builder/sliver_stream_builder.dart';

class ImagesGrid extends StatelessWidget {
  const ImagesGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('grid example'),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverStreamBuilder<String>(
              sliverBuilder: (_, delegate, {key}) => SliverGrid(
                delegate: delegate,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 100,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
              ),
              stream: Stream.periodic(
                const Duration(milliseconds: 300),
                (id) => 'https://picsum.photos/id/$id/200/200',
              ).take(100),
              builder: (ctx, url) => CachedNetworkImage(imageUrl: url),
            ),
          ],
        ),
      ),
    );
  }
}
