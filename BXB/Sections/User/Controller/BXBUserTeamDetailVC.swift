//
//  BXBUserMyTeamVC.swift
//  BXB
//
//  Created by equalriver on 2018/6/22.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit
import ObjectMapper

class BXBUserTeamDetailVC: BXBBaseNavigationVC {
    
    public var teamId = 0
    
    var data = TeamData()
    
    ///团队成员数
    var number = 0
    
    ///申请人数
    var applicationCount = 0
    
    public var teamTitle = "" {
        willSet{
            if newValue == "我创建的团队" {
//                actionTeamBtn.setTitle("解散团队", for: .normal)
                actionTeamBtn.isHidden = true
            }
            else if newValue == "申请加入" {
                actionTeamBtn.setTitle("申请加入", for: .normal)
            }
            else {
                actionTeamBtn.setTitle("退出团队", for: .normal)
//                actionTeamBtn.isHidden = true
            }
        }
    }

    lazy var headerView: BXBUserMyTeamHeaderView = {
        let v = BXBUserMyTeamHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 210 * KScreenRatio_6))
        return v
    }()
    
    lazy var tableView: UITableView = {
        let tb = UITableView.init(frame: .zero, style: .plain)
        tb.backgroundColor = kColor_background
        tb.dataSource = self
        tb.delegate = self
        tb.isScrollEnabled = false
        tb.separatorStyle = .none
        tb.layer.cornerRadius = kCornerRadius
        tb.layer.masksToBounds = true
        return tb
    }()
    
    lazy var introLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_2
        l.textColor = kColor_text
        l.numberOfLines = 0
        return l
    }()
    
    lazy var actionTeamBtn: UIButton = {
        let b = UIButton()
        b.titleLabel?.font = kFont_text
        b.setTitleColor(kColor_theme, for: .normal)
        b.addTarget(self, action: #selector(teamAction(sender:)), for: .touchUpInside)
        return b
    }()
    lazy var backBtn: UIButton = {
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "me_团队_返回"), for: .normal)
        return b
    }()
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        loadData()
        NotificationCenter.default.addObserver(self, selector: #selector(notiTeamDetailShouldRefreshData), name: .kNotiTeamDetailShouldRefreshData, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func initUI() {
        view.backgroundColor = kColor_background
        view.addSubview(headerView)
        view.addSubview(tableView)
        view.addSubview(actionTeamBtn)
        tableView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(headerView.snp.bottom).offset(15 * KScreenRatio_6)
            make.height.equalTo(55 * 6 * KScreenRatio_6 + 15 * KScreenRatio_6)
            make.width.equalTo(345 * KScreenRatio_6)
        }
        actionTeamBtn.snp.makeConstraints { (make) in
            make.width.bottom.centerX.equalTo(view)
            make.height.equalTo(44 * KScreenRatio_6 + kIphoneXBottomInsetHeight)
        }
        naviBar.backgroundColor = UIColor.clear
        naviBar.bottomBlackLineView.isHidden = true
        naviBar.titleView.isHidden = true
        isNeedBackButton = false
        naviBar.leftBarButtons = [backBtn]
    }
    
    //MARK: - noti
    @objc func notiTeamDetailShouldRefreshData() {
        loadData()
    }

    //MARK: - action
    override func leftButtonsAction(sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc func teamAction(sender: UIButton) {
        if teamTitle == "我创建的团队" {//解散
            
            
        }
        else if teamTitle == "申请加入" {
            
            sender.isUserInteractionEnabled = false
            BXBNetworkTool.BXBRequest(router: .teamMessage(id: teamId), success: { (resp) in
                
                sender.isUserInteractionEnabled = true
                
                self.number = resp["num"].intValue
                if let d = Mapper<TeamData>().map(JSONObject: resp["data"].object) {
                    self.data = d
                    self.headerView.data = d
                    self.headerView.count = self.number
                    self.tableView.reloadData()
                }
            }) { (error) in
                sender.isUserInteractionEnabled = true
            }
        }
        else {//退出
            let alert = UIAlertController.init(title: nil, message: "确定退出该团队吗?", preferredStyle: .alert)
            let action = UIAlertAction.init(title: "是", style: .default) { (ac) in
                BXBNetworkTool.BXBRequest(router: .quitTeam(id: self.data.userId, teamId: self.teamId), success: { (resp) in
                   
                    NotificationCenter.default.post(name: .kNotiUserShouldRefreshData, object: nil)
                    NotificationCenter.default.post(name: .kNotiTeamDetailShouldRefreshData, object: nil)
                    self.navigationController?.popViewController(animated: true)
                    
                }) { (error) in
                    
                }
            }
            let cancel = UIAlertAction.init(title: "否", style: .cancel, handler: nil)
            alert.addAction(action)
            alert.addAction(cancel)
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - network
    func loadData() {
        BXBNetworkTool.BXBRequest(router: .teamMessage(id: teamId), success: { (resp) in
            self.number = resp["num"].intValue
            self.applicationCount = resp["applicationCount"].intValue
            if let d = Mapper<TeamData>().map(JSONObject: resp["data"].object) {
                self.data = d
                self.headerView.data = d
                self.headerView.count = self.number
                self.tableView.reloadData()
            }
            else {
//                self.tableView.stateEmpty(title: nil)
            }

            
        }) { (error) in
            self.tableView.stateError {[weak self] in
                self?.loadData()
            }
        }
    }

}




