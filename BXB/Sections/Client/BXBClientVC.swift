//
//  BXBClientVC.swift
//  BXB
//
//  Created by 尹平江 on 2018/6/4.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit

class BXBClientVC: BXBBasePageController {
    
    ///列表菜单
    lazy var itemsCV: UICollectionView = {
        let l = UICollectionViewFlowLayout()
        l.sectionInset = UIEdgeInsetsMake(15 * KScreenRatio_6, 15 * KScreenRatio_6, 15 * KScreenRatio_6, 15 * KScreenRatio_6)
        l.scrollDirection = .horizontal
        l.minimumLineSpacing = 10 * KScreenRatio_6
        l.minimumInteritemSpacing = 10 * KScreenRatio_6
        let v = UICollectionView.init(frame: .zero, collectionViewLayout: l)
        v.showsHorizontalScrollIndicator = false
        v.backgroundColor = UIColor.white
        
        return <#value#>
    }()
    
    
    

    override func viewDidLoad() {
        //在父类前设置
        progressWidth = 60 * KScreenRatio_6
        menuViewStyle = .line
        titleSizeNormal = 18 * KScreenRatio_6
        titleSizeSelected = 19 * KScreenRatio_6
        super.viewDidLoad()
        initUI()

    }

    
    func initUI() {
        
        
        naviBar.titleView.isHidden = true
        isNeedBackButton = false
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let v = menuView {
            guard let sv = v.superview else { return }
            sv.bringSubview(toFront: v)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadData()
    }
    
    
    
    
}


