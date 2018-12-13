//
//  BXBClientDetailCells.swift
//  BXB
//
//  Created by equalriver on 2018/6/21.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit

//MARK: - notice
protocol ClientDetailNoticeDelegate: NSObjectProtocol {
    func didClickNormalNoticeDelete(cell: UITableViewCell)
}

class BXBClientDetailNoticeCell: BXBBaseTableViewCell {
    
    public var data = ClientDetailNoticeData() {
        willSet{
            titleLabel.text = newValue.matter + " " + newValue.remindName
            subTitleLabel.text = newValue.times
            noticeLabel.text = newValue.remindTime
        }
    }
    
    weak public var delegate: ClientDetailNoticeDelegate?
    
    lazy var transformContentView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        return v
    }()
    lazy var deleteBtn: UIButton = {
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "client_删除"), for: .normal)
        b.addBlock(for: .touchUpInside, block: { [unowned self](sender) in
            self.delegate?.didClickNormalNoticeDelete(cell: self)
        })
        return b
    }()
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = kColor_dark
        return l
    }()
    lazy var subTitleLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_3
        l.textColor = kColor_subText
        return l
    }()
    lazy var noticeLabel: UILabel = {
        let l = UILabel()
        l.textColor = kColor_subText
        l.font = kFont_text_3
        l.textAlignment = .right
        return l
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(transformContentView)
        transformContentView.addSubview(deleteBtn)
        transformContentView.addSubview(titleLabel)
        transformContentView.addSubview(subTitleLabel)
        contentView.addSubview(noticeLabel)
        transformContentView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 220 * KScreenRatio_6, height: 60 * KScreenRatio_6 - 1))
            make.top.equalTo(contentView)
            make.left.equalTo(contentView).offset(-40 * KScreenRatio_6)
        }
        deleteBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 25 * KScreenRatio_6, height: 25 * KScreenRatio_6))
            make.left.equalTo(transformContentView).offset(15 * KScreenRatio_6)
            make.centerY.equalTo(transformContentView)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(transformContentView).offset(10 * KScreenRatio_6)
            make.left.equalTo(deleteBtn.snp.right).offset(15 * KScreenRatio_6)
            make.width.equalTo(160 * KScreenRatio_6)
        }
        subTitleLabel.snp.makeConstraints { (make) in
            make.left.width.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        noticeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(subTitleLabel)
            make.right.equalTo(contentView).offset(-15 * KScreenRatio_6)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subTitleLabel.text = nil
        noticeLabel.text = nil
    }
    
}

//MARK: - notice edit
protocol ClientDetailNoticeEditDelegate: NSObjectProtocol {
    
    func didClickEditNoticeType(cell: UITableViewCell, callback: @escaping (_ type: ClientItemStyle) -> Void)
    
    func editNoticeRemarksTextFieldValueChange(cell: UITableViewCell, text: String)
    
    func didClickEditNoticeTimeDetail(cell: UITableViewCell, callback: @escaping (_ time: String) -> Void)
    
    func didClickEditNoticeDetail(cell: UITableViewCell, callback: @escaping (_ notice: String) -> Void)
    
}

class BXBClientDetailNoticeEditCell: BXBBaseTableViewCell {
    
    weak public var delegate: ClientDetailNoticeEditDelegate?
    
    public var type = ClientItemStyle.birthday{
        willSet{
            typeButton.setTitle(newValue.description() + " ", for: .normal)
        }
    }
    
