//
//  BXBUserJoinTeamVC.swift
//  BXB
//
//  Created by equalriver on 2018/7/5.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit
import ObjectMapper

class BXBUserJoinTeamVC: BXBBaseNavigationVC {

    public var teamId = 0
    
    var data = TeamData()
    ///团队成员数
    var number = 0
    
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
        return tb
    }()
    
    lazy var actionTeamBtn: UIButton = {
        let b = UIButton()
        b.titleLabel?.font = kFont_text_weight
        b.setTitleColor(kColor_theme, for: .normal)
        b.setTitle("申请加入", for: .normal)
        b.addTarget(self, action: #selector(teamAction(sender:)), for: .touchUpInside)
        return b
    }()
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        loadData()
    }
    
    func initUI() {
        view.addSubview(tableView)
        view.addSubview(actionTeamBtn)
        tableView.snp.makeConstraints { (make) in
            make.top.width.centerX.equalTo(view)
            make.bottom.equalTo(actionTeamBtn.snp.top)
        }
        actionTeamBtn.snp.makeConstraints { (make) in
            make.width.bottom.centerX.equalTo(view)
            make.height.equalTo(44 * KScreenRatio_6 + kIphoneXBottomInsetHeight)
        }
        naviBar.backgroundColor = UIColor.clear
        naviBar.bottomBlackLineView.isHidden = true
        naviBar.titleView.isHidden = true
        
    }
    
    //MARK: -action
    @objc func teamAction(sender: UIButton) {
        
        sender.isUserInteractionEnabled = false
        BXBNetworkTool.isShowSVProgressHUD = false

        BXBNetworkTool.BXBRequest(router: .addApplication(id: teamId, remarks: ""), success: { (resp) in

            SVProgressHUD.showSuccess(withStatus: "申请成功")
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                NotificationCenter.default.post(name: .kNotiUserShouldRefreshData, object: nil)
                sender.isUserInteractionEnabled = true
                self.navigationController?.popToRootViewController(animated: true)
            })
        }) { (error) in
            sender.isUserInteractionEnabled = true
        }
        
    }
    
    //MARK: - network
    func loadData() {
        BXBNetworkTool.isShowSVProgressHUD = false
        BXBNetworkTool.BXBRequest(router: .teamMessage(id: teamId), success: { (resp) in
            self.number = resp["num"].intValue
            if let d = Mapper<TeamData>().map(JSONObject: resp["data"].object) {
                self.data = d
                self.headerView.data = d
                self.headerView.count = self.number
                self.tableView.tableHeaderView = self.headerView
                self.tableView.reloadData()
            }
        }) { (error) in
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                self.navigationController?.popToRootViewController(animated: true)
            })
        }
    }


}

extension BXBUserJoinTeamVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return data.remarks.getStringHeight(font: UIFont.systemFont(ofSize: 15 * KScreenRatio_6), width: kScreenWidth - 20 * KScreenRatio_6) + 30 * KScreenRatio_6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BXBBaseTableViewCell()
        
        let l = UILabel()
        l.font = kFont_text_2
        l.textColor = kColor_subText
        l.numberOfLines = 0
        l.text = data.remarks
        cell.contentView.addSubview(l)
        l.snp.makeConstraints { (make) in
            make.width.equalTo(kScreenWidth - 20 * KScreenRatio_6)
            make.center.height.equalTo(cell.contentView)
        }
        
        return cell
    }
}
