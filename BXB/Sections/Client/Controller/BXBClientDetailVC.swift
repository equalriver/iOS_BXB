//
//  BXBClientDetailVC.swift
//  BXB
//
//  Created by equalriver on 2018/6/21.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit
import SwiftyJSON
import ObjectMapper
import Toast_Swift

class BXBClientDetailVC: BXBBasePageController {
    
    public var clientId = 0
    
    
    var data = ClientData()
    
    var noticeArr = Array<ClientDetailNoticeData>()
    
    var recordArr = Array<ClientDetailRecordData>()
    
    var maintainArr = Array<ClientDetailMaintainData>()
    
    ///互动记录总次数
    var visitListCount = 0
    
    ///维护总费用
    var spendSum = 0
    
    ///点击的地址cell
    var selectedAddressIndexPath: IndexPath!
    
    var sectionArr = ["提醒", "基本信息", "互动记录", "花费记录"]
    
//    var infoArr = ["手机", "性别", "生日", "婚姻状态", "年收入", "学历", "家庭住址", "工作地址"]
    

    lazy var headerView: ClientDetailHeaderView = {
        let v = ClientDetailHeaderView.init(frame: CGRect.init(x: 0, y: kNavigationBarAndStatusHeight, width: kScreenWidth, height: 150 * KScreenRatio_containX))
        v.backgroundColor = UIColor.white
        v.targetVC = self
        v.delegate = self
        return v
    }()
    lazy var moreButton: UIButton = {
        let b = UIButton()
//        b.setImage(#imageLiteral(resourceName: "bxb_更多"), for: .normal)
        b.titleLabel?.font = kFont_naviBtn_weight
        b.setTitle("删除", for: .normal)
        b.setTitleColor(kColor_red, for: .normal)
        return b
    }()
    
    //MARK: - life cycle
    override func viewDidLoad() {
        menuItemWidth = 345 / 3 * KScreenRatio_6
        menuViewStyle = .line
        titleSizeNormal = 16 * KScreenRatio_6
        titleSizeSelected = 16 * KScreenRatio_6
        titleColorNormal = kColor_text!
        titleColorSelected = kColor_theme!
        progressWidth = 20 * KScreenRatio_6
        
        super.viewDidLoad()
        initUI()
        loadData(id: clientId)
        NotificationCenter.default.addObserver(self, selector: #selector(notiClientDetailShouldRefreshData), name: .kNotiClientDetailShouldRefreshData, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ToastManager.shared.position = .top
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let vcs = navigationController?.viewControllers else { return }
        for v in vcs {
            if v.isKind(of: PYSearchViewController.self){
                navigationController?.navigationBar.isHidden = false
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard menuView != nil else { return }
        menuView?.backgroundColor = UIColor.white
        let maskPath = UIBezierPath.init(roundedRect: menuView!.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize.init(width: 5, height: 5))
        let maskLayer = CAShapeLayer()
        maskLayer.strokeColor = UIColor.white.cgColor
        maskLayer.frame = menuView!.bounds
        maskLayer.path = maskPath.cgPath
        menuView!.layer.mask = maskLayer
    }
  
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func initUI() {
        naviBar.naviBackgroundColor = UIColor.white
        view.backgroundColor = kColor_background
        naviBar.rightBarButtons = [moreButton]
        view.addSubview(headerView)
    }

    //MARK: - network
    func loadData(id: Int) {
        BXBNetworkTool.BXBRequest(router: .detailClient(id: id), success: { (resp) in
            DispatchQueue.global().async {
                if let notices = Mapper<ClientDetailNoticeData>().mapArray(JSONObject: resp["listRemind"].arrayObject){
                    self.noticeArr.removeAll()
                    self.noticeArr = notices
                }
                if let records = Mapper<ClientDetailRecordData>().mapArray(JSONObject: resp["visitList"].arrayObject){
                    self.recordArr.removeAll()
                    self.recordArr = records
                }
                if let maintains = Mapper<ClientDetailMaintainData>().mapArray(JSONObject: resp["listSpend"].arrayObject){
                    self.maintainArr.removeAll()
                    self.maintainArr = maintains
                }
                if let d = Mapper<ClientData>().map(JSONObject: resp["client"].object){
                    self.data = d
                }
                
                if let vc = resp["visitListCount"].int { self.visitListCount = vc }
                
                if let ss = resp["spendSum"].int { self.spendSum = ss }
                /*
                //是否超出两行
                if self.data.label.count > 0 {
                    let items = self.data.label.filter({ (c) -> Bool in
                        c != ","
                    })
                    var itemsCount = 0
                    for c in self.data.label { if c == "," { itemsCount += 1 } }
                    
                    let w = items.getStringWidth(font: UIFont.systemFont(ofSize: 15 * KScreenRatio_6), height: 15 * KScreenRatio_6) + CGFloat(itemsCount) * 20 * KScreenRatio_6
                    
                    if w > 250 * KScreenRatio_6 {
                        DispatchQueue.main.async {
                            self.headerView.height = 130 * KScreenRatio_6
                        }
                    }
                }*/
                
                DispatchQueue.main.async {
                    self.headerView.data = self.data
                    self.reloadData()
                }
            }
            
        }) { (error) in
            
        }
    }
    

}
