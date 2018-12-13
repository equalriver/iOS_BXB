//
//  UserDelegate.swift
//  BXB
//
//  Created by equalriver on 2018/6/22.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation

//MARK: - target delegate
extension BXBUserVC: UserTargetViewDelegate {
    //点击活动量
    func didClickActivity() {
        loginValidate(currentVC: self) { (isLogin) in
            
            if isLogin {
    
                let vc = BXBUserTargetVC()
                vc.targetName = "活动量目标"
                vc.data = self.data
                vc.aims = self.aimsData
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    //点击我的保费
    func didClickUserBaofei() {
        
        loginValidate(currentVC: self) { (isLogin) in
            
            if isLogin {
     
                let vc = BXBUserTargetVC()
                vc.targetName = "我的保费目标"
                vc.data = self.data
                vc.aims = self.aimsData
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    //点击团队保费
    func didClickTeamBaofei() {
        
        loginValidate(currentVC: self) { (isLogin) in
            
            if isLogin {
                guard self.data.createTeamId != 0 else {
                    
                    let alert = UIAlertController.init(title: "提示", message: "您还没有创建自己的团队，是否创建?", preferredStyle: .alert)
                    
                    let action = UIAlertAction.init(title: "是", style: .default, handler: { (ac) in
                        
                        BXBNetworkTool.BXBRequest(router: .createTeam(), success: { (resp) in
                            
                            self.loadData()
                            let vc = BXBUserTargetVC()
                            vc.targetName = "团队保费目标"
                            vc.data = self.data
                            vc.aims = self.aimsData
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        }) { (error) in
                            
                        }
                    })
                    
                    let cancel = UIAlertAction.init(title: "否", style: .cancel, handler: nil)
                    
                    alert.addAction(action)
                    alert.addAction(cancel)
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil)
                    }
                    return
                }
                let vc = BXBUserTargetVC()
                vc.targetName = "团队保费目标"
                vc.data = self.data
                vc.aims = self.aimsData
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}


//MARK: - UserTeamViewDelegate
extension BXBUserVC: UserTeamViewDelegate {
    
    //加入团队
    func didClickJoinTeam() {
        guard checkNetwork() == true else { return }
        loginValidate(currentVC: self) { (isLogin) in
            if isLogin {
                let vc = BXBUserTeamDetailVC()
                vc.teamTitle = "我加入的团队"
                
                if data.addTeamId != 0 {
                    vc.teamId = data.addTeamId
                }
                else {
                    AVCaptureSessionManager.checkAuthorizationStatusForCamera(grant: {
                        let vc = BXBQRScanVC()
                        vc.teamId = self.data.createTeamId
                        self.navigationController?.pushViewController(vc, animated: true)
                    }){
                        let action = UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { (action) in
                            let url = URL(string: UIApplication.openSettingsURLString)
                            UIApplication.shared.openURL(url!)
                        })
                        let con = UIAlertController(title: "权限未开启", message: "您未开启相机权限，点击确定跳转至系统设置开启", preferredStyle: UIAlertController.Style.alert)
                        con.addAction(action)
                        present(con, animated: true, completion: nil)
                    }
                    return
                }
                
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    //创建团队
    func didClickCreateTeam() {
        
        loginValidate(currentVC: self) { (isLogin) in
            if isLogin {
                let vc = BXBUserTeamDetailVC()
                vc.teamTitle = "我创建的团队"
                
                if data.createTeamId != 0 { vc.teamId = data.createTeamId }
                else {
                    let alert = UIAlertController.init(title: nil, message: "尚未创建团队，是否现在创建?", preferredStyle: .alert)
                    let action = UIAlertAction.init(title: "是", style: .default) { (ac) in
                        BXBNetworkTool.BXBRequest(router: .createTeam(), success: { (resp) in
                            let id = resp["id"].intValue
                            vc.teamId = id
                            self.loadData()
                          
                            self.navigationController?.pushViewController(vc, animated: true)
                        }) { (error) in
                            
                        }
                    }
                    let cancel = UIAlertAction.init(title: "否", style: .cancel, handler: nil)
                    alert.addAction(action)
                    alert.addAction(cancel)
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil)
                    }
                    return
                }
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

//MARK: - UserOtherViewDelegate
extension BXBUserVC: UserOtherViewDelegate {
    
    //我的统计
    func analyze() {
        
        loginValidate(currentVC: self) { (isLogin) in
            if isLogin {
                let vc = BXBAnalyzeVC()
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    //用户反馈
    func userFeedback() {
        
        loginValidate(currentVC: self) { (isLogin) in
            if isLogin {
                let vc = BXBUserFeedbackVC()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}


//MARK: - navi buttons aciton
extension BXBUserVC: UserTabVCNaviBarDelegate {
    
    func didClickRightButton(tag: Int) {
        //二维码扫描
        if tag == 0 {
            
            guard checkNetwork() == true else { return }
            
            AVCaptureSessionManager.checkAuthorizationStatusForCamera(grant: {
                let vc = BXBQRScanVC()
                vc.teamId = self.data.createTeamId
                self.navigationController?.pushViewController(vc, animated: true)
            }){
                let action = UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { (action) in
                    let url = URL(string: UIApplication.openSettingsURLString)
                    UIApplication.shared.openURL(url!)
                })
                let con = UIAlertController(title: "权限未开启", message: "您未开启相机权限，点击确定跳转至系统设置开启", preferredStyle: UIAlertController.Style.alert)
                con.addAction(action)
                present(con, animated: true, completion: nil)
            }
        }
        //setting
        if tag == 1 {
            let vc = BXBUserSettingVC()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK: - actions
extension BXBUserVC {
    
    //个人信息
    @objc func userinfoEdit() {
        
        loginValidate(currentVC: self) { (isLogin) in
            if isLogin {
                let vc = BXBUserinfoEditVC()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    
}
