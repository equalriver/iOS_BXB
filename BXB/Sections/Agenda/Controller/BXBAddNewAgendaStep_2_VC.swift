//
//  BXBAddNewAgendaStep_2_VC.swift
//  BXB
//
//  Created by equalriver on 2018/8/19.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit

class BXBAddNewAgendaStep_2_VC: BXBBaseNavigationVC {

    public var data = AgendaData()
    
    
    //提醒
    public var noticeDataArr = ["无", "日程开始时", "30分钟前", "1小时前", "2小时前", "自定义"]
    public var noticeSelectedItem = 3
    
    //是否需要跳转心得页面
    public var isGoHeartPage = false
    
    lazy var addressTitleLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = kColor_text
        l.text = "拜访地址"
        return l
    }()
    lazy var addressContentView: UIView = {
        let v = UIView()
        v.layer.contents = #imageLiteral(resourceName: "agenda_白色底").cgImage
        return v
    }()
    lazy var locationLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_2
        l.textColor = kColor_subText
        l.text = "请选择定位"
        l.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(addressSelect))
        l.addGestureRecognizer(tap)
        return l
    }()
    lazy var locationBtn: UIButton = {
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "agenda_定位"), for: .normal)
        b.addTarget(self, action: #selector(addressSelect), for: .touchUpInside)
        return b
    }()
    lazy var sepView: UIView = {
        let v = UIView()
        v.backgroundColor = kColor_background
        return v
    }()
    lazy var addressRemarkTF: UITextField = {
        let l = UITextField()
        l.font = kFont_text_2_weight
        l.textColor = kColor_dark
        l.attributedPlaceholder = NSAttributedString.init(string: "填写备注信息(门牌号、楼层等)", attributes: [NSAttributedString.Key.font: kFont_text_2, NSAttributedString.Key.foregroundColor: kColor_subText!])
        l.clearButtonMode = .whileEditing
        l.addBlock(for: .editingChanged, block: { [unowned self](tx) in
            
            guard l.hasText else { return }
            guard l.markedTextRange == nil else { return }
            if l.text!.count > kRemarkAddressTextLimitCount {
                self.view.makeToast("超出字数限制")
                l.text = String(l.text!.prefix(kRemarkAddressTextLimitCount))
                return
            }
        })
        return l
    }()
    lazy var noticeTitleLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = kColor_text
        l.text = "提醒"
        return l
    }()
    lazy var noticeContentView: UIView = {
        let v = UIView()
        v.layer.contents = #imageLiteral(resourceName: "agenda_白色底").cgImage
        return v
    }()
    lazy var noticeLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = kColor_dark
        l.text = "一小时前"
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(noticeSelect))
        l.addGestureRecognizer(tap)
        l.isUserInteractionEnabled = true
        return l
    }()
    lazy var noticeIV: UIImageView = {
        let iv = UIImageView.init(image: UIImage.init(named: "rightArrow"))
        return iv
    }()
    lazy var remarkTitleLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = kColor_text
        l.text = "备注"
        return l
    }()
    lazy var remarkContentView: UIView = {
        let v = UIView()
        v.layer.contents = #imageLiteral(resourceName: "agenda_白色底").cgImage
        return v
    }()
    lazy var voiceInputBtn: UIButton = {
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "语音输入"), for: .normal)
        b.addTarget(self, action: #selector(voiceInput), for: .touchUpInside)
        return b
    }()
    lazy var remarkTV: YYTextView = {
        let v = YYTextView()
        v.font = kFont_text_2_weight
        v.textColor = kColor_dark
        v.placeholderText = "请输入备注信息"
        v.placeholderTextColor = kColor_subText
        v.placeholderFont = kFont_text_2
        v.delegate = self
        return v
    }()
    lazy var remarkCountLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .right
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = kColor_background
        naviBar.naviBackgroundColor = kColor_background!
        
        initUI()
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardFrameChange(noti:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        data.remindTime = noticeDataArr[noticeSelectedItem]
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func initUI() {
        view.addSubview(addressTitleLabel)
        view.addSubview(addressContentView)
        addressContentView.addSubview(locationLabel)
        addressContentView.addSubview(locationBtn)
        addressContentView.addSubview(sepView)
        addressContentView.addSubview(addressRemarkTF)
        view.addSubview(noticeTitleLabel)
        view.addSubview(noticeContentView)
        noticeContentView.addSubview(noticeLabel)
        noticeContentView.addSubview(noticeIV)
        view.addSubview(remarkTitleLabel)
        view.addSubview(remarkContentView)
        view.addSubview(voiceInputBtn)
        remarkContentView.addSubview(remarkTV)
        view.addSubview(remarkCountLabel)
        view.addSubview(confirmBtn)
        makeConstraints()
    }
    
    func makeConstraints() {
        addressTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(20 * KScreenRatio_6)
            make.top.equalTo(naviBar.snp.bottom).offset(20 * KScreenRatio_6)
            make.right.equalTo(view)
            make.height.equalTo(20 * KScreenRatio_6)
        }
        addressContentView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.size.equalTo(CGSize.init(width: 345 * KScreenRatio_6, height: 110 * KScreenRatio_6))
            make.top.equalTo(addressTitleLabel.snp.bottom).offset(20 * KScreenRatio_6)
        }
        locationLabel.snp.makeConstraints { (make) in
            make.left.equalTo(addressContentView).offset(15 * KScreenRatio_6)
            make.right.equalTo(addressContentView).offset(-70 * KScreenRatio_6)
            make.height.equalTo(54 * KScreenRatio_6)
            make.top.equalTo(addressContentView)
        }
        locationBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 17.5 * 2 * KScreenRatio_6, height: 19 * 2 * KScreenRatio_6))
            make.right.equalTo(addressContentView).offset(-15 * KScreenRatio_6)
            make.centerY.equalTo(locationLabel)
        }
        sepView.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.center.width.equalTo(addressContentView)
        }
        addressRemarkTF.snp.makeConstraints { (make) in
            make.left.equalTo(locationLabel)
            make.right.equalTo(addressContentView).offset(-10 * KScreenRatio_6)
            make.top.equalTo(sepView.snp.bottom)
            make.height.equalTo(54.5 * KScreenRatio_6)
        }
        noticeTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(addressContentView.snp.bottom).offset(30 * KScreenRatio_6)
            make.left.size.equalTo(addressTitleLabel)
        }
        noticeContentView.snp.makeConstraints { (make) in
            make.left.width.equalTo(addressContentView)
            make.height.equalTo(55 * KScreenRatio_6)
            make.top.equalTo(noticeTitleLabel.snp.bottom).offset(20 * KScreenRatio_6)
        }
        noticeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(noticeContentView).offset(15 * KScreenRatio_6)
            make.centerY.right.height.equalTo(noticeContentView)
        }
        noticeIV.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20 * KScreenRatio_6)
        }
        remarkTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(noticeContentView.snp.bottom).offset(30 * KScreenRatio_6)
            make.left.size.equalTo(addressTitleLabel)
        }
        remarkContentView.snp.makeConstraints { (make) in
            make.left.width.equalTo(addressContentView)
            make.top.equalTo(remarkTitleLabel.snp.bottom).offset(20 * KScreenRatio_6)
            make.height.equalTo(70 * KScreenRatio_6)
        }
        remarkTV.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 325 * KScreenRatio_6, height: 50 * KScreenRatio_6))
            make.center.equalTo(remarkContentView)
        }
        voiceInputBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(remarkTitleLabel)
            make.right.equalTo(view).offset(-30 * KScreenRatio_6)
        }
        remarkCountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(remarkContentView.snp.bottom).offset(15 * KScreenRatio_6)
            make.right.width.equalTo(remarkContentView)
        }
        confirmBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 100 * KScreenRatio_6, height: 100 * KScreenRatio_6))
            make.centerX.equalTo(view)
            make.bottom.equalTo(view).offset(-15 * KScreenRatio_6 - kIphoneXBottomInsetHeight)
        }
    }
    
    
    
}









