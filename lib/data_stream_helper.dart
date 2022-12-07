import 'dart:async';

import 'data_stream_wrapper.dart';

class DSHNextResult<IteratorState, Result> {
  const DSHNextResult();
}

class DSHNextResultDone<IteratorState, Result>
    extends DSHNextResult<IteratorState, Result> {
  final Iterable<Result>? data;
  const DSHNextResultDone([this.data]);
}

class DSHNextResultNext<IteratorState, Result>
    extends DSHNextResult<IteratorState, Result> {
  final IteratorState nextState;
  final Iterable<Result> data;

  const DSHNextResultNext(this.data, this.nextState);
}

class DSHState<IteratorState, Result> {
  final IteratorState current;

  const DSHState(this.current);

  DSHNextResultDone<IteratorState, Result> done([Iterable<Result>? data]) {
    return DSHNextResultDone(data);
  }

  DSHNextResultNext<IteratorState, Result> next(
    Iterable<Result> data,
    IteratorState nextState,
  ) {
    return DSHNextResultNext(data, nextState);
  }
}

class DSHFluentHelper<IteratorState> {
  final IteratorState initialState;

  const DSHFluentHelper(this.initialState);

  Stream<Result> next<Result>(
    FutureOr<DSHNextResult<IteratorState, Result>> Function(
      DSHState<IteratorState, Result> it,
    )
        next,
  ) {
    DSHState<IteratorState, Result> state = DSHState(initialState);
    bool done = false;
    return dataStreamWrapper(() async {
      if (done) return null;
      final rnext = await next(state);

      if (rnext is DSHNextResultNext<IteratorState, Result>) {
        state = DSHState(rnext.nextState);
        return rnext.data;
      }
      if (rnext is DSHNextResultDone<IteratorState, Result> &&
          rnext.data != null) {
        done = true;
        return rnext.data!;
      }
      return null;
    });
  }
}

class DataStreamHelper {
  const DataStreamHelper();

  DSHFluentHelper<IteratorState> state<IteratorState>(IteratorState state) {
    return DSHFluentHelper(state);
  }
}

// allow to create dataStream more simply and prevent some missuse of dataStreamWrapper
// like change state before, actions that can throw as parse network data so that
//
// also it designed to infer state and return type, so no angle brackets here and it's main reason of too many code
const dataStreamHelper = DataStreamHelper();
