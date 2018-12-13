//
//  BXBClientNearVC.swift
//  BXB
//
//  Created by equalriver on 2018/7/17.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit
import ObjectMapper


class BXBClientNearVC: BXBBaseNavigationVC {
    
    var dataArr = Array<ClientNearData>()
    
    lazy var mapView: MAMapView = {
        let v = MAMapView.init()
        v.delegate = self
        v.zoomLevel = 14
        v.showsScale = true
        v.showsCompass = true
        v.showsUserLocation = true
        v.userTrackingMode = .follow
        return v
    }()
    lazy var alertView: BXBClientNearAlertView = {
        let v = BXBClientNearAlertView.init(frame: CGRect.init(x: 0, y: kScreenHeight, width: kScreenWidth, height: 210 * KScreenRatio_6 + kIphoneXBottomInsetHeight))
        v.delegate = self
        return v
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
        mapView.snp.makeConstraints { (make) in
            make.top.equalTo(naviBar.snp.bottom)
            make.bottom.width.centerX.equalTo(view)
        }
        title = "附近的客户"

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
    
    //MARK: - action
    
    func loadData() {
        guard mapView.userLocation.location != nil else {
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
                self.loadData()
            }
            return
        }
        let lat = mapView.userLocation.location!.coordinate.latitude
        let lng = mapView.userLocation.location!.coordinate.longitude
        
        BXBNetworkTool.BXBRequest(router: .nearClient(lat: "\(lat)", lng: "\(lng)"), success: { (resp) in
            
            if let d = Mapper<ClientNearData>().mapArray(JSONObject: resp["data"].arrayObject){
                self.dataArr = d
                for item in d {
                    let annotation = MAPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D.init(latitude: Double(item.latitude)!, longitude: Double(item.longitude)!)
                    annotation.title = item.name
                    self.mapView.addAnnotation(annotation)
                }
            }
            
        }) { (error) in
            self.view.makeToast("定位失败")
        }
    }
}

extension BXBClientNearVC: MAMapViewDelegate {
    
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation.isKind(of: MAUserLocation.self) {
            return nil
        }
        if annotation.isKind(of: MAPointAnnotation.self) {
            let pointReuseIndetifier = "pointReuseIndetifier"
            var annotationView: BXBClientNearCalloutView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as? BXBClientNearCalloutView
            
            if annotationView == nil {
                annotationView = BXBClientNearCalloutView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            }
            annotationView?.delegate = self
            annotationView!.canShowCallout = false // 设置为NO，用以调用自定义的calloutView
            //            annotationView!.animatesDrop = true //设置标注动画显示，默认为NO
            annotationView!.isDraggable = true //设置标注可以拖动，默认为NO
            
            //            annotationView!.pinColor = .red
            //设置中心点偏移，使得标注底部中间点成为经纬度对应点
            annotationView!.centerOffset = CGPoint.init(x: 0, y: -18)
            
//            annotationView?.callout.titleLabel.text = annotation.title
            return annotationView!
        }
        return nil
    }
    
}

//MARK: - 点击气泡
extension BXBClientNearVC: ClientNearCalloutViewDelegate {
    
    func didTapCalloutView(annotationView: MAAnnotationView) {
        guard annotationView.annotation.title != nil else { return }
        
        mapView.setCenter(annotationView.annotation.coordinate, animated: true)
        alertView.removeFromSuperview()
        
        for item in dataArr {
            if item.name == annotationView.annotation.title {
                alertView.data = item
                view.addSubview(alertView)
            }
        }
    }
    
}

//MARK: - alert view
extension BXBClientNearVC: ClientNearAlertDelegate {
    
