//
//  BXBContactsVC.swift
//  BXB
//
//  Created by equalriver on 2018/7/4.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit
import Contacts
import ObjectMapper

class BXBContactsVC: BXBBaseNavigationVC {
    
    public var isAgendaSelected = false
    
    var sectionIndexArr = NSMutableArray.init(capacity: 10)
    
    var clientNamesArr = Array<Array<String>>()
    
    var dataArr = Array<ClientContactData>()
    
    var remoteClientNameArr = Array<String>()
    
    var clientContactArr = Array<Array<ClientContactData>>()
    
    typealias callback = (_ client: ClientContactData) -> Void
    var handle: callback?
    
    lazy var tableView: UITableView = {
        let t = UITableView.init(frame: .zero, style: .plain)
        t.backgroundColor = kColor_background
        t.dataSource = self
        t.delegate = self
        t.separatorStyle = .none
        t.sectionIndexColor = kColor_subText
        return t
    }()
    
    convenience init(callback: @escaping callback){
        self.init()
        handle = callback
    }

    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(naviBar.snp.bottom)
            make.width.centerX.bottom.equalTo(view)
        }
        title = "通讯录导入"
        openContact()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        filterContact()
        
    }
    
    //MARK: - action
    
    //筛选联系人
    func filterContact() {
        
        DispatchQueue.global().async {
            
            var clients = Array<ClientData>()
            
            //获取本地保存的远程联系人
            let data: [Data]? = NSKeyedUnarchiver.unarchiveObject(withFile: kClientDataFilePath) as? [Data]
            if data == nil {
                
                self.loadData(handle: { (nameArr) in
                    self.remoteClientNameArr = nameArr
                })
                self.compareContact()
                
            }
            else {
                clients = data!.map({ (obj) -> ClientData in
                    return NSKeyedUnarchiver.unarchiveObject(with: obj) as! ClientData
                })
                self.remoteClientNameArr = clients.map({ (obj) -> String in
                    return obj.name
                })
                self.compareContact()
            }
        }
        
    }
    
    //对比远程和本地的联系人
    func compareContact() {
        
        for (i, v) in self.dataArr.enumerated() {
            for j in self.remoteClientNameArr {
                if v.name == j { self.dataArr[i].status = 1 }
            }
        }
        
        let localNames = self.dataArr.map({ (obj) -> String in
            return obj.name
        }).filter({ (str) -> Bool in
            return str.count > 0 && str.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count > 0
        })
        
        //table view section index
        self.sectionIndexArr = ChineseString.indexArray(localNames)
        //客户名二维数组
        self.clientNamesArr = ChineseString.letterSortArray(localNames) as! [Array<String>]
        //联系人模型二维数组
        self.clientContactArr = self.clientNamesArr.map { (arr) -> Array<ClientContactData> in
            var array = Array<ClientContactData>()
            for i in arr {
                for j in self.dataArr {
                    if i == j.name { array.append(j) }
                }
            }
            return array
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    //打开本地联系人
    func openContact() {
        // 获取指定的字段,并不是要获取所有字段，需要指定具体的字段
        let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
        let fetchRequest = CNContactFetchRequest.init(keysToFetch: keysToFetch as [CNKeyDescriptor])
        let contactStore = CNContactStore.init()
        
        do {
            try contactStore.enumerateContacts(with: fetchRequest, usingBlock: { (contact, stop) in
                let name = contact.familyName + contact.givenName
                let phone = contact.phoneNumbers.first?.value
                let d = ClientContactData()
                d.name = name
                d.phone = phone?.stringValue ?? ""
                self.dataArr.append(d)
            })
        } catch {
            
        }
        
    }

    //MARK: - network
    //获取客户列表
    func loadData(handle: @escaping (_ names: [String]) -> Void) {
        
        BXBNetworkTool.BXBRequest(router: .clientFilter(remind: "", isWrite: "", matter: ""), success: { (resp) in
            
            DispatchQueue.global().async {
                
                if let data = Mapper<ClientData>().mapArray(JSONObject: resp["data"].arrayObject){
                    
                    handle(data.map({ (obj) -> String in
                        return obj.name
                    }))
                }
            }
            
        }) { (error) in
            
        }
        
    }

}


extension BXBContactsVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return clientContactArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clientContactArr[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50 * KScreenRatio_6
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30 * KScreenRatio_6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "BXBContactsCell") as? BXBContactsCell
        if cell == nil {
            cell = BXBContactsCell.init(style: .default, reuseIdentifier: "BXBContactsCell")
        }
        cell?.data = clientContactArr[indexPath.section][indexPath.row]
        cell?.delegate = self
        if isAgendaSelected {
            cell?.tagButton.isHidden = isAgendaSelected
            cell?.tagLabel.isHidden = isAgendaSelected
        }
        if clientContactArr[indexPath.section].count - 1 == indexPath.row { cell?.isNeedSeparatorView = false }
        return cell!
 
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
        
        return v
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isAgendaSelected && handle != nil {
            
            handle!(self.clientContactArr[indexPath.section][indexPath.row])
            navigationController?.popViewController(animated: true)
            
        }
    }

    
    //section index
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionIndexArr as? [String]
    }

    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        print("title: \(title)----index: \(index)")
        if sectionIndexArr.contains(title) {
            tableView.scroll(toRow: 0, inSection: UInt(index), at: .middle, animated: true)
        }
        return index
    }
    
}


extension BXBContactsVC: ContactsAddDelegate {
    
    func didClickAddContact(cell: UITableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            
            if handle != nil {
                handle!(self.clientContactArr[indexPath.section][indexPath.row])
                navigationController?.popViewController(animated: true)
            }
            
        }
    }
}






