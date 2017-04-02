#import <Foundation/Foundation.h>

@interface TestNativeLib : NSObject

- (void) registerCommandDelegate: (void (^)(NSString* arg)) callback;

@end