    public var data = ClientDetailNoticeData() {
        willSet{
            typeButton.setTitle(newValue.matter + " ", for: .normal)
            timeDetailBtn.setTitle(newValue.time + "  ", for: .normal)
            noticeDetailBtn.setTitle(newValue.remindTime + "  ", for: .normal)
        }
    }
    lazy var typeButton: TitleFrontButton = {
        let b = TitleFrontButton()
        b.titleLabel?.font = kFont_text_weight
        b.setImage(#imageLiteral(resourceName: "rightArrow"), for: .normal)
        b.setTitle(type.description() + " ", for: .normal)
        b.setTitleColor(kColor_dark, for: .normal)
        b.contentHorizontalAlignment = .left
        b.addBlock(for: .touchUpInside, block: { [unowned self] (sender) in
            self.delegate?.didClickEditNoticeType(cell: self, callback: { (style) in
                self.type = style
            })
        })
        return b
    }()
    lazy var sepIV: UIImageView = {
        let iv = UIImageView.init(image: #imageLiteral(resourceName: "渐变线"))
        return iv
    }()
    lazy var sepView_1: UIView = {
        let v = UIView()
        v.backgroundColor = kColor_separatorView
        return v
    }()
    lazy var sepView_2: UIView = {
        let v = UIView()
        v.backgroundColor = kColor_separatorView
        return v
    }()
    
    lazy var customTF: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString.init(string: "主题(如：某某生日)", attributes: [NSAttributedString.Key.font: kFont_text, NSAttributedString.Key.foregroundColor: kColor_subText!])
        tf.textColor = kColor_dark
        tf.font = kFont_text_weight
        tf.clearButtonMode = .whileEditing
        tf.addBlock(for: .editingChanged, block: { (t) in
            
            guard tf.markedTextRange == nil else { return }
            
            if tf.hasText && tf.text!.count > kNoticeThemeTextLimitCount {
                if let v = UIApplication.shared.keyWindow {
                     v.makeToast("超出字数限制")
                }
                tf.text = String(tf.text!.prefix(kNoticeThemeTextLimitCount))
            }
            self.delegate?.editNoticeRemarksTextFieldValueChange(cell: self, text: tf.text!)
        })
        return tf
    }()
    lazy var timeTitle: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = kColor_dark
        l.text = "时间"
        return l
    }()
    lazy var dateFormatterYMD: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    lazy var timeDetailBtn: TitleFrontButton = {
        let b = TitleFrontButton()
        b.setImage(#imageLiteral(resourceName: "rightArrow"), for: .normal)
        b.setTitle(dateFormatterYMD.string(from: Date()) + "  ", for: .normal)
        b.setTitleColor(kColor_subText, for: .normal)
        b.titleLabel?.font = kFont_text
        return b
    }()
    lazy var noticeTitle: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = kColor_dark
        l.text = "提醒"
        return l
    }()
    lazy var noticeDetailBtn: TitleFrontButton = {
        let b = TitleFrontButton()
        b.setImage(#imageLiteral(resourceName: "rightArrow"), for: .normal)
        b.setTitle("提前一星期提醒  ", for: .normal)
        b.setTitleColor(kColor_subText, for: .normal)
        b.titleLabel?.font = kFont_text
        return b
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(typeButton)
        contentView.addSubview(sepIV)
        contentView.addSubview(sepView_1)
        contentView.addSubview(sepView_2)
        contentView.addSubview(customTF)
        contentView.addSubview(timeTitle)
        contentView.addSubview(timeDetailBtn)
        contentView.addSubview(noticeTitle)
        contentView.addSubview(noticeDetailBtn)
        makeConstraints()
        
        timeDetailBtn.addBlock(for: .touchUpInside, block: { [unowned self] (sender) in
            self.delegate?.didClickEditNoticeTimeDetail(cell: self, callback: { [unowned self] (str) in
                self.timeDetailBtn.setTitle(str + "  ", for: .normal)
            })
        })
        noticeDetailBtn.addBlock(for: .touchUpInside, block: { [unowned self] (sender) in
            self.delegate?.didClickEditNoticeDetail(cell: self, callback: { [unowned self] (str) in
                self.noticeDetailBtn.setTitle(str + "  ", for: .normal)
            })
        })
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        typeButton.setTitle(ClientItemStyle.birthday.description(), for: .normal)
        customTF.text = nil
    }
    
    func makeConstraints() {
        typeButton.snp.makeConstraints { (make) in
            make.top.equalTo(contentView)
            make.left.equalTo(contentView).offset(15 * KScreenRatio_6)
            make.size.equalTo(CGSize.init(width: 85 * KScreenRatio_6, height: 55 * KScreenRatio_6))
        }
        sepIV.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 0.5, height: 55 * KScreenRatio_6))
            make.left.equalTo(typeButton.snp.right)
            make.top.equalTo(contentView)
        }
        customTF.snp.makeConstraints { (make) in
            make.left.equalTo(sepIV.snp.right).offset(15 * KScreenRatio_6)
            make.centerY.equalTo(typeButton)
            make.height.equalTo(55 * KScreenRatio_6)
            make.right.equalTo(contentView).offset(-15 * KScreenRatio_6)
        }
        sepView_1.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 345 * KScreenRatio_6, height: 0.5))
            make.centerX.equalTo(contentView)
            make.top.equalTo(sepIV.snp.bottom)
        }
        timeTitle.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(15 * KScreenRatio_6)
            make.size.equalTo(CGSize.init(width: 60 * KScreenRatio_6, height: 55 * KScreenRatio_6))
            make.top.equalTo(sepView_1.snp.bottom)
        }
        timeDetailBtn.snp.makeConstraints { (make) in
            make.centerY.height.equalTo(timeTitle)
            make.right.equalTo(contentView).offset(-10 * KScreenRatio_6)
        }
        sepView_2.snp.makeConstraints { (make) in
            make.size.equalTo(sepView_1)
            make.centerX.equalTo(contentView)
            make.top.equalTo(timeTitle.snp.bottom)
        }
        noticeTitle.snp.makeConstraints { (make) in
            make.left.equalTo(timeTitle)
            make.size.equalTo(CGSize.init(width: 60 * KScreenRatio_6, height: 55 * KScreenRatio_6))
            make.top.equalTo(sepView_2.snp.bottom)
        }
        noticeDetailBtn.snp.makeConstraints { (make) in
            make.centerY.height.equalTo(noticeTitle)
            make.right.equalTo(contentView).offset(-10 * KScreenRatio_6)
        }
    }
    
}

