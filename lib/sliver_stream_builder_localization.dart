import 'package:flutter/material.dart';

/// class to localize sliver builder error widget
abstract class StreamSliverBuilderLocalization {
  /// text on retry button
  String get errorRetryButtonText;

  /// default error text
  String get errorMessageDefaultText;

  static StreamSliverBuilderLocalization of(BuildContext context) {
    final lcode = Localizations.localeOf(context).languageCode;

    switch (lcode) {
      case 'ru':
        return _StreamSliverBuilderLocalizationRu();
      case 'en':
        return _StreamSliverBuilderLocalizationEn();
      default:
        return _StreamSliverBuilderLocalizationEn();
    }
  }
}

class _StreamSliverBuilderLocalizationRu
    extends StreamSliverBuilderLocalization {
  @override
  String get errorMessageDefaultText => 'Произошла ошибка при загрузке данных.';

  @override
  String get errorRetryButtonText => 'Попробовать снова';
}

class _StreamSliverBuilderLocalizationEn
    extends StreamSliverBuilderLocalization {
  @override
  String get errorMessageDefaultText => 'The error has been acquired.';

  @override
  String get errorRetryButtonText => 'Retry';
}
