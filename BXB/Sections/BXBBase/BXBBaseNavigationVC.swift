//
//  BXBBaseNavigationVC.swift
//  BXB
//
//  Created by 尹平江 on 2018/6/1.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit

class BXBBaseNavigationVC: BXBBaseViewController {

    public let naviBar = BXBBaseNavigationBar.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: CGFloat(kNavigationBarAndStatusHeight)))
    
    ///是否隐藏导航
    public var isHiddenNavi = false {
        willSet{
            naviBar.isHidden = newValue
        }
    }
    ///默认显示返回
    public var isNeedBackButton = true {
        willSet{
            naviBar.layoutIfNeeded()
        }
    }
    ///导航title
    public var naviTitle = "" {
        willSet{
            naviBar.titleText = newValue
        }
    }
    ///导航底部线条颜色
    public var naviSepViewColor = UIColor.white {
        willSet{
            naviBar.bottomBlackLineView.backgroundColor = newValue
        }
    }
    
    ///是否隐藏底部线条
    public var isHiddenSepView = false {
        willSet{
            naviBar.bottomBlackLineView.isHidden = newValue
        }
    }
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        //导航背景色
        naviBar.naviBackgroundColor = .white
        
//        if parent != nil && parent!.isKind(of: UINavigationController.self) {
            view.addSubview(naviBar)
            naviBar.delegate = self
            
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
       
        naviTitle = title ?? ""
        if isNeedBackButton == true {
//            if parent != nil && parent!.isKind(of: UINavigationController.self) {
            
                for v in naviBar.subviews {
                    if v.tag == naviBackButtonTag { return }
                }
                
                //添加默认返回按钮
                let b = UIButton.init()
                b.tag = naviBackButtonTag
                b.setImage(#imageLiteral(resourceName: "bxb_返回_黑"), for: .normal)
                naviBar.leftBarButtons = [b]
//            }
            
        }
        else{
            for v in naviBar.subviews {
                if v.tag == naviBackButtonTag { v.removeFromSuperview() }
            }
        }
        view.bringSubviewToFront(naviBar)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    

}

extension BXBBaseNavigationVC: BaseNavigationButtonDelegate {
    @objc func leftButtonsAction(sender: UIButton) {
        if sender.tag == naviBackButtonTag {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func rightButtonsAction(sender: UIButton) {
        
    }
    
    
}
