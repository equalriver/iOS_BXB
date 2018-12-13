//
//  BXBMessageCell.swift
//  BXB
//
//  Created by equalriver on 2018/8/20.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit

protocol MessageCellDelegate: NSObjectProtocol {
    func didSelectedFollow(cell: UITableViewCell)
}

class BXBMessageCell: BXBBaseTableViewCell {

    weak public var delegate: MessageCellDelegate?
    
    public var data = NoticeDetailData(){
        willSet{
            titleLabel.text = newValue.matter + "信息"
            nameLabel.text = newValue.name
            matterLabel.text = newValue.matter + " " + newValue.remindName
            
            let s1 = newValue.times
            let s2 = "距今\(newValue.difTime)天"
//            let att = NSMutableAttributedString.init(string: s1 + " " + s2)
//            att.addAttributes([.foregroundColor: kColor_theme!, .font: kFont_text_3], range: NSMakeRange(0, s1.count))
//            att.addAttributes([.foregroundColor: kColor_subText!, .font: kFont_text_3], range: NSMakeRange(s1.count, s2.count + 1))
            timeLabel.text = s1 + "  " + s2
            
            if newValue.isFollow == "0" {
                followBtn.setTitle("跟进", for: .normal)
                followBtn.backgroundColor = kColor_theme
            }
            else {
                followBtn.setTitle("已跟进", for: .normal)
                followBtn.backgroundColor = kColor_naviBottomSepView
            }
            
            if newValue.matter == "生日" { iconIV.image = UIImage.init(named: "msg_生日") }
            if newValue.matter == "纪念日" { iconIV.image = UIImage.init(named: "msg_纪念日") }
            if newValue.matter == "保单" { iconIV.image = UIImage.init(named: "msg_合同") }
            if newValue.matter == "其他" { iconIV.image = UIImage.init(named: "msg_更多") }
        }
    }
    lazy var bgView: UIImageView = {
        let v = UIImageView()
        v.isUserInteractionEnabled = true
        return v
    }()
    lazy var iconIV: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_2
        l.textColor = kColor_text
        return l
    }()
    lazy var followBtn: UIButton = {
        let b = UIButton()
        b.titleLabel?.font = kFont_text_3
        b.setTitle("跟进", for: .normal)
        b.setTitleColor(UIColor.white, for: .normal)
        b.backgroundColor = kColor_theme
        b.layer.cornerRadius = 5
        b.layer.masksToBounds = true
        b.layer.drawsAsynchronously = true
        b.backgroundColor = UIColor.white
        b.addBlock(for: .touchUpInside, block: { [unowned self](btn) in
            self.delegate?.didSelectedFollow(cell: self)
        })
        return b
    }()
    lazy var sepView: UIView = {
        let v = UIView()
        v.backgroundColor = kColor_background
        return v
    }()
    
    lazy var matterLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = kColor_dark
        return l
    }()
    lazy var nameLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = kColor_dark
        l.textAlignment = .right
        return l
    }()
    lazy var timeLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_3
        l.textColor = kColor_subText
        return l
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        isNeedSeparatorView = false
        contentView.backgroundColor = kColor_background
        contentView.addSubview(bgView)
        bgView.addSubview(iconIV)
        bgView.addSubview(titleLabel)
        bgView.addSubview(followBtn)
        bgView.addSubview(sepView)
        bgView.addSubview(matterLabel)
        bgView.addSubview(nameLabel)
        bgView.addSubview(timeLabel)
        makeConstraints()
        UIImage.init(color: UIColor.white)?.asyncDrawCornerRadius(roundedRect: CGRect.init(x: 0, y: 0, width: 345, height: 110), cornerRadius: kCornerRadius, fillColor: kColor_background!, callback: { (img) in
            self.bgView.image = img
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconIV.image = nil
        titleLabel.text = nil
        matterLabel.text = nil
        nameLabel.text = nil
        timeLabel.attributedText = nil
    }
    
    func makeConstraints() {
        bgView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 345 * KScreenRatio_6 , height: 110 * KScreenRatio_6))
//            make.centerX.bottom.equalTo(contentView)
            make.center.equalTo(contentView)
        }
        iconIV.snp.makeConstraints { (make) in
            make.left.equalTo(bgView).offset(15 * KScreenRatio_6)
            make.top.equalTo(bgView).offset(12 * KScreenRatio_6)
            make.size.equalTo(CGSize.init(width: 20 * KScreenRatio_6, height: 20 * KScreenRatio_6))
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconIV.snp.right).offset(10 * KScreenRatio_6)
            make.centerY.equalTo(iconIV)
            make.right.equalTo(followBtn.snp.left).offset(-10 * KScreenRatio_6)
        }
        followBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 50 * KScreenRatio_6, height: 25 * KScreenRatio_6))
            make.right.equalTo(bgView).offset(-15 * KScreenRatio_6)
            make.centerY.equalTo(iconIV)
        }
        sepView.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.width.centerX.equalTo(bgView)
            make.top.equalTo(iconIV.snp.bottom).offset(12 * KScreenRatio_6)
        }
        matterLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconIV)
            make.top.equalTo(sepView.snp.bottom).offset(10 * KScreenRatio_6)
            make.width.equalTo(200 * KScreenRatio_6)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.right.equalTo(followBtn)
            make.left.equalTo(matterLabel.snp.right)
            make.centerY.equalTo(matterLabel)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.left.width.equalTo(matterLabel)
            make.top.equalTo(matterLabel.snp.bottom).offset(5)
        }
    }

}














