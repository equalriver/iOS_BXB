//
//  BXBNoticeDetailCell.swift
//  BXB
//
//  Created by equalriver on 2018/8/24.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit

protocol NoticeDetailCellDelegate: NSObjectProtocol {
    func detailTextChange(sender: UITextField, cell : UITableViewCell)
}

class BXBNoticeDetailCell: BXBBaseTableViewCell {
    
    weak public var delegate: NoticeDetailCellDelegate?
    
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
        l.text = "未设置"
        l.clearButtonMode = .whileEditing
        l.isUserInteractionEnabled = false
        l.addBlock(for: .editingChanged, block: { [unowned self](tf) in
            self.delegate?.detailTextChange(sender: l, cell: self)
        })
        return l
    }()
    lazy var rightArrowView: UIImageView = {
        let  v = UIImageView()
        v.image = #imageLiteral(resourceName: "rightArrow")
        v.isHidden = true
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailTF)
        contentView.addSubview(rightArrowView)
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
        }
        detailTF.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.right.equalTo(contentView).offset(-30 * KScreenRatio_6)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        rightArrowView.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-15 * KScreenRatio_6)
            make.centerY.equalTo(contentView)
        }
    }
    
}
