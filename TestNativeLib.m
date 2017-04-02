#import <CoreFoundation/CoreFoundation.h>
#import <objc/runtime.h>
#import "TestNativeLib.h"

@implementation TestNativeLib

- (id) init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void) registerCommandDelegate: (void (^)(NSString* arg)) callback
{
  callback(@"Hello from native lib");
}

@end
