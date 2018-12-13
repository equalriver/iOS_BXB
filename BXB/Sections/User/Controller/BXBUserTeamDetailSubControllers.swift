//
//  BXBUserMyTeamDetailControllers.swift
//  BXB
//
//  Created by equalriver on 2018/6/23.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation
import ObjectMapper
import Toast_Swift

//MARK: - 二维码
class BXBUserTeamDetailQRCodeVC: BXBBaseNavigationVC {
    
    public var data = TeamData() {
        willSet{
            bottomLabel_1.text = newValue.teamName
            bottomLabel_2.text = newValue.name + "创建"
        }
    }
    
    lazy var contentView: UIImageView = {
        let v = UIImageView()
        v.layer.contents = UIColor.white.cgColor
        return v
    }()
    lazy var qrIV: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    lazy var logoView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        v.layer.cornerRadius = kCornerRadius
        v.layer.masksToBounds = true
        return v
    }()
    lazy var shareButton: UIButton = {
        let b = UIButton()
        b.backgroundColor = kColor_theme
        b.titleLabel?.font = kFont_text
        b.setTitle("邀请好友加入团队", for: .normal)
        b.setTitleColor(UIColor.white, for: .normal)
        b.layer.cornerRadius = 25 * KScreenRatio_6
        b.layer.masksToBounds = true
        b.layer.borderColor = UIColor.white.cgColor
        b.layer.borderWidth = 1
        b.addTarget(self, action: #selector(shareQRCode(sender:)), for: .touchUpInside)
        return b
    }()
    lazy var bottomLabel_1: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = kColor_theme
        l.textAlignment = .center
        return l
    }()
    lazy var bottomLabel_2: UILabel = {
        let l = UILabel()
        l.font = kFont_text_3
        l.textColor = kColor_dark
        l.textAlignment = .center
        return l
    }()
    lazy var backButton: UIButton = {
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "bxb_返回_白"), for: .normal)
        return b
    }()
    lazy var downLoadBtn: UIButton = {
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "team_下载到本地"), for: .normal)
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    convenience init(teamData: TeamData, qrStr: String) {
        self.init()
        initUI()
        let iv = UIImageView()
        iv.layer.cornerRadius = kCornerRadius
        iv.layer.masksToBounds = true
        iv.setImageWith(URL.init(string: teamData.logo), placeholder: #imageLiteral(resourceName: "team_placeholder"))
        logoView.addSubview(iv)
        iv.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 52 * KScreenRatio_6, height: 52 * KScreenRatio_6))
            make.center.equalTo(logoView)
        }
        
        let img = UIImage.createQRCode(size: 260 * KScreenRatio_6, dataStr: qrStr)
        qrIV.image = img
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        UIImage.init(color: UIColor.white)?.asyncDrawCornerRadius(roundedRect: CGRect.init(x: 0, y: 0, width: 320, height: 355), cornerRadius: 10 * KScreenRatio_6, fillColor: UIColor.clear, callback: { (img) in
            self.contentView.image = img
        })
    }
    
    func initUI() {
        view.backgroundColor = kColor_theme
        view.addSubview(contentView)
        view.addSubview(shareButton)
        contentView.addSubview(qrIV)
        contentView.addSubview(logoView)
        contentView.addSubview(bottomLabel_1)
        contentView.addSubview(bottomLabel_2)
        contentView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 320 * KScreenRatio_6, height: 355 * KScreenRatio_6))
            make.centerX.equalTo(view)
            make.top.equalTo(naviBar.snp.bottom).offset(50 * KScreenRatio_6)
        }
        qrIV.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 260 * KScreenRatio_6, height: 260 * KScreenRatio_6))
            make.top.equalTo(contentView).offset(25 * KScreenRatio_6)
            make.centerX.equalTo(contentView)
        }
        logoView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 60 * KScreenRatio_6, height: 60 * KScreenRatio_6))
            make.center.equalTo(contentView)
        }
        shareButton.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.bottom).offset(30 * KScreenRatio_6)
            make.centerX.equalTo(view)
            make.size.equalTo(CGSize.init(width: 280 * KScreenRatio_6, height: 50 * KScreenRatio_6))
        }
        bottomLabel_1.snp.makeConstraints { (make) in
            make.width.centerX.equalTo(contentView)
            make.top.equalTo(qrIV.snp.bottom).offset(15 * KScreenRatio_6)
        }
        bottomLabel_2.snp.makeConstraints { (make) in
            make.width.centerX.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(-12.5 * KScreenRatio_6)
        }
        
        title = "团队二维码"
        naviBar.titleColor = UIColor.white
        naviBar.naviBackgroundColor = kColor_theme!
        naviBar.leftBarButtons = [backButton]
        naviBar.rightBarButtons = [downLoadBtn]
