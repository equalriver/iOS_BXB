//
//  UserMyTeamDetailDelegates.swift
//  BXB
//
//  Created by equalriver on 2018/7/3.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation
import Photos

//MARK: - qr code
extension BXBUserTeamDetailQRCodeVC {
    
    override func leftButtonsAction(sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    //下载到本地
    override func rightButtonsAction(sender: UIButton) {
        
        guard let img = getQRImage() else { return }
        //获取相册权限
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized: break
            
        default:
            PHPhotoLibrary.requestAuthorization { (s) in
                switch s {
                case .authorized: break
                    
                default: gotoAuthorizationView(vc: self)
                }
            }
        }
        
        sender.isUserInteractionEnabled = false
        PHPhotoLibrary.shared().performChanges({
            //写入图片到相册
            PHAssetChangeRequest.creationRequestForAsset(from: img)
            
        }, completionHandler: { (success: Bool, error: Error?) in
            DispatchQueue.main.async {
                sender.isUserInteractionEnabled = true
                if success { SVProgressHUD.showInfo(withStatus: "保存成功") }
                print("success = \(success), error = \(String(describing: error))")
            }
        })
    }
    
    //分享
    @objc func shareQRCode(sender: UIButton) {
        guard let img = getQRImage() else { return }
        BXBShare.shareWithDefaultUI(title: "分享二维码", text: "扫码加入我的团队", images: img, url: nil, view: view)
    }
    
    //获取qr img
    func getQRImage() -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(contentView.size, true, 0)
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        //设置白色context
        let path = UIBezierPath.init(rect: contentView.bounds)
        UIColor.white.set()
        context.addPath(path.cgPath)
        context.fillPath()
        
        contentView.layer.render(in: context)
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return img
    }
    
}

//MARK: - 修改团队名称
extension BXBUserTeamDetailNameVC {
    
    override func rightButtonsAction(sender: UIButton) {
        super.rightButtonsAction(sender: sender)
        if nameTF.hasText {
            sender.isUserInteractionEnabled = false
            BXBNetworkTool.BXBRequest(router: .editTeam(id: teamId, paramName: "teamName", paramValue: nameTF.text!), success: { (resp) in
                
                sender.isUserInteractionEnabled = true
                
                NotificationCenter.default.post(name: .kNotiTeamDetailShouldRefreshData, object: nil)
                NotificationCenter.default.post(name: .kNotiUserShouldRefreshData, object: nil)
                self.navigationController?.popViewController(animated: true)
                
            }) { (error) in
                sender.isUserInteractionEnabled = true
            }
        }
        else {
            view.makeToast("未填写团队名称")
        }
    }
    
}

//MARK: - 团队管理
extension BXBUserTeamDetailMemberVC: UserMyTeamDetailNewApplyDelegate {
    
    override func rightButtonsAction(sender: UIButton) {
        //解散团队
        let alert = UIAlertController.init(title: nil, message: "您确定解散该团队吗?", preferredStyle: .alert)
        let action = UIAlertAction.init(title: "是", style: .default) { (ac) in
            BXBNetworkTool.BXBRequest(router: .deleteTeam(id: self.teamId), success: { (resp) in
                
                self.navigationController?.popToRootViewController(animated: true)
                
                NotificationCenter.default.post(name: .kNotiUserShouldRefreshData, object: nil)
                
            }) { (error) in
                
            }
        }
        let cancel = UIAlertAction.init(title: "否", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //通过申请
    func didClickAccept(cell: BXBBaseTableViewCell) {
        
        if let indexPath = tableView.indexPath(for: cell) {
            BXBNetworkTool.BXBRequest(router: .receptApplication(id: applyArr[indexPath.row].ownerId, teamId: applyArr[indexPath.row].id, status: 1), success: { (resp) in
                
                self.loadData()
                NotificationCenter.default.post(name: .kNotiUserShouldRefreshData, object: nil)
                NotificationCenter.default.post(name: .kNotiTeamDetailShouldRefreshData, object: nil)
                
            }) { (error) in
                
            }
        }
        
    }
    
    //忽略申请
    func didClickIgnore(cell: BXBBaseTableViewCell) {
        
        if let indexPath = tableView.indexPath(for: cell) {
            BXBNetworkTool.BXBRequest(router: .receptApplication(id: applyArr[indexPath.row].ownerId, teamId: applyArr[indexPath.row].id, status: 2), success: { (resp) in
                
                self.loadData()
                NotificationCenter.default.post(name: .kNotiUserShouldRefreshData, object: nil)
                NotificationCenter.default.post(name: .kNotiTeamDetailShouldRefreshData, object: nil)
                
            }) { (error) in
                
            }
        }
    }
}


extension BXBUserTeamDetailMemberVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return applyArr.count > 0 && isJoinTeam == false ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if applyArr.count > 0 && isJoinTeam == false {
            return section == 0 ? applyArr.count : dataArr.count
        }
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55 * KScreenRatio_6
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55 * KScreenRatio_6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if applyArr.count > 0 && isJoinTeam == false {
            if indexPath.section == 0 {//申请
                var cell = tableView.dequeueReusableCell(withIdentifier: "UserMyTeamDetailNewApplyCell") as? UserMyTeamDetailNewApplyCell
                if cell == nil {
                    cell = UserMyTeamDetailNewApplyCell.init(style: .default, reuseIdentifier: "UserMyTeamDetailNewApplyCell")
                }
                cell?.delegate = self
                cell?.applyData = applyArr[indexPath.row]
                return cell!
            }
            else {//团队成员
                var cell = tableView.dequeueReusableCell(withIdentifier: "UserMyTeamDetailMemberCell") as? UserMyTeamDetailMemberCell
                if cell == nil {
                    cell = UserMyTeamDetailMemberCell.init(style: .default, reuseIdentifier: "UserMyTeamDetailMemberCell")
                }
                cell?.data = dataArr[indexPath.row]
                
                return cell!
            }
        }
        else {
            var cell = tableView.dequeueReusableCell(withIdentifier: "UserMyTeamDetailMemberCell") as? UserMyTeamDetailMemberCell
            if cell == nil {
                cell = UserMyTeamDetailMemberCell.init(style: .default, reuseIdentifier: "UserMyTeamDetailMemberCell")
            }
            cell?.data = dataArr[indexPath.row]
            
            return cell!
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 55 * KScreenRatio_6))
        v.backgroundColor = kColor_background
        
