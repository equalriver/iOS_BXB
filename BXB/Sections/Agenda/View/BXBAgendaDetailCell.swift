//
//  BXBAgendaDetailCell.swift
//  BXB
//
//  Created by equalriver on 2018/6/10.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit

protocol AgendaDetailCellDelegate: NSObjectProtocol {
    
    func didClickVoiceInput(cell: BXBAgendaDetailCell)
    func detailTextChange(sender: UITextView, cell: UITableViewCell)
    func isEditingText(isEditing: Bool, cell: UITableViewCell)
}

class BXBAgendaDetailCell: BXBBaseTableViewCell {
    
    weak public var delegate: AgendaDetailCellDelegate?
    
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_3
        l.textColor = kColor_subText
        return l
    }()
    lazy var detailTV: UITextView = {
        let l = UITextView()
        l.font = kFont_text
        l.textColor = kColor_text
        l.text = "未填写"
        l.isUserInteractionEnabled = false
        l.delegate = self
        l.tag = 1
        l.textContainerInset = UIEdgeInsets.init(top: 0, left: -5, bottom: 0, right: 0)
        return l
    }()
    lazy var rightArrowView: UIImageView = {
        let  v = UIImageView()
        v.image = #imageLiteral(resourceName: "rightArrow")
        v.isHidden = true
        return v
    }()
    lazy var voiceInputBtn: UIButton = {
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "语音输入"), for: .normal)
        b.isHidden = true
        b.addBlock(for: .touchUpInside, block: { [unowned self](btn) in
            self.delegate?.didClickVoiceInput(cell: self)
        })
        return b
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailTV)
        contentView.addSubview(rightArrowView)
        contentView.addSubview(voiceInputBtn)
        
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if titleLabel.text == "心得" || titleLabel.text == "备注" {
            let h = detailTV.text.getStringHeight(font: kFont_text, width: 315 * KScreenRatio_6) > 25 * KScreenRatio_6 ? 50 * KScreenRatio_6 : detailTV.text.getStringHeight(font: kFont_text, width: 315 * KScreenRatio_6)
            detailTV.snp.updateConstraints { (make) in
                make.height.equalTo(h)
            }
            rightArrowView.snp.remakeConstraints { (make) in
                make.right.equalTo(contentView).offset(-15 * KScreenRatio_6)
                make.centerY.equalTo(detailTV)
            }
        }
    }
    
    func makeConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(10 * KScreenRatio_6)
            make.left.equalTo(contentView).offset(15 * KScreenRatio_6)
            make.width.equalTo(100 * KScreenRatio_6)
            make.height.equalTo(13 * KScreenRatio_6)
        }
        detailTV.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.right.equalTo(contentView).offset(-5 * KScreenRatio_6)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.height.equalTo(25 * KScreenRatio_6)
        }
        rightArrowView.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-15 * KScreenRatio_6)
            make.centerY.equalTo(contentView)
        }
        voiceInputBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 80 * KScreenRatio_6, height: 30 * KScreenRatio_6))
            make.right.top.equalTo(contentView)
        }
    }

}

extension BXBAgendaDetailCell: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "未设置" || textView.text == "未填写" {
            textView.text = nil
        }
        delegate?.isEditingText(isEditing: true, cell: self)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.isEditingText(isEditing: false, cell: self)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == "未设置" || textView.text == "未填写" {
            textView.textColor = kColor_text
        }
        else {
            textView.textColor = kColor_dark
        }
        delegate?.detailTextChange(sender: textView, cell: self)
    }
    
    
}

protocol AgendaDetailAddressDelegate: NSObjectProtocol {

    func didClickAddressRightButton(cell: UITableViewCell)
    func addressSubDetailTextChange(sender: UITextField, cell: UITableViewCell)
}

class BXBAgendaDetailAddressCell: BXBBaseTableViewCell {
    
    weak public var delegate: AgendaDetailAddressDelegate?
    
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_3
        l.textColor = kColor_subText
        return l
    }()
    lazy var detailTF: UITextField = {
        let l = UITextField()
        l.font = kFont_text
        l.textColor = kColor_dark
        l.attributedPlaceholder = NSAttributedString.init(string: "未设置", attributes: [NSAttributedString.Key.font: kFont_text, NSAttributedString.Key.foregroundColor: kColor_text!])
        l.isUserInteractionEnabled = false
        return l
    }()
    lazy var subDetailTF: UITextField = {
        let l = UITextField()
        l.font = kFont_text_3
        l.textColor = kColor_dark
        l.attributedPlaceholder = NSAttributedString.init(string: "请输入门牌号、楼层", attributes: [NSAttributedString.Key.font: kFont_text, NSAttributedString.Key.foregroundColor: kColor_text!])
        l.isUserInteractionEnabled = false
        l.addBlock(for: .editingChanged, block: { [unowned self](t) in
            self.delegate?.addressSubDetailTextChange(sender: t as! UITextField, cell: self)
        })
        return l
    }()
    lazy var rightBtn: UIButton = {
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "agenda_导航"), for: .normal)
        b.addBlock(for: .touchUpInside, block: { [unowned self](btn) in
            self.delegate?.didClickAddressRightButton(cell: self)
        })
        return b
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailTF)
        contentView.addSubview(subDetailTF)
        contentView.addSubview(rightBtn)
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(10 * KScreenRatio_6)
            make.left.equalTo(contentView).offset(15 * KScreenRatio_6)
            make.width.equalTo(100 * KScreenRatio_6)
            make.height.equalTo(13 * KScreenRatio_6)
        }
        detailTF.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.right.equalTo(contentView).offset(-65 * KScreenRatio_6)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.height.equalTo(25 * KScreenRatio_6)
        }
        subDetailTF.snp.makeConstraints { (make) in
            make.left.width.height.equalTo(detailTF)
            make.top.equalTo(detailTF.snp.bottom)
        }
        rightBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 30 * KScreenRatio_6, height: 30 * KScreenRatio_6))
            make.right.equalTo(contentView).offset(-15 * KScreenRatio_6)
            make.centerY.equalTo(contentView)
        }

    }
    
}









