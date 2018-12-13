//
//  BXBBaseNavigationBar.swift
//  BXB
//
//  Created by 尹平江 on 2018/6/1.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit
import SnapKit

public protocol BaseNavigationButtonDelegate: class {
    func leftButtonsAction(sender: UIButton)
    func rightButtonsAction(sender: UIButton)
}

class BXBBaseNavigationBar: UIView {

    weak public var delegate: BaseNavigationButtonDelegate?
    
    ///导航背景色
    public var naviBackgroundColor = UIColor.white {
        willSet{
            for v in self.subviews {
                v.backgroundColor = newValue
                backgroundColor = newValue
            }
        }
    }
    
    public var titleText = "" {
        willSet{
            if titleView.isKind(of: UILabel.self) {
                let label = titleView as! UILabel
                label.text = newValue
            }
        }
    }
    
    public var titleColor = kColor_text! {
        willSet{
            if titleView.isKind(of: UILabel.self) {
                let label = titleView as! UILabel
                label.textColor = newValue
            }
        }
    }
    
    ///底部的黑线
    public lazy var bottomBlackLineView: UIView = {
        let v = UIView.init(frame: CGRect.init(x: 0, y: self.frame.size.height, width: self.frame.size.width, height: 0.5))
        v.backgroundColor = kColor_background
        v.isOpaque = true
        return v
    }()
    
    ///背景图
    public var backgroundImage = UIImage() {
        willSet{
            self.layer.contents = newValue.cgImage
        }
    }
   
    ///title view
    public lazy var titleView: UIView = {
        let v = UILabel.init()
        v.backgroundColor = .clear
        v.font = UIFont.systemFont(ofSize: 18 * KScreenRatio_6, weight: .semibold)
        v.textColor = kColor_text
        v.textAlignment = .center
        return v
    }()
    
