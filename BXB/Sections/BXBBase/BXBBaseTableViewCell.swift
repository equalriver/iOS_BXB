//
//  BXBBaseTableViewCell.swift
//  BXB
//
//  Created by equalriver on 2018/6/8.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit

class BXBBaseTableViewCell: UITableViewCell {
    
    public var isNeedSeparatorView = true {
        willSet{
            separatorView.isHidden = !newValue
        }
    }
    
    lazy var separatorView: UIView = {
        let v = UIView()
        v.backgroundColor = kColor_naviBottomSepView
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.white
        selectionStyle = .none
        contentView.addSubview(separatorView)
        separatorView.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.width.bottom.centerX.equalTo(contentView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

 
    

}