//        naviBar.titleView.isHidden = true
        naviBar.bottomBlackLineView.isHidden = true
        isNeedBackButton = false
    }
    
    
}

//MARK: - 团队名称
class BXBUserTeamDetailNameVC: BXBBaseNavigationVC {
    
    public var teamId = 0
    
    public var data = TeamData() {
        willSet{
            nameTF.text = newValue.teamName
        }
    }
    
    
    lazy var contentView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        v.layer.cornerRadius = kCornerRadius
        v.layer.masksToBounds = true
        return v
    }()
    
    lazy var nameTF: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString.init(string: "输入新的团队名字(不超过10个字)", attributes: [NSAttributedString.Key.font: kFont_text, NSAttributedString.Key.foregroundColor: kColor_subText!])
        tf.font = kFont_text_weight
        tf.textColor = kColor_dark
        tf.clearButtonMode = .whileEditing
        tf.addTarget(self, action: #selector(nameEditChange(sender:)), for: .editingChanged)
        return tf
    }()
    
    lazy var saveButton: UIButton = {
        let b = UIButton()
        b.titleLabel?.font = kFont_naviBtn_weight
        b.setTitle("保存", for: .normal)
        b.setTitleColor(kColor_theme, for: .normal)
        return b
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
         ToastManager.shared.position = .top
    }
    
    
    func initUI() {
        view.backgroundColor = kColor_background
        view.addSubview(contentView)
        contentView.addSubview(nameTF)
        contentView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 345 * KScreenRatio_6, height: 55 * KScreenRatio_6))
            make.centerX.equalTo(view)
            make.top.equalTo(naviBar.snp.bottom).offset(15 * KScreenRatio_6)
        }
        nameTF.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(15 * KScreenRatio_6)
            make.right.equalTo(contentView).offset(-15 * KScreenRatio_6)
            make.height.centerY.equalTo(contentView)
        }
        
        title = "团队名称"
        naviBar.rightBarButtons = [saveButton]
    }
    
    @objc func nameEditChange(sender: UITextField) {
        guard sender.hasText else { return }
        
        guard sender.markedTextRange == nil else { return }
        if sender.text!.count > kTeamNameTextLimitCount {
            sender.text = String(sender.text!.prefix(kTeamNameTextLimitCount))
            view.makeToast("超出字数限制")
            return
        }
    }
    
}

//MARK: - 团队管理
class BXBUserTeamDetailMemberVC: BXBBaseNavigationVC {
    
    public var teamId = 0
    
    public var isJoinTeam = false
    
    var dataArr = Array<TeamData>()
    
    var applyArr = Array<TeamPersonData>()
    
    lazy var tableView: UITableView = {
        let tb = UITableView.init(frame: .zero, style: .plain)
        tb.separatorStyle = .none
        tb.dataSource = self
        tb.delegate = self
        tb.backgroundColor = kColor_background
        return tb
    }()
    lazy var rightBtn: UIButton = {
        let b = UIButton()
//        b.setImage(#imageLiteral(resourceName: "bxb_更多"), for: .normal)
        b.titleLabel?.font = kFont_naviBtn_weight
        b.setTitle("解散", for: .normal)
        b.setTitleColor(kColor_red, for: .normal)
        return b
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "团队管理"
        if isJoinTeam == false { naviBar.rightBarButtons = [rightBtn] }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(naviBar.snp.bottom)
            make.centerX.width.bottom.equalTo(view)
        }
        