    ///leftBarButtons
    public var leftBarButtons = Array<UIButton>.init(){
        willSet{
//            if newValue.count == 0 {return}
            
            for item in newValue {
                item.titleLabel?.font = kFont_naviBtn_weight
                item.tag = item.tag == naviBackButtonTag ? naviBackButtonTag : newValue.index(of: item)!
                item.snp.removeConstraints()
                if self.subviews.contains(item) {
                    item.removeFromSuperview()
                }
                else {
                    self.addSubview(item)
                    item.addTarget(self, action: #selector(didClickLeftBarButton(sender:)), for: .touchUpInside)
                }
            }
            if newValue.count == 1 {
                let b = newValue.first!
                if b.tag == naviBackButtonTag {//默认返回
                    b.snp.remakeConstraints { (make) in
                        make.bottom.equalTo(self).offset(-5)
                        make.size.equalTo(CGSize.init(width: 40 * KScreenRatio_6, height: 40 * KScreenRatio_6))
                        make.left.equalTo(self).offset(5)
                    }
                }
                else {
                    b.snp.remakeConstraints { (make) in
                        make.bottom.equalTo(self).offset(-10)
                        make.height.equalTo(navigationBarButtonHeight)
                        make.width.equalTo(40 * KScreenRatio_6)
                        make.left.equalTo(self).offset(15 * KScreenRatio_6)
                    }
                }

                if let count = b.titleLabel?.text?.count {
                    //有文字
                    if count > 0 {
                        b.snp.remakeConstraints { (make) in
                            make.size.equalTo(CGSize.init(width: CGFloat(count) * 20 * KScreenRatio_6 + 10 * KScreenRatio_6, height: navigationBarButtonHeight))
                            make.bottom.equalTo(self).offset(-9)
                            make.left.equalTo(self).offset(15 * KScreenRatio_6)
                        }
                    }
                }
                
            }
            else{
                newValue.snp.remakeConstraints { (make) in
                    make.bottom.equalTo(self).offset(-10)
                    make.height.equalTo(navigationBarButtonHeight)
                }
                newValue.snp.distributeSudokuViews(fixedItemWidth: navigationBarButtonWidth, fixedItemHeight: navigationBarButtonHeight, warpCount: newValue.count)
            }
        }
    }
    
    ///rightBarButtons
    lazy var rightBtnBgView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.clear
        return v
    }()
    public var rightBarButtons = Array<UIButton>.init(){
        willSet{
            
            rightBtnBgView.removeAllSubviews()
            
            if newValue.count == 0 {return}
            
            rightBtnBgView.snp.remakeConstraints { (make) in
                make.right.equalTo(self)
                make.height.equalTo(navigationBarButtonHeight)
                make.bottom.equalTo(self).offset(-10 * KScreenRatio_6)
                make.width.equalTo(CGFloat(newValue.count) * (navigationBarButtonWidth + 10))
            }
            
            for item in newValue {
                item.titleLabel?.font = kFont_naviBtn_weight
//                item.tag = newValue.index(of: item)!
//                item.snp.removeConstraints()
//
//                if rightBtnBgView.subviews.contains(item) {
//                    item.removeFromSuperview()
//                }
//                else {
                    rightBtnBgView.addSubview(item)
                    item.addTarget(self, action: #selector(didClickRightBarButton(sender:)), for: .touchUpInside)
//                }
            }
            
            //只有一个button
            if newValue.count == 1 {
                let b = newValue.first!
                
                guard b.titleLabel?.text != nil else {
                    //无文字
                    b.snp.remakeConstraints { (make) in
                        make.right.equalTo(rightBtnBgView).offset(-15 * KScreenRatio_6)
                        make.width.equalTo(navigationBarButtonWidth)
                        make.height.centerY.equalTo(rightBtnBgView)
                    }
                    return
                }
              
                
                if let count = b.titleLabel?.text?.count {
                    
                    //是否有图
                    let total = b.imageView != nil ? count + 1 : count
                    //有文字
                    if count > 0 {
                        
                        b.snp.remakeConstraints { (make) in
                            make.size.equalTo(CGSize.init(width: CGFloat(total) * 15 * KScreenRatio_6 + 30 * KScreenRatio_6, height: navigationBarButtonHeight))
                            make.right.centerY.equalTo(rightBtnBgView)
                        }
                        rightBtnBgView.snp.updateConstraints { (make) in
                            make.width.equalTo(CGFloat(total) * 15 * KScreenRatio_6 + 50 * KScreenRatio_6)
                        }
                    }
                    else {
                        b.snp.remakeConstraints { (make) in
                            make.size.equalTo(CGSize.init(width: navigationBarButtonWidth, height: navigationBarButtonHeight))
                            make.center.equalTo(rightBtnBgView)
                        }
                    }
                }

            }
            else{//多个button

                var totalWidth:CGFloat = 0
                
                for (index, item) in newValue.enumerated() {
                    
                    //有文字
                    if let count = item.titleLabel?.text?.count {
                        if count >= 1 {
                            
                            //带图
                            totalWidth += item.imageView != nil ? navigationBarButtonWidth / 2 : 0
                            totalWidth += CGFloat(count) * navigationBarButtonWidth
                            
                            if index > 0 {
                                if index + 1 >= newValue.count {
                                    item.snp.remakeConstraints { (make) in
                                        make.width.equalTo(CGFloat(count) * navigationBarButtonWidth)
                                        make.left.equalTo(newValue[index - 1].snp.right).offset(10 * KScreenRatio_6)
                                        make.height.centerY.equalTo(rightBtnBgView)
                                    }
                                    return
                                }
                                item.snp.remakeConstraints { (make) in
                                    make.width.equalTo(CGFloat(count) * navigationBarButtonWidth)
                                    make.left.equalTo(newValue[index + 1].snp.right).offset(10 * KScreenRatio_6)
                                    make.height.centerY.equalTo(rightBtnBgView)
                                }
                            }
                            else{
                                item.snp.remakeConstraints { (make) in
                                    make.width.equalTo(CGFloat(count) * navigationBarButtonWidth)
                                    make.left.height.centerY.equalTo(rightBtnBgView)
                                }
                            }
                        }
                    }
                    
                    //只有图片
                    if item.titleLabel?.text == nil {
                        
                        totalWidth += navigationBarButtonWidth
                        
                        if index > 0 {
                            if index + 1 >= newValue.count {
                                item.snp.remakeConstraints { (make) in
                                    make.left.equalTo(newValue[index - 1].snp.right).offset(10 * KScreenRatio_6)
                                    make.height.centerY.equalTo(rightBtnBgView)
                                    make.width.equalTo(navigationBarButtonWidth)
                                }
                                return
                            }
                            item.snp.remakeConstraints { (make) in
                                make.left.equalTo(newValue[index + 1].snp.right).offset(10 * KScreenRatio_6)
                                make.width.equalTo(navigationBarButtonWidth)
                                make.height.centerY.equalTo(rightBtnBgView)
                            }
                        }
                        else{
                            item.snp.remakeConstraints { (make) in
                                make.width.equalTo(navigationBarButtonWidth)
                                make.left.height.centerY.equalTo(rightBtnBgView)
                            }
                        }
                    }
                    
                }
                rightBtnBgView.snp.updateConstraints { (make) in
                    make.width.equalTo(totalWidth + CGFloat(newValue.count * 10))
                }
                
            }
        }
    }
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = kColor_background
        self.addSubview(self.bottomBlackLineView)
        self.addSubview(self.titleView)
        self.addSubview(self.rightBtnBgView)

        self.titleView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self).offset(-10)
            make.width.equalTo(kScreenWidth - navigationBarButtonWidth * 3 - 30)
            make.height.equalTo(30 * KScreenRatio_6)
        }
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - action
    @objc func didClickLeftBarButton(sender: UIButton) {
        
        delegate?.leftButtonsAction(sender: sender)
    }

    @objc func didClickRightBarButton(sender: UIButton) {
        
        delegate?.rightButtonsAction(sender: sender)
    }
}


