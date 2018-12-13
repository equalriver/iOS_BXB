//
//  SelectedLocationDelegate.swift
//  BXB
//
//  Created by equalriver on 2018/8/13.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation

//MARK: - map delegate
extension BXBSelectedLocationVC: MAMapViewDelegate {
    /*
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation.isKind(of: MAUserLocation.self) {
            return nil
        }
        if annotation.isKind(of: MAPointAnnotation.self) {
            let pointReuseIndetifier = "pointReuseIndetifier"
            var annotationView: BXBMapCalloutView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as? BXBMapCalloutView
            
            if annotationView == nil {
                annotationView = BXBMapCalloutView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            }
            annotationView?.delegate = self
            annotationView!.canShowCallout = false // 设置为NO，用以调用自定义的calloutView
            //            annotationView!.animatesDrop = true //设置标注动画显示，默认为NO
            annotationView!.isDraggable = true //设置标注可以拖动，默认为NO
            
            //            annotationView!.pinColor = .red
            //设置中心点偏移，使得标注底部中间点成为经纬度对应点
            annotationView!.centerOffset = CGPoint.init(x: 0, y: -18)
            
            annotationView?.callout.titleLabel.text = annotation.title
            return annotationView!
        }
        return nil
    }
    
    //单击
    func mapView(_ mapView: MAMapView!, didSingleTappedAt coordinate: CLLocationCoordinate2D) {
        
        selectedCoordinate = coordinate
        
        let ap = AMapGeoPoint()
        ap.latitude = CGFloat(coordinate.latitude)
        ap.longitude = CGFloat(coordinate.longitude)
        reGeocodeReq.location = ap
        searchAPI.aMapReGoecodeSearch(reGeocodeReq)
        
    }
    
    //长按地图
    //    func mapView(_ mapView: MAMapView!, didLongPressedAt coordinate: CLLocationCoordinate2D) {
    //
    //    }
    */
    //地图区域改变完成
    func mapView(_ mapView: MAMapView!, regionDidChangeAnimated animated: Bool) {
        if mapView.userLocation.location != nil {
            
            let centerCoor = mapView.region.center
            
            reGeocodeReq.location = AMapGeoPoint.location(withLatitude: CGFloat(centerCoor.latitude), longitude: CGFloat(centerCoor.longitude))
            searchAPI.aMapReGoecodeSearch(reGeocodeReq)
            
            nearSearchReq.location = AMapGeoPoint.location(withLatitude: CGFloat(centerCoor.latitude), longitude: CGFloat(centerCoor.longitude))
            searchAPI.aMapPOIAroundSearch(nearSearchReq)
        }
    }
    
}

//MARK: - map search delegate
extension BXBSelectedLocationVC: AMapSearchDelegate {
    
    //poi搜索
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        SVProgressHUD.dismiss()
        
        guard response != nil else { return }
        if response.count == 0 {
            view.makeToast("无定位信息")
            return
        }
       
        self.mapView.userTrackingMode = .none
        pinAnimation()
        
        addressArr.removeAll()
        addressArr = response.pois

        //从搜索结果点击过来
        if clickSearchData != nil {
            
            let obj = AMapPOI()
            obj.address = clickSearchData!.address
            obj.name = clickSearchData!.name
            obj.adcode = clickSearchData!.adcode
            obj.district = clickSearchData!.district
            obj.uid = clickSearchData!.uid
            obj.location = clickSearchData!.location
            addressArr.insert(obj, at: 0)
            clickSearchData = nil
        }
        
        //第一次带位置参数加载
        if currentLocation != nil && isFirstLoadLocationList == true {
            isFirstLoadLocationList = false
            if let obj = addressArr.first {
                if obj.name != currentLocation!.name { addressArr.insert(currentLocation!, at: 0) }
            }
        }

