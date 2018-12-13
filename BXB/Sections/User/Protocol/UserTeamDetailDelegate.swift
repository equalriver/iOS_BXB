//
//  UserMyTeamDelegate.swift
//  BXB
//
//  Created by equalriver on 2018/7/4.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation


extension BXBUserTeamDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if teamTitle == "我加入的团队" { return 1 }
        return teamTitle == "申请加入" ? 0 : 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if teamTitle == "申请加入" { return 1 }
        if teamTitle == "我加入的团队" { return 4 }
        return section == 0 ? 4 : 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55 * KScreenRatio_6
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if teamTitle == "申请加入" { return 0 }
        return section == 1 ? 15 * KScreenRatio_6 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if teamTitle == "申请加入" {
            let cell = UITableViewCell()
            introLabel.text = data.remarks
            cell.contentView.addSubview(introLabel)
            introLabel.snp.makeConstraints { (make) in
                make.centerX.equalTo(cell.contentView)
                make.top.equalTo(cell.contentView).offset(15 * KScreenRatio_6)
                make.width.equalTo(kScreenWidth - 20 * KScreenRatio_6)
            }
            
            return cell
        }
        
        //加入的团队
        if teamTitle == "我加入的团队" {
            let cell = BXBUserMyTeamCell.init(style: .default, reuseIdentifier: nil)
            
            cell.titleLabel.text = ["团队二维码", "团队名称", "团队简介", "团队管理"][indexPath.row]
            
            switch indexPath.row {
            case 0://团队二维码
                cell.subTitleLabel.isHidden = true
                cell.subIV.isHidden = false
                cell.subIV.image = #imageLiteral(resourceName: "me_二维码")
                
            case 1://团队名称
                cell.rightIV.isHidden = true
                cell.subTitleLabel.text = data.teamName
                
            case 2://团队简介
                cell.subTitleLabel.text = data.remarks.count > 0 ? data.remarks: "无"
                
            case 3://团队管理
                cell.isNeedSeparatorView = false
                
            default: break
            }
            
            return cell
        }
        
        //创建的团队
        let cell = BXBUserMyTeamCell.init(style: .default, reuseIdentifier: nil)
        if indexPath.section == 0 {
            cell.titleLabel.text = ["团队二维码", "团队名称", "团队LOGO", "团队简介"][indexPath.row]
            switch indexPath.row {
            case 0://团队二维码
                cell.subTitleLabel.isHidden = true
                cell.subIV.isHidden = false
                cell.subIV.image = #imageLiteral(resourceName: "me_二维码")
                
            case 1://团队名称
                cell.subTitleLabel.text = data.teamName
                
            case 2://团队LOGO
                cell.subTitleLabel.text = data.logo.count > 0 ? "已设置" : "未设置"
                
            case 3://团队简介
                cell.subTitleLabel.text = data.remarks.count > 0 ? data.remarks: "无"
                cell.isNeedSeparatorView = false
                
            default: break
            }
        }
        else{
            if indexPath.row == 0 {
                //团队新的申请
                cell.titleLabel.text = "团队管理"
            }
            if indexPath.row == 1 {
                cell.isNeedSeparatorView = false
                cell.titleLabel.text = "查看团队活动量详细"
                cell.titleLabel.snp.updateConstraints { (make) in
                    make.width.equalTo(170 * KScreenRatio_6)
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 15 * KScreenRatio_6))
        v.backgroundColor = kColor_background
        return v
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if teamTitle == "申请加入" { return }
        
        if teamTitle != "我加入的团队" {
            if indexPath.section == 1 && indexPath.row == 0 {
                let maskPath = UIBezierPath.init(roundedRect: cell.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize.init(width: kCornerRadius, height: kCornerRadius))
                let maskLayer = CAShapeLayer()
                maskLayer.strokeColor = kColor_background!.cgColor
                maskLayer.frame = cell.contentView.bounds
                maskLayer.path = maskPath.cgPath
                cell.layer.mask = maskLayer
            }
        }
        
        if indexPath.section == 0 && indexPath.row == 3 {
            let maskPath = UIBezierPath.init(roundedRect: cell.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize.init(width: kCornerRadius, height: kCornerRadius))
            let maskLayer = CAShapeLayer()
            maskLayer.strokeColor = kColor_background!.cgColor
            maskLayer.frame = cell.bounds
            maskLayer.path = maskPath.cgPath
            cell.layer.mask = maskLayer
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if teamTitle == "我加入的团队" {
            switch indexPath.row {
            case 0: //团队二维码
                let vc = BXBUserTeamDetailQRCodeVC.init(teamData: data, qrStr: localShareURL + "teamId=" + "\(teamId)")
                vc.data = data
                navigationController?.pushViewController(vc, animated: true)
                
            case 2: //团队简介
                if data.remarks.count == 0 && teamTitle != "我创建的团队" { return }
                let vc = BXBUserTeamDetailIntroVC()
                vc.data = data
                vc.isEditableIntro = false
                navigationController?.pushViewController(vc, animated: true)
                
            case 3:////团队管理
                let vc = BXBUserTeamDetailMemberVC()
                vc.teamId = teamId
                vc.isJoinTeam = true
                self.navigationController?.pushViewController(vc, animated: true)
                
            default:
                break
            }
        }
        else {
            if indexPath.section == 0 {
                switch indexPath.row {
                case 0: //团队二维码
                    let vc = BXBUserTeamDetailQRCodeVC.init(teamData: data, qrStr: localShareURL + "teamId=" + "\(teamId)")
                    vc.data = data
                    navigationController?.pushViewController(vc, animated: true)
                    
                case 1: //团队名称
                    if teamTitle == "我加入的团队" { return }
                    let vc = BXBUserTeamDetailNameVC()
                    vc.teamId = teamId
                    vc.data = data
                    navigationController?.pushViewController(vc, animated: true)
                    
                case 2: //团队LOGO
                    if teamTitle == "我加入的团队" { return }
                    let picker = UIImagePickerController()
                    picker.allowsEditing = true
                    picker.sourceType = .savedPhotosAlbum
                    picker.delegate = self
                    navigationController?.present(picker, animated: true, completion: nil)
                    
                case 3: //团队简介
                    let vc = BXBUserTeamDetailIntroVC()
                    vc.data = data
                    vc.isEditableIntro = teamTitle == "我创建的团队"
                    navigationController?.pushViewController(vc, animated: true)
                    
                default:
                    break
                }
            }
            else{
                if indexPath.row == 0 {//团队管理
                    let vc = BXBUserTeamDetailMemberVC()
                    vc.teamId = teamId
                    vc.isJoinTeam = false
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else {
                    //查看团队活动量详细
                    if teamTitle == "我加入的团队" { return }
                    let vc = BXBUserTeamActivityVC()
                    vc.userId = data.userId
                    vc.teamName = data.teamName + "(\(number)人)"
                    navigationController?.pushViewController(vc, animated: true)
                }
                
            }
        }
        
    }
}


extension BXBUserTeamDetailVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        
        if let resultImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            
            guard let img = resultImage.clipImageToRect(newSize: CGSize.init(width: kScreenWidth, height: kScreenWidth * 0.75)) else { return }
            
            BXBNetworkTool.upLoadImageRequest(images: [img], imageName: "file", params: ["id": "\(teamId)", "token": UserDefaults.standard.string(forKey: "token") ?? ""], router: .uploadLogo(), success: { (resp) in
                NotificationCenter.default.post(name: .kNotiTeamDetailShouldRefreshData, object: nil)
                self.navigationController?.dismiss(animated: true, completion: {
                    
                })
            }) { (error) in
                self.navigationController?.dismiss(animated: true, completion: {
                    
                })
            }
            
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        navigationController?.dismiss(animated: true, completion: {
            
        })
    }
    
}





















// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
