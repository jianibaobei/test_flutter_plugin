#import "ZhwLoginPlugin.h"
#if __has_include(<zhw_login/zhw_login-Swift.h>)
#import <zhw_login/zhw_login-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "zhw_login-Swift.h"
#endif

@implementation ZhwLoginPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftZhwLoginPlugin registerWithRegistrar:registrar];
}
@end
