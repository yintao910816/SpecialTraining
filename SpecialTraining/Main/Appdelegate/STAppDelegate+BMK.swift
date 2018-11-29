//
//  STAppDelegate+BMK.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/21.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import Foundation

extension STAppDelegate: BMKGeneralDelegate {
    
    func baiduMapConfig(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        BMKLocationAuth.sharedInstance()?.checkPermision(withKey: bmkAK, authDelegate: nil)
        
        // 要使用百度地图，请先启动BaiduMapManager
        let mapManager = BMKMapManager()
        /**
         *百度地图SDK所有接口均支持百度坐标（BD09）和国测局坐标（GCJ02），用此方法设置您使用的坐标类型.
         *默认是BD09（BMK_COORDTYPE_BD09LL）坐标.
         *如果需要使用GCJ02坐标，需要设置CoordinateType为：BMK_COORDTYPE_COMMON.
         */
        if BMKMapManager.setCoordinateTypeUsedInBaiduMapSDK(BMK_COORD_TYPE.COORDTYPE_BD09LL) {
            NSLog("经纬度类型设置成功");
        } else {
            NSLog("经纬度类型设置失败");
        }
        
        // 如果要关注网络及授权验证事件，请设定generalDelegate参数
        let ret = mapManager.start(bmkAK, generalDelegate: self)
        if ret == false {
            NSLog("manager start failed!")
        }
    }
        
    //MARK: - BMKGeneralDelegate
    func onGetNetworkState(_ iError: Int32) {
        if (0 == iError) {
            NSLog("联网成功");
        }
        else{
            NSLog("联网失败，错误代码：Error\(iError)");
        }
    }
    
    func onGetPermissionState(_ iError: Int32) {
        if (0 == iError) {
            NSLog("授权成功");
            BMKLocationHelper.share.userLocation()
        }
        else{
            NSLog("授权失败，错误代码：Error\(iError)");
        }
    }

}
