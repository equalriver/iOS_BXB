//
//  BXBUserMyTeamDetailViews.swift
//  BXB
//
//  Created by equalriver on 2018/7/3.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation


//MARK: - 新的申请

protocol UserMyTeamDetailNewApplyDelegate: NSObjectProtocol {
    func didClickAccept(cell: BXBBaseTableViewCell)
    func didClickIgnore(cell: BXBBaseTableViewCell)
}

class UserMyTeamDetailNewApplyCell: BXBBaseTableViewCell {
    
    public var applyData = TeamPersonData(){
        willSet{
            titleLabel.text = newValue.name
            if newValue.name.isIncludeChinese {
                if newValue.name.isAllChinese { headLabel.text = newValue.name.last?.description }
                else { headLabel.text = newValue.name.first?.description }
            }
            else { headLabel.text = newValue.name.first?.description }
        }
    }
    
    weak public var delegate: UserMyTeamDetailNewApplyDelegate?
    
    lazy var headLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = UIColor.white
        l.backgroundColor = kColor_theme
        l.textAlignment = .center
        l.layer.cornerRadius = 18 * KScreenRatio_6
        l.layer.masksToBounds = true
        l.layer.drawsAsynchronously = true
        return l
    }()
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = kColor_dark
        return l
    }()
    lazy var ignoreButton: UIButton = {
        let b = UIButton()
        b.titleLabel?.font = kFont_text_2_weight
        b.setTitleColor(kColor_text, for: .normal)
        b.backgroundColor = UIColor.init(hexString: "#f5f6f8")
        b.setTitle("忽略", for: .normal)
        b.layer.cornerRadius = 5
        b.layer.masksToBounds = true
        b.layer.drawsAsynchronously = true
        b.addBlock(for: .touchUpInside, block: { [unowned self](sender) in
            self.delegate?.didClickIgnore(cell: self)
        })
        return b
    }()
    lazy var acceptButton: UIButton = {
        let b = UIButton()
        b.titleLabel?.font = kFont_text_2_weight
        b.backgroundColor = kColor_theme
        b.setTitleColor(UIColor.white, for: .normal)
        b.setTitle("同意", for: .normal)
        b.layer.cornerRadius = 5
        b.layer.masksToBounds = true
        b.layer.drawsAsynchronously = true
        b.addBlock(for: .touchUpInside, block: { [unowned self](sender) in
            self.delegate?.didClickAccept(cell: self)
        })
        return b
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(headLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(ignoreButton)
        contentView.addSubview(acceptButton)
        headLabel.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 36 * KScreenRatio_6, height: 36 * KScreenRatio_6))
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(15 * KScreenRatio_6)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headLabel.snp.right).offset(15 * KScreenRatio_6)
            make.centerY.height.equalTo(contentView)
            make.width.equalTo(150 * KScreenRatio_6)
        }
        ignoreButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 50 * KScreenRatio_6, height: 27 * KScreenRatio_6))
            make.right.equalTo(acceptButton.snp.left).offset(-10 * KScreenRatio_6)
        }
        acceptButton.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-15 * KScreenRatio_6)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 50 * KScreenRatio_6, height: 27 * KScreenRatio_6))
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        headLabel.text = nil
    }
}

//MARK: - 团队成员

class UserMyTeamDetailMemberCell: BXBBaseTableViewCell {
    
    public var data = TeamData(){
        willSet{
            titleLabel.text = newValue.name
            managerLabel.isHidden = newValue.label != "群主"
            
            if newValue.name.isIncludeChinese {
                if newValue.name.isAllChinese { headLabel.text = newValue.name.last?.description }
                else { headLabel.text = newValue.name.first?.description }
            }
            else { headLabel.text = newValue.name.first?.description }
            
            titleLabel.snp.updateConstraints { (make) in
                make.width.equalTo(newValue.name.getStringWidth(font: kFont_text_weight, height: 20 * KScreenRatio_6) + 15 * KScreenRatio_6)
            }
        }
    }
    
    lazy var headLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = UIColor.white
        l.backgroundColor = kColor_theme
        l.textAlignment = .center
        l.layer.cornerRadius = 18 * KScreenRatio_6
        l.layer.masksToBounds = true
        l.layer.drawsAsynchronously = true
        return l
    }()
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = kColor_dark
        return l
    }()
    lazy var managerLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 10 * KScreenRatio_6)
        l.textColor = kColor_theme
        l.text = "管理员"
        l.textAlignment = .center
        l.layer.cornerRadius = 7.5 * KScreenRatio_6
        l.layer.masksToBounds = true
        l.layer.borderColor = kColor_theme?.cgColor
        l.layer.borderWidth = 1
        l.layer.drawsAsynchronously = true
        l.isHidden = true
        return l
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(headLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(managerLabel)
        headLabel.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 36 * KScreenRatio_6, height: 36 * KScreenRatio_6))
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(15 * KScreenRatio_6)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headLabel.snp.right).offset(15 * KScreenRatio_6)
            make.centerY.height.equalTo(contentView)
            make.width.equalTo(50 * KScreenRatio_6)
        }
        managerLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 44 * KScreenRatio_6, height: 15 * KScreenRatio_6))
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        headLabel.text = nil
    }
    
}

//MARK: - 查看团员活动量
class UserMyTeamDetailActivityCell: BXBBaseTableViewCell {
    
    public var data = TeamData(){
        willSet{
            titleLabel.text = newValue.name
            subTitleLabel.isHidden = newValue.label != "群主"
        }
    }
    
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text
        l.textColor = kColor_text
        return l
    }()
    lazy var subTitleLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 13 * KScreenRatio_6)
        l.textColor = kColor_subText
        l.text = "管理员"
        l.isHidden = true
        return l
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.height.equalTo(contentView)
            make.left.equalTo(contentView).offset(15 * KScreenRatio_6)
        }
        subTitleLabel.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-15 * KScreenRatio_6)
            make.centerY.height.equalTo(contentView)
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
