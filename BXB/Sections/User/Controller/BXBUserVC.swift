//
//  BXBUserVC.swift
//  BXB
//
//  Created by 尹平江 on 2018/6/4.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ObjectMapper

class BXBUserVC: BXBBaseViewController {
    
    var data = UserData(){
        willSet{
            headView.data = newValue
            teamView.data = newValue
        }
    }
    var aimsData = UserAimsData(){
        willSet{
            targetView.data = newValue
        }
    }
    
    lazy var naviBar: BXBUserTabVCNaviBar = {
        let v = BXBUserTabVCNaviBar.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kNavigationBarAndStatusHeight))
        v.backgroundColor = UIColor.white
        v.delegate = self
        return v
    }()
    lazy var headView: BXBUserHeadView = {
        let v = BXBUserHeadView.init(frame: .zero)
        v.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(userinfoEdit))
        v.addGestureRecognizer(tap)
        return v
    }()
    lazy var targetView: BXBUserTargetView = {
        let v = BXBUserTargetView.init(frame: .zero)
        v.delegate = self
        return v
    }()
    lazy var teamView: BXBUserTeamView = {
        let v = BXBUserTeamView.init(frame: .zero)
        v.delegate = self
        return v
    }()
    lazy var otherView: BXBUserOtherView = {
        let v = BXBUserOtherView.init(frame: .zero)
        v.delegate = self
        return v
    }()
    
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(notiUserShouldRefreshData), name: .kNotiUserShouldRefreshData, object: nil)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if data.name == "" {
            BXBNetworkTool.isShowSVProgressHUD = false
            loadData()
//        }
//        else {  }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func initUI() {
        view.backgroundColor = kColor_background
        view.addSubview(naviBar)
        view.addSubview(headView)
        view.addSubview(targetView)
        view.addSubview(teamView)
        view.addSubview(otherView)
        headView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: kScreenWidth, height: 100 * KScreenRatio_6))
            make.top.equalTo(naviBar.snp.bottom)
            make.centerX.equalTo(view)
        }
        targetView.snp.makeConstraints { (make) in
            make.top.equalTo(headView.snp.bottom)
            make.centerX.width.equalTo(view)
            make.height.equalTo(60 * KScreenRatio_6)
        }
        teamView.snp.makeConstraints { (make) in
            make.top.equalTo(targetView.snp.bottom).offset(15 * KScreenRatio_6)
            make.width.centerX.equalTo(view)
            make.height.equalTo(235 * KScreenRatio_6)
        }
        otherView.snp.makeConstraints { (make) in
            make.top.equalTo(teamView.snp.bottom).offset(10 * KScreenRatio_6)
            make.centerX.equalTo(view)
            make.size.equalTo(CGSize.init(width: 345 * KScreenRatio_6, height: 120 * KScreenRatio_6))
        }
        
    }
    
    //noti
    @objc func notiUserShouldRefreshData() {
        data = UserData()
        aimsData = UserAimsData()
        BXBNetworkTool.isShowSVProgressHUD = false
        loadData()
    }

    //MARK: - network
    func loadData() {
        
        BXBNetworkTool.BXBRequest(router: .userDetail(), success: { (resp) in
            
            if let d = Mapper<UserData>().map(JSONObject: resp["user"].object) {
                self.data = d
            }
            if let a = Mapper<UserAimsData>().map(JSONObject: resp["aims"].object) {
                self.aimsData = a
            }
            
            
        }) { (error) in
            print("我的： \(error.localizedDescription)")
        }
    }

}
