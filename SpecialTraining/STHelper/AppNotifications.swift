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
        /// 环信账号登录状态改变
        public static let LoginStateChange = Notification.Name(rawValue: "org.easeMob.notification.name.loginStateChange")
        
        /// 收到新消息
        public static let ReceivedNewMessage = Notification.Name(rawValue: "org.easeMob.notification.name.receivedNewMessage")
        
        /// 会话列表发生变化
        public static let ConversationListChange = Notification.Name(rawValue: "org.easeMob.notification.name.conversationListChange")
    }
    
    // 播放语音状态
    public struct AudioPlayState {
        /// 语音播放完成
        public static let AudioPlayFinish = Notification.Name(rawValue: "org.audioPlay.notification.name.audioPlayFinish")
        /// 聊天室点击语音播放
        public static let AudioPlayStart = Notification.Name(rawValue: "org.audioPlay.notification.name.audioPlayStart")
        /// 聊天室停止语音播放
        public static let AudioPlayStop = Notification.Name(rawValue: "org.audioPlay.notification.name.audioPlayStop")
    }
    
    public struct BMK {
        /// 地图界面选择当前位置更新首页位置
        public static let RefreshHomeLocation = Notification.Name(rawValue: "org.bmk.notification.name.refreshHomeLocation")
        /// 启动app获取完经纬度加载首页数据
        public static let LoadHomeData = Notification.Name(rawValue: "org.bmk.notification.name.loadHomeData")
        /// 百度API启动失败
        public static let BMKSetupFail = Notification.Name(rawValue: "org.bmk.notification.name.BMKSetupFail")
    }
    
    public struct WX {
        /// 微信授权登录 获取code进行登录
        public static let WXAuthLogin = Notification.Name(rawValue: "org.bmk.notification.name.WXAuthLogin")
        
        public static let WXPay = Notification.Name(rawValue: "org.bmk.notification.name.payResult")
    }
    
    public struct AliPay {
        public static let aliPayBack = Notification.Name(rawValue: "org.bmk.notification.name.aliPayBack")
    }
    
    public struct Order {
        /// 添加课程到购物车购物车
        public static let AddOrder = Notification.Name(rawValue: "org.bmk.notification.name.AddOrder")
    }
    
    public struct PublishVideo {
        /// 发布界面选择了分类
        public static let ChooseClassifications = Notification.Name(rawValue: "org.bmk.notification.name.ChooseClassifications")
    }
}
