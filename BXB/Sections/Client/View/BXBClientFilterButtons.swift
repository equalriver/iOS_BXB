//
//  BXBClientFilterButtons.swift
//  BXB
//
//  Created by equalriver on 2018/8/2.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit

protocol ClientFilterButtonsDelegate: NSObjectProtocol {
    func didClickFilterItem(name: String, index: Int)
}

class BXBClientFilterButtons: UIView {

    weak public var delegate: ClientFilterButtonsDelegate?
    
    var selectedIndexPath = IndexPath.init(row: 0, section: -1)
    
    lazy var firstStateBtn: TitleFrontButton = {
        let b = TitleFrontButton()
        b.titleLabel?.font = kFont_text_2
        b.setTitle("客户 ", for: .normal)
        b.setTitleColor(kColor_text, for: .normal)
//        b.setTitleColor(kColor_theme, for: .selected)
        b.setImage(#imageLiteral(resourceName: "client_下箭头_灰"), for: .normal)
        b.tag = ClientFilterTableViewTag.first.rawValue
        b.addTarget(self, action: #selector(stateButtonClick(sender:)), for: .touchUpInside)
        return b
    }()
    lazy var secondStateBtn: TitleFrontButton = {
        let b = TitleFrontButton()
        b.titleLabel?.font = kFont_text_2
        b.setTitle("跟进状态 ", for: .normal)
        b.setTitleColor(kColor_text, for: .normal)
//        b.setTitleColor(kColor_theme, for: .selected)
        b.setImage(#imageLiteral(resourceName: "client_下箭头_灰"), for: .normal)
        b.tag = ClientFilterTableViewTag.second.rawValue
        b.addTarget(self, action: #selector(stateButtonClick(sender:)), for: .touchUpInside)
        return b
    }()
    lazy var thirdStateBtn: TitleFrontButton = {
        let b = TitleFrontButton()
        b.titleLabel?.font = kFont_text_2
        b.setTitle("提醒 ", for: .normal)
        b.setTitleColor(kColor_text, for: .normal)
//        b.setTitleColor(kColor_theme, for: .selected)
        b.setImage(#imageLiteral(resourceName: "client_下箭头_灰"), for: .normal)
        b.tag = ClientFilterTableViewTag.third.rawValue
        b.addTarget(self, action: #selector(stateButtonClick(sender:)), for: .touchUpInside)
        return b
    }()
    lazy var sepView_1: UIView = {
        let v = UIView()
        v.backgroundColor = kColor_separatorView
        return v
    }()
    lazy var sepView_2: UIView = {
        let v = UIView()
        v.backgroundColor = kColor_separatorView
        return v
    }()
    lazy var sepView_3: UIView = {
        let v = UIView()
        v.backgroundColor = kColor_separatorView
        return v
    }()
    lazy var filterView: BXBClientFilterView = {
        let v = BXBClientFilterView.init(frame: CGRect.init(x: 0, y: kNavigationBarAndStatusHeight + 44 * KScreenRatio_6, width: kScreenWidth, height: kScreenHeight - kNavigationBarAndStatusHeight - 45 * KScreenRatio_6 - kTabBarHeight), indexPath: selectedIndexPath)
        v.delegate = self
        return v
    }()
    
    lazy var stateButtons: Array<TitleFrontButton> = {
        let arr = [firstStateBtn, secondStateBtn, thirdStateBtn]
        return arr
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(firstStateBtn)
        addSubview(secondStateBtn)
        addSubview(thirdStateBtn)
        addSubview(sepView_1)
        addSubview(sepView_2)
        addSubview(sepView_3)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        firstStateBtn.snp.makeConstraints { (make) in
            make.left.top.equalTo(self)
            make.height.equalTo(self.height - 0.5)
            make.width.equalTo(kScreenWidth / 3 - 1)
        }
        sepView_1.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 1, height: self.height / 2))
            make.centerY.equalTo(self)
            make.left.equalTo(firstStateBtn.snp.right)
        }
        secondStateBtn.snp.makeConstraints { (make) in
            make.centerY.size.equalTo(firstStateBtn)
            make.left.equalTo(sepView_1.snp.right)
        }
        sepView_2.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 1, height: self.height / 2))
            make.centerY.equalTo(self)
            make.left.equalTo(secondStateBtn.snp.right)
        }
        thirdStateBtn.snp.makeConstraints { (make) in
            make.centerY.size.equalTo(firstStateBtn)
            make.left.equalTo(sepView_2.snp.right)
        }
        sepView_3.snp.makeConstraints { (make) in
            make.bottom.centerX.equalTo(self)
            make.size.equalTo(CGSize.init(width: kScreenWidth, height: 0.5))
        }
    }
   
    

}















