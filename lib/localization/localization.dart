import 'dart:ui';

import 'package:sliver_stream_builder/localization/strings.g.dart';

class _PackageLocalization {
  _PackageLocalization._();
  List<Locale> get supportedLocales => LocaleSettings.supportedLocales;

  void setLocaleRaw(String rawLocale) => LocaleSettings.setLocaleRaw(rawLocale);
}

final sliverStreamBuilderLocalization = _PackageLocalization._();
