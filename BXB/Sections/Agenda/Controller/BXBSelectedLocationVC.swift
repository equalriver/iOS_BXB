//
//  BXBSelectedLocationVC.swift
//  BXB
//
//  Created by equalriver on 2018/7/16.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit

protocol SelectedLocationDelegate: NSObjectProtocol {
    func didSelectedAddress(poi: AMapPOI)
}

class BXBSelectedLocationVC: BXBBaseNavigationVC {
    
    weak public var delegate: SelectedLocationDelegate?
    
    public var currentLocation: AMapPOI? {
        willSet{
            mapView.userTrackingMode = .none
        }
    }
    
    var addressArr = Array<AMapPOI>()
    
    var searchArr = Array<AMapTip>()
    
    
    var selectedCoordinate = CLLocationCoordinate2D()
    
    ///首次进入
    var isFirstLoadLocationList = true
    
    ///点击列表
    var isClickList = false
    
    var clickSearchData: AMapTip?
    
    var poiData: AMapPOI!
    
    ///当前城市
    var currentCity = "成都市" {
        didSet{
           searchRequest.city = currentCity
        }
    }
    
    lazy var mapView: MAMapView = {
        let v = MAMapView.init()
//        let v = MAMapView(frame: self.view.bounds)
        v.delegate = self
//        v.autoresizingMask = [UIView.AutoresizingMask.flexibleHeight, UIView.AutoresizingMask.flexibleWidth]
        v.zoomLevel = 16
        v.showsScale = true
        v.showsCompass = false
        v.isRotateEnabled = false
//        v.showsUserLocation = true
//        v.userTrackingMode = .follow
        return v
    }()
    
    lazy var searchAPI: AMapSearchAPI = {
        let s = AMapSearchAPI.init()
        s?.delegate = self
        return s!
    }()
    
    lazy var searchRequest: AMapInputTipsSearchRequest = {
        let s = AMapInputTipsSearchRequest()
//        s.cityLimit = true
        s.city = "成都市"
        return s
    }()
    
    lazy var reGeocodeReq: AMapReGeocodeSearchRequest = {
        let rg = AMapReGeocodeSearchRequest.init()
        rg.requireExtension = true
        return rg
    }()
    
    lazy var nearSearchReq: AMapPOIAroundSearchRequest = {
        let s = AMapPOIAroundSearchRequest()
        s.radius = 500
        s.keywords = "地名地址信息;交通地名;交通地名|产业园区|商务住宅;住宅区;住宅区|普通地名|自然地名|标志性建筑物|热点地名|城市中心|商场|保险公司|中国人民银行|中国银行|中国工商银行|中国建设银行|中国农业银行|交通银行|招商银行|华夏银行|中信银行|中国民生银行|中国光大银行|上海银行|上海浦东发展银行|平安银行|兴业银行|北京银行|广发银行|中国邮政储蓄银行|学校|三级甲等医院|专科医院"
        s.offset = 50
        
        return s
    }()
    
    lazy var searchVC: PYSearchViewController = {
        let vc = PYSearchViewController.init(hotSearches: nil, searchBarPlaceholder: "输入关键字")
        vc!.delegate = self
        vc!.dataSource = self
        vc?.showSearchHistory = false
        vc?.searchBar.setImage(UIImage.init(named: "bxb_搜索"), for: UISearchBar.Icon.search, state: UIControl.State.normal)
        vc?.searchTextField.attributedPlaceholder = NSAttributedString.init(string: "输入关键字", attributes: [.font: kFont_text_2_weight, .foregroundColor: kColor_subText!])
        vc?.searchBarCornerRadius = kCornerRadius
        return vc!
    }()
    
    lazy var searchNavi: BXBSearchNavi = {
        let navi = BXBSearchNavi.init(rootViewController: searchVC)
        return navi
    }()
    
