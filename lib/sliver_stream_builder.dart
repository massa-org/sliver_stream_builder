library sliver_stream_builder;

import 'dart:async';
import 'dart:math' show max;

import 'package:flutter/material.dart';
import './localization/strings.g.dart';

export 'data_stream_wrapper.dart';

part 'default_builders.dart';

// this behavior can't be implemented as delegate because need state

/// Take stream save all data event and display it as list, with use of sliverBuilder
/// onError display errorBuilder with errorTextExtractor(error) text
/// pause stream if data is't visible
class SliverStreamBuilder<T> extends StatefulWidget {
  /// Stream can't be changed later
  final Stream<T> stream;
  final Widget Function(BuildContext context, T item) builder;

  final Widget Function(BuildContext context) progressBuilder;
  final Widget Function(BuildContext context) emptyBuilder;

  final SliverBuilder sliverBuilder;

  // function that called when stream emit error and been paused
  // by default simply call `streamResumeCb` that resume stream
  final void Function(
    dynamic error,
    StackTrace? stackTrace,
    void Function() streamResumeCb,
  ) onErrorRetry;

  /// Error processing.
  /// If component recieve error from stream, component request pause on stream and await while resume call
  final String? Function(BuildContext context, dynamic error)
      errorTextExtractor;
  final ErrorBuilder errorBuilder;

  final bool keepOldDataOnLoading;

  const SliverStreamBuilder({
    Key? key,

    /// must be not broadcast to react on pause,resume
    required this.stream,

    /// keep old data when stream change and rebuild only when new event occur
    this.keepOldDataOnLoading = false,

    /// item builder
    required this.builder,

    /// sliver builder where items has been displayed
    this.sliverBuilder = _defaultSliverBuilder,
    this.progressBuilder = _defaultProgressBuilder,

    /// display if stream done without data emit
    this.emptyBuilder = _defaultEmptyBuilder,

    /// display as last element when error happens
    this.errorBuilder = _defaultErrorBuilder,
    this.onErrorRetry = _defaultRetry,

    /// extract text from error that passed to errorBuilder
    this.errorTextExtractor = _defaultErrorTextExtractor,
  }) : super(key: key);

  @override
  State<SliverStreamBuilder<T>> createState() => _SliverStreamBuilderState<T>();
}

class _SliverStreamBuilderState<T> extends State<SliverStreamBuilder<T>> {
  List<T> data = [];

  dynamic error;
  StackTrace? stackTrace;

  bool isDone = false;
  bool get isError => error != null;

  int lastVisible = 0;

  late StreamSubscription<T> sub;

  void onData(T e) {
    error = null;
    stackTrace = null;
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
    setState(() => isDone = true);
  }

  void onError(dynamic err, StackTrace stackTrace) {
    setState(() {
      error = err;
      this.stackTrace = stackTrace;
      sub.pause();
    });
  }

  void onDataKeep(T e) {
    finalCleanAndReSub();
    onData(e);
  }

  void onDoneKeep() {
    finalCleanAndReSub();
    onDone();
  }

  void onErrorKeep(dynamic err, StackTrace stackTrace) {
    finalCleanAndReSub();
    onError(err, stackTrace);
  }

  void _resumeAfterError() {
    setState(() {
      error = null;
      stackTrace = null;
      sub.resume();
    });
  }

  @override
  void initState() {
    resub();
    super.initState();
  }

  void resub() {
    sub = widget.stream.listen(
      onDataKeep,
      onDone: onDoneKeep,
      onError: onErrorKeep,
    );
  }

  void finalCleanAndReSub() {
    setState(() {
      isDone = false;
      data = [];
    });

    sub.onData(onData);
    sub.onDone(onDone);
    sub.onError(onError);
  }

  @override
  void didUpdateWidget(covariant SliverStreamBuilder<T> oldWidget) {
    if (identical(oldWidget.stream, widget.stream) != true) {
      sub.cancel();
      resub();

      // clear data only if stream change
      if (widget.keepOldDataOnLoading == false) finalCleanAndReSub();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }

  Widget? _builder(BuildContext context, int id) {
    if (isDone && data.isEmpty) {
      if (id == 0) return widget.emptyBuilder(context);
      return null;
    }
    lastVisible = max(lastVisible, id);

    if (id > data.length) {
      return null;
    }
    if (id == data.length) {
      if (isDone) return null;
      if (isError) {
        final errFn = widget.onErrorRetry;
        return widget.errorBuilder(
          context,
          SliverStreamBuilderErrorObject(
            error: error,
            stackTrace: stackTrace,
            retryCb: () => errFn(error, stackTrace, _resumeAfterError),
            errorMessage: widget.errorTextExtractor(context, error),
          ),
        );
      }

      sub.resume();
      return widget.progressBuilder(context);
    }

    return widget.builder(context, data[id]);
  }

  @override
  Widget build(BuildContext context) {
    return widget.sliverBuilder(
      context,
      SliverChildBuilderDelegate(_builder),
      key: widget.key,
    );
  }
}
