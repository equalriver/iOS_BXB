//
//  BXBLoginCodeTextFieldView.swift
//  BXB
//
//  Created by equalriver on 2018/7/5.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit

class BXBLoginCodeTextFieldView: UIView {

    
    lazy var bottomView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        return v
    }()
    
    lazy var inputTF: UITextField = {
        let tf = UITextField()
        tf.textColor = UIColor.white
        tf.font = UIFont.systemFont(ofSize: 18 * KScreenRatio_6)
        tf.keyboardType = .numbersAndPunctuation
        tf.contentHorizontalAlignment = .center
        return tf
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bottomView)
        addSubview(inputTF)
        inputTF.snp.makeConstraints { (make) in
            make.top.right.equalTo(self)
            make.bottom.equalTo(bottomView.snp.top).offset(-2)
            make.left.equalTo(self).offset(20 * KScreenRatio_6)
        }
        bottomView.snp.makeConstraints { (make) in
            make.bottom.width.centerX.equalTo(self)
            make.height.equalTo(0.5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
