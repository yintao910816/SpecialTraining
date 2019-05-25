//
//  STMapViewController.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/21.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class STMapViewController: BaseViewController {

    var locationManager: BMKLocationManager!
        
    var mapView: BMKMapView!
    
    var lockedScreenAnnotation: BMKPointAnnotation!
    
    var userLocation: BMKUserLocation!
    
    private var coor: CLLocationCoordinate2D?
    
    @IBAction func actions(_ sender: UIButton) {
        switch sender.tag {
        case 200:
            creatMapView()
        case 202:
            PrintLog(mapView.convert(mapView.center, toCoordinateFrom: mapView))
        default:
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView.viewWillAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if navigationController?.viewControllers.contains(self) == false {
            locationManager.delegate = nil
            mapView.delegate = nil
            mapView.viewWillDisappear()
        }
    }
    
    override func setupUI() {
        addBarItem(title: "确定", titleColor: ST_MAIN_COLOR, right: true)
            .drive(onNext: { [unowned self] in
                let coordinate = self.mapView.convert(self.mapView.center, toCoordinateFrom: self.mapView)
                NotificationCenter.default.post(name: NotificationName.BMK.RefreshHomeLocation, object: coordinate)
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

        locationManager = BMKLocationManager()
        locationManager.delegate = self
        locationManager.coordinateType = BMKLocationCoordinateType.BMK09LL
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = CLActivityType.automotiveNavigation
        locationManager.locationTimeout = 10
        locationManager.allowsBackgroundLocationUpdates = false
        
        userLocation = BMKUserLocation()
        
        creatMapView()
    }
    
    override func rxBind() {

    }
    
    private func creatMapView() {
        if mapView != nil {
            mapView.removeFromSuperview()
            mapView.delegate = nil
            mapView = nil
        }
        
        mapView = BMKMapView.init()
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.userTrackingMode = BMKUserTrackingModeFollow
        mapView.zoomLevel = 15
        mapView.showsUserLocation = true
        mapView.delegate = self
        view.addSubview(mapView!)
        
        mapView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
        
        locationManager.startUpdatingLocation()
        
        view.bringSubviewToFront(view.viewWithTag(200)!)
        view.bringSubviewToFront(view.viewWithTag(201)!)
    }
    
    //添加固定屏幕位置的标注
    private func addLockScreenAnnotation() {
        if lockedScreenAnnotation == nil {
            lockedScreenAnnotation = BMKPointAnnotation()
            lockedScreenAnnotation?.isLockedToScreen = true
            lockedScreenAnnotation?.screenPointToLock = mapView.center
//            lockedScreenAnnotation?.title = "我是固定屏幕的标注"
        }
        mapView.addAnnotation(lockedScreenAnnotation)
        
        // 添加一个标注
        if let _coor = coor {
            let annotation = BMKPointAnnotation()
//            annotation.isLockedToScreen = false
            annotation.coordinate = _coor
            mapView.addAnnotation(annotation)
            mapView.selectAnnotation(annotation, animated: true)
        }
    }
    
    override func prepare(parameters: [String : Any]?) {
        if let lat = parameters?["lat"] as? Double,
            let lng = parameters?["lng"] as? Double{
            coor = CLLocationCoordinate2D.init(latitude: lat, longitude: lng)
            PrintLog("店铺坐标：lat -- \(lat) -- lng -- \(lng)")
        }
    }
}

extension STMapViewController: BMKMapViewDelegate {
    
    // MARK: - BMKMapViewDelegate
    
    /**
     *地图初始化完毕时会调用此接口
     *@param mapview 地图View
     */
    func mapViewDidFinishLoading(_ mapView: BMKMapView!) {
        addLockScreenAnnotation()
    }

}

extension STMapViewController: BMKLocationManagerDelegate {

    func bmkLocationManager(_ manager: BMKLocationManager, didUpdate location: BMKLocation?, orError error: Error?) {
        if let temError = error {
            PrintLog("locError:{\(temError.localizedDescription)}")
        }

        if let temLocation = location {
            userLocation.location = temLocation.location;
            mapView.updateLocationData(userLocation)

            locationManager.stopUpdatingLocation()
        }
    }

}
