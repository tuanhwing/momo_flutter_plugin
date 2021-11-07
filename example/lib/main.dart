import 'package:flutter/material.dart';
import 'package:momo_flutter_plugin/momo_flutter_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  late MoMoPaymentModel options;

  @override
  void initState() {
    super.initState();

    options = MoMoPaymentModel(
        merchantName: "CGV Cinemas",
        merchantCode: 'CGV01',
        appScheme: "momob0ce20211106",
        amount: 20000,
        orderId: "${DateTime.now().microsecond}",
        orderLabel: '',
        merchantNameLabel: "Service",
        fee: 0,
        description: 'Thanh toán vé xem phim',
        username: 'tuanhwing2014@gmail.com',
        extra: "{\"key1\":\"value1\",\"key2\":\"value2\"}",
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: TextButton(
            onPressed: () async {
              MoMoPaymentResult result = await MoMoFlutterPlugin.makePayment(options);

              print ("Payment result: ${result.toString()}");
            },
            child: const Text("MOMO payment"),
          ),
        ),
      ),
    );
  }
}
