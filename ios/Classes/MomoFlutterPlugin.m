#import "MomoFlutterPlugin.h"
#if __has_include(<momo_flutter_plugin/momo_flutter_plugin-Swift.h>)
#import <momo_flutter_plugin/momo_flutter_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "momo_flutter_plugin-Swift.h"
#endif

@implementation MomoFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMomoFlutterPlugin registerWithRegistrar:registrar];
}
@end
