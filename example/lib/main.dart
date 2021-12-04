import 'package:examples/data_stream.dart';
import 'package:examples/empty.dart';
import 'package:examples/images_grid.dart';
import 'package:examples/simple.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(title: Text('SliverStreamBuilder example')),
          body: ListView(
            children: [
              ListTile(
                title: Text('Grid sliver'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ImagesGrid()),
                ),
              ),
              ListTile(
                title: Text('Empty'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EmptyStream()),
                ),
              ),
              ListTile(
                title: Text('Simple list'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SimpleSliver()),
                ),
              ),
              ListTile(
                title: Text('Data Stream example'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DataStreamExample()),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
