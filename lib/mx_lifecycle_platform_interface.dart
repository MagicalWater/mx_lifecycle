import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'mx_lifecycle_method_channel.dart';

abstract class MxLifecyclePlatform extends PlatformInterface {
  /// Constructs a MxLifecyclePlatform.
  MxLifecyclePlatform() : super(token: _token);

  static final Object _token = Object();

  static MxLifecyclePlatform _instance = MethodChannelMxLifecycle();

  /// The default instance of [MxLifecyclePlatform] to use.
  ///
  /// Defaults to [MethodChannelMxLifecycle].
  static MxLifecyclePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MxLifecyclePlatform] when
  /// they register themselves.
  static set instance(MxLifecyclePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// 當前生命週期
  String? get currentLifecycleState;

  /// 生命週期狀態串流
  Stream<String> get lifecycleStateStream;

  Future<String?> getLifecycleState() {
    throw UnimplementedError('getLifecycleState() has not been implemented.');
  }
}
