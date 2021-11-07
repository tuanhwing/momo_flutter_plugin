
import 'dart:async';

import 'package:flutter/services.dart';

import 'common.dart';
import 'models/models.dart';
import 'enums/enums.dart';

class MoMoFlutterPlugin {
  static const MethodChannel _channel = MethodChannel(moEventChannel);

  ///Make payment request using [MoMoPaymentModel] information
  ///
  /// return [MoMoPaymentResult] data
  static Future<MoMoPaymentResult> makePayment(MoMoPaymentModel model) async {
    String? invalidString = model.isInValidString;
    if (invalidString != null) {
      return MoMoPaymentResult(MoMoPaymentStatus.somethingWentWrong, message: invalidString);
    }

    var response = await _channel.invokeMethod(MoMoFlutterPluginMethods.makePayment, model.toJson());

    if (response != null && response is Map) {
      return MoMoPaymentResult.fromMap(response);
    }
    return MoMoPaymentResult(MoMoPaymentStatus.unknown);
  }
}