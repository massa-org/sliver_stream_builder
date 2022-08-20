/// Generated file. Do not edit.
///
/// Locales: 2
/// Strings: 4 (2 per locale)
///
/// Built on 2022-08-20 at 01:24 UTC

// coverage:ignore-file
// ignore_for_file: type=lint

import 'package:flutter/widgets.dart';
import 'package:slang_flutter/slang_flutter.dart';
export 'package:slang_flutter/slang_flutter.dart';

const AppLocale _baseLocale = AppLocale.en;

/// Supported locales, see extension methods below.
///
/// Usage:
/// - LocaleSettings.setLocale(AppLocale.en) // set locale
/// - Locale locale = AppLocale.en.flutterLocale // get flutter locale from enum
/// - if (LocaleSettings.currentLocale == AppLocale.en) // locale check
enum AppLocale with BaseAppLocale<StringsEn> {
  en(languageCode: 'en', build: StringsEn.build),
  ru(languageCode: 'ru', build: StringsRu.build);

  const AppLocale(
      {required this.languageCode,
      this.scriptCode,
      this.countryCode,
      required this.build}); // ignore: unused_element

  @override
  final String languageCode;
  @override
  final String? scriptCode;
  @override
  final String? countryCode;
  @override
  final TranslationBuilder<StringsEn> build;

  /// Gets current instance managed by [LocaleSettings].
  StringsEn get translations => LocaleSettings.instance.translationMap[this]!;
}

/// Method A: Simple
///
/// No rebuild after locale change.
/// Translation happens during initialization of the widget (call of L).
/// Configurable via 'translate_var'.
///
/// Usage:
/// String a = L.someKey.anotherKey;
/// String b = L['someKey.anotherKey']; // Only for edge cases!
StringsEn get L => LocaleSettings.instance.currentTranslations;

/// Method B: Advanced
///
/// All widgets using this method will trigger a rebuild when locale changes.
/// Use this if you have e.g. a settings page where the user can select the locale during runtime.
///
/// Step 1:
/// wrap your App with
/// TranslationProvider(
/// 	child: MyApp()
/// );
///
/// Step 2:
/// final L = Translations.of(context); // Get L variable.
/// String a = L.someKey.anotherKey; // Use L variable.
/// String b = L['someKey.anotherKey']; // Only for edge cases!
class Translations {
  Translations._(); // no constructor

  static StringsEn of(BuildContext context) =>
      InheritedLocaleData.of<AppLocale, StringsEn>(context).translations;
}

/// The provider for method B
class TranslationProvider
    extends BaseTranslationProvider<AppLocale, StringsEn> {
  TranslationProvider({required super.child})
      : super(
          initLocale: LocaleSettings.instance.currentLocale,
          initTranslations: LocaleSettings.instance.currentTranslations,
        );

  static InheritedLocaleData<AppLocale, StringsEn> of(BuildContext context) =>
      InheritedLocaleData.of<AppLocale, StringsEn>(context);
}

/// Method B shorthand via [BuildContext] extension method.
/// Configurable via 'translate_var'.
///
/// Usage (e.g. in a widget's build method):
/// context.L.someKey.anotherKey
extension BuildContextTranslationsExtension on BuildContext {
  StringsEn get L => TranslationProvider.of(this).translations;
}

/// Manages all translation instances and the current locale
class LocaleSettings extends BaseFlutterLocaleSettings<AppLocale, StringsEn> {
  LocaleSettings._()
      : super(
          locales: AppLocale.values,
          baseLocale: _baseLocale,
          utils: AppLocaleUtils.instance,
        );

  static final instance = LocaleSettings._();

  // static aliases (checkout base methods for documentation)
  static AppLocale get currentLocale => instance.currentLocale;
  static Stream<AppLocale> getLocaleStream() => instance.getLocaleStream();
  static AppLocale setLocale(AppLocale locale) => instance.setLocale(locale);
  static AppLocale setLocaleRaw(String rawLocale) =>
      instance.setLocaleRaw(rawLocale);
  static AppLocale useDeviceLocale() => instance.useDeviceLocale();
  static List<Locale> get supportedLocales => instance.supportedLocales;
  static List<String> get supportedLocalesRaw => instance.supportedLocalesRaw;
  static void setPluralResolver(
          {String? language,
          AppLocale? locale,
          PluralResolver? cardinalResolver,
          PluralResolver? ordinalResolver}) =>
      instance.setPluralResolver(
        language: language,
        locale: locale,
        cardinalResolver: cardinalResolver,
        ordinalResolver: ordinalResolver,
      );
}

/// Provides utility functions without any side effects.
class AppLocaleUtils extends BaseAppLocaleUtils<AppLocale, StringsEn> {
  AppLocaleUtils._()
      : super(baseLocale: _baseLocale, locales: AppLocale.values);

  static final instance = AppLocaleUtils._();

  // static aliases (checkout base methods for documentation)
  static AppLocale parse(String rawLocale) => instance.parse(rawLocale);
  static AppLocale findDeviceLocale() => instance.findDeviceLocale();
}

// translations

// Path: <root>
class StringsEn implements BaseTranslations {
  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  StringsEn.build(
      {PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
      : _cardinalResolver = cardinalResolver,
        _ordinalResolver = ordinalResolver;

  /// Access flat map
  dynamic operator [](String key) => _flatMap[key];

  // Internal flat map initialized lazily
  late final Map<String, dynamic> _flatMap = _buildFlatMap();

  final PluralResolver? _cardinalResolver; // ignore: unused_field
  final PluralResolver? _ordinalResolver; // ignore: unused_field

  late final StringsEn _root = this; // ignore: unused_field

  // Translations
  String get genericLoadingError => 'The error has been acquired.';
  String get retryButton => 'Retry';
}

// Path: <root>
class StringsRu extends StringsEn {
  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  StringsRu.build(
      {PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
      : _cardinalResolver = cardinalResolver,
        _ordinalResolver = ordinalResolver,
        super.build();

  /// Access flat map
  @override
  dynamic operator [](String key) => _flatMap[key] ?? super._flatMap[key];

  // Internal flat map initialized lazily
  @override
  late final Map<String, dynamic> _flatMap = _buildFlatMap();

  @override
  final PluralResolver? _cardinalResolver; // ignore: unused_field
  @override
  final PluralResolver? _ordinalResolver; // ignore: unused_field

  @override
  late final StringsRu _root = this; // ignore: unused_field

  // Translations
  @override
  String get genericLoadingError => 'Произошла ошибка при загрузке данных.';
  @override
  String get retryButton => 'Попробовать снова';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.

extension on StringsEn {
  Map<String, dynamic> _buildFlatMap() {
    return <String, dynamic>{
      'genericLoadingError': 'The error has been acquired.',
      'retryButton': 'Retry',
    };
  }
}

extension on StringsRu {
  Map<String, dynamic> _buildFlatMap() {
    return <String, dynamic>{
      'genericLoadingError': 'Произошла ошибка при загрузке данных.',
      'retryButton': 'Попробовать снова',
    };
  }
}
