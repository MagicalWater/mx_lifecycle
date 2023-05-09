//
//  LifecycleState.swift
//  mx_lifecycle
//
//  Created by Magical Water on 2023/5/9.
//

import Foundation

enum LifecycleState: String {
    // 即將進入前台
    case willEnterForeground = "willEnterForeground"
    
    // 進入後台
    case didEnterBackground = "didEnterBackground"
    
    // 進入活動狀態
    case didBecomeActive = "didBecomeActive"
    
    // 即將進入非活動狀態
    case willResignActive = "willResignActive"
    
    // 即將銷毀
    case willTerminate = "willTerminate"
}
