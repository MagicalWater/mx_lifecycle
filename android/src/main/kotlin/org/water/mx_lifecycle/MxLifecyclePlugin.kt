package org.water.mx_lifecycle

import android.app.Activity
import android.app.Application
import android.os.Bundle
import androidx.lifecycle.*
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** MxLifecyclePlugin */
class MxLifecyclePlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    private var activity: Activity? = null

    private val methodName: String = "getLifecycleState"

    // 當前的app狀態
    private var appLifecycleState: LifecycleState? = null

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == methodName) {
            result.success(appLifecycleState?.rawValue)
        } else {
            result.notImplemented()
        }
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "mx_lifecycle")
        channel.setMethodCallHandler(this)
        registerLifecycleCallback()
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    // 註冊app生命週期回調
    private fun registerLifecycleCallback() {
        ProcessLifecycleOwner.get().lifecycle.addObserver(object : LifecycleEventObserver {
            override fun onStateChanged(source: LifecycleOwner, event: Lifecycle.Event) {
                when (event) {
                    Lifecycle.Event.ON_CREATE -> {
                        // app創建
                        appLifecycleState = LifecycleState.Created
                        invokeLifecycleCallback()
                    }
                    Lifecycle.Event.ON_START -> {
                        // 進入前台
                        appLifecycleState = LifecycleState.Started
                        invokeLifecycleCallback()
                    }
                    Lifecycle.Event.ON_RESUME -> {
                        // 進入前台開始交互
                        appLifecycleState = LifecycleState.Resumed
                        invokeLifecycleCallback()
                    }
                    Lifecycle.Event.ON_PAUSE -> {
                        // 進入後台
                        appLifecycleState = LifecycleState.Paused
                        invokeLifecycleCallback()
                    }
                    Lifecycle.Event.ON_STOP -> {
                        // 停止
                        appLifecycleState = LifecycleState.Stopped
                        invokeLifecycleCallback()
                    }
                    Lifecycle.Event.ON_DESTROY -> {
                        // 被銷毀
                        appLifecycleState = LifecycleState.Destroyed
                        invokeLifecycleCallback()
                    }
                    Lifecycle.Event.ON_ANY -> {
                        // 任何事件都會匹配?
                        printLog("生命週期的任意事件")
                    }
                }
            }
        })
    }

    private fun invokeLifecycleCallback() {
        channel.invokeMethod(methodName, mapOf("state" to appLifecycleState?.rawValue))
    }

    private fun printLog(content: String) {
        channel.invokeMethod("printLog", mapOf("content" to content))
    }
}
