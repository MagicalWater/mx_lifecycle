import 'package:collection/collection.dart';
import 'package:mx_lifecycle/src/android_lifecycle_state.dart';
import 'package:mx_lifecycle/src/ios_lifecycle_state.dart';

import 'mx_lifecycle_platform_interface.dart';

export 'src/android_lifecycle_state.dart';
export 'src/ios_lifecycle_state.dart';

class MxLifecycle {
  /// 當前生命週期
  String? get currentLifecycleState =>
      MxLifecyclePlatform.instance.currentLifecycleState;

  /// 生命週期狀態串流
  Stream<String> get lifecycleStateStream =>
      MxLifecyclePlatform.instance.lifecycleStateStream;

  /// 取得生命週期狀態
  Future<String?> getLifecycleState() {
    return MxLifecyclePlatform.instance.getLifecycleState();
  }

  /// 將生命週期字串轉為android的狀態
  /// [stateString] - 狀態字串, 可由以下獲得
  ///                   [currentLifecycleState] 當前狀態
  ///                   [lifecycleStateStream] 狀態串流
  ///                   [getLifecycleState] 取得最新狀態
  AndroidLifecycleState? toAndroid(String stateString) {
    return AndroidLifecycleState.values
        .firstWhereOrNull((element) => element.name == stateString);
  }

  /// 將生命週期字串轉為ios的狀態
  /// [stateString] - 狀態字串, 可由以下獲得
  ///                   [currentLifecycleState] 當前狀態
  ///                   [lifecycleStateStream] 狀態串流
  ///                   [getLifecycleState] 取得最新狀態
  IosLifecycleState? toIos(String stateString) {
    return IosLifecycleState.values
        .firstWhereOrNull((element) => element.name == stateString);
  }
}
