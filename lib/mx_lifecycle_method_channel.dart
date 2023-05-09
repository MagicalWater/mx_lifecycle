import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'mx_lifecycle_platform_interface.dart';

/// An implementation of [MxLifecyclePlatform] that uses method channels.
class MethodChannelMxLifecycle extends MxLifecyclePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('mx_lifecycle');

  MethodChannelMxLifecycle() {
    methodChannel.setMethodCallHandler(_onMethodCall);
  }

  /// 當前生命週期
  @override
  String? get currentLifecycleState => _currentLifecycleState;

  String? _currentLifecycleState;

  /// 生命週期狀態串流
  @override
  Stream<String> get lifecycleStateStream {
    return _lifecycleStateBroadcastStream ??=
        _lifecycleStateStreamController.stream.asBroadcastStream();
  }

  Stream<String>? _lifecycleStateBroadcastStream;
  final _lifecycleStateStreamController = StreamController<String>();

  @override
  Future<String?> getLifecycleState() async {
    return await methodChannel.invokeMethod<String?>('getLifecycleState');
  }

  /// Handle incoming message from platforms (iOS and Android)
  Future<dynamic> _onMethodCall(final MethodCall call) async {
    final method = call.method;
    switch (method) {
      case 'getLifecycleState':
        final state = call.arguments?['state'] as String;
        _currentLifecycleState = state;
        _lifecycleStateStreamController.add(state);
        // print('生命週期: $state');
        break;
      default:
        if (kDebugMode) {
          print('[MxLifecycle] ${call.arguments}');
        }
        break;
    }
  }
}
