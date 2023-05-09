enum IosLifecycleState {
  // 即將進入前台
  willEnterForeground,

  // 進入後台
  didEnterBackground,

  // 進入活動狀態
  didBecomeActive,

  // 即將進入非活動狀態
  willResignActive,

  // 即將銷毀
  willTerminate,
}
