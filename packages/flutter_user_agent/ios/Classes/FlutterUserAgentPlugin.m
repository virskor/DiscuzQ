#import "FlutterUserAgentPlugin.h"

@implementation FlutterUserAgentPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_user_agent"
            binaryMessenger:[registrar messenger]];
  FlutterUserAgentPlugin* instance = [[FlutterUserAgentPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getProperties" isEqualToString:call.method]) {
      [self constantsToExport:^(NSDictionary * _Nonnull constants) {
          result(constants);
      }];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@synthesize isEmulator;
@synthesize webView;

//eg. Darwin/16.3.0
- (NSString *)darwinVersion
{
    struct utsname u;
    (void) uname(&u);
    return [NSString stringWithUTF8String:u.release];
}

//eg. iPhone5,2
- (NSString *)deviceName
{
    struct utsname systemInfo;
    uname(&systemInfo);

    NSString* deviceIdentifier = [NSString stringWithUTF8String:systemInfo.machine];

    if ([deviceIdentifier isEqualToString:@"i386"] || [deviceIdentifier isEqualToString:@"x86_64"]) {
        deviceIdentifier = [NSString stringWithFormat:@"%s", getenv("SIMULATOR_MODEL_IDENTIFIER")];
        self.isEmulator = YES;
    } else {
        self.isEmulator = NO;
    }

    static NSDictionary* deviceNames = nil;

    if (!deviceNames) {

        deviceNames = @{
            @"iPod1,1"   :@"iPod",               // (Original)
            @"iPod2,1"   :@"iPod",               // (Second Generation)
            @"iPod3,1"   :@"iPod",               // (Third Generation)
            @"iPod4,1"   :@"iPod",               // (Fourth Generation)
            @"iPod5,1"   :@"iPod",               // (Fifth Generation)
            @"iPod7,1"   :@"iPod",               // (Sixth Generation)
            @"iPad1,1"   :@"iPad",               // (Original)
            @"iPad2,1"   :@"iPad/2",             //
            @"iPad2,2"   :@"iPad/2",             //
            @"iPad2,3"   :@"iPad/2",             //
            @"iPad2,4"   :@"iPad/2",             //
            @"iPad3,1"   :@"iPad",               // (3rd Generation)
            @"iPad3,2"   :@"iPad",               // (3rd Generation)
            @"iPad3,3"   :@"iPad",               // (3rd Generation)
            @"iPad3,4"   :@"iPad",               // (4th Generation)
            @"iPad3,5"   :@"iPad",               // (4th Generation)
            @"iPad3,6"   :@"iPad",               // (4th Generation)
            @"iPad2,5"   :@"iPad/Mini",          // (Original)
            @"iPad2,6"   :@"iPad/Mini",          // (Original)
            @"iPad2,7"   :@"iPad/Mini",          // (Original)
            @"iPad4,1"   :@"iPad/Air",           // 5th Generation iPad (iPad Air) - Wifi
            @"iPad4,2"   :@"iPad/Air",           // 5th Generation iPad (iPad Air) - Cellular
            @"iPad4,3"   :@"iPad/Air",           // 5th Generation iPad (iPad Air)
            @"iPad4,4"   :@"iPad/Mini_2",        // (2nd Generation iPad Mini - Wifi)
            @"iPad4,5"   :@"iPad/Mini_2",        // (2nd Generation iPad Mini - Cellular)
            @"iPad4,6"   :@"iPad/Mini_2",        // (2nd Generation iPad Mini)
            @"iPad4,7"   :@"iPad/Mini_3",        // (3rd Generation iPad Mini)
            @"iPad4,8"   :@"iPad/Mini_3",        // (3rd Generation iPad Mini)
            @"iPad4,9"   :@"iPad/Mini_3",        // (3rd Generation iPad Mini)
            @"iPad5,1"   :@"iPad/Mini_4",        // (4th Generation iPad Mini)
            @"iPad5,2"   :@"iPad/Mini_4",        // (4th Generation iPad Mini)
            @"iPad5,3"   :@"iPad/Air_2",         // 6th Generation iPad (iPad/Air_2)
            @"iPad5,4"   :@"iPad/Air_2",         // 6th Generation iPad (iPad/Air_2)
            @"iPad6,3"   :@"iPad/Pro_9.7-inch",  // iPad/Pro_9.7-inch
            @"iPad6,4"   :@"iPad/Pro_9.7-inch",  // iPad/Pro_9.7-inch
            @"iPad6,7"   :@"iPad/Pro_12.9-inch", // iPad/Pro_12.9-inch
            @"iPad6,8"   :@"iPad/Pro_12.9-inch", // iPad/Pro_12.9-inch
            @"iPad7,1"   :@"iPad/Pro_12.9-inch", // 2nd Generation iPad Pro 12.5-inch - Wifi
            @"iPad7,2"   :@"iPad/Pro_12.9-inch", // 2nd Generation iPad Pro 12.5-inch - Cellular
            @"iPad7,3"   :@"iPad/Pro_10.5-inch", // iPad/Pro_10.5-inch - Wifi
            @"iPad7,4"   :@"iPad/Pro_10.5-inch", // iPad/Pro_10.5-inch - Cellular
            @"iPhone1,1" :@"iPhone",             // (Original)
            @"iPhone1,2" :@"iPhone/3G",          // (3G)
            @"iPhone2,1" :@"iPhone/3GS",         // (3GS)
            @"iPhone3,1" :@"iPhone/4",           // (GSM)
            @"iPhone3,2" :@"iPhone/4",           // iPhone 4
            @"iPhone3,3" :@"iPhone/4",           // (CDMA/Verizon/Sprint)
            @"iPhone4,1" :@"iPhone/4S",          //
            @"iPhone5,1" :@"iPhone/5",           // (model A1428, AT&T/Canada)
            @"iPhone5,2" :@"iPhone/5",           // (model A1429, everything else)
            @"iPhone5,3" :@"iPhone/5c",          // (model A1456, A1532 | GSM)
            @"iPhone5,4" :@"iPhone/5c",          // (model A1507, A1516, A1526 (China), A1529 | Global)
            @"iPhone6,1" :@"iPhone/5s",          // (model A1433, A1533 | GSM)
            @"iPhone6,2" :@"iPhone/5s",          // (model A1457, A1518, A1528 (China), A1530 | Global)
            @"iPhone7,1" :@"iPhone/6_Plus",      //
            @"iPhone7,2" :@"iPhone/6",           //
            @"iPhone8,1" :@"iPhone/6s",          //
            @"iPhone8,2" :@"iPhone/6s_Plus",     //
            @"iPhone8,4" :@"iPhone/..SE",        //
            @"iPhone9,1" :@"iPhone/7",           // (model A1660 | CDMA)
            @"iPhone9,3" :@"iPhone/7",           // (model A1778 | Global)
            @"iPhone9,2" :@"iPhone/7_Plus",      // (model A1661 | CDMA)
            @"iPhone9,4" :@"iPhone/7_Plus",      // (model A1784 | Global)
            @"iPhone10,1":@"iPhone/8",           // (model A1863, A1906, A1907)
            @"iPhone10,4":@"iPhone/8",           // (model A1905)
            @"iPhone10,2":@"iPhone/8_Plus",      // (model A1864, A1898, A1899)
            @"iPhone10,5":@"iPhone/8_Plus",      // (model A1897)
            @"iPhone10,3":@"iPhone/X",           // (model A1865, A1902)
            @"iPhone10,6":@"iPhone/X",           // (model A1901)
            @"iPhone11,2":@"iPhone/XS",
            @"iPhone11,4":@"iPhone/XS_Max",
            @"iPhone11,6":@"iPhone/XS_Max_Global",
            @"iPhone11,8":@"iPhone/XR",
            @"iPhone12,1":@"iPhone/11",
            @"iPhone12,3":@"iPhone/11_Pro",
            @"iPhone12,5":@"iPhone/11_Pro_Max",
            @"AppleTV2,1":@"AppleTV",            // Apple TV (2nd Generation)
            @"AppleTV3,1":@"AppleTV",            // Apple TV (3rd Generation)
            @"AppleTV3,2":@"AppleTV",            // Apple TV (3rd Generation - Rev A)
            @"AppleTV5,3":@"AppleTV",            // Apple TV (4th Generation)
            @"AppleTV6,2":@"AppleTV_4K",         // Apple TV 4K
        };
    }

     NSString* deviceName = [deviceNames objectForKey:deviceIdentifier];

     if (!deviceName) {
        if ([deviceIdentifier rangeOfString:@"iPod"].location != NSNotFound) {
            deviceName = @"iPod";
        }
        else if([deviceIdentifier rangeOfString:@"iPad"].location != NSNotFound) {
            deviceName = @"iPad";
        }
        else if([deviceIdentifier rangeOfString:@"iPhone"].location != NSNotFound){
            deviceName = @"iPhone";
        }
        else if([deviceIdentifier rangeOfString:@"AppleTV"].location != NSNotFound){
            deviceName = @"AppleTV";
        }
    }

    return deviceName;

}

- (void)getWebViewUserAgent:(void (^ _Nullable)(NSString * _Nullable webViewUserAgent, NSError * _Nullable error))completionHandler
{
    if (@available(ios 8.0, *)) {
        if (self.webView == nil) {
            // retain because `evaluateJavaScript:` is asynchronous
            self.webView = [[WKWebView alloc] init];
        }
        // Not sure if this is really neccesary
        [self.webView loadHTMLString:@"<html></html>" baseURL:nil];
        
        [self.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:completionHandler];
    }
}

- (void)constantsToExport:(void  (^ _Nullable)(NSDictionary * _Nonnull constants))completionHandler
{
    UIDevice *currentDevice = [UIDevice currentDevice];

    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"] ?: [NSNull null];
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] ?: [NSNull null];
    NSString *buildNumber = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"] ?: [NSNull null];
    NSString *darwinVersion = [self darwinVersion];
    NSString *cfnVersion = [NSBundle bundleWithIdentifier:@"com.apple.CFNetwork"].infoDictionary[@"CFBundleShortVersionString"];
    NSString *deviceName = [self deviceName];

    NSString *userAgent = [NSString stringWithFormat:@"CFNetwork/%@ Darwin/%@ (%@ %@/%@)", cfnVersion, darwinVersion, deviceName, currentDevice.systemName, currentDevice.systemVersion];

    [self getWebViewUserAgent:^(NSString * _Nullable webViewUserAgent, NSError * _Nullable error) {
        completionHandler(@{
          @"isEmulator": @(self.isEmulator),
          @"systemName": currentDevice.systemName,
          @"systemVersion": currentDevice.systemVersion,
          @"applicationName": appName,
          @"applicationVersion": appVersion,
          @"buildNumber": buildNumber,
          @"darwinVersion": darwinVersion,
          @"cfnetworkVersion": cfnVersion,
          @"deviceName": deviceName,
          @"packageUserAgent": [NSString stringWithFormat:@"%@/%@.%@ %@)", appName, appVersion, buildNumber, userAgent],
          @"userAgent": userAgent,
          @"webViewUserAgent": webViewUserAgent ?: [NSNull null]
        });
    }];
}

@end
