//
//  BXBUserTeamActivityCells.swift
//  BXB
//
//  Created by equalriver on 2018/9/3.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation


class UserTeamActivityNameCell: BXBBaseTableViewCell {
    
    lazy var nameLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text
        l.textAlignment = .center
        l.textColor = kColor_dark
        return l
    }()
    lazy var sepView: UIView = {
        let v = UIView()
        v.backgroundColor = kColor_separatorView
        return v
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        contentView.addSubview(sepView)
        nameLabel.snp.makeConstraints { (make) in
            make.left.height.centerY.equalTo(contentView)
            make.right.equalTo(contentView).offset(-0.5)
        }
        sepView.snp.makeConstraints { (make) in
            make.height.right.centerY.equalTo(contentView)
            make.width.equalTo(0.5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
    }
}



class UserTeamActivityDetailCell: UICollectionViewCell {
    
    public var isFirstCell: Bool! {
        willSet{
            if newValue {
                sepView_2.isHidden = true
            }
        }
    }
    
    lazy var detailLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text
        l.textAlignment = .center
        l.textColor = kColor_dark
        return l
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(detailLabel)
        contentView.addSubview(sepView_1)
        contentView.addSubview(sepView_2)
        detailLabel.snp.makeConstraints { (make) in
            make.left.top.equalTo(contentView)
            make.right.equalTo(sepView_1.snp.left)
            make.bottom.equalTo(sepView_2.snp.top)
        }
        sepView_1.snp.makeConstraints { (make) in
            make.width.equalTo(0.5)
            make.right.centerY.height.equalTo(contentView)
        }
        sepView_2.snp.makeConstraints { (make) in
            make.bottom.left.equalTo(contentView)
            make.height.equalTo(0.5)
            make.right.equalTo(sepView_1.snp.left)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        detailLabel.text = nil
        sepView_2.isHidden = false
    }
}





























