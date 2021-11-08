import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:momo_flutter_plugin/momo_flutter_plugin.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MoMoFlutterPlugin.initialize(MoMoPaymentEnvironments.develop);
  runApp(const MaterialApp(
  home: MyApp())
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  late MoMoPaymentModel options;

  final TextEditingController merchantNameTEC = TextEditingController();
  final TextEditingController merchantCodeTEC = TextEditingController();
  final TextEditingController appSchemeTEC = TextEditingController();
  final TextEditingController amountTEC = TextEditingController();
  final TextEditingController orderIdTEC = TextEditingController();
  final TextEditingController orderLabelTEC = TextEditingController();
  final TextEditingController merchantNameLabelTEC = TextEditingController();
  final TextEditingController feeTEC = TextEditingController();
  final TextEditingController descriptionTEC = TextEditingController();
  final TextEditingController usernameTEC = TextEditingController();
  final TextEditingController extraTEC = TextEditingController();

  void _handleResult(MoMoPaymentResult result) {
    print ("Payment result: ${result.toString()}");

    late String message;
    switch(result.status) {
      case MoMoPaymentStatus.success:
        message = "Successfully";
        break;
      case MoMoPaymentStatus.appNotInstalled:
        message = "App not installed!";
        break;
      case MoMoPaymentStatus.cancel:
        message = "Canceled by user!";
        break;
      default:
        message = result.message ?? "Unknown!";
        break;
    }

    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Notify"),
        content: Text(message),
        actions: <Widget>[
          CupertinoDialogAction(
            child: const Text("OK"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    merchantNameTEC.text = "CGV Cinemas";
    merchantCodeTEC.text = "CGV01";
    appSchemeTEC.text = "momob0ce20211106";
    amountTEC.text = "20000";
    orderIdTEC.text = "${DateTime.now().microsecond}";
    orderLabelTEC.text = "";
    merchantNameLabelTEC.text = "Service";
    feeTEC.text = "0";
    descriptionTEC.text = "Thanh toán vé xem phim";
    usernameTEC.text = "tuanhwing2014@gmail.com";
    extraTEC.text = "{\"key1\":\"value1\",\"key2\":\"value2\"}";
  }

  @override
  void dispose() {
    merchantNameTEC.dispose();
    merchantCodeTEC.dispose();
    appSchemeTEC.dispose();
    amountTEC.dispose();
    orderIdTEC.dispose();
    orderLabelTEC.dispose();
    merchantNameLabelTEC.dispose();
    feeTEC.dispose();
    descriptionTEC.dispose();
    usernameTEC.dispose();
    extraTEC.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 16.0
              ),
              child: Column(
                children: [
                  _InputWidget(
                    textEditingController: merchantNameTEC,
                    title: "merchantName",
                  ),
                  _InputWidget(
                    textEditingController: merchantCodeTEC,
                    title: "merchantCode",
                  ),
                  _InputWidget(
                    textEditingController: appSchemeTEC,
                    title: "appScheme",
                    readOnly: true,
                  ),
                  _InputWidget(
                    textEditingController: amountTEC,
                    title: "amount",
                    keyboardType: TextInputType.number,
                  ),
                  _InputWidget(
                    textEditingController: orderIdTEC,
                    title: "orderId",
                  ),
                  _InputWidget(
                    textEditingController: orderLabelTEC,
                    title: "orderLabel",
                  ),
                  _InputWidget(
                    textEditingController: merchantNameLabelTEC,
                    title: "merchantNameLabel",
                  ),
                  _InputWidget(
                    textEditingController: feeTEC,
                    title: "fee",
                    keyboardType: TextInputType.number,
                  ),
                  _InputWidget(
                    textEditingController: descriptionTEC,
                    title: "description",
                  ),
                  _InputWidget(
                    textEditingController: usernameTEC,
                    title: "username",
                  ),
                  _InputWidget(
                    textEditingController: extraTEC,
                    title: "extra",
                    readOnly: true,
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            MoMoPaymentResult result = await MoMoFlutterPlugin.makePayment(MoMoPaymentModel(
              merchantName: merchantNameTEC.text,
              merchantCode: merchantCodeTEC.text,
              appScheme: appSchemeTEC.text,
              amount: int.parse(amountTEC.text),
              orderId: orderIdTEC.text,
              orderLabel: orderLabelTEC.text,
              merchantNameLabel: merchantNameLabelTEC.text,
              fee: int.parse(feeTEC.text),
              description: descriptionTEC.text,
              username: usernameTEC.text,
              extra: extraTEC.text,
            ));

            _handleResult(result);
          },
          label: const Text('Purchase'),
          icon: const Icon(Icons.payment),
          backgroundColor: Theme.of(context).primaryColorDark,
        ),
      ),
    );
  }
}

class _InputWidget extends StatelessWidget {
  const _InputWidget({
    required this.textEditingController,
    this.title,
    this.keyboardType = TextInputType.text,
    this.readOnly = false
  });

  final TextEditingController textEditingController;
  final String? title;
  final TextInputType keyboardType;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      controller: textEditingController,
      decoration: InputDecoration(
        label: Text(title ?? "")
      ),
      readOnly: readOnly,
    );
  }

}
