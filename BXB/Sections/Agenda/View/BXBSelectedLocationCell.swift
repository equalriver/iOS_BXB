//
//  BXBSelectedLocationCell.swift
//  BXB
//
//  Created by equalriver on 2018/8/13.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit

class BXBSelectedLocationCell: BXBBaseTableViewCell {

    lazy var nameLabel: UILabel = {
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
    lazy var stateIV: UIImageView = {
        let iv = UIImageView.init(image: #imageLiteral(resourceName: "bxb_选中_筛选栏"))
        iv.isHidden = true
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(stateIV)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(10 * KScreenRatio_6)
            make.right.equalTo(contentView).offset(-50 * KScreenRatio_6)
            make.top.equalTo(contentView).offset(7 * KScreenRatio_6)
        }
        detailLabel.snp.makeConstraints { (make) in
            make.width.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
        }
        stateIV.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-10 * KScreenRatio_6)
            make.centerY.equalTo(contentView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        detailLabel.text = nil
        stateIV.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        stateIV.isHidden = !selected
    }
    
}








