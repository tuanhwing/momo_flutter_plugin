
import 'package:flutter/foundation.dart';

const String moEventChannel = "momo_flutter_plugin";

class MoMoFlutterPluginMethods {
  static const String initialize = "initialize";
  static const String makePayment = "makePayment";
}

///Print lob
void printLog(Object? object) {
  const String tag = "[MoMo_Flutter_Plugin]";
  if (kDebugMode) {
    // ignore: avoid_print
    print("$tag ${object.toString()}");
  }
}

extension StringExtension on String {
  static bool isNullOrEmpty(String? value) {
    return value == null || value.isEmpty;
  }
}