
import 'dart:io';

import '../common.dart';

class MoMoPaymentModel {
  String appScheme;
  String merchantName;
  String merchantCode;
  String merchantNameLabel;
  int amount;
  int fee;
  String? description;
  String? extra;
  String? username;
  String orderId;
  String orderLabel;

  ///Whether valid or not information
  String? get isInValidString {
    if (StringExtension.isNullOrEmpty(merchantCode)) {
      return 'merchantcode is required. Please check if key is present in options.';
    }

    if (StringExtension.isNullOrEmpty(merchantName)) {
      return 'merchantName is required. Please check if key is present in options.';
    }

    if (Platform.isIOS && (StringExtension.isNullOrEmpty(appScheme))) {
      return'appScheme is required. Please check if key is present in options.';
    }
    if (amount < 0) {
      return 'amount is required. Please check if key is present in options.';
    }

    if (StringExtension.isNullOrEmpty(description)) {
      return 'description is required. Please check if key is present in options.';
    }

    return null;
  }

  MoMoPaymentModel({
    required this.appScheme,
    required this.merchantName,
    required this.merchantCode,
    required this.amount,
    required this.orderId,
    required this.orderLabel,
    required this.merchantNameLabel,
    required this.fee,
    this.description,
    this.username,
    this.extra,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      "merchantname": merchantName,
      "merchantcode": merchantCode,
      "amount": amount,
      "orderId": orderId,
      "orderlabel": orderLabel,
      "fee": fee,
      "merchantnamelabel": merchantNameLabel
    };
    if (Platform.isIOS) {
      json["appScheme"] = appScheme;
    }
    if (description != null) {
      json["description"] = description;
    }
    if (username != null) {
      json["username"] = username;
    }
    if (extra != null) {
      json["extra"] = extra;
    }
    return json;
  }
}