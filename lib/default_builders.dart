part of 'sliver_stream_builder.dart';

class SliverStreamBuilderErrorObject {
  final dynamic error;
  final StackTrace? stackTrace;
  final void Function() retryCb;
  final String? errorMessage;

  SliverStreamBuilderErrorObject({
    required this.error,
    required this.retryCb,
    required this.errorMessage,
    required this.stackTrace,
  });
}

typedef ErrorBuilder = Widget Function(
  BuildContext context,
  SliverStreamBuilderErrorObject error,
);

Widget _defaultErrorBuilder(
  BuildContext context,
  SliverStreamBuilderErrorObject error,
) {
  return Center(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextButton.icon(
            onPressed: error.retryCb,
            icon: const Icon(Icons.refresh),
            label: const Text('Loading error, retry'),
          ),
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
