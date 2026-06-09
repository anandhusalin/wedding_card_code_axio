import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'locale_provider.g.dart';

@riverpod
class LocaleController extends _$LocaleController {
  @override
  Locale build() {
    return const Locale('en'); // Default to English
  }

  void toggleLocale() {
    state = state.languageCode == 'en' ? const Locale('ml') : const Locale('en');
  }
}
