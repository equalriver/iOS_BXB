//
//  BXBUserMyTeamViews.swift
//  BXB
//
//  Created by equalriver on 2018/6/23.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation

class BXBUserMyTeamHeaderView: UIView {
    
    public var data = TeamData() {
        willSet{
            titleLabel.text = newValue.teamName
            nameLabel.text = "管理员：\(newValue.name)"
//            guard let url = URL.init(string: newValue.logo) else { return }
            logoIV.setImageWith(URL.init(string: newValue.logo), placeholder: #imageLiteral(resourceName: "team_placeholder"), options: YYWebImageOptions.allowBackgroundTask, completion: nil)
        }
    }
    
    public var count = 1 {
        willSet{
            numLabel.text = "组员\(newValue)人"
        }
    }
    
    lazy var logoIV: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        return iv
    }()
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 24 * KScreenRatio_6, weight: .semibold)
        l.textColor = UIColor.white
        return l
    }()
    lazy var nameLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text
        l.textColor = UIColor.white
        return l
    }()
    lazy var numLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text
        l.textColor = UIColor.white
        l.textAlignment = .right
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(logoIV)
        addSubview(titleLabel)
        addSubview(nameLabel)
        addSubview(numLabel)
        logoIV.snp.makeConstraints { (make) in
            make.size.centerX.centerY.equalTo(self)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(15 * KScreenRatio_6)
            make.right.equalTo(self).offset(-15 * KScreenRatio_6)
            make.height.equalTo(25 * KScreenRatio_6)
            make.bottom.equalTo(nameLabel.snp.top).offset(-10 * KScreenRatio_6)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-13 * KScreenRatio_6)
            make.left.equalTo(self).offset(15 * KScreenRatio_6)
            make.size.equalTo(CGSize.init(width: 200 * KScreenRatio_6, height: 20 * KScreenRatio_6))
        }
        numLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-10 * KScreenRatio_6)
            make.right.equalTo(self).offset(-15 * KScreenRatio_6)
            make.left.equalTo(nameLabel.snp.right).offset(10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    
}

class BXBUserMyTeamCell: BXBBaseTableViewCell {
    
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = kColor_dark
        return l
    }()
    lazy var subTitleLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text
        l.textColor = kColor_subText
        l.textAlignment = .right
        return l
    }()
    lazy var subIV: UIImageView = {
        let iv = UIImageView()
        iv.isHidden = true
        return iv
    }()
    lazy var rightIV: UIImageView = {
        let iv = UIImageView.init(image: #imageLiteral(resourceName: "rightArrow"))
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(subIV)
        contentView.addSubview(rightIV)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(15 * KScreenRatio_6)
            make.height.centerY.equalTo(contentView)
            make.width.equalTo(90 * KScreenRatio_6)
        }
        subTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right).offset(10 * KScreenRatio_6)
            make.centerY.height.equalTo(contentView)
            make.right.equalTo(rightIV.snp.left).offset(-10 * KScreenRatio_6)
        }
        subIV.snp.makeConstraints { (make) in
            make.right.equalTo(rightIV.snp.left).offset(-10 * KScreenRatio_6)
            make.centerY.equalTo(contentView)
        }
        rightIV.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).offset(-15 * KScreenRatio_6)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