        locationTV.reloadData()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.locationTV.endUpdates()
            if self.isClickList == false {
                self.locationTV.scroll(toRow: 0, inSection: 0, at: .top, animated: true)
            }
            else {
                self.isClickList = false
            }
        }

    }
    
    func onInputTipsSearchDone(_ request: AMapInputTipsSearchRequest!, response: AMapInputTipsSearchResponse!) {
        
        guard response != nil else { return }
        
        if response.count == 0 {
            view.makeToast("无定位信息")
            return
        }
 
        searchArr.removeAll()
        searchArr = response.tips.filter({ (obj) -> Bool in
            return obj.uid != nil && obj.location != nil
        })

        searchVC.searchSuggestionView.reloadData()
        
    }
    
    
    
    //地理编码搜索
    func onGeocodeSearchDone(_ request: AMapGeocodeSearchRequest!, response: AMapGeocodeSearchResponse!) {
        
    }
    
    //逆地理编码搜索
    func onReGeocodeSearchDone(_ request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
        
        guard let city = response.regeocode.addressComponent.city else { return }
        
        currentCity = city
        
//        guard response != nil, response!.regeocode != nil, response!.regeocode!.addressComponent != nil, response!.regeocode!.addressComponent!.district != nil,  response!.regeocode!.addressComponent!.streetNumber != nil, response!.regeocode!.addressComponent!.streetNumber!.street != nil, response!.regeocode!.addressComponent!.streetNumber!.number != nil else { return }
//        let address = response!.regeocode!.addressComponent!.district! +  response!.regeocode!.addressComponent!.streetNumber!.street! + response!.regeocode!.addressComponent!.streetNumber!.number!
//        let annotation = MAPointAnnotation()
//        annotation.coordinate = selectedCoordinate
//        annotation.title = address
//        mapView.removeAnnotations(mapView.annotations)
//        mapView.addAnnotation(annotation)
    }
 
}

//search vc delegate
extension BXBSelectedLocationVC: PYSearchViewControllerDelegate, PYSearchViewControllerDataSource {
    
    func searchSuggestionView(_ searchSuggestionView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return searchArr.count > 40 ? 40 : searchArr.count
    }
    
    func searchSuggestionView(_ searchSuggestionView: UITableView!, heightForRowAt indexPath: IndexPath!) -> CGFloat {
        return 50 * KScreenRatio_6
    }
    
    func searchSuggestionView(_ searchSuggestionView: UITableView!, cellForRowAt indexPath: IndexPath!) -> UITableViewCell! {
        var cell = searchSuggestionView.dequeueReusableCell(withIdentifier: "BXBSelectedLocationCell") as? BXBSelectedLocationCell
        if cell == nil {
            cell = BXBSelectedLocationCell.init(style: .default, reuseIdentifier: "BXBSelectedLocationCell")
        }
        if searchArr.count > indexPath.row {
            cell?.nameLabel.text = searchArr[indexPath.row].name
            cell?.detailLabel.text = searchArr[indexPath.row].address
        }
        
        return cell!
    }
    
    
    func searchViewController(_ searchViewController: PYSearchViewController!, searchTextDidChange searchBar: UISearchBar!, searchText: String!) {
        
        searchRequest.location = "\(Float(self.mapView.region.center.longitude)),\(Float(self.mapView.region.center.latitude))"
        searchRequest.keywords = searchText
        searchAPI.aMapInputTipsSearch(searchRequest)
        
    }
    
    func searchViewController(_ searchViewController: PYSearchViewController!, didSelectSearchSuggestionAt indexPath: IndexPath!, searchBar: UISearchBar!) {
    
        guard searchArr.count > indexPath.row else { return }
        
        dismiss(animated: true) {

            DispatchQueue.main.async {
                let coor = CLLocationCoordinate2D.init(latitude: Double(self.searchArr[indexPath.row].location.latitude), longitude: Double(self.searchArr[indexPath.row].location.longitude))
                self.clickSearchData = self.searchArr[indexPath.row]
                self.mapView.setCenter(coor, animated: true)
            }
        }
        
    }
    
    func didClickCancel(_ searchViewController: PYSearchViewController!) {
        
        searchViewController.dismiss(animated: true) {
            self.mapView.setCenter(self.mapView.region.center, animated: true)
        }
    }
    
    
}

//MARK: - table view
extension BXBSelectedLocationVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50 * KScreenRatio_6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "BXBSelectedLocationCell") as? BXBSelectedLocationCell
        if cell == nil {
            cell = BXBSelectedLocationCell.init(style: .default, reuseIdentifier: "BXBSelectedLocationCell")
        }
        guard addressArr.count > indexPath.row else { return cell! }
        
        cell?.nameLabel.text = addressArr[indexPath.row].name
        cell?.detailLabel.text = addressArr[indexPath.row].address
        
        if indexPath.row == 0 {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            poiData = addressArr[indexPath.row]
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard addressArr.count > indexPath.row else { return }
        poiData = addressArr[indexPath.row]
        guard poiData.location != nil else { return }
        isClickList = true
        mapView.setCenter(CLLocationCoordinate2D.init(latitude: Double(poiData.location!.latitude), longitude: Double(poiData.location!.longitude)), animated: true)
    }
    
}


















