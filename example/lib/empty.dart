import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sliver_stream_builder/sliver_stream_builder.dart';

class EmptyStream extends StatelessWidget {
  const EmptyStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('empty stream example'),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverStreamBuilder<String>(
              stream: const Stream.empty(),
              emptyBuilder: (_) => const Center(
                child: Padding(
                  padding: EdgeInsets.all(64.0),
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