        loadData()
    }
    
    
    //network
    func loadData() {
        BXBNetworkTool.BXBRequest(router: .searchTeamMember(id: self.teamId), success: { (resp) in
            if let apply = Mapper<TeamPersonData>().mapArray(JSONObject: resp["listAplication"].arrayObject){
                self.applyArr.removeAll()
                self.applyArr = apply
            }
            if let d = Mapper<TeamData>().mapArray(JSONObject: resp["data"].arrayObject){
                self.dataArr.removeAll()
                self.dataArr = d
            }
            self.tableView.reloadData()

        }) { (error) in
            
        }
    }

}


//MARK: - 团队简介
class BXBUserTeamDetailIntroVC: BXBBaseNavigationVC {
    
    public var isEditableIntro = false {
        willSet{
            introTV.isUserInteractionEnabled = newValue
            saveButton.isHidden = !newValue
            countLabel.isHidden = !newValue
        }
    }
    
    public var data = TeamData() {
        willSet{
            introTV.text = newValue.remarks
        }
    }
    
    lazy var contentView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        v.layer.cornerRadius = kCornerRadius
        v.layer.masksToBounds = true
        return v
    }()
    
    lazy var introTV: YYTextView = {
        let tv = YYTextView()
        tv.font = kFont_text_2_weight
        tv.textColor = kColor_dark
        tv.delegate = self
        return tv
    }()
    
    lazy var countLabel: UILabel = {
        let l = UILabel()
        l.backgroundColor = UIColor.white
        let str = "0/60"
        let attStr = NSMutableAttributedString.init(string: str)
        attStr.addAttributes([.font: UIFont.systemFont(ofSize: 13 * KScreenRatio_6), .foregroundColor: kColor_theme!], range: NSMakeRange(0, str.count - 3))
        attStr.addAttributes([.font: UIFont.systemFont(ofSize: 13 * KScreenRatio_6), .foregroundColor: kColor_subText!], range: NSMakeRange(str.count - 3, 3))
        l.attributedText = attStr
        return l
    }()
    
    lazy var saveButton: UIButton = {
        let b = UIButton()
        b.titleLabel?.font = kFont_naviBtn_weight
        b.setTitle("保存", for: .normal)
        b.setTitleColor(kColor_theme, for: .normal)
        return b
    }()
    
    let introCount = 60
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isEditableIntro { introTV.becomeFirstResponder() }
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if data.remarks.count > 0 && isEditableIntro == false {
            contentView.snp.updateConstraints { (make) in
                make.size.equalTo(CGSize.init(width: 345 * KScreenRatio_6, height: data.remarks.getStringHeight(font: UIFont.systemFont(ofSize: 15 * KScreenRatio_6), width: kScreenWidth - 20 * KScreenRatio_6) + 60 * KScreenRatio_6))
            }
            introTV.snp.remakeConstraints { (make) in
                make.left.top.equalTo(contentView).offset(10 * KScreenRatio_6)
                make.bottom.right.equalTo(contentView).offset(-15 * KScreenRatio_6)
            }
        }
    }
    
    func initUI() {
        view.backgroundColor = kColor_background
        view.addSubview(contentView)
        contentView.addSubview(introTV)
        contentView.addSubview(countLabel)
        contentView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 345 * KScreenRatio_6, height: 200 * KScreenRatio_6))
            make.centerX.equalTo(view)
            make.top.equalTo(naviBar.snp.bottom).offset(15 * KScreenRatio_6)
        }
        introTV.snp.makeConstraints { (make) in
            make.left.top.equalTo(contentView).offset(10 * KScreenRatio_6)
            make.right.equalTo(contentView).offset(-15 * KScreenRatio_6)
            make.bottom.equalTo(countLabel.snp.top).offset(-15 * KScreenRatio_6)
        }
        countLabel.snp.makeConstraints { (make) in
            make.height.equalTo(20 * KScreenRatio_6)
            make.right.bottom.equalTo(contentView).offset(-15 * KScreenRatio_6)
        }
        
        title = "团队简介"
        naviBar.rightBarButtons = [saveButton]
    }

}










