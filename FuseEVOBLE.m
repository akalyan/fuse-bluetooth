#import <Cordova/CDVInvokedUrlCommand.h>
#import <objc/runtime.h>

#import "FuseEVOBLE.h"
#import "NSData+Base64.h"

// //////////////////////////////////////////////////////////////////
// //               Class Extension CBPeripheral                   //
// //////////////////////////////////////////////////////////////////
//
// static int EVOPerhiperalAssociatedObjectKey = 42;
//
// @interface CBPeripheral (BLEPluginSupport)
//
// - (void) setEvoPeripheral: (EVOPeripheral*)evoPerhiperal;
// - (EVOPeripheral*) getEvoPerhiperal;
//
// @end
//
// @implementation CBPeripheral (BLEPluginSupport)
//
// - (void) setEvoPeripheral: (EVOPeripheral*)evoPerhiperal
// {
//     objc_setAssociatedObject(
//                              self,
//                              &EVOPerhiperalAssociatedObjectKey,
//                              evoPerhiperal,
//                              OBJC_ASSOCIATION_ASSIGN);
// }
//
//
// - (EVOPeripheral*) getEvoPerhiperal
// {
//     return objc_getAssociatedObject(
//                                     self,
//                                     &EVOPerhiperalAssociatedObjectKey);
// }
//
// @end
//
@implementation FuseEVOBLE
//
// /**
//  * BLE API call: connect
//  */
// - (void) connect: (CDVInvokedUrlCommand*)command
// {
//     // The connect address is in the first argument.
//     NSString* address = [command.arguments objectAtIndex: 0];
//
//     // Check that address was given.
//     if (nil == address)
//     {
//         // Pass back error message.
//         [self
//          sendErrorMessage: @"no device address given"
//          forCallback: command.callbackId];
//         return;
//     }
//
//     // Get the pheripheral object for the given address.
//     NSUUID* uuid = [[NSUUID UUID] initWithUUIDString: address];
//     NSArray* pheriperals = [self.central
//                             retrievePeripheralsWithIdentifiers: @[uuid]];
//
//     if ([pheriperals count] < 1)
//     {
//         // Pass back error message.
//         [self
//          sendErrorMessage: @"device with given address not found"
//          forCallback: command.callbackId];
//         return;
//     }
//
//     // Get first found pheriperal.
//     CBPeripheral* peripheral = pheriperals[0];
//
//     if (nil == peripheral)
//     {
//         // Pass back error message.
//         [self
//          sendErrorMessage: @"device not found"
//          forCallback: command.callbackId];
//         return;
//     }
//
//     // Check if periheral is already connected.
//     if (nil != [peripheral getEvoPerhiperal])
//     {
//         // Debug log.
//         NSLog(@"BLE.m: Periheral was already connected");
//
//         // Pass back error message.
//         [self
//          sendErrorMessage: @"device already connected"
//          forCallback: command.callbackId];
//     }
//     else
//     {
//         // Not connected yet.
//
//         // Create custom peripheral object.
//         FuseEVOPeripheral* evoPerhiperal = [FuseEVOPeripheral
//                                         withBLE: self
//                                         periperal: peripheral];
//
//         // Save Cordova callback id.
//         evoPerhiperal.connectCallbackId = command.callbackId;
//
//         // Send 'connecting' state to JS side.
//         [self
//          sendConnectionState: @1 // STATE_CONNECTING
//          forEvoPeripheral: evoPerhiperal];
//
//         // Connect. Result is given in methods:
//         //   centralManager:didConnectPeripheral:
//         //   centralManager:didDisconnectPeripheral:error:
//         [self.central
//          connectPeripheral: peripheral
//          options: nil];
//     }
// }
//
// /**
//  * Internal helper method.
//  */
// - (void) sendConnectionState: (NSNumber *)state
//             forEvoPeripheral: (EVOPeripheral *)evoPerhiperal
// {
//     // Create an info object.
//     // The UUID is used as the address of the device (the 6-byte BLE address
//     // does not seem to be directly available on iOS).
//     NSDictionary* info = @{
//                            @"deviceHandle" : evoPerhiperal.handle,
//                            @"state" : state
//                            };
//
//     // Send back data to JS.
//     [self
//      sendDictionary: info
//      forCallback: evoPerhiperal.connectCallbackId
//      keepCallback: YES];
// }


