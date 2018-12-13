
//
//  BXBAddNewAgendaStep_1_CVCell.swift
//  BXB
//
//  Created by equalriver on 2018/8/24.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation

class BXBAddNewAgendaStep_1_CVCell: UICollectionViewCell {
    
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.backgroundColor = UIColor.white
        l.font = kFont_text_3
        l.textColor = kColor_dark
        l.textAlignment = .center
        l.layer.borderColor = kColor_text?.cgColor
        l.layer.borderWidth = 0.5
        l.layer.masksToBounds = true
        l.layer.cornerRadius = 15 * KScreenRatio_6
        return l
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = kColor_background
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.size.centerX.centerY.equalTo(contentView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
