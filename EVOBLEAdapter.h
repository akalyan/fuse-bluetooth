#import <Foundation/Foundation.h>

#import <Cordova/CDVAppDelegate.h>
#import <Cordova/CDVViewController.h>
#import <Cordova/CDVCommandQueue.h>
#import <Cordova/CDVCommandDelegate.h>
#import <Cordova/CDVCommandDelegateImpl.h>

#import "EVOBLE.h"

@interface AppDelegate : CDVAppDelegate {}
@end

@interface MainViewController : CDVViewController
@end

@interface MainCommandDelegate : CDVCommandDelegateImpl
@end

@interface MainCommandQueue : CDVCommandQueue
@end

@interface EVOBLEAdapter : NSObject

@property (nonatomic, readonly, strong) id <CDVCommandDelegate> commandDelegate;
@property EVOBLE* evoble;

// @property CDVInvokedUrlCommand* startScanCommand;
// @property CDVInvokedUrlCommand* startScanPostponedCommand;
// @property CDVInvokedUrlCommand* getBondedDevicesPostponedCommand;

// Public Cordova API.
- (int) powerStatus;
- (void) startScan: (NSArray*)command onScanResult:(void (^)(NSString* arg))successCallback onError:(void (^)(NSString* arg))errorCallback;
// - (void) stopScan: (CDVInvokedUrlCommand*)command;
// - (void) getBondedDevices: (CDVInvokedUrlCommand*)command;
// - (void) getBondState: (CDVInvokedUrlCommand*)command;
// - (void) bond: (CDVInvokedUrlCommand*)command;
// - (void) unbond: (CDVInvokedUrlCommand*)command;
// - (void) connect: (CDVInvokedUrlCommand*)command;
// - (void) close: (CDVInvokedUrlCommand*)command;
// - (void) rssi: (CDVInvokedUrlCommand*)command;
// - (void) services: (CDVInvokedUrlCommand*)command;
// - (void) characteristics: (CDVInvokedUrlCommand*)command;
// - (void) descriptors: (CDVInvokedUrlCommand*)command;
// - (void) readCharacteristic: (CDVInvokedUrlCommand*)command;
// - (void) readDescriptor: (CDVInvokedUrlCommand*)command;
// - (void) writeCharacteristic: (CDVInvokedUrlCommand*)command;
// - (void) writeCharacteristicWithoutResponse: (CDVInvokedUrlCommand*)command;
// - (void) writeDescriptor: (CDVInvokedUrlCommand*)command;
// - (void) enableNotification: (CDVInvokedUrlCommand*)command;
// - (void) disableNotification: (CDVInvokedUrlCommand*)command;
// - (void) reset: (CDVInvokedUrlCommand*)command;

@end