//MARK: - record
class BXBClientDetailRecordCell: BXBBaseTableViewCell {
    
    public var data = ClientDetailRecordData() {
        willSet{
            titleLabel.text = newValue.visitTepyName
            detailLabel.text = newValue.visitDate
            statusIV.isHidden = newValue.visitStatus == 0
            if newValue.visitStatus == 0 {
                if let date = formatter.date(from: newValue.visitDate) {
                    
                    guard let ca = NSCalendar.init(calendarIdentifier: .gregorian) else { return }
                    if date.compare(Date()) == .orderedAscending {//提醒小于当前时间点
                        //提醒时间是否在当天
                        statusLabel.isHidden = ca.isDateInToday(date)
                    }
                    else { statusLabel.isHidden = true }
                }
            }
        }
    }
    
    lazy var formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd HH:mm"
        return f
    }()
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = kColor_dark
        return l
    }()
    lazy var detailLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_3
        l.textColor = kColor_subText
        return l
    }()
    lazy var statusIV: UIImageView = {
        let iv = UIImageView.init(image: #imageLiteral(resourceName: "client_勾"))
        iv.isHidden = true
        return iv
    }()
    lazy var statusLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text
        l.textColor = kColor_text
        l.text = "逾期"
        l.textAlignment = .right
        l.isHidden = true
        return l
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(statusIV)
        contentView.addSubview(statusLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(10 * KScreenRatio_6)
            make.left.equalTo(contentView).offset(15 * KScreenRatio_6)
            make.right.equalTo(contentView).offset(-80 * KScreenRatio_6)
        }
        detailLabel.snp.makeConstraints { (make) in
            make.left.width.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        statusIV.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-15 * KScreenRatio_6)
            make.centerY.equalTo(contentView)
        }
        statusLabel.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-15 * KScreenRatio_6)
            make.centerY.equalTo(contentView)
            make.height.equalTo(contentView)
            make.width.equalTo(50 * KScreenRatio_6)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        detailLabel.text = nil
        statusIV.isHidden = true
        statusLabel.isHidden = true
    }
    
}

