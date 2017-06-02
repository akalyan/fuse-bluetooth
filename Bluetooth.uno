using Fuse;
using Fuse.Scripting;
using Fuse.Reactive;
using Uno.UX;
using Uno.Compiler.ExportTargetInterop;
using Uno;
using Uno.Collections;
using Fuse.Marshal;

[Require("Xcode.Framework","Foundation.framework")]
[ForeignInclude(Language.ObjC, "FuseEVOBLE.h")]

[UXGlobalModule]
public class Bluetooth : FuseCDVPluginAdapter
{
  static readonly Bluetooth _instance;

  public Bluetooth() : base("Bluetooth")
  {
    if(_instance != null)
      return;

    _instance = this;
    Uno.UX.Resource.SetGlobalKey(_instance, _ID);

    AddMember(new NativeFunction("startScan", (NativeCallback)startScan));
    AddMember(new NativeFunction("stopScan", (NativeCallback)stopScan));
    AddMember(new NativeFunction("connect", (NativeCallback)connect));
    AddMember(new NativeFunction("close", (NativeCallback)close));
    AddMember(new NativeFunction("services", (NativeCallback)services));
    AddMember(new NativeFunction("characteristics", (NativeCallback)characteristics));
    AddMember(new NativeFunction("descriptors", (NativeCallback)descriptors));
    AddMember(new NativeFunction("readCharacteristic", (NativeCallback)readCharacteristic));
    AddMember(new NativeFunction("writeCharacteristic", (NativeCallback)writeCharacteristic));
    AddMember(new NativeFunction("writeCharacteristicWithoutResponse", (NativeCallback)writeCharacteristicWithoutResponse));
    AddMember(new NativeFunction("readDescriptor", (NativeCallback)readDescriptor));
    AddMember(new NativeFunction("writeDescriptor", (NativeCallback)writeDescriptor));
    AddMember(new NativeFunction("enableNotification", (NativeCallback)enableNotification));
    AddMember(new NativeFunction("disableNotification", (NativeCallback)disableNotification));
    AddMember(new NativeFunction("reset", (NativeCallback)reset));

    if defined(iOS)
      _nativeLib = AllocNativeLib();

    // needs to be done last
    _bridge.registerPlugin(_ID, this);
  }

  [Foreign(Language.ObjC)]
  extern(iOS)
  ObjC.Object AllocNativeLib()
  @{
    FuseEVOBLE *plugin = [FuseEVOBLE alloc];
    [plugin pluginInitialize];
    return plugin;
  @}

  int getIntArgAtIndex(object[] args, int index, bool required) {
    if (args.Length > index) {
      object o = args[index];
      return Marshal.ToInt(o);
    } else {
      if (required) {
        debug_log("Missing argument at index " + index + " of type int");
      }
      debug_log("Missing argument at index " + index + " of type int");
      return -1;
    }
  }

  Function getFunctionArgAtIndex(object[] args, int index, bool required) {
    if (args.Length > index) {
      return args[index] as Function;
    } else {
      if (required) {
        debug_log("Missing argument at index " + index + " of type Function");
      }
      return null;
    }
  }

  string getStringArgAtIndex(object[] args, int index, bool required) {
    if (args.Length > index) {
      return args[index] as string;
    } else {
      if (required) {
        debug_log("Missing argument at index " + index + " of type string");
      }
      return null;
    }
  }

  Fuse.Scripting.Object getObjectArgAtIndex(object[] args, int index, bool required) {
    if (args.Length > index) {
      return args[index] as Fuse.Scripting.Object;
    } else {
      if (required) {
        debug_log("Missing argument at index " + index + " of type Fuse.Scripting.Object");
      }
      return null;
    }
  }

