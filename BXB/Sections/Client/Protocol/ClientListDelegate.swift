//
//  ClientListDelegate.swift
//  BXB
//
//  Created by equalriver on 2018/8/6.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation
import ObjectMapper


//MARK: - navi buttons aciton
extension BXBClientListVC: ClientTabVCNaviBarDelegate {
    //搜索客户
    func didClickSearch() {
        self.search.searchBar.text = nil
        self.present( self.searchVC, animated: true, completion: nil)
    }
    
    
    func didClickRightButton(tag: Int) {
        //附近
        if tag == 0 {
            loginValidate(currentVC: self) { (isLogin) in
                guard isLogin else { return }
                switch CLLocationManager.authorizationStatus() {
                case .authorizedAlways, .authorizedWhenInUse, .notDetermined:
                    let vc = BXBClientNearVC()
                    navigationController?.pushViewController(vc, animated: true)
                    
                default:
                    gotoAuthorizationView(vc: self)
                }
            }
        }
        //新增客户
        if tag == 1 {
            addNewClient()
        }
    }
}

//MARK: - action
extension BXBClientListVC {
    //新建客户
    func addNewClient() {
        loginValidate(currentVC: self) { (isLogin) in
            guard isLogin else { return }
            let vc = BXBAddNewClientVC()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //刷新数据
    @objc func shouldRefreshData(sender: Notification) {
        clientData.removeAll()
        clientNameData.removeAll()
        dataArr.removeAll()
        sectionIndexArr.removeAllObjects()
        clientNamesArr.removeAll()
        dataAllArr.removeAll()
        tableView.reloadData()
        tableView.tableFooterView = nil
        
        BXBNetworkTool.isShowSVProgressHUD = false
        cellStyle == .normal ? loadData(remind: remind, isWrite: isWrite, matter: matter) : loadData(style: style)
        
    }
    
    //MARK: - network
    func loadData(remind: String, isWrite: String, matter: String) {
        
        let isAllData = remind == "" && isWrite == "" && matter == ""
        
        BXBNetworkTool.BXBRequest(router: .clientFilter(remind: remind, isWrite: isWrite, matter: matter), success: { (resp) in
            
            DispatchQueue.global().async {
                
                if let data = Mapper<ClientData>().mapArray(JSONObject: resp["data"].arrayObject){
                    
                    BXBNetworkTool.isShowSVProgressHUD = true
                    self.dataAllArr.removeAll()
                    self.dataAllArr = data
                    
                    if isAllData {
                        archiverUserData(datas: data)
                        self.clientData = data
                        self.clientNameData = self.clientData.map({ (obj) -> String in
                            return obj.name
                        })
                    }
    
                    let arr = data.map({ (d) -> String in
                        return d.name
                    }).filter({ (s) -> Bool in
                        return s.count > 0 && s.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count > 0
                    })
                    self.sectionIndexArr = ChineseString.indexArray(arr)
                    self.clientNamesArr = ChineseString.letterSortArray(arr) as! [Array<String>]
                    
                    self.dataArr.removeAll()
                    self.dataArr = data
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.tableView.mj_header.endRefreshing()
                        
                        if data.count == 0 {
                            if isAllData {
                                self.tableView.stateEmpty(title: "暂时没有添加客户", img: #imageLiteral(resourceName: "client_空白页"), buttonTitle: "新建客户", handle: {[weak self] in
                                    self?.addNewClient()
                                })
                            }
                            else {
                                self.tableView.stateEmpty(title: "未匹配到满足条件的客户", img: #imageLiteral(resourceName: "client_未匹配到"), buttonTitle: nil, handle: nil)
                            }
                            self.tableView.tableFooterView = nil
                        }
                        else {
                            self.footerView.text = "\(data.count)位联系人"
                            self.tableView.tableFooterView = self.footerView
                            self.tableView.stateNormal()
                        }
                    }
                    
                }
            }
            
        }) { (error) in
            BXBNetworkTool.isShowSVProgressHUD = true
            self.tableView.mj_header.endRefreshing()
            self.tableView.tableFooterView = nil
        }
        
    }
    
    func loadData(style: ClientItemStyle) {
        
        var rid = ""
        switch style {
        case .birthday:
            rid = "1"
            
        case .memorial:
            rid = "2"
            
        case .baodan:
            rid = "3"
            
        case .other:
            rid = "4"
            
        default:
            break
        }
        
        BXBNetworkTool.BXBRequest(router: .clientNoticeFilter(matterId: rid, pageSize: 10, currentPage: page), success: { (resp) in
            
            BXBNetworkTool.isShowSVProgressHUD = true
            
            if let data = Mapper<ClientData>().mapArray(JSONObject: resp["data"].arrayObject){
                
                self.tableView.mj_header.endRefreshing()
                self.tableView.stateNormal()
                if self.tableView.mj_footer != nil { self.tableView.mj_footer.endRefreshing() }
                
                if self.page == 1 { self.dataArr.removeAll() }
                self.dataArr += data
                
                if data.count == 0 {
                    self.tableView.tableFooterView = nil
                    if self.page == 1 {
                        self.tableView.stateEmpty(title: "未匹配到满足条件的客户", img: #imageLiteral(resourceName: "client_未匹配到"), buttonTitle: nil, handle: nil)
                    }
                    else {
                        self.tableView.stateNormal()
                        self.tableView.mj_footer.endRefreshingWithNoMoreData()
                    }
                }
                else {
                    self.tableView.tableFooterView = nil
                }
                self.tableView.reloadData()
                
            }
            
        }) { (error) in
            self.page = 1
            self.tableView.mj_header.endRefreshing()
            if self.tableView.mj_footer != nil { self.tableView.mj_footer.endRefreshing() }
            self.tableView.tableFooterView = nil
        }
        
    }
    
    //refresh
    func setRefresh() {
        BXBNetworkRefresh.headerRefresh(scrollView: tableView) {[weak self] in
            guard self != nil else { return }
            BXBNetworkTool.isShowSVProgressHUD = false
            
            if self!.cellStyle == .normal {
                
                self!.loadData(remind: self!.remind, isWrite: self!.isWrite, matter: self!.matter)
            }
            else {
                self!.page = 1
                self!.loadData(style: self!.style)
            }
        }
        
    }
}

//MARK: - search delegate
extension BXBClientListVC: PYSearchViewControllerDelegate, PYSearchViewControllerDataSource {
    
    func searchViewController(_ searchViewController: PYSearchViewController!, searchTextDidChange searchBar: UISearchBar!, searchText: String!) {
        searchViewController.searchSuggestions = clientNameData.filter({ (obj) -> Bool in
            return obj.contains(searchText)
        })
    }
    
    func searchViewController(_ searchViewController: PYSearchViewController!, didSelectSearchSuggestionAt indexPath: IndexPath!, searchBar: UISearchBar!) {
        
        let vc = BXBClientDetailVC()
        guard searchBar.text != nil else { return }
        if let index = clientNameData.index(of: searchBar.text!){
            vc.clientId = clientData[index].id
            dismiss(animated: false) {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
}


//MARK: - 筛选 delegate
extension BXBClientListVC: ClientFilterButtonsDelegate {
    
    func didClickFilterItem(name: String, index: Int) {
        if index != 2 {
            cellStyle = .normal
            if tableView.mj_footer != nil { tableView.mj_footer = nil }
            
            if name == "已设置提醒" || name == "未设置提醒" { remind = name }
            else { remind = "" }
            
            if name == "已签单" || name == "未签单" { isWrite = name }
            else { isWrite = "" }
            
            if name == "开启面谈" || name == "建议书" || name == "转介名单" { matter = name }
            else if name == "所有状态" { matter = "不限" }
            else { matter = "" }
            
            loadData(remind: remind, isWrite: isWrite, matter: matter)
        }
        else {//提醒类型
            page = 1
            style = ClientItemStyle.initWithDescription(des: name)
            cellStyle = .notice
            if tableView.mj_footer == nil && self.dataArr.count > 0 {
                BXBNetworkRefresh.footerRefresh(scrollView: tableView) {[weak self] in
                    guard self != nil else { return }
                    if self!.dataArr.count > 0 {
                        self!.page += 1
                        self!.loadData(style: self!.style)
                    }
                }
            }
            
            loadData(style: style)
        }
    }
}

//MARK: - table view delegate
extension BXBClientListVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellStyle == .normal ? clientNamesArr.count : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellStyle == .normal ? clientNamesArr[section].count : dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellStyle == .normal ? 60 * KScreenRatio_6 : 85 * KScreenRatio_6
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellStyle == .normal ? 30 * KScreenRatio_6 : 0
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if cellStyle == .normal {
            var cell = tableView.dequeueReusableCell(withIdentifier: "BXBClientUserAllCell") as? BXBClientUserAllCell
            if cell == nil {
                cell = BXBClientUserAllCell.init(style: .default, reuseIdentifier: "BXBClientUserAllCell")
            }
            if let cd = self.dataAllArr.filter({ (item) -> Bool in
                return item.name == clientNamesArr[indexPath.section][indexPath.row]
            }).first {
                cell?.data = cd
            }
            
            cell?.isNeedSeparatorView = clientNamesArr[indexPath.section].count - 1 != indexPath.row
            
            return cell!
        }
        else {
            var cell = tableView.dequeueReusableCell(withIdentifier: "BXBClientUserNoticeCell") as? BXBClientUserNoticeCell
            if cell == nil {
                cell = BXBClientUserNoticeCell.init(style: .default, reuseIdentifier: "BXBClientUserNoticeCell")
            }
            
            var rid = ""
            if style != nil {
                switch style! {
                case .birthday:
                    rid = "1"
                    
                case .memorial:
                    rid = "2"
                    
                case .baodan:
                    rid = "3"
                    
                case .other:
                    rid = "4"
                    
                default:
                    break
                }
            }
            
            dataArr[indexPath.row].clientItemStyle = rid
            cell!.data = dataArr[indexPath.row]
            cell?.isNeedSeparatorView = dataArr.count - 1 != indexPath.row
            return cell!
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 30 * KScreenRatio_6))
        v.backgroundColor = kColor_background
        
        let l = UILabel()
        l.font = kFont_text
        l.textColor = kColor_text
        l.backgroundColor = kColor_background
        l.text = sectionIndexArr[section] as? String
        v.addSubview(l)
        l.snp.makeConstraints { (make) in
            make.centerY.height.equalTo(v)
            make.left.equalTo(v).offset(15 * KScreenRatio_6)
        }
        
        return cellStyle == .normal ? v : nil
    }
 
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if checkNetwork() == false { return }
        
        if cellStyle == .normal {
            let vc = BXBClientDetailVC()
            let name = clientNamesArr[indexPath.section][indexPath.row]
            for i in dataAllArr {
                if i.name == name {
                    vc.clientId = i.id
                    navigationController?.pushViewController(vc, animated: true)
                    return
                }
            }
        }
        else {
            let vc = BXBClientDetailVC()
            vc.clientId = dataArr[indexPath.row].id
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    //section index
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return cellStyle == .normal ? sectionIndexArr as? [String] : nil
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        
        if sectionIndexArr.contains(title) {
            tableView.scroll(toRow: 0, inSection: UInt(index), at: .middle, animated: true)
        }
        return index
    }
    
    
}


















