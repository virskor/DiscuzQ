#import "FlutterNativeDialogPlugin.h"
#import <flutter_native_dialog/flutter_native_dialog-Swift.h>

@implementation FlutterNativeDialogPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterNativeDialogPlugin registerWithRegistrar:registrar];
}
@end
