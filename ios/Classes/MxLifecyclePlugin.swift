import Flutter
import UIKit

public class MxLifecyclePlugin: NSObject, FlutterPlugin {
    
    private var channel: FlutterMethodChannel
    
    private let methodName: String = "getLifecycleState"
    
    // 當前的app狀態
    private var appLifecycleState: LifecycleState? = nil
    
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
        if (method == methodName) {
            result(appLifecycleState?.rawValue)
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
        invokeLifecycleCallback()
    }
    
    private func invokeLifecycleCallback() {
        if (isFlutterRunning()) {
            channel.invokeMethod(methodName, arguments: ["state" : appLifecycleState?.rawValue])
        } else {
            print("flutter framework 已不再運行中")
        }
    }
    
    // 檢測 Flutter Framework 是否正常運行的方法
    func isFlutterRunning() -> Bool {
        if #available(iOS 13.0, *) {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first else {
                return false
            }
            guard let flutterViewController = window.rootViewController as? FlutterViewController else {
                return false
            }

            guard flutterViewController.engine != nil else {
                return false
            }
        } else {
            // Fallback on earlier versions
            guard let appDelegate = UIApplication.shared.delegate else {
                return false
            }
            
            guard let window = appDelegate.window as? UIWindow else {
                return false
            }

            guard let flutterViewController = window.rootViewController as? FlutterViewController else {
                return false
            }

            guard flutterViewController.engine != nil else {
                return false
            }
        }

        
        return true
    }
}
