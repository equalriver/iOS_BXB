//
//  BXBAddNewClientCells.swift
//  BXB
//
//  Created by equalriver on 2018/6/20.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit

class BXBAddNewClientCell: BXBBaseTableViewCell {
    
    lazy var inputTF: UITextField = {
        let tf = UITextField()
        tf.font = kFont_text_weight
        tf.textColor = kColor_dark
        tf.clearButtonMode = .whileEditing
        return tf
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(inputTF)
        inputTF.snp.makeConstraints { (make) in
            make.centerY.height.equalTo(contentView)
            make.left.equalTo(contentView).offset(15 * KScreenRatio_6)
            make.right.equalTo(contentView).offset(-15 * KScreenRatio_6)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class BXBAddNewClientMoreCell: BXBBaseTableViewCell {
    
    public var title = ""{
        willSet{
            titleLabel.text = newValue
        }
    }
    
    public var detail = ""{
        willSet{
            if newValue == "0" {
                detailLabel.text = "未设置"
            }
            detailLabel.text = newValue.count > 0 ? newValue : "未设置"
        }
    }
    
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = kColor_dark
        return l
    }()
    
    lazy var detailLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text
        l.textColor = kColor_subText
        l.textAlignment = .right
        l.text = "未设置"
        return l
    }()
    
    lazy var rightIV: UIImageView = {
        let iv = UIImageView.init(image: #imageLiteral(resourceName: "rightArrow"))
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(rightIV)
        titleLabel.snp.makeConstraints { (make) in
            make.height.centerY.equalTo(contentView)
            make.width.equalTo(70 * KScreenRatio_6)
            make.left.equalTo(contentView).offset(15 * KScreenRatio_6)
        }
        rightIV.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).offset(-15 * KScreenRatio_6)
            make.size.equalTo(CGSize.init(width: 5, height: 9))
        }
        detailLabel.snp.makeConstraints { (make) in
            make.height.centerY.equalTo(contentView)
            make.right.equalTo(rightIV.snp.left).offset(-15 * KScreenRatio_6)
            make.left.equalTo(titleLabel.snp.right).offset(20 * KScreenRatio_6)
        }
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


protocol AddNewClientAddressDelegate: NSObjectProtocol {
    func didEditRemarkAddress(sender: UITextField, cell: BXBAddNewClientAddressCell)
}

class BXBAddNewClientAddressCell: BXBBaseTableViewCell {
    
    weak public var delegate: AddNewClientAddressDelegate?
    
    public var title = ""{
        willSet{
            titleLabel.text = newValue
        }
    }
    
    public var detail = ""{
        willSet{
            if newValue == "0" {
                detailLabel.text = "未设置"
            }
            detailLabel.text = newValue.count > 0 ? newValue : "未设置"
        }
    }
    
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = kColor_dark
        return l
    }()
    lazy var sepView: UIView = {
        let v = UIView()
        v.backgroundColor = kColor_separatorView
        return v
    }()
    lazy var addressTF: UITextField = {
        let tf = UITextField()
        tf.font = kFont_text_2
        tf.textColor = kColor_subText
        tf.clearButtonMode = .whileEditing
        tf.attributedPlaceholder = NSAttributedString.init(string: "填写备注信息(门牌号、楼层等)", attributes: [NSAttributedString.Key.font: kFont_text_2, NSAttributedString.Key.foregroundColor: kColor_subText!])
        tf.addBlock(for: .editingChanged, block: { [unowned self](t) in

            self.delegate?.didEditRemarkAddress(sender: tf, cell: self)
        })
        return tf
    }()
    lazy var detailLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text
        l.textColor = kColor_subText
        l.textAlignment = .right
        l.text = "未设置"
        return l
    }()
    
    lazy var rightIV: UIImageView = {
        let iv = UIImageView.init(image: #imageLiteral(resourceName: "rightArrow"))
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(rightIV)
        contentView.addSubview(sepView)
        contentView.addSubview(addressTF)
        titleLabel.snp.makeConstraints { (make) in
            make.height.equalTo(54 * KScreenRatio_6)
            make.top.equalTo(contentView)
            make.width.equalTo(70 * KScreenRatio_6)
            make.left.equalTo(contentView).offset(15 * KScreenRatio_6)
        }
        rightIV.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel)
            make.right.equalTo(contentView).offset(-15 * KScreenRatio_6)
            make.size.equalTo(CGSize.init(width: 5, height: 9))
        }
        detailLabel.snp.makeConstraints { (make) in
            make.height.centerY.equalTo(titleLabel)
            make.right.equalTo(rightIV.snp.left).offset(-15 * KScreenRatio_6)
            make.left.equalTo(titleLabel.snp.right).offset(20 * KScreenRatio_6)
        }
        sepView.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.left.equalTo(contentView).offset(15 * KScreenRatio_6)
            make.right.equalTo(contentView).offset(-15 * KScreenRatio_6)
            make.centerY.equalTo(contentView)
        }
        addressTF.snp.makeConstraints { (make) in
            make.top.equalTo(sepView.snp.bottom)
            make.left.equalTo(titleLabel)
            make.right.equalTo(sepView)
            make.bottom.equalTo(contentView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



