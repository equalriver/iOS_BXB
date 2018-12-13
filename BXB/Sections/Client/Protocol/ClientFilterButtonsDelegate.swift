//
//  ClientFilterButtonsDelegate.swift
//  BXB
//
//  Created by equalriver on 2018/8/2.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation

extension BXBClientFilterButtons: ClientFilterViewDelegate {
    
    func didSelectedFilterItem(name: String, index: Int) {
        if name.count == 0 {//取消选择
            for v in stateButtons {
                if v.tag == selectedIndexPath.section { v.setImage(UIImage.init(named: "client_下箭头_蓝"), for: .normal) }
                else { v.isSelected = false }
            }
        }
        else {
            selectedIndexPath = IndexPath.init(row: index, section: filterView.index)
            for v in stateButtons {
                if v.tag == selectedIndexPath.section {
                    v.setTitleColor(kColor_theme, for: .normal)
                    v.setImage(UIImage.init(named: "client_下箭头_蓝"), for: .normal)
                    v.setTitle(name + " ", for: .normal)
                }
                else {
                    v.setTitleColor(kColor_text, for: .normal)
                    switch v.tag {
                    case ClientFilterTableViewTag.first.rawValue:
                        v.setTitle("客户 ", for: .normal)
                        break
                        
                    case ClientFilterTableViewTag.second.rawValue:
                        v.setTitle("跟进状态 ", for: .normal)
                        break
                        
                    case ClientFilterTableViewTag.third.rawValue:
                        v.setTitle("提醒 ", for: .normal)
                        break
                        
                    default: break
                    }
                }
            }
            var item = name
            if name.contains("全部") { item = "" }
            
            self.delegate?.didClickFilterItem(name: item, index: selectedIndexPath.section)
            
        }
        
    }
    
    func didRemoveView() {
        for v in stateButtons {
            if v.tag != selectedIndexPath.section {
                v.setImage(#imageLiteral(resourceName: "client_下箭头_灰"), for: .normal)
            }
        }
    }
    
}


extension BXBClientFilterButtons {
    //action
    @objc func stateButtonClick(sender: UIButton) {
        
        guard UIApplication.shared.keyWindow != nil else { return }
        if filterView.superview == nil { UIApplication.shared.keyWindow!.addSubview(filterView) }

        for v in stateButtons {
            if v == sender { v.setImage(UIImage.init(named: "client_上箭头_蓝"), for: .normal) }
            else { v.setImage(#imageLiteral(resourceName: "client_下箭头_灰"), for: .normal) }
        }
        
        filterView.index = sender.tag
        filterView.selectedIndexPath = selectedIndexPath
    }
}











