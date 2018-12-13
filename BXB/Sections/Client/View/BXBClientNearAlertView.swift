//
//  BXBClientNearAlertView.swift
//  BXB
//
//  Created by equalriver on 2018/8/24.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit

protocol ClientNearAlertDelegate: NSObjectProtocol {
    func didClickLocation(data: ClientNearData)
    func didClickPhone(phone: String)
    func didClickAddNewAgenda(data: ClientNearData)
}

class BXBClientNearAlertView: UIView {
    
    weak public var delegate: ClientNearAlertDelegate?

    public var data = ClientNearData(){
        willSet{
            nameLabel.text = newValue.name
            stateIV.isHidden = newValue.isWrite == 0
            distanceLabel.text = newValue.label
            addressLabel.text = newValue.unitAddress + " " + newValue.residentialAddress
            if newValue.visitCount != 0 {
                let day = newValue.visitTime == 0 ? "今天" : "\(newValue.visitTime)天前"
                interactionLabel.text = "上次互动\(day) 互动次数\(newValue.visitCount)次"
            }
            else {
                interactionLabel.text = "无互动"
            }
            distanceLabel.snp.updateConstraints { (make) in
                make.width.equalTo(newValue.label.getStringWidth(font: kFont_text_2, height: 15 * KScreenRatio_6) + 5)
            }
        }
    }
    
    lazy var contentView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        v.layer.cornerRadius = kCornerRadius
        v.layer.masksToBounds = true
        return v
    }()
    lazy var nameLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_btn_weight
        l.textColor = kColor_dark
        return l
    }()
    lazy var stateIV: UIImageView = {
        let v = UIImageView.init(image: #imageLiteral(resourceName: "已签单"))
        v.isHidden = true
        return v
    }()
    lazy var distanceLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_2
        l.textColor = kColor_dark
        return l
    }()
    lazy var addressLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_2
        l.textColor = kColor_dark
        return l
    }()
    lazy var interactionLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_3
        l.textColor = kColor_subText
        return l
    }()
    lazy var sepView_1: UIView = {
        let v = UIView()
        v.backgroundColor = kColor_background
        return v
    }()
    lazy var sepView_2: UIView = {
        let v = UIView()
        v.backgroundColor = kColor_background
        return v
    }()
    lazy var sepView_3: UIView = {
        let v = UIView()
        v.backgroundColor = kColor_background
        return v
    }()
    lazy var locationBtn: UIButton = {
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "map_导航"), for: .normal)
        b.addBlock(for: .touchUpInside, block: { [unowned self](btn) in
            self.delegate?.didClickLocation(data: self.data)
        })
        return b
    }()
    lazy var phoneButton: UIButton = {
        let b = UIButton()
        b.backgroundColor = UIColor.white
        b.setImage(#imageLiteral(resourceName: "map_致电"), for: .normal)
        b.titleLabel?.font = kFont_text_2
        b.setTitle(" 致电", for: .normal)
        b.setTitleColor(kColor_dark, for: .normal)
        b.addBlock(for: .touchUpInside, block: { [unowned self](btn) in
            self.delegate?.didClickPhone(phone: self.data.phone)
        })
        return b
    }()
    lazy var addNewAgendaBtn: UIButton = {
        let b = UIButton()
        b.backgroundColor = UIColor.white
        b.setImage(#imageLiteral(resourceName: "map_新建日程"), for: .normal)
        b.titleLabel?.font = kFont_text_2
        b.setTitle(" 新建日程", for: .normal)
        b.setTitleColor(kColor_dark, for: .normal)
        b.addBlock(for: .touchUpInside, block: { [unowned self](btn) in
            self.delegate?.didClickAddNewAgenda(data: self.data)
        })
        return b
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        backgroundColor = UIColor.clear
        isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.3, animations: {
            
            var center = self.center
            center.y -= (self.height + 10)
            self.center = center
            
        }) { (isFinished) in

        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI() {
        addSubview(contentView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(stateIV)
        contentView.addSubview(distanceLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(interactionLabel)
        contentView.addSubview(sepView_1)
        contentView.addSubview(sepView_2)
        contentView.addSubview(sepView_3)
        addSubview(locationBtn)
        contentView.addSubview(phoneButton)
        contentView.addSubview(addNewAgendaBtn)
        contentView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 355 * KScreenRatio_6, height: 155 * KScreenRatio_6))
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(50 * KScreenRatio_6)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(20 * KScreenRatio_6)
            make.top.equalTo(contentView).offset(15 * KScreenRatio_6)
        }
        stateIV.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.right).offset(10 * KScreenRatio_6)
            make.centerY.equalTo(nameLabel)
        }
        distanceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(10 * KScreenRatio_6)
            make.height.equalTo(15 * KScreenRatio_6)
            make.width.equalTo(30 * KScreenRatio_6)
        }
        sepView_1.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 1, height: 12))
            make.centerY.equalTo(distanceLabel)
            make.left.equalTo(distanceLabel.snp.right).offset(5)
        }
        addressLabel.snp.makeConstraints { (make) in
            make.height.centerY.equalTo(distanceLabel)
            make.left.equalTo(sepView_1.snp.right).offset(5)
            make.right.equalTo(contentView).offset(-10 * KScreenRatio_6)
        }
        interactionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(distanceLabel)
            make.top.equalTo(distanceLabel.snp.bottom).offset(10 * KScreenRatio_6)
            make.right.equalTo(contentView).offset(-10 * KScreenRatio_6)
        }
        sepView_2.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 315 * KScreenRatio_6, height: 1))
            make.top.equalTo(interactionLabel.snp.bottom).offset(15 * KScreenRatio_6)
            make.centerX.equalTo(contentView)
        }
        phoneButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 170 * KScreenRatio_6, height: 50 * KScreenRatio_6))
            make.left.bottom.equalTo(contentView)
        }
        sepView_3.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 1, height: 25 * KScreenRatio_6))
            make.centerX.equalTo(contentView)
            make.centerY.equalTo(phoneButton)
        }
        addNewAgendaBtn.snp.makeConstraints { (make) in
            make.size.equalTo(phoneButton)
            make.right.bottom.equalTo(contentView)
        }
        locationBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 100 * KScreenRatio_6, height: 100 * KScreenRatio_6))
            make.top.equalTo(contentView).offset(-50 * KScreenRatio_6)
            make.right.equalTo(contentView).offset(-20 * KScreenRatio_6)
        }
    }
    
}













