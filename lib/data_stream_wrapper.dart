import 'dart:async';

/// create to transform loading of paginated data to stream
/// and clean data after loading is ended
///
/// next function must load the data and if data exceed must return null
///
/// Usage
/// ```dart
/// Stream<int> load(){
///   // initialization
///   var i = 0;
///   return dataStreamWrapper(
///     // fetch portion of data
///     (_) => Future.delayed(Duration(seconds: 1), () => i < 100 ? [++i] : null),
///   );
/// }
/// ```
///
/// Main reason of creation cause code bellow never free ressource on cancel
/// if i < 100
/// ```dart
/// Stream<int> load() async *{
///  var i = 0;
///  while(i < 100){
///    yield ++i;
///  }
/// }
/// ```
Stream<T> dataStreamWrapper<T>(
  FutureOr<Iterable<T>?> Function() next,
) {
  var closed = false;
  Completer? pause;

  void resume() {
    pause?.complete();
    pause = null;
  }

  // latet initialization for acces from callbacks
  late final StreamController<T> controller;

  controller = StreamController<T>(
    onCancel: () {
      closed = true;
      resume();
      // if onListen is not called we must close controller here
      controller.close();
    },
    onPause: () => pause = Completer(),
    onResume: resume,
    onListen: () async {
      do {
        try {
          final res = await next();
          if (res == null || closed) break;
          res.forEach(controller.add);
        } catch (err, stackTrace) {
          controller.addError(err, stackTrace);
        }
        await pause?.future;
      } while (!closed);
      controller.close();
    },
  );

  return controller.stream;
}
