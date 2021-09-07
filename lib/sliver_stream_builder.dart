library sliver_stream_builder;

import 'dart:async';
import 'dart:math' show max;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'sliver_stream_builder_localization.dart';
export 'sliver_stream_builder_localization.dart';

Widget _defaultSliverBuilder(ctx, delegate) => SliverList(
      delegate: delegate,
    );

// this behavior can't be implemented as delegate because need state

/// Take stream save all data event and display it as list, with use of sliverBuilder
/// onError display errorBuilder with errorTextExtractor(error) text
/// pause stream if data is't visible
class SliverStreamBuilder<T> extends StatefulWidget {
  /// Stream can't be changed later
  final Stream<T> stream;
  final Widget Function(BuildContext context, T v) builder;
  final Widget Function(BuildContext context)? progressBuilder;

  final Widget Function(BuildContext context)? emptyBuilder;
  final Widget Function(BuildContext context, SliverChildDelegate delegate)?
      sliverBuilder;

  /// Error processing.
  /// If component recieve error from stream, component request pause on stream and await while resume call
  final String Function(dynamic)? errorTextExtractor;
  final Widget? Function(
    BuildContext context,
    dynamic err,
    void Function() resumeCb,
    String errorText,
  )? errorBuilder;

  final StreamSliverBuilderLocalization? localization;

  SliverStreamBuilder({
    Key? key,

    /// must be not broadcast to react on pause,resume
    required this.stream,

    /// item builder
    required this.builder,

    /// sliver builder where items has been displayed
    this.sliverBuilder = _defaultSliverBuilder,

    /// progress indicator builder if not provided default is used
    this.progressBuilder,

    /// display if stream done without data emit
    this.emptyBuilder,

    /// extract text from error that passed to errorBuilder
    this.errorTextExtractor,

    /// display as last element when error happens
    this.errorBuilder,
    this.localization,
  }) : super(key: key);
  @override
  _SliverStreamBuilderState<T> createState() => _SliverStreamBuilderState<T>();
}

class _SliverStreamBuilderState<T> extends State<SliverStreamBuilder<T>> {
  List<T> data = [];
  dynamic error;

  bool isDone = false;
  bool get isError => error != null;

  int lastVisible = 0;

  late StreamSubscription sub;

  late StreamSliverBuilderLocalization localization =
      widget.localization ?? StreamSliverBuilderLocalization.of(context);

  void addElement(T e) {
    error = null;
    data.add(e);
    // initiate rebuild only if added child in visible area.
    // else just add it to data list and wait until user scroll.
    // Then sliver call builder while has data and if data end builder return null.
    // After that sliver need to be forced to rebuild
    if (data.length <= lastVisible + 1) {
      setState(() {});
    } else {
      sub.pause();
    }
  }

  void onDone() {
    isDone = true;
    if (data.isEmpty) _currentBuilder = _emptyBuilder;
  }

  void onError(err, _) {
    error = err;
    sub.pause();
    setState(() {});
  }

  void _resumeAfterError() {
    error = null;
    sub.resume();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    sub = widget.stream.listen(
      addElement,
      onDone: onDone,
      onError: onError,
    );
  }

  @override
  void didUpdateWidget(covariant SliverStreamBuilder<T> oldWidget) {
    if (identical(oldWidget.stream, widget.stream) != true) {
      _currentBuilder = _builder;
      data = [];
      sub.cancel();
      sub = widget.stream.listen(
        addElement,
        onDone: onDone,
        onError: onError,
      );
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }

  Widget? _emptyBuilder(context, i) {
    if (i == 0) return widget.emptyBuilder?.call(context);
    return null;
  }

  Widget? Function(
    BuildContext context,
    dynamic err,
    void Function() resume,
    String errorText,
  ) get _errorBuilder => widget.errorBuilder ?? _defaultErrorBuilder;

  Widget? _defaultErrorBuilder(
    BuildContext context,
    dynamic err,
    void Function() resumeCb,
    String errorText,
  ) {
    // final locallization = StreamSliverBuilderLocalization.of(context);
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 8,
          ),
          Text(
            errorText,
            style: TextStyle(color: Theme.of(context).errorColor),
          ),
          TextButton(
            onPressed: resumeCb,
            child: Text(localization.errorRetryButtonText),
          )
        ],
      ),
    );
  }

  Widget? _builder(ctx, i) {
    lastVisible = max(lastVisible, i);

    if (i > data.length) {
      return null;
    }
    if (i == data.length) {
      if (isDone) return null;
      if (isError) {
        return _errorBuilder(
          ctx,
          error,
          _resumeAfterError,
          widget.errorTextExtractor?.call(error) ??
              localization.errorMessageDefaultText,
        );
      }

      sub.resume();
      return widget.progressBuilder?.call(context) ??
          Center(child: CircularProgressIndicator());
    }

    return widget.builder(ctx, data[i]);
  }

  late Widget? Function(BuildContext, int) _currentBuilder = _builder;

  @override
  Widget build(BuildContext context) {
    return widget.sliverBuilder!(
      context,
      SliverChildBuilderDelegate(_currentBuilder),
    );
  }
}
