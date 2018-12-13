//
//  BXBTabBarController.swift
//  BXB
//
//  Created by 尹平江 on 2018/6/4.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit

class BXBTabBarController: UITabBarController {

    private let tabTitles = ["工作", "日程", "客户", "我的"]
    
    private let tabImages = [UIImage.init(named: "tab_工作"), #imageLiteral(resourceName: "tab_日程"), #imageLiteral(resourceName: "tab_客户"), #imageLiteral(resourceName: "tab_我的")]
    
    private let tabSelectedImages = [UIImage.init(named: "tab_工作_选中"), #imageLiteral(resourceName: "tab_日程_选中"), #imageLiteral(resourceName: "tab_客户_选中"), #imageLiteral(resourceName: "tab_我的_选中")]
    
    private lazy var workVC: BXBNavigationController = {
        let vc = BXBNavigationController.init(rootViewController: BXBWorkViewController())
        return vc
    }()
    
    private lazy var agendaVC: BXBNavigationController = {
        let vc = BXBNavigationController.init(rootViewController: BXBAgendaVC())
        return vc
    }()
    
    private lazy var clientVC: BXBNavigationController = {
        let vc = BXBNavigationController.init(rootViewController: BXBClientListVC())
        return vc
    }()
    
    private lazy var userVC: BXBNavigationController = {
        let vc = BXBNavigationController.init(rootViewController: BXBUserVC())
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .white
//        tabBar.backgroundColor = UIColor.white
        //取消tabBar的透明效果
        tabBar.isTranslucent = false
        viewControllers = [workVC, agendaVC, clientVC, userVC]
        for (index, item) in (viewControllers?.enumerated())! {
            item.tabBarItem.title = tabTitles[index]
            item.tabBarItem.image = tabImages[index]
            item.tabBarItem.selectedImage = tabSelectedImages[index]
            
        }
        
        
        
    }


}
