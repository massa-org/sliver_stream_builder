import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sliver_stream_builder/sliver_stream_builder.dart';

class EmptyStream extends StatelessWidget {
  const EmptyStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('empty stream example'),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverStreamBuilder<String>(
              stream: Stream.empty(),
              emptyBuilder: (_) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(64.0),
                  child: Text('Some Empty Placeholder'),
                ),
              ),
              builder: (ctx, url) => ListTile(
                title: Text(url),
                leading: CachedNetworkImage(
                  imageUrl: url,
                  width: 48,
                  height: 48,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
