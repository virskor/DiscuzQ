#import "FlutterNativeLoadingPlugin.h"
#import <flutter_native_loading/flutter_native_loading-Swift.h>

@implementation FlutterNativeLoadingPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterNativeLoadingPlugin registerWithRegistrar:registrar];
}
@end
