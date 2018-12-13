//
//  BXBUserinfoEditVC.swift
//  BXB
//
//  Created by equalriver on 2018/6/22.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit
import ObjectMapper

class BXBUserinfoEditVC: BXBBaseNavigationVC {
    
    var data = UserData()
    
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
    
//    lazy var quitButton: UIButton = {
//        let b = UIButton()
//        b.setTitle("退出登录", for: .normal)
//        b.setTitleColor(kColor_theme, for: .normal)
//        b.addTarget(self, action: #selector(quitLogin), for: .touchUpInside)
//        return b
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        loadData()
    }

    func initUI() {
        view.backgroundColor = kColor_background
        view.addSubview(tableView)
//        view.addSubview(quitButton)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(naviBar.snp.bottom).offset(15 * KScreenRatio_6)
            make.centerX.equalTo(view)
            make.size.equalTo(CGSize.init(width: 345 * KScreenRatio_6, height: 7 * 55 * KScreenRatio_6 + 35 * KScreenRatio_6))
        }
//        quitButton.snp.makeConstraints { (make) in
//            make.size.equalTo(CGSize.init(width: kScreenWidth, height: 40 * KScreenRatio_6 + kIphoneXBottomInsetHeight))
//            make.bottom.centerX.equalTo(view)
//        }
        title = "修改个人信息"
    }
    
    
    //MARK: - action
    override func leftButtonsAction(sender: UIButton) {
        NotificationCenter.default.post(name: .kNotiUserShouldRefreshData, object: nil)
        super.leftButtonsAction(sender: sender)
    }

    //MARK: - network
    func loadData() {
        BXBNetworkTool.BXBRequest(router: .userDetail(), success: { (resp) in
            if let d = Mapper<UserData>().map(JSONObject: resp["user"].object) {
                self.data = d
                self.tableView.reloadData()
            }
        }) { (error) in
            
        }
    }
    
}

extension BXBUserinfoEditVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 5 : 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55 * KScreenRatio_6
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 35 * KScreenRatio_6 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BXBUserinfoEditCell.init(style: .default, reuseIdentifier: nil)
        if indexPath.section == 0 {
            cell.titleLabel.text = ["姓名", "手机", "性别", "生日", "婚姻状态"][indexPath.row]
            switch indexPath.row {
            case 0://姓名
                cell.subTitleLabel.text = data.name.count > 0 ? data.name : "未设置"
                
            case 1://手机
                cell.rightIV.isHidden = true
                cell.subTitleLabel.text = data.userName.count > 0 ? data.userName : ""
                
            case 2://性别
                cell.subTitleLabel.text = data.sex.count > 0 ? data.sex : "未设置"
                
            case 3://生日
                cell.subTitleLabel.text = data.birthday.count > 0 ? data.birthday : "未设置"
                
            case 4://婚姻状态
                cell.isNeedSeparatorView = false
                cell.subTitleLabel.text = data.marriageStatus.count > 0 ? data.marriageStatus : "未设置"
            default: break
            }
        }
        else{
            cell.titleLabel.text = ["签名", "简介"][indexPath.row]
            if indexPath.row == 0 {
                cell.subTitleLabel.text = data.signature.count > 0 ? data.signature : "未设置"
            }
            else {
                cell.isNeedSeparatorView = false
                cell.subTitleLabel.text = data.introduce.count > 0 ? data.introduce : "未设置"
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 35 * KScreenRatio_6))
        v.backgroundColor = kColor_background
        return v
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 4 {
            let maskPath = UIBezierPath.init(roundedRect: cell.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize.init(width: 5, height: 5))
            let maskLayer = CAShapeLayer()
            maskLayer.strokeColor = kColor_background!.cgColor
            maskLayer.frame = cell.bounds
            maskLayer.path = maskPath.cgPath
            cell.layer.mask = maskLayer
        }
        if indexPath.section == 1 && indexPath.row == 0 {
            let maskPath = UIBezierPath.init(roundedRect: cell.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize.init(width: 5, height: 5))
            let maskLayer = CAShapeLayer()
            maskLayer.strokeColor = kColor_background!.cgColor
            maskLayer.frame = cell.contentView.bounds
            maskLayer.path = maskPath.cgPath
            cell.layer.mask = maskLayer
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //生日
        if indexPath.section == 0 {
            
            if indexPath.row == 1 { return }//电话
            
            if indexPath.row == 3 {
                let datePicker = AgendaDetailDatePickerAlert.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)) { (date) in
                    
                    BXBNetworkTool.BXBRequest(router: .editUser(args: ["birthday": date]), success: { (resp) in
                        self.loadData()
                    }, failure: { (error) in
                        
                    })
                    
                }
                datePicker.datePicker.datePickerMode = .date
                datePicker.dateFormatter.dateFormat = "yyyy-MM-dd"
                self.view.addSubview(datePicker)
                return
            }
        }
        
        let vc = AddNewClientEditInfoVC.init { [unowned self](str) in
            
            var paramName = ""
            
            if indexPath.section == 0 {

                switch indexPath.row {
                case 0: //姓名
                    paramName = "name"
                    
//                case 1: //手机
//                    paramName = "phone"
                    
                case 2: //性别
                    paramName = "sex"
                    
                    
                case 4: //婚姻状态
                    paramName = "marriageStatus"
                    
                default:
                    break
                }
            }
            else{
                if indexPath.row == 0 {//签名
                    paramName = "signature"
                }
                else{//个人简介
                    paramName = "introduce"
                }
            }
            
            BXBNetworkTool.BXBRequest(router: .editUser(args: [paramName: str]), success: { (resp) in
                
                self.loadData()
                
            }, failure: { (error) in
                
            })
            
        }
        if indexPath.section == 0 {
            vc.titleInfo = ["姓名", "手机", "性别", "生日", "婚姻状态"][indexPath.row]
        }
        else {
            vc.titleInfo = ["签名", "简介"][indexPath.row]
//            vc.detailText = [data.signature, data.introduce][indexPath.row]
        }
        vc.data = data
        navigationController?.pushViewController(vc, animated: true)
        
    }
}

class BXBUserinfoEditCell: BXBBaseTableViewCell {
    
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = kColor_dark
        return l
    }()
    lazy var subTitleLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text
        l.textColor = kColor_subText
        l.textAlignment = .right
        l.text = "未设置"
        l.numberOfLines = 1
        return l
    }()
    lazy var rightIV: UIImageView = {
        let iv = UIImageView.init(image: #imageLiteral(resourceName: "rightArrow"))
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(rightIV)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(15 * KScreenRatio_6)
            make.height.centerY.equalTo(contentView)
            make.width.equalTo(100 * KScreenRatio_6)
        }
        subTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right).offset(5)
            make.centerY.height.equalTo(contentView)
            make.right.equalTo(rightIV.snp.left).offset(-10 * KScreenRatio_6)
        }
        rightIV.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).offset(-15 * KScreenRatio_6)
            make.size.equalTo(CGSize.init(width: 5, height: 9))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}









