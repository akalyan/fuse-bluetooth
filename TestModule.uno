using Fuse;
using Fuse.Scripting;
using Fuse.Reactive;
using Uno.UX;
using Uno.Compiler.ExportTargetInterop;
using Uno;
using Uno.Collections;

[Require("Xcode.Framework","Foundation.framework")]
[ForeignInclude(Language.ObjC, "TestNativeLib.h")]

[UXGlobalModule]
public class TestModule : NativeModule
{
  static readonly TestModule _instance;
  extern(iOS) ObjC.Object _nativeLib;
  Dictionary<string, Dictionary<string, object>> _contextCallbackMap;
  // { callbackId => { context => Context, callback => Function }

  public TestModule()
  {
    if(_instance != null)
      return;

    _instance = this;
    Resource.SetGlobalKey(_instance, "Test");
    AddMember(new NativeFunction("getStatus", (NativeCallback)getStatus));
    _contextCallbackMap = new Dictionary<string, Dictionary<string, object>>();

    if defined(iOS)
    {
      _nativeLib = AllocNativeLib();
      registerCommandDelegate(_nativeLib, commandDelegate);
    }
  }

  [Foreign(Language.ObjC)]
  extern(iOS)
  ObjC.Object AllocNativeLib()
  @{
    return [[TestNativeLib alloc] init];
  @}

  extern(iOS)
  void commandDelegate(string result) {
    debug_log("Got a result from command delegate");
    debug_log(result);
  }

  [Foreign(Language.ObjC)]
  extern(iOS)
  public void registerCommandDelegate(ObjC.Object nativeLib, Action<string> cb)
  @{
    [(TestNativeLib *)nativeLib registerCommandDelegate:cb];
    NSLog(@"%@", @"Hi!");
    cb(@"Testing");
  @}

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

  class CallbackClosure
  {
    Function _callback;
    string _arg;
    public CallbackClosure(Function callback, string arg)
    {
      _callback = callback;
      _arg = arg;
    }
    public void Call()
    {
      _callback.Call(_arg);
    }
  }

  class ContextCallbackClosure
  {
    public Context context;
    Function _callback;
    string _arg;
    public ContextCallbackClosure(Context c, Function callback)
    {
      context = c;
      _callback = callback;
    }
    public void SetArg(string arg)
    {
      _arg = arg;
    }
    public void Call()
    {
      _callback.Call(_arg);
    }
  }

  class InvokeClosure
  {
    Function _callback;
    string _arg;
    public InvokeClosure(Function callback, string arg)
    {
      _callback = callback;
      _arg = arg;
    }
    public void Call()
    {
      _callback.Call(_arg);
    }
  }

  class CallbackClosure1
  {
    Function _callback;
    string _arg;
    public CallbackClosure1(Function callback)
    {
      _callback = callback;
    }
    public void SetArg(string arg)
    {
      _arg = arg;
    }
    public void Call()
    {
      _callback.Call(_arg);
    }
  }

  void RegisterCallbackClosure(string callbackId, Context c, Function fn)
  {
    debug_log("Adding " + callbackId + " to closure map");
    Dictionary<string, object> callbackMap = new Dictionary<string, object>();
    callbackMap.Add("context", c);
    callbackMap.Add("callback", fn);
    _contextCallbackMap.Add(callbackId, callbackMap);
  }

  void InvokeCallbackClosure(string callbackId, string arg)
  {
    Dictionary<string, object> callbackMap = _contextCallbackMap[callbackId];
    if (callbackMap != null)
    {
      Context context = callbackMap["context"] as Context;
      Function callback = callbackMap["callback"] as Function;

      if (context != null && callback != null)
      {
        context.Dispatcher.Invoke(new InvokeClosure(callback, arg).Call);
      }
    }
  }

  void InvokeCallback(Context c, Function cb, string arg)
  {
    CallbackClosure1 cc = new CallbackClosure1(cb);
    cc.SetArg(arg);
    c.Dispatcher.Invoke(cc.Call);
    c.ProcessUIMessages();
  }

  object getStatus(Context c, object[] args)
  {
    if defined(iOS) {
      Function successCb = args[0] as Function;
      string uuid = GetUUID();
      RegisterCallbackClosure(uuid, c, successCb);
      _getStatus(uuid);    // did not work
      // c.Dispatcher.Invoke(new CallbackClosure(successCb, "Hello from dispatcher").Call);     // success!!
      // InvokeCallback(c, successCb, "Hello from dispatcher again!");    // success
      // InvokeCallbackClosure(uuid, "Hello from mapped closure");
      // InvokeCallbackClosure(uuid, "Hello from mapped closure again");
      return null;
    } else {
      debug_log "getStatus is only implemented for iOS";
      return null;
    }
  }

  [Foreign(Language.ObjC)]
  extern(iOS)
  public void _getStatus(string uuid)
  @{
    @{TestModule:Of(_this).InvokeCallbackClosure(string, string):Call(uuid, @"Hello from native land!")};
    @{TestModule:Of(_this).InvokeCallbackClosure(string, string):Call(uuid, @"Hello from native land one more time!")};
  @}

  [Foreign(Language.Java)]
  extern(android)
  public static string GetUUID()
  @{
      return UUID.randomUUID().toString();
  @}

  [Foreign(Language.ObjC)]
  extern(iOS)
  public static string GetUUID()
  @{
      NSString *uuid = [[NSUUID UUID] UUIDString];
      return uuid;
  @}

}
