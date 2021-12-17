import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sliver_stream_builder/sliver_stream_builder.dart';

class SimpleSliver extends StatelessWidget {
  const SimpleSliver({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('simple sliver'),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverStreamBuilder<String>(
              stream: Stream.periodic(const Duration(milliseconds: 300),
                  (id) => 'https://picsum.photos/id/$id/200/200').take(100),
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