  object startScan(Context c, object[] args)
  {
    if defined(iOS) {
      Function successCb = getFunctionArgAtIndex(args, 0, true);
      Function failureCb = getFunctionArgAtIndex(args, 1, false);
      Fuse.Scripting.Object options = getObjectArgAtIndex(args, 2, false);

      string callbackId = RegisterCordovaCallbackClosure(c, successCb, failureCb);

      List<object> arguments = new List<object>();
      if (options != null && options.ContainsKey("serviceUUIDs")) {
        arguments.Add(options["serviceUUIDs"]);
      }

      performSelector(_nativeLib, "startScan", callbackId, convertArgsArrayToJson(arguments.ToArray()));
    } else {
      debug_log "startScan is only implemented for iOS";
    }
    return null;
  }

  object stopScan(Context c, object[] args)
  {
    if defined(iOS) {
      Function successCb = getFunctionArgAtIndex(args, 0, false);
      Function failureCb = getFunctionArgAtIndex(args, 1, false);

      string callbackId = RegisterCordovaCallbackClosure(c, successCb, failureCb);

      performSelector(_nativeLib, "stopScan", callbackId, "[]");
    } else {
      debug_log "stopScan is only implemented for iOS";
    }
    return null;
  }

  object connect(Context c, object[] args)
  {
    if defined(iOS) {
      string address = getStringArgAtIndex(args, 0, true);
      Function successCb = getFunctionArgAtIndex(args, 1, true);
      Function failureCb = getFunctionArgAtIndex(args, 1, false);

      string callbackId = RegisterCordovaCallbackClosure(c, successCb, failureCb);

      List<object> arguments = new List<object>();
      arguments.Add(address);

      performSelector(_nativeLib, "connect", callbackId, convertArgsArrayToJson(arguments.ToArray()));
    } else {
      debug_log "connect is only implemented for iOS";
    }
    return null;
  }

  object close(Context c, object[] args)
  {
    if defined(iOS) {
      int deviceHandle = getIntArgAtIndex(args, 0, true);

      string callbackId = RegisterCordovaCallbackClosure(c, null, null);

      List<object> arguments = new List<object>();
      arguments.Add(deviceHandle);

      performSelector(_nativeLib, "close", callbackId, convertArgsArrayToJson(arguments.ToArray()));
    } else {
      debug_log "close is only implemented for iOS";
    }
    return null;
  }

  object rssi(Context c, object[] args)
  {
    if defined(iOS) {
      int deviceHandle = getIntArgAtIndex(args, 0, true);
      Function successCb = getFunctionArgAtIndex(args, 1, true);
      Function failureCb = getFunctionArgAtIndex(args, 2, false);

      string callbackId = RegisterCordovaCallbackClosure(c, successCb, failureCb);

      List<object> arguments = new List<object>();
      arguments.Add(deviceHandle);

      performSelector(_nativeLib, "rssi", callbackId, convertArgsArrayToJson(arguments.ToArray()));
    } else {
      debug_log "rssi is only implemented for iOS";
    }
    return null;
  }

  object services(Context c, object[] args)
  {
    if defined(iOS) {
      int deviceHandle = getIntArgAtIndex(args, 0, true);
      Function successCb = getFunctionArgAtIndex(args, 1, true);
      Function failureCb = getFunctionArgAtIndex(args, 2, false);

      string callbackId = RegisterCordovaCallbackClosure(c, successCb, failureCb);

      List<object> arguments = new List<object>();
      arguments.Add(deviceHandle);

      performSelector(_nativeLib, "services", callbackId, convertArgsArrayToJson(arguments.ToArray()));
    } else {
      debug_log "services is only implemented for iOS";
    }
    return null;
  }

  object characteristics(Context c, object[] args)
  {
    if defined(iOS) {
      int deviceHandle = getIntArgAtIndex(args, 0, true);
      int serviceHandle = getIntArgAtIndex(args, 1, true);
      Function successCb = getFunctionArgAtIndex(args, 2, true);
      Function failureCb = getFunctionArgAtIndex(args, 3, false);

      string callbackId = RegisterCordovaCallbackClosure(c, successCb, failureCb);

      List<object> arguments = new List<object>();
      arguments.Add(deviceHandle);
      arguments.Add(serviceHandle);

      performSelector(_nativeLib, "characteristics", callbackId, convertArgsArrayToJson(arguments.ToArray()));
    } else {
      debug_log "characteristics is only implemented for iOS";
    }
    return null;
  }