    lazy var locationTV: UITableView = {
        let t = UITableView.init(frame: .zero, style: .plain)
        t.dataSource = self
        t.delegate = self
        t.separatorStyle = .none
        t.backgroundColor = UIColor.white
        return t
    }()
    lazy var searchBtn: UIButton = {
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "map_搜索地点"), for: .normal)
        b.backgroundColor = UIColor.init(hexString: "#efeef4")
        b.addTarget(self, action: #selector(goSearch), for: .touchUpInside)
        return b
    }()
    lazy var sepView: UIView = {
        let v = UIView()
        v.backgroundColor = kColor_separatorView
        return v
    }()
    lazy var userLocationBtn: UIButton = {
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "map_原点"), for: .normal)
        b.addTarget(self, action: #selector(gotoCurrentLocation), for: .touchUpInside)
        return b
    }()
    lazy var confirmBtn: UIButton = {
        let b = UIButton()
        b.titleLabel?.font = kFont_naviBtn_weight
        b.setTitle("确定", for: .normal)
        b.setTitleColor(kColor_theme, for: .normal)
        return b
    }()
    lazy var pinImageView: UIImageView = {
        let iv = UIImageView.init(image: #imageLiteral(resourceName: "map_redPin"))
        return iv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "选择位置"
        initUI()
        
        SVProgressHUD.show()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            SVProgressHUD.dismiss()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapView.showsUserLocation = true
        if currentLocation != nil {
            mapView.setCenter(CLLocationCoordinate2D.init(latitude: CLLocationDegrees(currentLocation!.location!.latitude), longitude: CLLocationDegrees(currentLocation!.location!.longitude)), animated: true)
        }
        else {
            mapView.userTrackingMode = .follow
        }
        
    }
    
    func initUI() {
        naviBar.rightBarButtons = [confirmBtn]
        view.addSubview(mapView)
        mapView.addSubview(searchBtn)
        mapView.addSubview(sepView)
        mapView.addSubview(userLocationBtn)
        mapView.addSubview(pinImageView)
        view.addSubview(locationTV)
        mapView.snp.makeConstraints { (make) in
            make.top.equalTo(naviBar.snp.bottom)
            make.width.centerX.equalTo(view)
            make.height.equalTo(view.height * 0.5)
        }
        searchBtn.snp.makeConstraints { (make) in
            make.width.top.centerX.equalTo(mapView)
            make.height.equalTo(50 * KScreenRatio_6)
        }
        sepView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: kScreenWidth, height: 0.5))
            make.top.equalTo(searchBtn.snp.bottom)
            make.centerX.equalTo(mapView)
        }
        userLocationBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 40 * KScreenRatio_6, height: 40 * KScreenRatio_6))
            make.right.bottom.equalTo(mapView).offset(-15 * KScreenRatio_6)
        }
        pinImageView.snp.makeConstraints { (make) in
            make.center.equalTo(mapView)
        }
        locationTV.snp.makeConstraints { (make) in
            make.width.centerX.bottom.equalTo(view)
            make.top.equalTo(mapView.snp.bottom)
        }
    }
    
    //MARK: - action
    @objc func goSearch() {
        addressArr.removeAll()
        present(searchNavi, animated: true, completion: nil)
    }
    
    @objc func gotoCurrentLocation() {
        mapView.setCenter(mapView.userLocation.location.coordinate, animated: true)
    }
    
    override func rightButtonsAction(sender: UIButton) {
      
        guard poiData != nil else { return }
        self.delegate?.didSelectedAddress(poi: poiData)
        self.navigationController?.popViewController(animated: true)
    }


    func pinAnimation() {
        let an = CAKeyframeAnimation.init(keyPath: "transform")
        an.duration = 0.8
        an.fillMode = CAMediaTimingFillMode.forwards
        an.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
        var values = Array<Any>()
        values.append(NSValue.init(caTransform3D: CATransform3DMakeTranslation(0, 12, 0)))
        values.append(NSValue.init(caTransform3D: CATransform3DMakeTranslation(0, 0, 0)))
        values.append(NSValue.init(caTransform3D: CATransform3DMakeTranslation(0, 6, 0)))
        values.append(NSValue.init(caTransform3D: CATransform3DMakeTranslation(0, 0, 0)))
        an.values = values
        
        pinImageView.layer.add(an, forKey: nil)
    }
}











