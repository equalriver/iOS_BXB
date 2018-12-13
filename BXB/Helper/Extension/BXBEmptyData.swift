//
//  BXBEmptyData.swift
//  BXB
//
//  Created by equalriver on 2018/7/10.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation

extension UITableView {
    
    public func stateLoading() {
        
        self.isScrollEnabled = false
        
        for v in self.subviews {
            if v.tag == emptyButtonTag || v.tag == errorButtonTag || v.tag == loadingImageViewTag { v.removeFromSuperview() }
        }
        
        let iv = self.createStateLoadingIV()
        iv.startAnimating()
    }
    
    public func stateNormal() {
        
        self.isScrollEnabled = true
        
        for v in self.subviews {
            if v.tag == emptyButtonTag || v.tag == errorButtonTag || v.tag == loadingImageViewTag { v.removeFromSuperview() }
        }
    }
    
    public func stateEmpty(title: String?, img: UIImage?, buttonTitle: String?, handle: (() -> Void)?) {
        
        self.isScrollEnabled = true
        
        for v in self.subviews {
            if v.tag == emptyButtonTag || v.tag == errorButtonTag || v.tag == loadingImageViewTag { v.removeFromSuperview() }
        }
        self.createStateEmptyView(title: title, img: img, btnTitle: buttonTitle) {
            if handle != nil { handle!() }
        }
        
    }
    
    public func stateError(handle: (() -> Void)?) {
        
        self.isScrollEnabled = false
        
        for v in self.subviews {
            if v.tag == emptyButtonTag || v.tag == errorButtonTag || v.tag == loadingImageViewTag { v.removeFromSuperview() }
        }
        self.createStateErrorBtn {
            if handle != nil { handle!() }
        }
        
    }
    
    //MARK: - private method
    private func createStateEmptyView(title: String?, img: UIImage?, btnTitle: String?, handle: @escaping () -> Void) {
        
        let v = UIView()
        v.backgroundColor = self.backgroundColor
        v.tag = emptyButtonTag
        self.addSubview(v)
        v.snp.makeConstraints { (make) in
            make.size.centerX.centerY.equalTo(self)
        }
        
        let imgIV = UIImageView.init(image: img)
        v.addSubview(imgIV)
        imgIV.snp.makeConstraints { (make) in
            make.centerX.equalTo(v)
            make.centerY.equalTo(v).multipliedBy(0.6)
        }
        
        let titleLabel = UILabel()
        titleLabel.font = kFont_text_2
        titleLabel.textColor = kColor_text
        titleLabel.text = title
        titleLabel.textAlignment = .center
        v.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.width.centerX.equalTo(v)
            make.top.equalTo(imgIV.snp.bottom).offset(15 * KScreenRatio_6)
            make.height.equalTo(20 * KScreenRatio_6)
        }
        
        if btnTitle != nil {
            let stateEmptyBtn = UIButton()
            stateEmptyBtn.backgroundColor = kColor_theme
            stateEmptyBtn.titleLabel?.font = kFont_text_3_weight
            stateEmptyBtn.setTitle(btnTitle, for: .normal)
            stateEmptyBtn.setTitleColor(UIColor.white, for: .normal)
            stateEmptyBtn.layer.cornerRadius = kCornerRadius
            stateEmptyBtn.layer.masksToBounds = true
            v.addSubview(stateEmptyBtn)
            stateEmptyBtn.snp.makeConstraints { (make) in
                make.size.equalTo(CGSize.init(width: 114 * KScreenRatio_6, height: 34 * KScreenRatio_6))
                make.centerX.equalTo(v)
                make.top.equalTo(titleLabel.snp.bottom).offset(20 * KScreenRatio_6)
            }
            stateEmptyBtn.addBlock(for: .touchUpInside) { (btn) in
                handle()
            }
        }
        
    }
    
    private func createStateLoadingIV() -> UIImageView {
        
        let stateLoadingIV = UIImageView()
        stateLoadingIV.tag = loadingImageViewTag
        self.addSubview(stateLoadingIV)
        
        stateLoadingIV.snp.remakeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(CGSize.init(width: 40 * KScreenRatio_6, height: 40 * KScreenRatio_6))
        }
//        var imgs = Array<UIImage>()
//
//        for v in 1...30 {
//            if let img = UIImage.init(named: "图层\(v)") {
//                imgs.append(img)
//            }
//        }
//        stateLoadingIV.animationImages = imgs
//        stateLoadingIV.animationDuration = 1
//        stateLoadingIV.animationRepeatCount = 0
        
        return stateLoadingIV
    }
    
    private func createStateErrorBtn(handle: @escaping () -> Void) {
        
        let stateErrorBtn = UIButton()
        stateErrorBtn.tag = errorButtonTag
        stateErrorBtn.backgroundColor = kColor_background
        stateErrorBtn.titleLabel?.font = kFont_text
        stateErrorBtn.setTitle("网络连接失败\n 点击重试", for: .normal)
        stateErrorBtn.setTitleColor(kColor_text, for: .normal)
        stateErrorBtn.addBlock(for: .touchUpInside) { (sender) in
            handle()
        }
        self.addSubview(stateErrorBtn)
        stateErrorBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 200, height: 60))
            make.center.equalTo(self)
        }
    }
    
}


