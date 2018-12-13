//
//  BXBContactsCell.swift
//  BXB
//
//  Created by equalriver on 2018/7/17.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit

protocol ContactsAddDelegate: NSObjectProtocol {
    func didClickAddContact(cell: UITableViewCell)
}

class BXBContactsCell: BXBBaseTableViewCell {
    
    weak public var delegate: ContactsAddDelegate?
    
    public var data = ClientContactData(){
        willSet{
            titleLabel.text = newValue.name
            tagLabel.isHidden = newValue.status == 0
            tagButton.isHidden = newValue.status == 1
        }
    }

    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = kColor_dark
        return l
    }()
    lazy var tagLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 13 * KScreenRatio_6)
        l.textColor = kColor_subText
        l.text = "已添加"
        l.isHidden = true
        l.textAlignment = .center
        return l
    }()
    lazy var tagButton: UIButton = {
        let b = UIButton()
        b.titleLabel?.font = UIFont.systemFont(ofSize: 13 * KScreenRatio_6)
        b.setTitle("添加", for: .normal)
        b.setTitleColor(UIColor.white, for: .normal)
        b.backgroundColor = kColor_theme
        b.layer.masksToBounds = true
        b.layer.cornerRadius = kCornerRadius
        b.addBlock(for: .touchUpInside, block: { [unowned self](btn) in
            self.delegate?.didClickAddContact(cell: self)
        })
        return b
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(tagLabel)
        contentView.addSubview(tagButton)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(15 * KScreenRatio_6)
            make.height.centerY.equalTo(contentView)
        }
        tagLabel.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 55 * KScreenRatio_6, height: 30 * KScreenRatio_6))
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).offset(-8 * KScreenRatio_6)
        }
        tagButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 55 * KScreenRatio_6, height: 30 * KScreenRatio_6))
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).offset(-8 * KScreenRatio_6)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        
    }
    
}































