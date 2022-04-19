part of 'sliver_stream_builder.dart';

typedef ErrorBuilder = Widget Function({
  required BuildContext context,
  required dynamic error,
  required void Function() retryCb,
  required String? errorMessage,
  StackTrace? stackTrace,
  Key? key,
});

Widget _defaultErrorBuilder({
  required BuildContext context,
  required dynamic error,
  required void Function() retryCb,
  required String? errorMessage,
  StackTrace? stackTrace,
  Key? key,
}) {
  return Center(
    child: Column(
      children: [
        const SizedBox(
          height: 8,
        ),
        Text(
          errorMessage ?? L.genericLoadingError,
          style: TextStyle(color: Theme.of(context).errorColor),
        ),
        TextButton(
          onPressed: retryCb,
          child: Text(L.retryButton),
        )
      ],
    ),
  );
}

typedef SliverBuilder = Widget Function(
  BuildContext context,
  SliverChildBuilderDelegate delegate, {
  Key? key,
});

Widget _defaultSliverBuilder(
  BuildContext context,
  SliverChildBuilderDelegate delegate, {
  Key? key,
}) {
  return SliverList(
    key: key,
    delegate: delegate,
  );
}

Widget _defaultEmptyBuilder(BuildContext context) {
  return const SizedBox.shrink();
}

Widget _defaultProgressBuilder(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16),
    child: Center(child: CircularProgressIndicator()),
  );
}

void _defaultRetry(
  dynamic error,
  StackTrace? stackTrace,
  void Function() streamResumeCb,
) {
  return streamResumeCb();
}

String? _defaultErrorTextExtractor(BuildContext _, __) => null;
