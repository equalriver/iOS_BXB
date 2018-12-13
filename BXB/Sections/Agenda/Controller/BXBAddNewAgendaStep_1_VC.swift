//
//  BXBAddNewAgendaStep_1_VC.swift
//  BXB
//
//  Created by equalriver on 2018/8/19.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit
import Toast_Swift

class BXBAddNewAgendaStep_1_VC: BXBBaseNavigationVC {
    
    
    public var type = "" {
        willSet{
            data.visitTypeName = newValue
            title = newValue
        }
    }
    
    public var selectDate: Date? {
        didSet{
            createFullDate()
        }
    }
    
    public var agendaData = AgendaData() {
        willSet{
            nameTF.text = newValue.name
            data.name = newValue.name
            data.address = newValue.address
            data.detailAddress = newValue.detailAddress
            data.lat = newValue.lat
            data.lng = newValue.lng
        }
    }
    
    public var clientNearData = ClientNearData() {
        willSet{
            nameTF.text = newValue.name
            data.name = newValue.name
            data.address = newValue.residentialAddress
            data.detailAddress = newValue.unitAddress
            data.lat = newValue.latitude
            data.lng = newValue.longitude
        }
    }
    
    public var noticeData = NoticeDetailData() {
        willSet{
            nameTF.text = newValue.name
            data.name = newValue.name
            data.isWorkData = newValue.isWorkData
            data.noticeId = newValue.id
            data.isNoticeFollow = true
        }
    }
    
    public var selectedDate = Date()
    
    var data = AgendaData()
    
    let matters = ["运动", "旅游", "健身", "娱乐", "吃饭", "美容", "羽毛球", "美甲", "美发"]
    
    //模糊搜索客户名相关
    var searchDatas = Set<String>()
    var dataArr = Array<ClientContactData>()
    var remoteClientNameArr = Array<String>()
    var searchFilterDatas = Array<String>()
    