//MARK: - maintain
protocol ClientDetailMaintainDelegate: NSObjectProtocol {
    func didClickNormalMaintainDelete(cell: UITableViewCell)
}

class BXBClientDetailMaintainCell: BXBBaseTableViewCell {
    
    public var data = ClientDetailMaintainData(){
        willSet{
            titleLabel.text = newValue.content
            detailLabel.text = newValue.spentDate
            costLabel.text = "\(newValue.spentMoney)元"
        }
    }
    
    weak public var delegate: ClientDetailMaintainDelegate?
    
    lazy var transformContentView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        return v
    }()
    lazy var deleteBtn: UIButton = {
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "client_删除"), for: .normal)
        b.addBlock(for: .touchUpInside, block: { [unowned self](sender) in
            self.delegate?.didClickNormalMaintainDelete(cell: self)
        })
        return b
    }()
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = kColor_dark
        return l
    }()
    lazy var detailLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_3
        l.textColor = kColor_subText
        return l
    }()
    lazy var costLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_3
        l.textColor = kColor_dark
        l.textAlignment = .right
        return l
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(transformContentView)
        transformContentView.addSubview(deleteBtn)
        transformContentView.addSubview(titleLabel)
        transformContentView.addSubview(detailLabel)
        contentView.addSubview(costLabel)
        transformContentView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 270 * KScreenRatio_6, height: 60 * KScreenRatio_6 - 1))
            make.top.equalTo(contentView)
            make.left.equalTo(contentView).offset(-40 * KScreenRatio_6)
        }
        deleteBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 25 * KScreenRatio_6, height: 25 * KScreenRatio_6))
            make.left.equalTo(transformContentView).offset(15 * KScreenRatio_6)
            make.centerY.equalTo(transformContentView)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(transformContentView).offset(10 * KScreenRatio_6)
            make.left.equalTo(deleteBtn.snp.right).offset(15 * KScreenRatio_6)
            make.width.equalTo(180 * KScreenRatio_6)
        }
        detailLabel.snp.makeConstraints { (make) in
            make.left.width.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        costLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(detailLabel)
            make.right.equalTo(contentView).offset(-15 * KScreenRatio_6)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        detailLabel.text = nil
        costLabel.text = nil
    }
    
}

//MARK: - maintain edit
protocol ClientDetailMaintainEditDelegate: NSObjectProtocol {
    
    func didClickEditMaintainType(cell: UITableViewCell, sender: UITextField)
    
    func editMaintainRemarksTextFieldValueChange(cell: UITableViewCell, sender: UITextField)
    
    func didClickEditMaintainTimeDetail(cell: UITableViewCell, callback: @escaping(_ time: String) -> Void)
}

class BXBClientDetailMaintainEditCell: BXBBaseTableViewCell {
    
    weak public var delegate: ClientDetailMaintainEditDelegate?
    
    public var type = ""{
        willSet{
            typeTF.text = newValue
        }
    }

    lazy var typeTF: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString.init(string: "请输入事项", attributes: [NSAttributedString.Key.font: kFont_text, NSAttributedString.Key.foregroundColor: kColor_subText!])
        tf.textColor = kColor_dark
        tf.font = kFont_text_weight
        tf.clearButtonMode = .whileEditing
        
