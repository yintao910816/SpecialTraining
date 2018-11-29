//
//  AppNotifications.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/7/18.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import Foundation

typealias NotificationName = Notification.Name

extension Notification.Name {
    
    public struct EaseMob {
        // 环信账号登录状态改变
        public static let LoginStateChange = Notification.Name(rawValue: "org.easeMob.notification.name.loginStateChange")
        
        // 收到新消息
        public static let ReceivedNewMessage = Notification.Name(rawValue: "org.easeMob.notification.name.receivedNewMessage")
        
        // 会话列表发生变化
        public static let ConversationListChange = Notification.Name(rawValue: "org.easeMob.notification.name.conversationListChange")
    }
    
    // 播放语音状态
    public struct AudioPlayState {
        // 语音播放完成
        public static let AudioPlayFinish = Notification.Name(rawValue: "org.audioPlay.notification.name.audioPlayFinish")
        // 聊天室点击语音播放
        public static let AudioPlayStart = Notification.Name(rawValue: "org.audioPlay.notification.name.audioPlayStart")
        // 聊天室停止语音播放
        public static let AudioPlayStop = Notification.Name(rawValue: "org.audioPlay.notification.name.audioPlayStop")
    }
    
    public struct BMK {
        // 地图界面选择当前位置更新首页位置
        public static let RefreshHomeLocation = Notification.Name(rawValue: "org.bmk.notification.name.refreshHomeLocation")
        // 启动app获取完经纬度加载首页数据
        public static let LoadHomeData = Notification.Name(rawValue: "org.bmk.notification.name.loadHomeData")
    }
    
}