- (void) writeCharacteristic: (CDVInvokedUrlCommand*)command
{
  NSMutableArray *newArguments = [command.arguments mutableCopy];
  NSString *b64string = [command.arguments objectAtIndex:2];
  NSData *data = [[NSData alloc] initWithData:[NSData dataFromBase64String:b64string]];

  [newArguments replaceObjectAtIndex:2 withObject:data];

  CDVInvokedUrlCommand *newCommand =
    [[CDVInvokedUrlCommand alloc] initWithArguments:newArguments
                                        callbackId:command.callbackId
                                         className:command.className
                                        methodName:command.methodName];

  [super writeCharacteristic:newCommand];
}

- (void) writeCharacteristicWithoutResponse: (CDVInvokedUrlCommand*)command
{
  NSMutableArray *newArguments = [command.arguments mutableCopy];
  NSString *b64string = [command.arguments objectAtIndex:2];
  NSData *data = [[NSData alloc] initWithData:[NSData dataFromBase64String:b64string]];

  [newArguments replaceObjectAtIndex:2 withObject:data];

  CDVInvokedUrlCommand *newCommand =
    [[CDVInvokedUrlCommand alloc] initWithArguments:newArguments
                                        callbackId:command.callbackId
                                         className:command.className
                                        methodName:command.methodName];

  [super writeCharacteristicWithoutResponse:newCommand];
}

- (void) writeDescriptor: (CDVInvokedUrlCommand*)command
{
  NSMutableArray *newArguments = [command.arguments mutableCopy];
  NSString *b64string = [command.arguments objectAtIndex:2];
  NSData *data = [[NSData alloc] initWithData:[NSData dataFromBase64String:b64string]];

  [newArguments replaceObjectAtIndex:2 withObject:data];

  CDVInvokedUrlCommand *newCommand =
    [[CDVInvokedUrlCommand alloc] initWithArguments:newArguments
                                        callbackId:command.callbackId
                                         className:command.className
                                        methodName:command.methodName];

  [super writeDescriptor:newCommand];
}

@end

// @implementation FuseEVOPeripheral
//
// + (FuseEVOPeripheral*) withBLE: (FuseEVOBLE*) ble periperal: (CBPeripheral*) peripheral
// {
//     return (FuseEVOPeripheral*)[super withBLE:ble periperal:peripheral];
// }
//
// // Note: Called both on read and notify!
// - (void) peripheral: (CBPeripheral *)peripheral
// didUpdateValueForCharacteristic: (CBCharacteristic *)characteristic
//               error: (NSError *)error
// {
//     EVOCallbackInfo* callback = [self
//                                  getCallbackForCharacteristic: characteristic];
//
//     // Perhaps it might happen that the notification is disabled
//     // and the callback removed, but there is still a pending
//     // notification, that is sent after notification is disabled.
//     // Here we check for this case.
//     // This error should not cause any harm and should be safe to ignore.
//     if (nil == callback)
//     {
//         // Print a log message so we can see if this ever happens.
//         NSLog(@"BLE.m: Callback for characteristic not found: %@", characteristic);
//         return; // Error
//     }
//
//     if (nil == error)
//     {
//         // Send back data to JS.
//         NSData* buffer = characteristic.value;
//
//         NSDictionary* result = @{
//                                  @"data" : [buffer base64EncodedString]
//                                  };
//
//         [self.ble
//          sendDictionary: result
//          forCallback: callback.callbackId
//          keepCallback: callback.isNotificationCallback];
//     }
//     else
//     {
//         [self.ble
//          sendErrorMessage: [error localizedDescription]
//          forCallback: callback.callbackId];
//     }
// }
//
// @end