        tf.addBlock(for: .editingChanged, block: { [unowned self](t) in
            guard tf.hasText else { return }
            
            guard tf.markedTextRange == nil else { return }
            if tf.text!.count > kCostMatterTextLimitCount {
                if let v = UIApplication.shared.keyWindow {
                    v.makeToast("超出字数限制")
                }
                tf.text = String(tf.text!.prefix(kCostMatterTextLimitCount))

            }
            self.delegate?.didClickEditMaintainType(cell: self, sender: tf)
        })
        return tf
    }()
    lazy var sepIV: UIImageView = {
        let iv = UIImageView.init(image: #imageLiteral(resourceName: "渐变线"))
        return iv
    }()
    lazy var sepView_1: UIView = {
        let v = UIView()
        v.backgroundColor = kColor_separatorView
        return v
    }()
    lazy var customTF: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString.init(string: "金额", attributes: [NSAttributedString.Key.font: kFont_text, NSAttributedString.Key.foregroundColor: kColor_subText!])
        tf.textColor = kColor_dark
        tf.font = kFont_text_weight
        tf.clearButtonMode = .whileEditing
        tf.keyboardType = .numbersAndPunctuation
        tf.addBlock(for: .editingChanged, block: { [unowned self](t) in
            if tf.hasText && tf.text!.count > kCostMoneyLimitCount {
                if let v = UIApplication.shared.keyWindow {
                    v.makeToast("超出字数限制")
                }
                tf.text = String(tf.text!.prefix(kCostMoneyLimitCount))
            }
            self.delegate?.editMaintainRemarksTextFieldValueChange(cell: self, sender: tf)
        })
        return tf
    }()
    lazy var moneyTagLabel: UILabel = {
        let l = UILabel()
        l.textColor = kColor_dark
        l.font = kFont_text_weight
        l.text = "元"
        return l
    }()
    lazy var timeTitle: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = kColor_dark
        l.text = "时间"
        return l
    }()
    lazy var timeDetailBtn: TitleFrontButton = {
        let b = TitleFrontButton()
        b.setImage(#imageLiteral(resourceName: "rightArrow"), for: .normal)
        b.setTitle(dateFormatterYMD.string(from: Date()) + "   ", for: .normal)
        b.setTitleColor(kColor_text, for: .normal)
        b.titleLabel?.font = kFont_text
        return b
    }()
    lazy var dateFormatterYMD: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(typeTF)
        contentView.addSubview(sepIV)
        contentView.addSubview(sepView_1)
        contentView.addSubview(customTF)
        contentView.addSubview(moneyTagLabel)
        contentView.addSubview(timeTitle)
        contentView.addSubview(timeDetailBtn)
        makeConstraints()
        
        timeDetailBtn.addBlock(for: .touchUpInside, block: { [unowned self] (sender) in
            self.delegate?.didClickEditMaintainTimeDetail(cell: self, callback: { [unowned self] (str) in
                self.timeDetailBtn.setTitle(str + "   ", for: .normal)
            })
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        typeTF.text = nil
        customTF.text = nil
        timeDetailBtn.setTitle(dateFormatterYMD.string(from: Date()) + "   ", for: .normal)
    }
    
    func makeConstraints() {
        typeTF.snp.makeConstraints { (make) in
            make.top.equalTo(contentView)
            make.left.equalTo(contentView).offset(15 * KScreenRatio_6)
            make.size.equalTo(CGSize.init(width: 170 * KScreenRatio_6, height: 54 * KScreenRatio_6))
        }
        sepIV.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 0.5, height: 54 * KScreenRatio_6))
            make.left.equalTo(typeTF.snp.right).offset(10 * KScreenRatio_6)
            make.top.equalTo(contentView)
        }
        customTF.snp.makeConstraints { (make) in
            make.left.equalTo(sepIV.snp.right).offset(10 * KScreenRatio_6)
            make.centerY.equalTo(typeTF)
            make.height.equalTo(sepIV)
            make.right.equalTo(moneyTagLabel.snp.left).offset(-15 * KScreenRatio_6)
        }
        moneyTagLabel.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-15 * KScreenRatio_6)
            make.centerY.height.equalTo(customTF)
        }
        sepView_1.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: contentView.width, height: 0.5))
            make.centerX.equalTo(contentView)
            make.top.equalTo(sepIV.snp.bottom)
        }
        timeTitle.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(15 * KScreenRatio_6)
            make.size.equalTo(CGSize.init(width: 60 * KScreenRatio_6, height: 54 * KScreenRatio_6))
            make.top.equalTo(sepView_1.snp.bottom)
        }
        timeDetailBtn.snp.makeConstraints { (make) in
            make.centerY.height.equalTo(timeTitle)
            make.right.equalTo(contentView).offset(-15 * KScreenRatio_6)
        }
    }
    
}
