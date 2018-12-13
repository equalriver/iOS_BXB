//
//  BXBAddNewClientVC.swift
//  BXB
//
//  Created by equalriver on 2018/6/20.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit
import Contacts

class BXBAddNewClientVC: BXBBaseNavigationVC {

    ///是否添加更多信息
    public var isAddMoreInfo = false {
        willSet{
            addMoreBtn.isHidden = newValue
        }
    }
    
    ///是否需要跳转心得
    public var agendaData: AgendaData?
    
    public var data = ClientData()
    
    ///点击的地址cell
    var selectedAddressIndexPath: IndexPath!
    
    let incomes = ["10", "20", "30", "40", "50"]
    
    lazy var nameCell: BXBAddNewClientCell = {
        let c = BXBAddNewClientCell.init(style: .default, reuseIdentifier: nil)
        c.inputTF.attributedPlaceholder = NSAttributedString.init(string: "请输入姓名", attributes: [NSAttributedString.Key.font: kFont_text, NSAttributedString.Key.foregroundColor: kColor_subText!])
        c.inputTF.addBlock(for: .editingChanged, block: { [unowned self](t) in
            guard c.inputTF.hasText else { return }
            guard c.inputTF.markedTextRange == nil else { return }
            if c.inputTF.text!.count > kNameTextLimitCount {
                c.inputTF.text = String(c.inputTF.text!.prefix(kNameTextLimitCount))
            }
            
        })
        return c
    }()
    
    lazy var phoneCell: BXBAddNewClientCell = {
        let c = BXBAddNewClientCell.init(style: .default, reuseIdentifier: nil)
        c.inputTF.attributedPlaceholder = NSAttributedString.init(string: "请输入手机号", attributes: [NSAttributedString.Key.font: kFont_text, NSAttributedString.Key.foregroundColor: kColor_subText!])
        c.inputTF.keyboardType = .numbersAndPunctuation
        c.inputTF.addBlock(for: .editingChanged, block: { [unowned self](t) in
            guard c.inputTF.hasText else { return }
            c.inputTF.text = String(c.inputTF.text!.prefix(11)).filter({ (c) -> Bool in
                return String(c).isAllNumber
            })
        })
        return c
    }()
    
    lazy var tableView: UITableView = {
        let tb = UITableView.init(frame: .zero, style: .plain)
        tb.backgroundColor = UIColor.white
        tb.separatorStyle = .none
        tb.dataSource = self
        tb.delegate = self
        tb.layer.cornerRadius = kCornerRadius
        tb.layer.masksToBounds = true
        tb.showsVerticalScrollIndicator = false
        return tb
    }()
    
