//
//  BXBWorkLogCells.swift
//  BXB
//
//  Created by equalriver on 2018/8/8.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation

protocol WorkLogMeCellDelegate: NSObjectProtocol {
    func didFinishRemark(data: WorkLogData, heart: String)
}

class BXBWorkLogMeCell: BXBBaseTableViewCell {
    
    public var data = WorkLogData() {
        willSet{
            nameLabel.text = newValue.name
            dateLabel.text = newValue.visitDate
            matterLabel.text = newValue.matter
            remarkTF.text = newValue.heart.count > 0 ? newValue.heart : nil
        }
    }
    
    weak public var delegate: WorkLogMeCellDelegate?
    
    lazy var sepView_1: UIView = {
        let v = UIView()
        v.backgroundColor = kColor_background
        return v
    }()
    lazy var sepView_2: UIView = {
        let v = UIView()
        v.backgroundColor = kColor_background
        return v
    }()
    lazy var sepView_3: UIView = {
        let v = UIView()
        v.backgroundColor = kColor_background
        return v
    }()
    lazy var nameLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 17 * KScreenRatio_6, weight: .semibold)
        l.textColor = kColor_text
        return l
    }()
    lazy var dateLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 13 * KScreenRatio_6)
        l.textColor = kColor_subText
        return l
    }()
    lazy var matterLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = kColor_theme
        return l
    }()
    lazy var remarkTF: UITextField = {
        let t = UITextField()
        t.font = kFont_text_2
        t.textColor = kColor_text
        t.attributedPlaceholder = NSAttributedString.init(string: "这里是心得。", attributes: [NSAttributedString.Key.font: kFont_text_2, NSAttributedString.Key.foregroundColor: kColor_subText!])
        t.isUserInteractionEnabled = false
        return t
    }()
    lazy var editButton: UIButton = {
        let b = UIButton()
        b.titleLabel?.font = UIFont.systemFont(ofSize: 13 * KScreenRatio_6)
        b.setTitle("编辑", for: .normal)
        b.setTitleColor(kColor_theme, for: .normal)
        b.setTitle("完成", for: .selected)
        b.setTitleColor(kColor_theme, for: .selected)
        b.addTarget(self, action: #selector(editRemark(sender:)), for: .touchUpInside)
        return b
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        isNeedSeparatorView = false
        contentView.addSubview(sepView_1)
        contentView.addSubview(sepView_2)
        contentView.addSubview(sepView_3)
        contentView.addSubview(nameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(matterLabel)
        contentView.addSubview(remarkTF)
        contentView.addSubview(editButton)
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeConstraints() {
        sepView_1.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: kScreenWidth, height: 0.5))
            make.top.left.equalTo(contentView)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(15 * KScreenRatio_6)
            make.right.equalTo(contentView).offset(-15)
            make.top.equalTo(sepView_1.snp.bottom).offset(15 * KScreenRatio_6)
        }
        dateLabel.snp.makeConstraints { (make) in
            make.left.width.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(10 * KScreenRatio_6)
        }
        matterLabel.snp.makeConstraints { (make) in
            make.left.width.equalTo(nameLabel)
            make.top.equalTo(dateLabel.snp.bottom).offset(10 * KScreenRatio_6)
        }
        sepView_2.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 345 * KScreenRatio_6, height: 0.5))
            make.centerX.equalTo(contentView)
            make.top.equalTo(matterLabel.snp.bottom).offset(10 * KScreenRatio_6)
        }
        remarkTF.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(sepView_2.snp.bottom)
            make.bottom.equalTo(contentView)
            make.right.equalTo(sepView_3.snp.left).offset(-10 * KScreenRatio_6)
        }
        sepView_3.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 0.5, height: 16 * KScreenRatio_6))
            make.centerY.equalTo(remarkTF)
            make.right.equalTo(contentView).offset(-60 * KScreenRatio_6)
        }
        editButton.snp.makeConstraints { (make) in
            make.right.equalTo(contentView)
            make.left.equalTo(sepView_3.snp.right)
            make.height.centerY.equalTo(remarkTF)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        dateLabel.text = nil
        matterLabel.text = nil
        matterLabel.attributedText = nil
        remarkTF.text = nil
    }
    
    @objc func editRemark(sender: UIButton){
        if sender.isSelected {
            delegate?.didFinishRemark(data: data, heart: remarkTF.text ?? "")
        }
        else {
            remarkTF.isUserInteractionEnabled = true
            remarkTF.becomeFirstResponder()
        }
        sender.isSelected = !sender.isSelected
        remarkTF.isUserInteractionEnabled = sender.isSelected
    }
    
    
}









