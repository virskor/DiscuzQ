#import "ClipboardManagerPlugin.h"
#import <clipboard_manager/clipboard_manager-Swift.h>

@implementation ClipboardManagerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftClipboardManagerPlugin registerWithRegistrar:registrar];
}
@end
