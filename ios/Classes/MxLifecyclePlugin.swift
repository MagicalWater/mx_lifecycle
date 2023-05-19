import Flutter
import UIKit

public class MxLifecyclePlugin: NSObject, FlutterPlugin {
    
    private var channel: FlutterMethodChannel
    
    private let methodGetLifecycleState: String = "getLifecycleState"
    private let methodFlutterDetached: String = "flutterDetached"
    
    // 當前的app狀態
    private var appLifecycleState: LifecycleState? = nil
    
    // flutter engine是否已停止
    var isFlutterDetached: Bool = false
    
    init(channel: FlutterMethodChannel) {
        self.channel = channel
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        
        let channel = FlutterMethodChannel(name: "mx_lifecycle", binaryMessenger: registrar.messenger())
        let instance = MxLifecyclePlugin(channel: channel)
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        // 註冊生命週期回調
        instance._listenLifecycle()
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let method = call.method
        if (method == methodGetLifecycleState) {
            result(appLifecycleState?.rawValue)
        } else if (method == methodFlutterDetached) {
            isFlutterDetached = true
            result(nil)
        } else {
            result(nil)
        }
    }
    
    // 註冊生命週期回調
    func _listenLifecycle() {
        let center = NotificationCenter.default
        
        // 即將進入前景
        center.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        // 進入背景
        center.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        // 進入活動狀態
        center.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        // 即將進入非活動狀態
        center.addObserver(self, selector: #selector(appWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        
        // 即將終止
        center.addObserver(self, selector: #selector(appWillTerminate), name: UIApplication.willTerminateNotification, object: nil)
    }
    
    // 進入活動狀態
    @objc func appDidBecomeActive() {
        print("app進入活動狀態")
        appLifecycleState = LifecycleState.didBecomeActive
        invokeLifecycleCallback()
    }
    
    // 即將進入非活動狀態
    @objc func appWillResignActive() {
        print("app即將進入非活動狀態")
        appLifecycleState = LifecycleState.willResignActive
        invokeLifecycleCallback()
    }
    
    // 即將進入前景
    @objc func appWillEnterForeground() {
        print("app即將進入前景")
        appLifecycleState = LifecycleState.willEnterForeground
        invokeLifecycleCallback()
    }
    
    // 進入背景
    @objc func appDidEnterBackground() {
        print("app進入背景")
        appLifecycleState = LifecycleState.didEnterBackground
        invokeLifecycleCallback()
    }
    
    // 即將終止
    @objc func appWillTerminate() {
        print("app即將終止")
        appLifecycleState = LifecycleState.willTerminate
        
        // 此狀態下app不可再傳送消息給flutter, 因此不傳送
        //        invokeLifecycleCallback()
    }
    
    private func invokeLifecycleCallback() {
        guard let appDelegate = UIApplication.shared.delegate as? FlutterAppDelegate else {
            return
        }
        
        guard let window = appDelegate.window else {
            return
        }
        
        guard let flutterViewController = window.rootViewController as? FlutterViewController else {
            return
        }
        
        guard flutterViewController.engine != nil else {
            return
        }
        
        if (isFlutterDetached) {
            print("[MxLifecyclePlugin] Flutter Engine已離線, 不可傳送消息")
            return
        }
        
        channel.invokeMethod(methodGetLifecycleState, arguments: ["state" : appLifecycleState?.rawValue])
    }
}