class BXBWorkLogTeamCell: BXBBaseTableViewCell {
    
    lazy var contentIV: UIView = {
        let v = UIView()
        return v
    }()
    lazy var nameLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 17 * KScreenRatio_6, weight: .semibold)
        l.textColor = kColor_text
        return l
    }()
    lazy var dateLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 13 * KScreenRatio_6)
        l.textColor = kColor_subText
        return l
    }()
    lazy var stateLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_2
        l.textColor = kColor_theme
        l.textAlignment = .right
        return l
    }()
    lazy var sepView_1: UIView = {
        let v = UIView()
        v.backgroundColor = kColor_background
        return v
    }()
    lazy var sepView_2: UIView = {
        let v = UIView()
        v.backgroundColor = kColor_background
        return v
    }()
    lazy var detailLabel_1: UILabel = {
        let l = UILabel()
        l.font = kFont_text_2
        l.textColor = kColor_text
        return l
    }()
    lazy var detailLabel_2: UILabel = {
        let l = UILabel()
        l.font = kFont_text_2
        l.textColor = kColor_text
        return l
    }()
    lazy var detailLabel_3: UILabel = {
        let l = UILabel()
        l.font = kFont_text_2
        l.textColor = kColor_text
        return l
    }()
    lazy var countLabel: UILabel = {
        let l = UILabel()
        l.textColor = kColor_text
        l.font = kFont_text_weight
        l.textAlignment = .center
        return l
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        isNeedSeparatorView = false
        contentView.backgroundColor = kColor_background
        contentView.addSubview(contentIV)
        contentIV.addSubview(nameLabel)
        contentIV.addSubview(dateLabel)
        contentIV.addSubview(stateLabel)
        contentIV.addSubview(sepView_1)
        contentIV.addSubview(sepView_2)
        contentIV.addSubview(detailLabel_1)
        contentIV.addSubview(detailLabel_2)
        contentIV.addSubview(detailLabel_3)
        contentIV.addSubview(countLabel)
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeConstraints() {
        contentIV.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 345 * KScreenRatio_6, height: 210 * KScreenRatio_6))
            make.center.equalTo(contentView)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.width.equalTo(kScreenWidth * 0.5)
            make.left.top.equalTo(contentIV).offset(15 * KScreenRatio_6)
        }
        dateLabel.snp.makeConstraints { (make) in
            make.left.width.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(10 * KScreenRatio_6)
        }
        stateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentIV).offset(25 * KScreenRatio_6)
            make.right.equalTo(contentIV).offset(-15 * KScreenRatio_6)
        }
        sepView_1.snp.makeConstraints { (make) in
            make.width.centerX.equalTo(contentIV)
            make.height.equalTo(0.5)
            make.top.equalTo(dateLabel.snp.bottom).offset(10 * KScreenRatio_6)
        }
        detailLabel_1.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(sepView_1.snp.bottom).offset(15 * KScreenRatio_6)
            make.right.equalTo(contentIV).offset(-15 * KScreenRatio_6)
        }
        detailLabel_2.snp.makeConstraints { (make) in
            make.centerX.width.equalTo(detailLabel_1)
            make.top.equalTo(detailLabel_1.snp.bottom).offset(10 * KScreenRatio_6)
        }
        detailLabel_3.snp.makeConstraints { (make) in
            make.centerX.width.equalTo(detailLabel_1)
            make.top.equalTo(detailLabel_2.snp.bottom).offset(10 * KScreenRatio_6)
        }
        sepView_2.snp.makeConstraints { (make) in
            make.width.centerX.equalTo(contentIV)
            make.height.equalTo(0.5)
            make.top.equalTo(detailLabel_3.snp.bottom).offset(10 * KScreenRatio_6)
        }
        countLabel.snp.makeConstraints { (make) in
            make.width.equalTo(340 * KScreenRatio_6)
            make.bottom.equalTo(contentIV).offset(-10 * KScreenRatio_6)
            make.centerX.equalTo(contentIV)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentIV.layer.contents = nil
        nameLabel.text = nil
        dateLabel.text = nil
        stateLabel.text = nil
        detailLabel_1.text = nil
        detailLabel_2.text = nil
        detailLabel_3.text = nil
        countLabel.text = nil
        countLabel.attributedText = nil
    }
    
    
    
    
    
    
    
}


































