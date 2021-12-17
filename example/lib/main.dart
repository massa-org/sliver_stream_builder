import 'package:examples/data_stream.dart';
import 'package:examples/empty.dart';
import 'package:examples/images_grid.dart';
import 'package:examples/simple.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(title: const Text('SliverStreamBuilder example')),
          body: ListView(
            children: [
              ListTile(
                title: const Text('Grid sliver'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ImagesGrid()),
                ),
              ),
              ListTile(
                title: const Text('Empty'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EmptyStream()),
                ),
              ),
              ListTile(
                title: const Text('Simple list'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SimpleSliver()),
                ),
              ),
              ListTile(
                title: const Text('Data Stream example'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DataStreamExample()),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
