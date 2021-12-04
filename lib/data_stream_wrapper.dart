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
  FutureOr<List<T>?> Function() next,
) {
  var active = true;
  Completer? pause;

  final controller = StreamController<T>(
    onCancel: () {
      active = false;
    },
    onPause: () => pause = Completer(),
    onResume: () {
      pause?.complete();
      pause = null;
    },
  );

  () async {
    while (active) {
      await pause?.future;
      try {
        final res = await next();
        if (res == null || active == false) break;
        res.forEach(controller.add);
      } catch (err) {
        controller.addError(err);
      }
    }
  }();
  return controller.stream;
}