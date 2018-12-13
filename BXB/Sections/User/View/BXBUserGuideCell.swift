//
//  BXBUserGuideCell.swift
//  BXB
//
//  Created by equalriver on 2018/10/31.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit

class BXBUserGuideCell: BXBBaseTableViewCell {
    
    lazy var iconIV: UIImageView = {
        let v = UIImageView()
        return v
    }()
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = kColor_dark
        return l
    }()
    lazy var rightArrow: UIImageView = {
        let v = UIImageView.init(image: UIImage.init(named: "rightArrow"))
        return v
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(iconIV)
        contentView.addSubview(titleLabel)
        contentView.addSubview(rightArrow)
        iconIV.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15 * KScreenRatio_6)
            make.size.equalTo(CGSize.init(width: 35 * KScreenRatio_6, height: 35 * KScreenRatio_6))
            make.centerY.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(iconIV.snp.right).offset(15 * KScreenRatio_6)
            make.right.equalToSuperview().offset(-50 * KScreenRatio_6)
        }
        rightArrow.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15 * KScreenRatio_6)
        }
        separatorView.snp.remakeConstraints { (make) in
            make.height.equalTo(0.5)
            make.width.equalTo(295 * KScreenRatio_6)
            make.right.equalToSuperview().offset(-15 * KScreenRatio_6)
            make.bottom.equalTo(contentView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}


class BXBUserGuideSubCell: BXBBaseTableViewCell {
    
    lazy var headIconIV: UIImageView = {
        let v = UIImageView.init(image: UIImage.init(named: "meGuide_二级"))
        return v
    }()
    lazy var iconIV: UIImageView = {
        let v = UIImageView()
        return v
    }()
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = kColor_theme
        return l
    }()
    lazy var rightArrow: UIImageView = {
        let v = UIImageView.init(image: UIImage.init(named: "rightArrow"))
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(headIconIV)
        contentView.addSubview(iconIV)
        contentView.addSubview(titleLabel)
        contentView.addSubview(rightArrow)
        headIconIV.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15 * KScreenRatio_6)
            make.size.equalTo(CGSize.init(width: 35 * KScreenRatio_6, height: 35 * KScreenRatio_6))
            make.centerY.equalToSuperview()
        }
        iconIV.snp.makeConstraints { (make) in
            make.left.equalTo(headIconIV.snp.right).offset(15 * KScreenRatio_6)
            make.size.equalTo(CGSize.init(width: 35 * KScreenRatio_6, height: 35 * KScreenRatio_6))
            make.centerY.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(iconIV.snp.right).offset(15 * KScreenRatio_6)
            make.right.equalToSuperview().offset(-50 * KScreenRatio_6)
        }
        rightArrow.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15 * KScreenRatio_6)
        }
        separatorView.snp.remakeConstraints { (make) in
            make.height.equalTo(0.5)
            make.width.equalTo(295 * KScreenRatio_6)
            make.right.equalToSuperview().offset(-15 * KScreenRatio_6)
            make.bottom.equalTo(contentView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
