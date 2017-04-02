using Fuse;
using Fuse.Scripting;
using Fuse.Reactive;
using Uno.UX;
using Uno.Compiler.ExportTargetInterop;
using Uno;
using Uno.Collections;

// [Require("Xcode.Framework","CoreBluetooth.framework")]
[Require("Xcode.Framework","Foundation.framework")]
// [ForeignInclude(Language.ObjC, "EVOBLEAdapter.h")]

[UXGlobalModule]
public class BluetoothModule : NativeModule
{
  static readonly BluetoothModule _instance;
  // extern(iOS) ObjC.Object _bluetooth;
  // Dictionary<string, object> _functionMap;
  // Function _testFunction;

  public BluetoothModule()
  {
    if(_instance != null)
      return;

    _instance = this;
    Resource.SetGlobalKey(_instance, "Bluetooth");

    // AddMember(new NativeFunction("powerStatus", (NativeCallback)powerStatus));
    // AddMember(new NativeFunction("startScan", (NativeCallback)startScan));
    AddMember(new NativeFunction("getStatus", (NativeCallback)getStatus));

    // _functionMap = new Dictionary<string, object>();
    //
    // if defined(iOS)
    //   _bluetooth = AllocBluetooth();
  }

  // public void registerCallback(string callbackId, Function cb)
  // {
  //   _functionMap.Add(callbackId, cb);
  //   _testFunction = cb;
  // }
  //
  // public void invokeCallback(string callbackId, string arg)
  // {
  //   // var fn = _functionMap[callbackId] as Function;
  //   // fn.Call(arg);
  //   debug_log("Invoking callback with " + arg);
  //   _testFunction.Call(arg);
  // }

  // [Foreign(Language.ObjC)]
  // extern(iOS) ObjC.Object AllocBluetooth()
  // @{
  //   return [[EVOBLEAdapter alloc] init];
  // @}

  // /**
  //  * powerStatus
  //  */
  //
  // object powerStatus(Context c, object[] args)
  // {
  //   if defined(iOS){
  //     return _powerStatus(_bluetooth);
  //   } else {
  //     debug_log "BLE is only implemented for iOS";
  //     return 4; // same as CBPeripheralManagerStateUnsupported
  //   }
  // }
  //
  // [Foreign(Language.ObjC)]
  // public extern(iOS) int _powerStatus(ObjC.Object bluetooth)
  // @{
  //   return [(EVOBLEAdapter *)bluetooth powerStatus];
  // @}

  // /**
  //  * startScan
  //  */
  //
  // extern(iOS) void failureCallback(ObjC.Object error) {
  //   debug_log("Got scan failure");
  // }
  //
  // class CallbackClosure
  // {
  //   Function _callback;
  //   public CallbackClosure(Function callback)
  //   {
  //     _callback = callback;
  //   }
  //   public void Call(string arg)
  //   {
  //     _callback.Call(arg);
  //   }
  // }

  // object startScan(Context c, object[] args)
  // {
  //   if defined(iOS) {
  //
  //     Function successCallback = args[0] as Function;
  //     Function failureCallback = args[1] as Function;
  //     // Fuse.Scripting.Object options = args[2] as Fuse.Scripting.Object;
  //
  //     _startScan(
  //       _bluetooth,
  //       (new CallbackClosure(successCallback)).Call,
  //       (new CallbackClosure(failureCallback)).Call,
  //       null
  //     );
  //     return null;
  //   } else {
  //     debug_log "BLE is only implemented for iOS";
  //     return null;
  //   }
  // }

  // [Foreign(Language.ObjC)]
  // public extern(iOS) void _startScan(ObjC.Object bluetooth, Action<string> success, Action<string> fail, Fuse.Scripting.Object options)
  // @{
  //   NSArray* args = @[@"testCallbackId", @"EVOBLE", @"startScan", @[]];
  //   // [(EVOBLEAdapter *)bluetooth startScan:args onScanResult:success onError:fail];
  //   success(@"Testing");
  // @}

  /**
   * getStatus
   */

  class SuccessClosure
  {
    Function _callback;
    public SuccessClosure(Function callback)
    {
      _callback = callback;
    }
    public void Call(string arg)
    {
      _callback.Call(arg);
    }
  }

  // extern(iOS) void successCallback(ObjC.Object result) {
  //   debug_log("Got scan result");
  //   debug_log(result);
  // }

  object getStatus(Context c, object[] args)
  {
    if defined(iOS) {
      Function successCb = args[0] as Function;
      // registerCallback("12345", successCb);

      // new SuccessClosure(successCb).Call("Closure invokation");

      // invokeCallback("12345", "Direct invoke");
      _getStatus(new SuccessClosure(successCb).Call);
      return null;
    } else {
      debug_log "getStatus is only implemented for iOS";
      return null;
    }
  }

  [Foreign(Language.ObjC)]
  public extern(iOS) void _getStatus(Action<string> success)
  @{
    success(@"Hello");
  @}

}

// @{BluetoothModule:Of(_this).invokeCallback(string, string):Call(@"12345", @§"Please Work!!")};
// cb(@"Please work!!");

// "EVOBLEAdapter.h:ObjCHeader:iOS",
// "EVOBLEAdapter.m:ObjCSource:iOS",
// "cordova-test/plugins/cordova-plugin-ble/src/ios/EVOBLE.h:ObjCHeader:iOS",
// "cordova-test/plugins/cordova-plugin-ble/src/ios/EVOBLE.m:ObjCSource:iOS",
