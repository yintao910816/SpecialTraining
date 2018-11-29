//
//  BMKMapHelper.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/21.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import Foundation
import RxSwift

class BMKLocationHelper: NSObject, BMKLocationManagerDelegate {
    
    static let share = BMKLocationHelper()
    
    private var locationManager: BMKLocationManager!
    
    override init() {
        super.init()
        
        locationManager = BMKLocationManager()
        locationManager.coordinateType = BMKLocationCoordinateType.BMK09LL
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = CLActivityType.automotiveNavigation
        locationManager.locationTimeout = 10
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    func userLocation() {
        locationManager.delegate = self

        locationManager.startUpdatingLocation()
    }
    
    func bmkLocationManager(_ manager: BMKLocationManager, didUpdate location: BMKLocation?, orError error: Error?) {
       
        if error != nil {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            NotificationCenter.default.post(name: NotificationName.BMK.LoadHomeData,
                                            object: nil)
            return
        }
        
        //获取经纬度和该定位点对应的位置信息
        if let l = location, let coordinate = l.location?.coordinate {
            userDefault.lat = coordinate.latitude
            userDefault.lng = coordinate.longitude
            
            NotificationCenter.default.post(name: NotificationName.BMK.LoadHomeData,
                                            object: nil)
            
            NotificationCenter.default.post(name: NotificationName.BMK.RefreshHomeLocation,
                                            object: coordinate)
        }
        
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
    }
}

class BMKGeoCodeSearchHelper: NSObject, BMKGeoCodeSearchDelegate {
    
    static let share = BMKGeoCodeSearchHelper()
    
    public let reverseGeoObser = PublishSubject<(BMKReverseGeoCodeSearchResult, Bool, String?)>()

    private var searcher: BMKGeoCodeSearch!
    
    override init() {
        super.init()
        
        searcher = BMKGeoCodeSearch.init()
    }
    
    func startReverseGeoCode(coordinate: CLLocationCoordinate2D) {

        searcher.delegate = self
        let reverseGeoCodeSearchOption = BMKReverseGeoCodeSearchOption.init()
        reverseGeoCodeSearchOption.location = coordinate
        
        if searcher.reverseGeoCode(reverseGeoCodeSearchOption) {
           PrintLog("逆geo检索发送成功")
        }else {
            PrintLog("逆geo检索发送失败")
        }
    }
    
    func onGetReverseGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeSearchResult!, errorCode error: BMKSearchErrorCode) {
        
        if error == BMK_SEARCH_NO_ERROR {
            reverseGeoObser.onNext((result, true, nil))
        }else {
            PrintLog("检索失败")
            reverseGeoObser.onNext((result, false, "检索失败"))
            
            searcher.delegate = nil
        }
    }
}