  object descriptors(Context c, object[] args)
  {
    if defined(iOS) {
      int deviceHandle = getIntArgAtIndex(args, 0, true);
      int characteristicHandle = getIntArgAtIndex(args, 1, true);
      Function successCb = getFunctionArgAtIndex(args, 2, true);
      Function failureCb = getFunctionArgAtIndex(args, 3, false);

      string callbackId = RegisterCordovaCallbackClosure(c, successCb, failureCb);

      List<object> arguments = new List<object>();
      arguments.Add(deviceHandle);
      arguments.Add(characteristicHandle);

      performSelector(_nativeLib, "descriptors", callbackId, convertArgsArrayToJson(arguments.ToArray()));
    } else {
      debug_log "descriptors is only implemented for iOS";
    }
    return null;
  }

  object readCharacteristic(Context c, object[] args)
  {
    if defined(iOS) {
      int deviceHandle = getIntArgAtIndex(args, 0, true);
      int characteristicHandle = getIntArgAtIndex(args, 1, true);
      Function successCb = getFunctionArgAtIndex(args, 2, true);
      Function failureCb = getFunctionArgAtIndex(args, 3, false);

      string callbackId = RegisterCordovaCallbackClosure(c, successCb, failureCb);

      List<object> arguments = new List<object>();
      arguments.Add(deviceHandle);
      arguments.Add(characteristicHandle);

      performSelector(_nativeLib, "readCharacteristic", callbackId, convertArgsArrayToJson(arguments.ToArray()));
    } else {
      debug_log "readCharacteristic is only implemented for iOS";
    }
    return null;
  }

  object readDescriptor(Context c, object[] args)
  {
    if defined(iOS) {
      int deviceHandle = getIntArgAtIndex(args, 0, true);
      int descriptorHandle = getIntArgAtIndex(args, 1, true);
      Function successCb = getFunctionArgAtIndex(args, 2, true);
      Function failureCb = getFunctionArgAtIndex(args, 3, false);

      string callbackId = RegisterCordovaCallbackClosure(c, successCb, failureCb);

      List<object> arguments = new List<object>();
      arguments.Add(deviceHandle);
      arguments.Add(descriptorHandle);

      performSelector(_nativeLib, "readDescriptor", callbackId, convertArgsArrayToJson(arguments.ToArray()));
    } else {
      debug_log "readDescriptor is only implemented for iOS";
    }
    return null;
  }

  /* Changing this API from the original library to pass the data as a base64-encoded string */
  object writeCharacteristic(Context c, object[] args)
  {
    if defined(iOS) {
      int deviceHandle = getIntArgAtIndex(args, 0, true);
      int characteristicHandle = getIntArgAtIndex(args, 1, true);
      string data = getStringArgAtIndex(args, 2, true);
      Function successCb = getFunctionArgAtIndex(args, 3, true);
      Function failureCb = getFunctionArgAtIndex(args, 4, false);

      string callbackId = RegisterCordovaCallbackClosure(c, successCb, failureCb);

      List<object> arguments = new List<object>();
      arguments.Add(deviceHandle);
      arguments.Add(characteristicHandle);
      arguments.Add(data);

      performSelector(_nativeLib, "writeCharacteristic", callbackId, convertArgsArrayToJson(arguments.ToArray()));
    } else {
      debug_log "writeCharacteristic is only implemented for iOS";
    }
    return null;
  }

