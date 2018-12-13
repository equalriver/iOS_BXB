//
//  BXBUserSettingVC.swift
//  BXB
//
//  Created by equalriver on 2018/8/31.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit

class BXBUserSettingVC: BXBBaseNavigationVC {

    lazy var tableView: UITableView = {
        let tb = UITableView.init(frame: .zero, style: .plain)
        tb.separatorStyle = .none
        tb.backgroundColor = UIColor.white
        tb.isScrollEnabled = false
        tb.layer.cornerRadius = kCornerRadius
        tb.layer.masksToBounds = true
        tb.dataSource = self
        tb.delegate = self
        return tb
    }()
    lazy var quitButton: UIButton = {
        let b = UIButton()
        b.backgroundColor = UIColor.white
        b.layer.cornerRadius = kCornerRadius
        b.layer.masksToBounds = true
        b.titleLabel?.font = kFont_text_weight
        b.setTitle("退出登录", for: .normal)
        b.setTitleColor(kColor_red, for: .normal)
        b.addTarget(self, action: #selector(quitLogin), for: .touchUpInside)
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "设置"
        view.backgroundColor = kColor_background
        view.addSubview(tableView)
        view.addSubview(quitButton)
        tableView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 345 * KScreenRatio_6, height: 55 * KScreenRatio_6))
            make.top.equalTo(naviBar.snp.bottom).offset(20)
            make.centerX.equalTo(view)
        }
        quitButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 345 * KScreenRatio_6, height: 55 * KScreenRatio_6))
            make.centerX.equalTo(view)
            make.bottom.equalTo(view).offset(-20 * KScreenRatio_6 - kIphoneXBottomInsetHeight)
        }
        
        guard UserDefaults.standard.string(forKey: "token") != nil else {
            quitButton.setTitle("登 录", for: .normal)
            return
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard UserDefaults.standard.string(forKey: "token") != nil else {
            quitButton.setTitle("登 录", for: .normal)
            return
        }
        quitButton.setTitle("退出登录", for: .normal)
    }

    
    //MARK: - action
    @objc func quitLogin() {
        
        loginValidate(currentVC: self) { (isLogin) in
            if isLogin {
                let alert = UIAlertController.init(title: nil, message: "确定退出登录吗?", preferredStyle: .alert)
                let action = UIAlertAction.init(title: "确定", style: .default) { (ac) in
                    BXBNetworkTool.BXBRequest(router: .loginOut(), success: { (resp) in
                        
                        UserDefaults.standard.set(nil, forKey: "token")
                        UserDefaults.standard.synchronize()
                        do{
                            try FileManager.default.removeItem(atPath: kClientDataFilePath)
                        }catch{ print("remove local client data fail: \(error)") }
                        
                        NotificationCenter.default.post(name: .kNotiAgendaShouldRefreshData, object: nil, userInfo: ["loginOut": true])
                        NotificationCenter.default.post(name: .kNotiClientShouldRefreshData, object: nil, userInfo: ["loginOut": true])
                        NotificationCenter.default.post(name: .kNotiRemindShouldRefreshData, object: nil, userInfo: ["loginOut": true])
                        NotificationCenter.default.post(name: .kNotiUserShouldRefreshData, object: nil, userInfo: ["loginOut": true])
                        self.navigationController?.popViewController(animated: true)
                        
                    }, failure: { (error) in
                        
                    })
                }
                let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
                alert.addAction(action)
                alert.addAction(cancel)
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
    }
}


extension BXBUserSettingVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55 * KScreenRatio_6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BXBUserSettingCell.init(style: .default, reuseIdentifier: nil)
        cell.titleLabel.text = ["关于"][indexPath.row]
        cell.isNeedSeparatorView = false
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = BXBUserAboutVC()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}


class BXBUserSettingCell: BXBBaseTableViewCell {
    
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = kColor_dark
        return l
    }()
    lazy var arrowIV: UIImageView = {
        let iv = UIImageView.init(image: #imageLiteral(resourceName: "rightArrow"))
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowIV)
        titleLabel.snp.makeConstraints { (make) in
            make.height.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(15 * KScreenRatio_6)
            make.right.equalTo(contentView).offset(-50 * KScreenRatio_6)
        }
        arrowIV.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).offset(-15 * KScreenRatio_6)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: - 关于我们
class BXBUserAboutVC: BXBBaseNavigationVC {
    
