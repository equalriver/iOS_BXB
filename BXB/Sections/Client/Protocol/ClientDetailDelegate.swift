//
//  ClientDetailDelegate.swift
//  BXB
//
//  Created by equalriver on 2018/6/21.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper


extension BXBClientDetailVC {
    
    //MARK: - page controller
    override func numbersOfChildControllers(in pageController: WMPageController) -> Int {
        return 3
    }
    
    override func pageController(_ pageController: WMPageController, titleAt index: Int) -> String {
        return ["提醒事项", "互动记录", "花费记录"][index]
    }
    
    override func pageController(_ pageController: WMPageController, viewControllerAt index: Int) -> UIViewController {
        if index == 0 {//提醒事项
            let vc = ClientDetailNoticeVC()
            vc.noticeArr = noticeArr
            vc.clientId = data.id
            return vc
        }
        if index == 1 {//互动记录
            let vc = ClientDetailRecordVC()
            vc.recordArr = recordArr
            return vc
        }
        if index == 2 {//花费记录
            let vc = ClientDetailCostVC()
            vc.maintainArr = maintainArr
            vc.spendSum = spendSum
            vc.clientName = data.name
            vc.clientId = clientId
            return vc
        }
        return UIViewController()
    }
    
    override func pageController(_ pageController: WMPageController, preferredFrameFor menuView: WMMenuView) -> CGRect {
        return CGRect.init(x: 15 * KScreenRatio_6, y: kNavigationBarAndStatusHeight + 165 * KScreenRatio_containX, width: 345 * KScreenRatio_6, height: 55 * KScreenRatio_containX)
    }
    
    override func pageController(_ pageController: WMPageController, preferredFrameForContentView contentView: WMScrollView) -> CGRect {
        return CGRect.init(x: 15 * KScreenRatio_6, y: kNavigationBarAndStatusHeight + 220 * KScreenRatio_containX, width: 345 * KScreenRatio_6, height: 370 * KScreenRatio_containX)
    }
    
    override func pageController(_ pageController: WMPageController, didEnter viewController: UIViewController, withInfo info: [AnyHashable : Any]) {
        
    }
    
    //MARK: - action
    override func rightButtonsAction(sender: UIButton) {
        super.rightButtonsAction(sender: sender)
        //删除客户
        let alert = UIAlertController.init(title: "提示", message: "删除客户的同时会删除对应的日程，确定要删除吗?", preferredStyle: .alert)
        let action = UIAlertAction.init(title: "删除", style: .destructive) { (ac) in
            
            BXBNetworkTool.BXBRequest(router: .deleteClient(name: self.data.name), success: { (resp) in
                //移除跟客户相关的日程通知
                if let idArr = Mapper<ClientAllAgendaIdData>().mapArray(JSONObject: resp["list"].arrayObject) {
                    for v in idArr {
                        BXBLocalizeNotification.removeLocalizeNotification(id: v.id)
                    }
                }
                NotificationCenter.default.post(name: .kNotiClientShouldRefreshData, object: nil)
                NotificationCenter.default.post(name: .kNotiAgendaShouldRefreshData, object: nil, userInfo: nil)
                self.navigationController?.popViewController(animated: true)
                
            }) { (error) in
                
            }
        }
        alert.addAction(action)
        let cacel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        alert.addAction(cacel)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
        /*
        let vc = BXBAgendaDetailPopoverVC()
        vc.delegate = self
        vc.dataArr = ["删除"]
        vc.preferredContentSize = CGSize.init(width: 100 * KScreenRatio_6, height: 50 * KScreenRatio_6)
        vc.modalPresentationStyle = .popover
        if let pop = vc.popoverPresentationController {
            pop.delegate = self
            pop.backgroundColor = UIColor.white
            pop.permittedArrowDirections = .up
            pop.sourceView = sender
            pop.sourceRect = sender.bounds
            
            present(vc, animated: true, completion: nil)
        }
        */
    }

    //noti
    @objc func notiClientDetailShouldRefreshData() {
        BXBNetworkTool.isShowSVProgressHUD = false
        loadData(id: data.id)
    }
    
    
}

//MARK: - 客户详细
extension BXBClientDetailVC: ClientDetailHeaderDelegate {
    
    func didClickDetail(data: ClientData) {
        let vc = BXBClientDetailClientInfoVC()
        vc.data = data
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - SelectedLocationDelegate
extension BXBClientDetailVC: SelectedLocationDelegate {
    
    func didSelectedAddress(poi: AMapPOI) {
        var param_name = ""
        var param_lat = ""
        var param_lng = ""
        
        if selectedAddressIndexPath.row == 6 {
            param_name = "residentialAddress"
            param_lat = "latitude"
            param_lng = "longitude"
        }
        if selectedAddressIndexPath.row == 7 {
            param_name = "workingAddress"
            param_lat = "workLatitude"
            param_lng = "workLongitude"
        }
        
        BXBNetworkTool.BXBRequest(router: .editClient(id: self.data.id, params: [param_name: poi.name, param_lat: "\(poi.location.latitude)", param_lng: "\(poi.location.longitude)"]), success: { (resp) in
            self.loadData(id: self.clientId)
            NotificationCenter.default.post(name: .kNotiClientShouldRefreshData, object: nil)
            
        }, failure: { (error) in
            
        })
    }
}