    lazy var addMoreBtn: UIButton = {
        let b = UIButton()
        b.setTitle("添加更多信息", for: .normal)
        b.setTitleColor(kColor_theme, for: .normal)
        b.titleLabel?.font = kFont_text_weight
        b.addTarget(self, action: #selector(showMoreInfo(sender:)), for: .touchUpInside)
        return b
    }()
    lazy var addButton: ImageTopButton = {
        let b = ImageTopButton()
        b.titleLabel?.font = kFont_text_3
        b.setTitle("添加", for: .normal)
        b.setTitleColor(kColor_text, for: .normal)
        b.setImage(#imageLiteral(resourceName: "bxb_btn完成"), for: .normal)
        b.addTarget(self, action: #selector(addNewClient(sender:)), for: .touchUpInside)
        return b
    }()
    
    lazy var batchButton: UIButton = {
        let b = UIButton()
        b.setTitle("通讯录导入", for: .normal)
        b.setTitleColor(kColor_theme, for: .normal)
        b.titleLabel?.font = kFont_naviBtn_weight
        return b
    }()
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        naviBar.rightBarButtons = [batchButton]
    }
    
    func initUI() {
        title = "新建客户"
        view.backgroundColor = kColor_background
        view.addSubview(tableView)
        view.addSubview(addMoreBtn)
        view.addSubview(addButton)
        tableView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.width.equalTo(345 * KScreenRatio_6)
            make.top.equalTo(naviBar.snp.bottom).offset(15 * KScreenRatio_6)
            make.height.equalTo(2 * 55 * KScreenRatio_6)
        }
        addMoreBtn.snp.makeConstraints { (make) in
            make.top.equalTo(tableView.snp.bottom).offset(15 * KScreenRatio_6)
            make.centerX.equalTo(view)
            make.height.equalTo(20 * KScreenRatio_6)
        }
        addButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view).offset(-10 * KScreenRatio_6 - kIphoneXBottomInsetHeight)
            make.size.equalTo(CGSize.init(width: 100 * KScreenRatio_6, height: 100 * KScreenRatio_6))
            make.centerX.equalTo(view)
        }
    }

    //MARK: - action
    //从通讯录导入
    override func rightButtonsAction(sender: UIButton) {
        super.rightButtonsAction(sender: sender)
        let status = CNContactStore.authorizationStatus(for: .contacts)
        switch status {
        case .notDetermined:
            let store = CNContactStore()
            store.requestAccess(for: .contacts) { (finish, error) in
                DispatchQueue.main.async {
                    if error == nil {
                        self.openContact()
                    }
                    else { gotoAuthorizationView(vc: self) }
                }
            }
            
        case .authorized:
            self.openContact()
            
        default:
            gotoAuthorizationView(vc: self)
        }
        
        
    }
    
    func openContact() {
        
        let vc = BXBContactsVC.init { (contactData) in
            
            BXBNetworkTool.BXBRequest(router: .validateClient(name: contactData.name), success: { (resp) in
                let code = resp["responseCode"].stringValue
                if code == "客户名已存在" { self.view.makeToast("客户名已存在") }
                else {
                    self.nameCell.inputTF.text = contactData.name
                    self.phoneCell.inputTF.text = contactData.phone
                }
                
            }) { (error) in
                
            }
        }
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func showMoreInfo(sender: UIButton) {
        isAddMoreInfo = true
        self.tableView.snp.updateConstraints({ (make) in
            make.height.equalTo(480 * KScreenRatio_containX + 2)
        })
        self.tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
            self.tableView.scroll(toRow: 2, inSection: 0, at: .top, animated: true)
        }
    }
    
    @objc func addNewClient(sender: UIButton) {
        
        if nameCell.inputTF.hasText == false {
            view.makeToast("未填写姓名")
            return
        }
        
        if phoneCell.inputTF.hasText {
            data.phone = phoneCell.inputTF.text!
        }
        data.name = nameCell.inputTF.text!
        
        let args: [String: Any] = ["name": data.name, "phone": data.phone, "residentialAddress": data.residentialAddress, "workingAddress": data.workingAddress, "birthday": data.birthday, "sex": data.sex, "income": data.income, "marriageStatus": data.marriageStatus, "educationName": data.educationName, "educationKey": data.educationKey, "introducerId": data.introducerId, "grade": data.grade, "label": data.label, "status": data.status, "remarks": data.remarks, "latitude": data.latitude, "longitude": data.longitude, "workLatitude": data.workLatitude, "workLongitude": data.workLongitude, "unitAddress": data.unitAddress, "workUnitAddress": data.workUnitAddress]
        
        if self.agendaData != nil {
            let vc = BXBAgendaDetailEditVC()
            vc.titleText = "说点什么吧..."
            vc.data = self.agendaData!
            vc.isNeedPopToRootVC = true
            vc.addClientParams = args
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else{
            sender.isUserInteractionEnabled = false
            
            BXBNetworkTool.BXBRequest(router: .addClient(args: args), success: { (resp) in
                sender.isUserInteractionEnabled = true
                
                NotificationCenter.default.post(name: .kNotiClientShouldRefreshData, object: nil)
                archiverUserData(datas: nil)
                self.navigationController?.popViewController(animated: true)
                
            }) { (error) in
                sender.isUserInteractionEnabled = true
            }
        }
        
    }

}








