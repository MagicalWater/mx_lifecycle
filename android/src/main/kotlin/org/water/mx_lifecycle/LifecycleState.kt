package org.water.mx_lifecycle

enum class LifecycleState(val rawValue: String) {
    // app創建
    Created("created"),

    // 進入前台
    Started("started"),

    // 進入前台開始交互
    Resumed("resumed"),

    // 進入後台
    Paused("paused"),

    // 停止
    Stopped("stopped"),

    // 被銷毀
    Destroyed("destroyed");

    companion object {
        fun fromRawValue(rawValue: String): LifecycleState? {
            return values().find { it.rawValue == rawValue }
        }
    }
}