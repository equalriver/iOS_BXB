//
//  BXBClientUserAllCell.swift
//  BXB
//
//  Created by equalriver on 2018/6/17.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit

protocol ClientUserAllNoticeDelegate: NSObjectProtocol {
    func didClickNoticeButton(index: Int)
}

class BXBClientUserAllCell: BXBBaseTableViewCell {
    
    
    public var data = ClientData(){
        willSet{
            nameLabel.text = newValue.name
            if newValue.visitCount != 0 {
                detailLabel.text = newValue.visitTime == 0 ? "上次互动今天" + "  " + "互动\(newValue.visitCount)次" : "上次互动\(newValue.visitTime)天前" + "  " + "互动\(newValue.visitCount)次"
            }
            else { detailLabel.text = "无互动" }
            tagIV.isHidden = newValue.isWrite != "已签单"
            noticeLabel.text = newValue.remind
            if newValue.name.isIncludeChinese {
                if newValue.name.isAllChinese { headLabel.text = newValue.name.last?.description }
                else { headLabel.text = newValue.name.first?.description }
            }
            else { headLabel.text = newValue.name.first?.description }
        }
    }
    
    weak public var delegate: ClientUserAllNoticeDelegate?
    
    lazy var headLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = UIColor.white
        l.textAlignment = .center
        l.backgroundColor = kColor_theme
        l.layer.cornerRadius = 18 * KScreenRatio_6
        l.layer.masksToBounds = true
        l.layer.drawsAsynchronously = true
        return l
    }()
    
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
    
    lazy var tagIV: UIImageView = {
        let iv = UIImageView.init(image: #imageLiteral(resourceName: "已签单"))
        return iv
    }()
    
    lazy var noticeLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_3
        l.textColor = kColor_subText
        l.textAlignment = .right
        return l
    }()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(headLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(tagIV)
        contentView.addSubview(noticeLabel)
        makeConstaints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        headLabel.text = nil
        nameLabel.text = nil
        detailLabel.text = nil
        noticeLabel.text = nil
        tagIV.isHidden = true
    }
    
    @objc func noticeAction(sender: UIButton) {
        delegate?.didClickNoticeButton(index: sender.tag)
    }
    
    func makeConstaints() {
        headLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(15 * KScreenRatio_6)
            make.size.equalTo(CGSize.init(width: 36 * KScreenRatio_6, height: 36 * KScreenRatio_6))
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headLabel.snp.right).offset(15 * KScreenRatio_6)
            make.top.equalTo(contentView).offset(11 * KScreenRatio_6)
        }
        detailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(3)
            make.width.equalTo(300 * KScreenRatio_6)
        }
        tagIV.snp.makeConstraints { (make) in
            make.centerY.equalTo(nameLabel)
            make.left.equalTo(nameLabel.snp.right).offset(10 * KScreenRatio_6)
        }
        noticeLabel.snp.makeConstraints { (make) in
            make.width.equalTo(90 * KScreenRatio_6)
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).offset(-8 * KScreenRatio_6)
        }

    }
    
}
