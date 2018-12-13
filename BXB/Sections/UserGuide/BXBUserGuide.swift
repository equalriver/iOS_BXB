//
//  BXBUserGuide.swift
//  BXB
//
//  Created by equalriver on 2018/9/25.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation

public func makeUserGuideForAgenda() {
    guard UserDefaults.standard.string(forKey: "bxb_didLoadAgendaGuide") == nil else { return }
    makeUserGuide(imgs: [UIImage.init(imageLiteralResourceName: isIphoneXLatter ? "guide_新建日程_x" : "guide_新建日程")])
    UserDefaults.standard.set("bxb_didLoadAgendaGuide", forKey: "bxb_didLoadAgendaGuide")
}

public func makeUserGuideForAddNewAgenda() {
    guard UserDefaults.standard.string(forKey: "bxb_didLoadAddNewAgendaGuide") == nil else { return }
    makeUserGuide(imgs: [UIImage.init(imageLiteralResourceName: isIphoneXLatter ? "guide_勾选_x" : "guide_勾选")])
    UserDefaults.standard.set("bxb_didLoadAddNewAgendaGuide", forKey: "bxb_didLoadAddNewAgendaGuide")
}

public func makeUserGuideForClient() {
    guard UserDefaults.standard.string(forKey: "bxb_didLoadClietnGuide") == nil else { return }
    makeUserGuide(imgs: [UIImage.init(imageLiteralResourceName: isIphoneXLatter ? "guide_客户筛选栏_x" : "guide_客户筛选栏")])
    UserDefaults.standard.set("bxb_didLoadClietnGuide", forKey: "bxb_didLoadClietnGuide")
}

public func makeUserGuideForNoticeMessage() {
    guard UserDefaults.standard.string(forKey: "bxb_didLoadNoticeMessageGuide") == nil else { return }
    makeUserGuide(imgs: [UIImage.init(imageLiteralResourceName: isIphoneXLatter ? "guide_提醒消息_x" : "guide_提醒消息")])
    UserDefaults.standard.set("bxb_didLoadNoticeMessageGuide", forKey: "bxb_didLoadNoticeMessageGuide")
}

public func makeUserGuideForTeamActivity() {
    guard UserDefaults.standard.string(forKey: "bxb_didLoadTeamActivityGuide") == nil else { return }
    makeUserGuide(imgs: [UIImage.init(imageLiteralResourceName: isIphoneXLatter ? "guide_团队活动量_x" : "guide_团队活动量")])
    UserDefaults.standard.set("bxb_didLoadTeamActivityGuide", forKey: "bxb_didLoadTeamActivityGuide")
}



private func makeUserGuide(imgs: [UIImage]) {
    
    let bgView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
    bgView.backgroundColor = UIColor.clear
//    bgView.isUserInteractionEnabled = true
    
    for (i, v) in imgs.enumerated() {
        
        let imgIV = UIImageView.init(image: v)
        imgIV.isUserInteractionEnabled = true
        imgIV.tag = i
        bgView.addSubview(imgIV)
        
//        let bottomView = UIView()
//        bottomView.backgroundColor = UIColor.init(white: 0, alpha: 0.6)
//        bgView.addSubview(bottomView)
        
        imgIV.snp.makeConstraints { (make) in
            make.top.width.centerX.equalToSuperview()
            make.height.equalTo(kScreenHeight)
        }
//        bottomView.snp.makeConstraints { (make) in
//            make.bottom.width.centerX.equalToSuperview()
//            make.top.equalTo(imgIV.snp.bottom)
//        }
        
        let tap = UITapGestureRecognizer.init { (t) in
            
            if imgIV.tag == 0 {
                bgView.removeFromSuperview()
                return
            }
            
            imgIV.removeFromSuperview()
//            bottomView.removeFromSuperview()
            
        }
        imgIV.addGestureRecognizer(tap)
        
    }
    
    guard UIApplication.shared.keyWindow != nil else { return }
    UIApplication.shared.keyWindow?.addSubview(bgView)
    
}
