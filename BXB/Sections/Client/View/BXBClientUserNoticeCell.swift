//
//  BXBClientUserNoticeCell.swift
//  BXB
//
//  Created by equalriver on 2018/8/2.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation


class BXBClientUserNoticeCell: BXBBaseTableViewCell {
    
    public var data = ClientData(){
        willSet{
            nameLabel.text = newValue.name
            remarksLabel.text = newValue.remindName + "  " + newValue.times
            typeLabel.text = newValue.matter
            if newValue.visitCount != 0 {
                interactionLabel.text = newValue.visitTime == 0 ? "上次互动今天" + "  " + "互动\(newValue.visitCount)次" : "上次互动\(newValue.visitTime)天前" + "  " + "互动\(newValue.visitCount)次"
            }
            else { interactionLabel.text = "无互动" }
           
            typeLabel.snp.updateConstraints { (make) in
                make.width.equalTo(CGFloat(newValue.matter.count) * 10 * KScreenRatio_6 + 15 * KScreenRatio_6)
            }
            
            if newValue.name.isIncludeChinese {
                if newValue.name.isAllChinese { headLabel.text = newValue.name.last?.description }
                else { headLabel.text = newValue.name.first?.description }
            }
            else { headLabel.text = newValue.name.first?.description }
            
            var days = ""
            days = "\(newValue.time)"

            var str = "\(days) 天后"
            if days == "0" {
                str = "今天"
                noticeLabel.text = str
                noticeLabel.textColor = kColor_theme
                return
            }
            else if days == "-1" {
                str = "已过期"
                noticeLabel.text = str
                noticeLabel.textColor = kColor_theme
                return
            }
            else if days == "" { return }
            let att = NSMutableAttributedString.init(string: str)
            att.addAttributes([.font: kFont_text_2_weight, .foregroundColor: kColor_theme!], range: NSMakeRange(0, str.count - 3))
            att.addAttributes([.font: kFont_text_3_weight, .foregroundColor: kColor_theme!], range: NSMakeRange(str.count - 3, 3))
            noticeLabel.attributedText = att
        }
    }
    
    
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
    lazy var interactionLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_3
        l.textColor = kColor_subText
        return l
    }()
    lazy var typeLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 10 * KScreenRatio_6, weight: .semibold)
        l.backgroundColor = kColor_background
        l.textColor = kColor_text
        l.textAlignment = .center
        l.layer.masksToBounds = true
        l.layer.cornerRadius = 7.5 * KScreenRatio_6
        l.layer.drawsAsynchronously = true
        return l
    }()
    lazy var remarksLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 10 * KScreenRatio_6, weight: .semibold)
        l.textColor = kColor_text
        l.backgroundColor = UIColor.white
        return l
    }()
    
    lazy var noticeLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_2_weight
        l.textColor = kColor_theme
        l.textAlignment = .right
        return l
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        contentView.addSubview(headLabel)
        contentView.addSubview(interactionLabel)
        contentView.addSubview(remarksLabel)
        contentView.addSubview(noticeLabel)
        contentView.addSubview(typeLabel)
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        headLabel.text = nil
        noticeLabel.attributedText = nil
        remarksLabel.text = nil
        typeLabel.text = nil
        interactionLabel.text = nil
    }
    
    func makeConstraints() {
        headLabel.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 36 * KScreenRatio_6, height: 36 * KScreenRatio_6))
            make.left.equalTo(contentView).offset(17 * KScreenRatio_6)
            make.top.equalTo(contentView).offset(13 * KScreenRatio_6)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(15 * KScreenRatio_6)
            make.left.equalTo(headLabel.snp.right).offset(15 * KScreenRatio_6)
        }
        interactionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.right.equalTo(contentView).offset(-15 * KScreenRatio_6)
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
        }
        typeLabel.snp.makeConstraints { (make) in
            make.height.equalTo(15 * KScreenRatio_6)
            make.width.equalTo(35 * KScreenRatio_6)
            make.top.equalTo(interactionLabel.snp.bottom).offset(5)
            make.left.equalTo(nameLabel)
        }
        remarksLabel.snp.makeConstraints { (make) in
            make.height.equalTo(15 * KScreenRatio_6)
            make.right.equalTo(noticeLabel.snp.left)
            make.left.equalTo(typeLabel.snp.right).offset(5)
            make.centerY.equalTo(typeLabel)
        }
        noticeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-15 * KScreenRatio_6)
            make.centerY.equalTo(typeLabel)
            make.width.equalTo(80 * KScreenRatio_6)
        }
    }
    
    
}
