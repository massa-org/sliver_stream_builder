import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sliver_stream_builder/sliver_stream_builder.dart';

MaterialApp _testApp(
  Stream<String?> Function() stream, [
  Stream<void>? rebuildStream,
]) {
  return MaterialApp(
    home: Scaffold(
      body: StreamBuilder(
        stream: rebuildStream,
        builder: (ctx, _) => CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: [
            SliverStreamBuilder<String?>(
              stream: stream(),
              emptyBuilder: (_) => Text('empty_builder'),
              builder: (context, item) => Text(item ?? 'item'),
              progressBuilder: (_) => Text('progress'),
            ),
          ],
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('Use empty builder on empty stream', (WidgetTester tester) async {
    await tester.pumpWidget(_testApp(() => Stream.empty()));

    await tester.pumpAndSettle();

    expect(find.text('empty_builder'), findsOneWidget);
    expect(find.text('item'), findsNothing);
    expect(find.text('progress'), findsNothing);
  });

  testWidgets('Draw progress builder', (WidgetTester tester) async {
    await tester.pumpWidget(
      _testApp(() =>Stream<String?>.periodic(Duration(milliseconds: 50)).take(2)),
    );

    // start progress

    expect(find.text('empty_builder'), findsNothing);
    expect(find.text('progress'), findsOneWidget);
    expect(find.text('item'), findsNothing);
    await tester.pump(Duration(milliseconds: 50));
    expect(find.text('empty_builder'), findsNothing);
    expect(find.text('progress'), findsOneWidget);
    expect(find.text('item'), findsOneWidget);
    await tester.pump(Duration(milliseconds: 50));
    expect(find.text('empty_builder'), findsNothing);
    expect(find.text('progress'), findsOneWidget);
    expect(find.text('item'), findsNWidgets(2));
    await tester.pumpAndSettle();
    expect(find.text('item'), findsNWidgets(2));
  });
  testWidgets('Draw exactly N items', (WidgetTester tester) async {
    await tester.pumpWidget(
      _testApp(() => Stream.fromIterable(List.filled(4, null))),
    );

    await tester.pumpAndSettle();

    expect(find.text('empty_builder'), findsNothing);
    expect(find.text('item'), findsNWidgets(4));
  });

  testWidgets('Pause and resume stream', (WidgetTester tester) async {
    var paused = false;
    var resumed = false;
    late StreamSubscription sub;
    final ctr = StreamController<String?>(
      onPause: () {
        paused = true;
        sub.pause();
      },
      onResume: () {
        resumed = true;
        sub.resume();
      },
    );
    final stream = Stream.fromIterable(List<String?>.filled(100, null));
    sub = stream.listen((event) => ctr.add(event));

    await tester.pumpWidget(_testApp(() => ctr.stream));

    await tester.pumpAndSettle();

    expect(paused, true);
    expect(resumed, false);
    await tester.scrollUntilVisible(find.text('progress'), 100);
    await tester.pumpAndSettle();
    expect(resumed, true);
  });

  testWidgets('Purge data on stream recreate', (WidgetTester tester) async {
    var value = 'zero';
    final reload = StreamController<void>();
    await tester.pumpWidget(
      _testApp(() => Stream.fromIterable(List.filled(5, value)), reload.stream),
    );

    await tester.pumpAndSettle();

    expect(find.text('zero'), findsNWidgets(5));
    expect(find.text('one'), findsNothing);
    value = 'one';
    reload.add(null);
    await tester.pumpAndSettle();
    expect(find.text('one'), findsNWidgets(5));
    expect(find.text('zero'), findsNothing);
  });
}