        let l = UILabel.init(frame: CGRect.init(x: 0, y: 15 * KScreenRatio_6, width: kScreenWidth, height: 39 * KScreenRatio_6))
        l.backgroundColor = UIColor.white
        l.font = kFont_text_3
        l.textColor = kColor_text
        if applyArr.count > 0 && isJoinTeam == false {
            l.text = section == 0 ? "     新的申请" : "      团队成员"
        }
        else {
            l.text = "    团队成员"
        }
        v.addSubview(l)
        
        let sep = UIView.init(frame: CGRect.init(x: 0, y: 54 * KScreenRatio_6, width: kScreenWidth, height: 0.5))
        sep.backgroundColor = kColor_separatorView
        v.addSubview(sep)
        
        return v
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        if applyArr.count > 0 {
            if indexPath.section == 0 {//申请
                return .none
            }
            else {//团队成员
                guard dataArr.count > indexPath.row else { return .none }
                if isJoinTeam == false {
                    if dataArr[indexPath.row].label == "群主" { return .none }
                    return .delete
                }
                else { return .delete }
            }
        }
        else {//团队成员
            guard dataArr.count > indexPath.row else { return .none }
            if isJoinTeam == false {
                if dataArr[indexPath.row].label == "群主" { return .none }
                return .delete
            }
            else { return .delete }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if applyArr.count > 0 {
            if indexPath.section == 0 {//申请
                return false
            }
            else {//团队成员
                guard dataArr.count > indexPath.row else { return false }
                if isJoinTeam == false {
                    if dataArr[indexPath.row].label == "群主" { return false }
                    return true
                }
                else { return false }
            
            }
        }
        else {//团队成员
            guard dataArr.count > indexPath.row else { return false }
            if isJoinTeam == false {
                if dataArr[indexPath.row].label == "群主" { return false }
                return true
            }
            else { return false }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if applyArr.count > 0 {
                if indexPath.section == 0 {//申请
                    
                }
                else {//团队成员
                    removeCell(indexPath: indexPath)
                }
            }
            else {//团队成员
                removeCell(indexPath: indexPath)
            }
        }
    }
    
    
    func removeCell(indexPath: IndexPath) {
        let alert = UIAlertController.init(title: nil, message: "确定删除该成员吗?", preferredStyle: .alert)
        let action = UIAlertAction.init(title: "删除", style: .destructive) { (ac) in
            
            BXBNetworkTool.BXBRequest(router: .quitTeam(id: self.dataArr[indexPath.row].ownerId, teamId: self.teamId), success: { (resp) in
                
                self.loadData()
                NotificationCenter.default.post(name: .kNotiUserShouldRefreshData, object: nil)
                NotificationCenter.default.post(name: .kNotiTeamDetailShouldRefreshData, object: nil)
                
            }, failure: { (error) in
                
            })
        }
        let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
       
    }
    
}

//MARK: - 团队简介
extension BXBUserTeamDetailIntroVC: YYTextViewDelegate {
    
    //保存简介
    override func rightButtonsAction(sender: UIButton) {
        super.rightButtonsAction(sender: sender)

        sender.isUserInteractionEnabled = false
        BXBNetworkTool.BXBRequest(router: .editTeam(id: data.id, paramName: "remarks", paramValue: introTV.text), success: { (resp) in
            
            sender.isUserInteractionEnabled = true
            
            NotificationCenter.default.post(name: .kNotiTeamDetailShouldRefreshData, object: nil)
            self.navigationController?.popViewController(animated: true)
            
        }) { (error) in
            sender.isUserInteractionEnabled = true
        }
    }
    
    //YYTextViewDelegate
    func textViewDidChange(_ textView: YYTextView) {
        
        if textView.hasText && textView.text.isIncludeEmoji {
            
            textView.text = textView.text!.filter({ (c) -> Bool in
                return String(c).isIncludeEmoji == false
            })
            return
        }
        
        let str = "\(textView.text.count)/60"
        
        let attStr = NSMutableAttributedString.init(string: str)
        attStr.addAttributes([.font: UIFont.systemFont(ofSize: 13 * KScreenRatio_6), .foregroundColor: kColor_theme!], range: NSMakeRange(0, str.count - 3))
        attStr.addAttributes([.font: UIFont.systemFont(ofSize: 13 * KScreenRatio_6), .foregroundColor: kColor_subText!], range: NSMakeRange(str.count - 3, 3))
        
        countLabel.attributedText = attStr
        
        if textView.text.count > introCount {
            textView.text = String(textView.text.prefix(introCount))
            attStr.replaceCharacters(in: NSMakeRange(0, str.count - 4), with: "60")
            return
        }
    }
    
}




