  /* Changing this API from the original library to pass the data as a base64-encoded string */
  object writeCharacteristicWithoutResponse(Context c, object[] args)
  {
    if defined(iOS) {
      int deviceHandle = getIntArgAtIndex(args, 0, true);
      int characteristicHandle = getIntArgAtIndex(args, 1, true);
      string data = getStringArgAtIndex(args, 2, true);
      Function successCb = getFunctionArgAtIndex(args, 3, true);
      Function failureCb = getFunctionArgAtIndex(args, 4, false);

      string callbackId = RegisterCordovaCallbackClosure(c, successCb, failureCb);

      List<object> arguments = new List<object>();
      arguments.Add(deviceHandle);
      arguments.Add(characteristicHandle);
      arguments.Add(data);

      performSelector(_nativeLib, "writeCharacteristicWithoutResponse", callbackId, convertArgsArrayToJson(arguments.ToArray()));
    } else {
      debug_log "writeCharacteristicWithoutResponse is only implemented for iOS";
    }
    return null;
  }

  /* Changing this API from the original library to pass the data as a base64-encoded string */
  object writeDescriptor(Context c, object[] args)
  {
    if defined(iOS) {
      int deviceHandle = getIntArgAtIndex(args, 0, true);
      int descriptorHandle = getIntArgAtIndex(args, 1, true);
      string data = getStringArgAtIndex(args, 2, true);
      Function successCb = getFunctionArgAtIndex(args, 3, true);
      Function failureCb = getFunctionArgAtIndex(args, 4, false);

      string callbackId = RegisterCordovaCallbackClosure(c, successCb, failureCb);

      List<object> arguments = new List<object>();
      arguments.Add(deviceHandle);
      arguments.Add(descriptorHandle);
      arguments.Add(data);

      performSelector(_nativeLib, "writeDescriptor", callbackId, convertArgsArrayToJson(arguments.ToArray()));
    } else {
      debug_log "writeDescriptor is only implemented for iOS";
    }
    return null;
  }

  /* Docs have an additional options argument, but it appears not to be used, so leaving it out */
  object enableNotification(Context c, object[] args)
  {
    if defined(iOS) {
      int deviceHandle = getIntArgAtIndex(args, 0, true);
      int characteristicHandle = getIntArgAtIndex(args, 1, true);
      Function successCb = getFunctionArgAtIndex(args, 2, true);
      Function failureCb = getFunctionArgAtIndex(args, 3, false);

      string callbackId = RegisterCordovaCallbackClosure(c, successCb, failureCb);

      List<object> arguments = new List<object>();
      arguments.Add(deviceHandle);
      arguments.Add(characteristicHandle);

      performSelector(_nativeLib, "enableNotification", callbackId, convertArgsArrayToJson(arguments.ToArray()));
    } else {
      debug_log "enableNotification is only implemented for iOS";
    }
    return null;
  }

  /* Docs have an additional options argument, but it appears not to be used, so leaving it out */
  object disableNotification(Context c, object[] args)
  {
    if defined(iOS) {
      int deviceHandle = getIntArgAtIndex(args, 0, true);
      int characteristicHandle = getIntArgAtIndex(args, 1, true);
      Function successCb = getFunctionArgAtIndex(args, 2, true);
      Function failureCb = getFunctionArgAtIndex(args, 3, false);

      string callbackId = RegisterCordovaCallbackClosure(c, successCb, failureCb);

      List<object> arguments = new List<object>();
      arguments.Add(deviceHandle);
      arguments.Add(characteristicHandle);

      performSelector(_nativeLib, "disableNotification", callbackId, convertArgsArrayToJson(arguments.ToArray()));
    } else {
      debug_log "disableNotification is only implemented for iOS";
    }
    return null;
  }

  object reset(Context c, object[] args)
  {
    if defined(iOS) {
      Function successCb = getFunctionArgAtIndex(args, 0, true);
      Function failureCb = getFunctionArgAtIndex(args, 1, false);

      string callbackId = RegisterCordovaCallbackClosure(c, successCb, failureCb);

      List<object> arguments = new List<object>();

      performSelector(_nativeLib, "reset", callbackId, convertArgsArrayToJson(arguments.ToArray()));
    } else {
      debug_log "reset is only implemented for iOS";
    }
    return null;
  }

}