    lazy var nameTitleLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = kColor_text
        l.text = "拜访对象"
        return l
    }()
    lazy var nameContentView: UIView = {
        let v = UIView()
        v.layer.contents = #imageLiteral(resourceName: "agenda_白色底").cgImage
        return v
    }()
    lazy var nameTF: UITextField = {
        let f = UITextField()
        f.font = kFont_text_2_weight
        f.textColor = kColor_dark
        f.clearButtonMode = .whileEditing
        f.attributedPlaceholder = NSAttributedString.init(string: "请输入客户姓名", attributes: [NSAttributedString.Key.font: kFont_text_2, NSAttributedString.Key.foregroundColor: kColor_subText!])
        f.addTarget(self, action: #selector(nameTextFieldEditChange(sender:)), for: .editingChanged)
//        f.addTarget(self, action: #selector(nameTextFieldEditEnd(sender:)), for: .editingDidEnd)
        return f
    }()
    lazy var searchTV: UITableView = {
        let tb = UITableView.init(frame: .zero, style: .plain)
        tb.backgroundColor = kColor_background
        tb.dataSource = self
        tb.delegate = self
        tb.showsVerticalScrollIndicator = false
        tb.isHidden = true
        tb.bounces = false
        tb.separatorStyle = .none
        tb.layer.cornerRadius = kCornerRadius
        tb.layer.masksToBounds = true
        return tb
    }()
    lazy var searchShadow: UIView = {
        let v = UIView()
        v.layer.backgroundColor = UIColor.clear.cgColor
        v.setLayerShadow(kColor_separatorView, offset: CGSize.zero, radius: 10)
        return v
    }()
    lazy var sepView: UIView = {
        let v = UIView()
        v.backgroundColor = kColor_background
        return v
    }()
    lazy var contactBtn: UIButton = {
        let b = UIButton()
        b.titleLabel?.font = kFont_text_2_weight
        b.setTitleColor(kColor_theme, for: .normal)
        b.setTitle("从通讯录导入", for: .normal)
        b.addTarget(self, action: #selector(gotoContact), for: .touchUpInside)
        return b
    }()
    lazy var timeTitleLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = kColor_text
        l.text = "开始时间"
        return l
    }()
    lazy var timeContentView: UIView = {
        let v = UIView()
        v.layer.contents = #imageLiteral(resourceName: "agenda_白色底").cgImage
        return v
    }()
    lazy var timeLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = kColor_dark
        l.text = dateFormatter.string(from: Date())
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(datePickerAlert))
        l.addGestureRecognizer(tap)
        return l
    }()
    lazy var datePicker: UIDatePicker = {
        let p = UIDatePicker.init()
        p.setDate(Date(), animated: false)
        p.backgroundColor = UIColor.white
        p.datePickerMode = .dateAndTime
        p.locale = .init(identifier: "zh")
        p.addTarget(self, action: #selector(dateChanged(sender:)), for: .valueChanged)
        return p
    }()
    lazy var matterTitleLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = kColor_text
        l.text = "客户维护事项"
        l.isHidden = true
        return l
    }()
    lazy var matterContentView: UIView = {
        let v = UIView()
        v.layer.contents = #imageLiteral(resourceName: "agenda_白色底").cgImage
        v.isHidden = true
        return v
    }()
    lazy var matterTF: UITextField = {
        let f = UITextField()
        f.font = kFont_text_2_weight
        f.textColor = kColor_dark
        f.clearButtonMode = .whileEditing
        f.attributedPlaceholder = NSAttributedString.init(string: "请输入事项", attributes: [NSAttributedString.Key.font: kFont_text_2, NSAttributedString.Key.foregroundColor: kColor_subText!])
        f.isHidden = true
        f.addBlock(for: .editingChanged, block: { [unowned self](t) in
            guard f.hasText else { return }
            guard f.markedTextRange == nil else { return }
            if f.text!.count > kCostMatterTextLimitCount {
                if let v = UIApplication.shared.keyWindow {
                    v.makeToast("超出字数限制")
                }
                f.text = String(f.text!.prefix(kCostMatterTextLimitCount))
            }
            
        })
        return f
    }()
    lazy var matterCV: UICollectionView = {
        let l = UICollectionViewFlowLayout()
        l.itemSize = CGSize.init(width: 60 * KScreenRatio_6, height: 30 * KScreenRatio_6)
        l.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        l.minimumLineSpacing = 10
        l.minimumInteritemSpacing = 5
        l.scrollDirection = .vertical
        let cv = UICollectionView.init(frame: .zero, collectionViewLayout: l)
        cv.backgroundColor = kColor_background
        cv.isHidden = true
        cv.isScrollEnabled = false
        cv.dataSource = self
        cv.delegate = self
        cv.register(BXBAddNewAgendaStep_1_CVCell.self, forCellWithReuseIdentifier: "BXBAddNewAgendaStep_1_CVCell")
        return cv
    }()
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm"
        return formatter
    }()
    lazy var dateFormatterStd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }()
    lazy var checkBtn: UIButton = {
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "bxb_勾选框"), for: .normal)
        b.setImage(UIImage.init(named: "client_勾"), for: .selected)
        b.addTarget(self, action: #selector(checkAction), for: .touchUpInside)
        return b
    }()
    lazy var checkTitleLabel: UILabel = {
        let l = UILabel()
        let s1 = "补充地址、提醒和备注"
        let s2 = "(可不填)"
        let att = NSMutableAttributedString.init(string: s1 + s2)
        att.addAttributes([NSAttributedString.Key.font: kFont_text_2, NSAttributedString.Key.foregroundColor: kColor_text!], range: NSMakeRange(0, s1.count))
        att.addAttributes([NSAttributedString.Key.font: kFont_text_2, NSAttributedString.Key.foregroundColor: kColor_subText!], range: NSMakeRange(s1.count, s2.count))
        l.attributedText = att
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(checkAction))
        l.addGestureRecognizer(tap)
        l.isUserInteractionEnabled = true
        return l
    }()
    lazy var confirmBtn: ImageTopButton = {
        let b = ImageTopButton()
        b.titleLabel?.font = kFont_text_3
        b.setTitle("完成", for: .normal)
        b.setTitleColor(kColor_text, for: .normal)
        b.setImage(#imageLiteral(resourceName: "bxb_btn完成"), for: .normal)
        b.addTarget(self, action: #selector(confirmAction(sender:)), for: .touchUpInside)
        return b
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = kColor_background
        naviBar.naviBackgroundColor = kColor_background!
        
        initUI()
        filterContact()
        
        makeUserGuideForAddNewAgenda()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ToastManager.shared.position = .top
    }
    
    func initUI() {
        view.addSubview(nameTitleLabel)
        view.addSubview(nameContentView)
        nameContentView.addSubview(nameTF)
        nameContentView.addSubview(sepView)
        nameContentView.addSubview(contactBtn)
        view.addSubview(timeTitleLabel)
        view.addSubview(timeContentView)
        timeContentView.addSubview(timeLabel)
        timeContentView.addSubview(datePicker)
        view.addSubview(matterContentView)
        view.addSubview(matterTitleLabel)
        matterContentView.addSubview(matterTF)
        view.addSubview(matterCV)
        view.addSubview(checkBtn)
        view.addSubview(checkTitleLabel)
        view.addSubview(confirmBtn)
        view.addSubview(searchShadow)
        searchShadow.addSubview(searchTV)
        makeConstraints()
        if type == "客户服务" {
            datePicker.isHidden = true
            matterContentView.isHidden = false
            matterTitleLabel.isHidden = false
            matterTF.isHidden = false
            matterCV.isHidden = false
            timeLabel.isUserInteractionEnabled = true
            makeMattersConstraints()
        }
    }
    
    func makeConstraints() {
        nameTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(20 * KScreenRatio_6)
            make.top.equalTo(naviBar.snp.bottom).offset( 20 * KScreenRatio_6)
        }
        nameContentView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.size.equalTo(CGSize.init(width: 345 * KScreenRatio_6, height: 55 * KScreenRatio_6))
            make.top.equalTo(nameTitleLabel.snp.bottom).offset(20 * KScreenRatio_6)
        }
        nameTF.snp.makeConstraints { (make) in
            make.left.equalTo(nameContentView).offset(15 * KScreenRatio_6)
            make.centerY.equalTo(nameContentView)
//            make.size.equalTo(CGSize.init(width: 170 * KScreenRatio_6, height: 40 * KScreenRatio_6))
            make.height.equalTo(40 * KScreenRatio_6)
            make.right.equalTo(sepView.snp.left).offset(-15 * KScreenRatio_6)
        }
        searchShadow.snp.makeConstraints { (make) in
            make.left.equalTo(nameContentView)
            make.right.equalTo(sepView)
            make.top.equalTo(nameContentView.snp.bottom).offset(2)
            make.height.equalTo(160 * KScreenRatio_6)
        }
        searchTV.snp.makeConstraints { (make) in
            make.left.equalTo(nameContentView)
            make.right.equalTo(sepView)
            make.top.equalTo(nameContentView.snp.bottom).offset(2)
            make.height.equalTo(160 * KScreenRatio_6)
        }
        sepView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 1, height: 30 * KScreenRatio_6))
            make.centerY.equalTo(nameContentView)
            make.right.equalTo(contactBtn.snp.left).offset(-2)
        }
        contactBtn.snp.makeConstraints { (make) in
            make.height.right.centerY.equalTo(nameContentView)
            make.width.equalTo(120 * KScreenRatio_6)
        }
        timeTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameContentView.snp.bottom).offset(30 * KScreenRatio_6)
            make.left.equalTo(nameTitleLabel)
        }
        timeContentView.snp.makeConstraints { (make) in
            make.left.width.equalTo(nameContentView)
            make.top.equalTo(timeTitleLabel.snp.bottom).offset(20 * KScreenRatio_6)
            make.height.equalTo(255 * KScreenRatio_6)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(timeContentView).offset(15 * KScreenRatio_6)
            make.right.equalTo(timeContentView).offset(-15 * KScreenRatio_6)
            make.top.equalTo(timeContentView)
            make.height.equalTo(50 * KScreenRatio_6)
        }
        datePicker.snp.makeConstraints { (make) in
            make.top.equalTo(timeLabel.snp.bottom).offset(5)
            make.bottom.width.centerX.equalTo(timeContentView)
        }
        checkBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 30, height: 30))
            make.left.equalTo(view).offset(70 * KScreenRatio_6)
            make.bottom.equalTo(view).offset(-120 * KScreenRatio_6 - kIphoneXBottomInsetHeight)
        }
        checkTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(checkBtn.snp.right).offset(5)
            make.centerY.equalTo(checkBtn)
            make.right.equalTo(view).offset(-10)
            make.height.equalTo(30 * KScreenRatio_6)
        }
        confirmBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 100 * KScreenRatio_6, height: 100 * KScreenRatio_6))
            make.centerX.equalTo(view)
            make.top.equalTo(checkTitleLabel.snp.bottom).offset(15 * KScreenRatio_6)
        }
    }
    
    func makeMattersConstraints() {
        timeContentView.snp.remakeConstraints { (make) in
            make.left.width.equalTo(nameContentView)
            make.top.equalTo(timeTitleLabel.snp.bottom).offset(20 * KScreenRatio_6)
            make.height.equalTo(55 * KScreenRatio_6)
        }
        matterTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(timeLabel.snp.bottom).offset(30 * KScreenRatio_6)
            make.left.equalTo(nameTitleLabel)
        }
        matterContentView.snp.makeConstraints { (make) in
            make.left.width.equalTo(nameContentView)
            make.top.equalTo(matterTitleLabel.snp.bottom).offset(20 * KScreenRatio_6)
            make.height.equalTo(55 * KScreenRatio_6)
        }
        matterTF.snp.makeConstraints { (make) in
            make.left.equalTo(matterContentView).offset(15 * KScreenRatio_6)
            make.right.equalTo(matterContentView).offset(-15 * KScreenRatio_6)
            make.centerY.equalTo(matterContentView)
            make.height.equalTo(40 * KScreenRatio_6)
        }
        matterCV.snp.makeConstraints { (make) in
            make.width.left.equalTo(matterContentView)
            make.top.equalTo(matterContentView.snp.bottom).offset(10 * KScreenRatio_6)
            make.height.equalTo(80 * KScreenRatio_6)
        }
    }
    
    

}