    //打电话
    func didClickPhone(phone: String) {
        
        if phone.isPhoneNumber == false {
            self.view.makeToast("未设置电话或电话信息有误")
            return
        }
        let alert = UIAlertController.init(title: nil, message: "是否拨打联系电话?", preferredStyle: .alert)
        let action = UIAlertAction.init(title: "是", style: .default, handler: { (ac) in
            guard URL.init(string: "telprompt:\(phone)") != nil else {
                self.view.makeToast("未设置电话或电话信息有误")
                return
            }
            if UIApplication.shared.canOpenURL(URL.init(string: "telprompt:\(phone)")!){
                UIApplication.shared.openURL(URL.init(string: "telprompt:\(phone)")!)
            }
        })
        let cancel = UIAlertAction.init(title: "否", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //导航
    func didClickLocation(data: ClientNearData) {
        guard Double(data.latitude) != nil && Double(data.longitude) != nil else {
            view.makeToast("无效的位置信息")
            return
        }
        
        var maps = ["苹果地图" : ""]
        if UIApplication.shared.canOpenURL(URL.init(string: "baidumap://")!) {
            maps["百度地图"] = "baidumap://map/direction?origin={{我的位置}}&destination=latlng:\(data.latitude),\(data.longitude)|name=目的地&mode=driving&coord_type=gcj02"
        }
        if UIApplication.shared.canOpenURL(URL.init(string: "iosamap://")!) {
            maps["高德地图"] = "iosamap://navi?sourceApplication= &backScheme= &lat=\(data.latitude)&lon=\(data.longitude)&dev=0&style=2"
        }
        if UIApplication.shared.canOpenURL(URL.init(string: "comgooglemaps://")!) {
            maps["谷歌地图"] = "comgooglemaps://?saddr=&daddr=\(data.latitude),\(data.longitude)&directionsmode=walking"
        }
        if UIApplication.shared.canOpenURL(URL.init(string: "qqmap://")!) {
            maps["腾讯地图"] = "qqmap://map/routeplan?from=我的位置&type=drive&tocoord=\(data.latitude),\(data.longitude)&to=终点&coord_type=1&policy=0"
        }
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        for (k, v) in maps {
            let action = UIAlertAction.init(title: k, style: .default) { (ac) in
                if k == "苹果地图" { self.localMap(data: data) }
                else {
                    if let url = URL.init(string: v.URL_UTF8_string) {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
            alert.addAction(action)
        }
        let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        alert.addAction(cancel)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func localMap(data: ClientNearData) {
        guard data.latitude.count > 0 && data.longitude.count > 0 else { return }
        let coor = CLLocationCoordinate2D.init(latitude: Double(data.latitude)!, longitude: Double(data.longitude)!)
        let current = MKMapItem.forCurrentLocation()
        let toLocation = MKMapItem.init(placemark: MKPlacemark.init(coordinate: coor, addressDictionary: nil))
        
        MKMapItem.openMaps(with: [current, toLocation], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsShowsTrafficKey: true])
    }
    
    //新建日程
    func didClickAddNewAgenda(data: ClientNearData) {
        
        guard data.name.count > 0 else { return }
        if let t = UIApplication.shared.keyWindow?.rootViewController {
            
            if t.isKind(of: BXBTabBarController.self) {
                let tab = t as! BXBTabBarController
                tab.selectedIndex = 1
                NotificationCenter.default.post(name: .kNotiAddNewAgendaByOtherController, object: nil, userInfo: ["ClientNearData": data])
                self.navigationController?.popToRootViewController(animated: false)
//                let alert = UIAlertController.init(title: "是否返回首页新建日程?", message: nil, preferredStyle: .alert)
//
//                let action = UIAlertAction.init(title: "是", style: .default) { (ac) in
//                    let tab = t as! BXBTabBarController
//                    tab.selectedIndex = 1
//                    NotificationCenter.default.post(name: NSNotification.Name.init(kNotiAddNewAgendaByOtherController), object: nil, userInfo: ["ClientNearData": data])
//                    self.navigationController?.popToRootViewController(animated: true)
//                }
//                let cancel = UIAlertAction.init(title: "否", style: .cancel, handler: nil)
//
//                alert.addAction(action)
//                alert.addAction(cancel)
//
//                DispatchQueue.main.async {
//                    self.present(alert, animated: true, completion: nil)
//                }
                
            }
        }
        
    }
}

