    lazy var iconIV: UIImageView = {
        let iv = UIImageView.init(image: #imageLiteral(resourceName: "login_保记"))
        return iv
    }()
    lazy var versionLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_3
        l.textColor = kColor_text
        l.textAlignment = .center
        if let v = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            l.text = "v" + v
        }
        return l
    }()
    lazy var tableView: UITableView = {
        let tb = UITableView.init(frame: .zero, style: .plain)
        tb.separatorStyle = .none
        tb.backgroundColor = UIColor.white
        tb.isScrollEnabled = false
        tb.layer.cornerRadius = kCornerRadius
        tb.layer.masksToBounds = true
        tb.dataSource = self
        tb.delegate = self
        return tb
    }()
    lazy var agreementBtn: UIButton = {
        let b = UIButton()
        b.titleLabel?.font = kFont_text_3
        b.setTitle("服务条款", for: .normal)
        b.setTitleColor(kColor_theme, for: .normal)
        b.addTarget(self, action: #selector(agreementAction), for: .touchUpInside)
        return b
    }()
    lazy var privacyBtn: UIButton = {
        let b = UIButton()
        b.titleLabel?.font = kFont_text_3
        b.setTitle("隐私政策", for: .normal)
        b.setTitleColor(kColor_theme, for: .normal)
        b.addTarget(self, action: #selector(privacyAction), for: .touchUpInside)
        return b
    }()
    lazy var sepView: UIView = {
        let v = UIView()
        v.backgroundColor = kColor_theme
        return v
    }()
    lazy var copyrightLabel: UILabel = {
        let l = UILabel()
        l.textColor = kColor_text
        l.font = UIFont.systemFont(ofSize: 10 * KScreenRatio_6)
        l.textAlignment = .center
        let f = DateFormatter()
        f.dateFormat = "yyyy"
        l.text = "Copyright @\(f.string(from: Date())) All Rights Reserved"
        return l
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "关于"
        naviBar.naviBackgroundColor = UIColor.white
        view.backgroundColor = kColor_background
        initUI()
    }
    
    func initUI() {
        view.addSubview(iconIV)
        view.addSubview(versionLabel)
        view.addSubview(tableView)
        view.addSubview(privacyBtn)
        view.addSubview(agreementBtn)
        view.addSubview(sepView)
        view.addSubview(copyrightLabel)
        iconIV.snp.makeConstraints { (make) in
            make.top.equalTo(naviBar.snp.bottom).offset(85 * KScreenRatio_6)
            make.centerX.equalTo(view)
        }
        versionLabel.snp.makeConstraints { (make) in
            make.width.centerX.equalTo(view)
            make.top.equalTo(iconIV.snp.bottom)
        }
        tableView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 345 * KScreenRatio_6, height: 165 * KScreenRatio_6))
            make.centerX.equalTo(view)
            make.top.equalTo(versionLabel.snp.bottom).offset(40 * KScreenRatio_6)
        }
        agreementBtn.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(110 * KScreenRatio_6 - 0.5)
            make.bottom.equalTo(view).offset(-kIphoneXBottomInsetHeight - 35 * KScreenRatio_6)
            make.size.equalTo(CGSize.init(width: 77 * KScreenRatio_6, height: 30 * KScreenRatio_6))
        }
        privacyBtn.snp.makeConstraints { (make) in
            make.right.equalTo(view).offset(-110 * KScreenRatio_6 + 0.5)
            make.centerY.equalTo(agreementBtn)
            make.size.equalTo(CGSize.init(width: 77 * KScreenRatio_6, height: 30 * KScreenRatio_6))
        }
        sepView.snp.makeConstraints { (make) in
            make.centerY.equalTo(agreementBtn)
            make.left.equalTo(agreementBtn.snp.right)
            make.size.equalTo(CGSize.init(width: 1, height: 10 * KScreenRatio_6))
        }
        copyrightLabel.snp.makeConstraints { (make) in
            make.width.centerX.equalTo(view)
            make.bottom.equalTo(view).offset(-kIphoneXBottomInsetHeight - 15 * KScreenRatio_6)
        }
    }
    
    @objc func privacyAction() {
        let vc = BXBUserPrivacyVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func agreementAction() {
        let vc = BXBUserAgreementVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension BXBUserAboutVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55 * KScreenRatio_6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UserAboutCell.init(style: .default, reuseIdentifier: nil)
        cell.titleLabel.text = ["QQ群", "邮箱", "版权所有"][indexPath.row]
        cell.detialLabel.text = ["857313494", "bxbsupport@163.com", "保记团队"][indexPath.row]
        
        if indexPath.row == 2 {
            cell.isNeedSeparatorView = false
        }
        return cell
    }
}

class UserAboutCell: BXBBaseTableViewCell {
    
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = kColor_dark
        return l
    }()
    lazy var detialLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text
        l.textColor = kColor_subText
        l.textAlignment = .right
        return l
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detialLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.height.equalTo(contentView)
            make.left.equalTo(contentView).offset(15 * KScreenRatio_6)
            make.width.equalTo(80 * KScreenRatio_6)
        }
        detialLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right)
            make.centerY.height.equalTo(contentView)
            make.right.equalTo(contentView).offset(-15 * KScreenRatio_6)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}








