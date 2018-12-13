//
//  BXBMessageVC.swift
//  BXB
//
//  Created by equalriver on 2018/8/20.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit
import ObjectMapper

class BXBMessageVC: BXBBaseNavigationVC {

    var dataArr = Array<NoticeData>()
    
    lazy var tableView: UITableView = {
        let tb = UITableView.init(frame: .zero, style: .grouped)
        tb.backgroundColor = kColor_background
        tb.delegate = self
        tb.dataSource = self
        tb.separatorStyle = .none
        return tb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "提醒"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(naviBar.snp.bottom)
            make.width.centerX.bottom.equalTo(view)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(notiRemindShouldRefreshData(sender:)), name: .kNotiRemindShouldRefreshData, object: nil)
        
        loadData()
        setRefresh()
        
        makeUserGuideForNoticeMessage()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - noti
    @objc func notiRemindShouldRefreshData(sender: Notification) {
        
        if sender.userInfo != nil {
            if let loginOut: Bool = sender.userInfo!["loginOut"] as? Bool {
                if loginOut == true {
                    dataArr.removeAll()
                    tableView.reloadData()
                    return
                }
            }
        }
        tableView.mj_header.beginRefreshing()
    }
    
    //MARK: - network
    func loadData() {

        BXBNetworkTool.BXBRequest(router: .clientNoticeAll(), success: { (resp) in
 
            self.tableView.mj_header.endRefreshing()
            self.tableView.stateNormal()
            if let data = Mapper<NoticeData>().mapArray(JSONObject: resp["data"].arrayObject){
                self.dataArr.removeAll()
                self.dataArr = data
                self.tableView.reloadData()
                if data.count == 0 {
                    self.tableView.stateEmpty(title: "暂时没有提醒消息", img: #imageLiteral(resourceName: "msg_空白页"), buttonTitle: nil, handle: {
                    
                    })
                }
                else { self.tableView.stateNormal() }
            }
        }) { (error) in

            //            self.tableView.stateEmpty(title: nil)
            self.tableView.mj_header.endRefreshing()
        }
    }
    
    //refresh
    func setRefresh() {
        BXBNetworkRefresh.headerRefresh(scrollView: tableView) {[weak self] in
            self?.loadData()
        }
    }


}


//MARK: - table view
extension BXBMessageVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr[section].list.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120 * KScreenRatio_6
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 53 * KScreenRatio_6 : 35 * KScreenRatio_6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "BXBMessageCell") as? BXBMessageCell
        if cell == nil {
            cell = BXBMessageCell.init(style: .default, reuseIdentifier: "BXBMessageCell")
        }
        cell?.data = dataArr[indexPath.section].list[indexPath.row]
        cell?.delegate = self
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 30 * KScreenRatio_6))
        v.backgroundColor = kColor_background
        
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 11 * KScreenRatio_6)
        l.textColor = UIColor.white
        l.backgroundColor = kColor_naviBottomSepView
        l.textAlignment = .center
        l.layer.cornerRadius = 8 * KScreenRatio_6
        l.layer.masksToBounds = true
        l.layer.drawsAsynchronously = true
        v.addSubview(l)
        l.snp.makeConstraints { (make) in
            make.centerX.equalTo(v)
            make.bottom.equalTo(v).offset(-5 * KScreenRatio_6)
            make.size.equalTo(CGSize.init(width: 55 * KScreenRatio_6, height: 16 * KScreenRatio_6))
        }
        l.text = dataArr[section].remindDate
        
        return v
    }
    
    
}

//MARK: - 跟进
extension BXBMessageVC: MessageCellDelegate {
    
    func didSelectedFollow(cell: UITableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let d = dataArr[indexPath.section].list[indexPath.row]
            if d.isFollow == "0" {
                NotificationCenter.default.post(name: .kNotiAddNewAgendaBySelectFollow, object: nil, userInfo: ["NoticeDetailData": d])
                if let t = UIApplication.shared.keyWindow?.rootViewController {
                    guard t.isKind(of: BXBTabBarController.self) else { return }
                    let tab = t as! BXBTabBarController
                    tab.selectedIndex = 1
                }
                self.navigationController?.popViewController(animated: true)
            }
            else { return }
            
        }
    }
}







