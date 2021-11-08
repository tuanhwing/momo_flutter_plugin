# Getting started
```
https://github.com/tuanhwing/momo_flutter_plugin
```

**MoMo has been the leading payment solutions provider in Vietnam with strong technical capabilities**

A Flutter plugin for iOS and Android for integrate MoMo payment process into your app.

---
## Installation
First, add `momo_flutter_plugin` as a dependency in your pubspec.yaml file.

`Register your application at momo business home page :` https://business.momo.vn

#### IOS
- Config file Plist (CFBundleURLTypes and LSApplicationQueriesSchemes)
  Repalce `YOUR_APP_SCHEME` with `IOS SCHEME ID` value from (https://business.momo.vn/merchant/integrateAppInfo)
    ```
    <key>CFBundleURLTypes</key>
    <array>
      <dict>
        <key>CFBundleURLName</key>
        <string></string>
        <key>CFBundleURLSchemes</key>
        <array>
          <string>YOUR_APP_SCHEME</string>
        </array>
      </dict>
    </array>
    <key>LSApplicationQueriesSchemes</key>
    <array>
      <string>momo</string>
    </array>
    <key>NSAppTransportSecurity</key>
    <dict>
      <key>NSAllowsArbitraryLoads</key>
      <true/>
    </dict>
    ```

#### Android
At a minimum, this SDK is designed to work with Android SDK 14.

- Import SDK Add the JitPack repository to your `build.gradle`:
    ```
    allprojects {
        repositories {
            ...
            maven { url 'https://jitpack.io' }
        }
    }
    ```
    Add the dependency:
    ```
    dependencies {
	    compile 'com.github.momo-wallet:mobile-sdk:1.0.7'
    }
    ```
-  Config `AndroidMainfest`
    ```
    <uses-permission android:name="android.permission.INTERNET" />
    ```

## Usage
- Initialize
    ```
    void main() {
      WidgetsFlutterBinding.ensureInitialized();//Important
      MoMoFlutterPlugin.initialize(MoMoPaymentEnvironments.develop);//Development mode
      
      ...
    }
    ```
- Perform a payment request
    ```
    MoMoPaymentResult result = await MoMoFlutterPlugin.makePayment(
        MoMoPaymentModel(
            merchantName: "CGV Cinemas",
            merchantCode: "CGV01",
            appScheme: "momob0ce20211106",
            amount: 20000,
            orderId: "ID123456",
            orderLabel: "",
            merchantNameLabel: "Service",
            fee: 0,
            description: "Thanh toán vé xem phim",
            username: "tuanhwing2014@gmail.com",
            extra: "{\"key1\":\"value1\",\"key2\":\"value2\"}",
        )
    );
    ```
- Handle response payment process
    ```
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
    ```
#### Testing
Refer: https://developers.momo.vn/v2/#/docs/testing_information
NOTE: `Development` mode using MoMo Test applicaiton