
import '../common.dart';
import '../enums/enums.dart';

class MoMoPaymentResult {
  MoMoPaymentStatus status;
  String? token;
  String? phoneNumber;
  String? data;
  String? message;
  String? extra;

  MoMoPaymentResult(
      this.status,
      {
        this.token,
        this.phoneNumber,
        this.message,
        this.data,
        this.extra
      }
  );

  @override
  String toString() => "status:$status | phoneNumber:$phoneNumber | data:$data | message:$message | extra: $extra | token: $token";

  static MoMoPaymentStatus _parseStatus(dynamic value) {
    MoMoPaymentStatus result = MoMoPaymentStatus.unknown;
    try {
      int? status = int.tryParse(value.toString());
      if (status != null) {
        switch (status) {
          case 0:
            result = MoMoPaymentStatus.success;
            break;
          case 5:
            result = MoMoPaymentStatus.timeout;
            break;
          case 6:
            result = MoMoPaymentStatus.cancel;
            break;
          case 9:
            result = MoMoPaymentStatus.appNotInstalled;
            break;
          case 10:
            result = MoMoPaymentStatus.somethingWentWrong;
            break;
          default:
            result = MoMoPaymentStatus.unknown;
            break;
        }
      }
    }
    catch(exception) {
      printLog (exception.toString());
    }
    return result;
  }

  factory MoMoPaymentResult.fromMap(Map<dynamic, dynamic> map) {
    try {
      MoMoPaymentStatus status = _parseStatus(map['status']);
      String? token = map["token"];
      String? phoneNumber = map["phoneNumber"];
      String? data = map["data"];
      String? message = map["message"];
      String? extra = "";
      extra = map["extra"];
      return MoMoPaymentResult(status, token: token, phoneNumber: phoneNumber, data: data, message: message, extra: extra);
    }
    catch(exception) {
      return MoMoPaymentResult(MoMoPaymentStatus.unknown, message: exception.toString());
    }

  }
}
