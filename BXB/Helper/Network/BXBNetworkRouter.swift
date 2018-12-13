
//
//  BXBNetworkRouter.swift
//  BXB
//
//  Created by 尹平江 on 2018/6/4.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Alamofire
import SwiftyJSON

enum Router: URLRequestConvertible {
    
    
    //MARK: - 工作
    
    ///今日提醒
    case todayNotice()
    
    ///工作简报--日
    case dayReport()
    
    ///工作简报--月
    case monthReport()
    
    
    
    //MARK: - 用户
    
    /// 注册/登录
    case register(userName: String, password: String)
    
    ///获取验证码 flag: 1为注册，2为登录
    case getAuthCode(telphone: String)
    
    ///退出登录
    case loginOut()
    
    ///用户详细
    case userDetail()
    
    ///用户编辑 remarks意见反馈  remarkPhone意见反馈联系电话
    case editUser(args: [String: Any])
    
    ///用户反馈
    case userCallback()
    
    ///上传日志文件
    case uploadLogFile()
    
    //MARK: - 日程
    
    ///新增日程name, visitDate, remindTime, address, visitTypeName, remarks, remindDate, latitude, longitude, unitAddress, matter  补录日程status = 1
    case addNewAgenda(args: [String: Any])
    
 
    ///日程事项列表
    case agendaList()
    
    ///删除日程事项
    case deleteAgenda(id: Int)
    
    ///编辑日程
    case editAgenda(name: String, id: Int, params: [String: Any])
    
    ///当天前后一个月日程
    case nearAgendaWithToday()
    
    ///查询某天日程
    case searchAgendaByDay(time: String)
    
    ///查询某月日程
    case searchAgendaByMonth(time: String)
    
    ///日程详细
    case detailAgenda(id: Int)
    
    ///我的日志列表
    case meWorkLog(date: String)
    
    ///批量提交我的日志
    case commitMeWorkLog(args: Any)
    
    
    //MARK: - 客户
    
    ///新增客户 name: String, phone: String, residentialAddress: String, workingAddress: String, birthday: String, sex: String, income: Int, marriageStatus: String, educationName: String, educationKey: String, introducerId: Int, grade: Int, label: String, status: Int, remarks: String, latitude: String, longitude: String, workLatitude: String, workLongitude: String, unitAddress: String, workUnitAddress: String
    case addClient(args: [String : Any])
    
    ///删除客户
    case deleteClient(name: String)
    
    ///编辑客户
    case editClient(id: Int, params: [String : Any])
    
    ///验重客户名
    case validateClient(name: String)
    
    ///客户详细
    case detailClient(id: Int)
    
    ///客户列表
    case clientList(matterId: String)
    
    ///新增花费记录name: String, content: String, spentDate: String, spentMoney: Int, remarks: String
    case addClientMaintain(maintain: Any)
    
    ///删除花费记录
    case deleteClientMaintain(id: Int, clientId: Int)
    
    ///花费记录列表
    case clientMaintainList(id: Int)
    
    ///新增客户提醒  matterId:生日/纪念日/保单/其他
    case addClientNotice(client: Any)
    
    ///删除客户提醒
    case deleteClientNotice(id: Int)
    
    ///客户提醒列表
    case clientNoticeList(id: Int)
    
    ///所有提醒列表
    case clientNoticeAll()
    
    ///编辑客户提醒
    case editClientRemind(id: Int, args: [String: Any])
    
    ///附近的客户
    case nearClient(lat: String, lng: String)
    
    ///客户筛选
    case clientFilter(remind: String, isWrite: String, matter: String)
    
    ///客户提醒筛选
    case clientNoticeFilter(matterId: String, pageSize: Int, currentPage: Int)
    
    //MARK: - 团队
    
    ///新建团队
    case createTeam()

    ///新增申请人
    case addApplication(id: Int, remarks: String)
    
    ///查询所有团队名称
    case teamNameList(id: Int, teamName: String, ownerId: Int)
  
    ///编辑团队信息
    case editTeam(id: Int, paramName: String, paramValue: Any)
    
    ///上传logo
    case uploadLogo()

    ///申请退出团队/移除成员
    case quitTeam(id: Int, teamId: Int)
    
    ///解散团队
    case deleteTeam(id: Int)
    
    ///申请接受（1）或忽略（2）
    case receptApplication(id: Int, teamId: Int, status: Int)
    
    ///查询某个团队所有成员
    case searchTeamMember(id: Int)
    
    ///团队基本信息
    case teamMessage(id: Int)
    
    ///添加个人活动量目标
    case addUserActivity(activityCount: Int, teamId: Int, userId: Int)
    
    ///添加个人保费目标
    case addBaoFei(targetAmount: Int, teamId: Int, userId: Int)
    
    ///添加团队保费目标
    case addTeamBaofei(targetAmount: Int, teamId: Int, userId: Int)

    ///团队活动量情况
    case teamActivityDetail(id: Int)
    
    ///根据月份查看团队活动量情况
    case searchTeamActivityWithYM(time: String, userId: Int)
    
    ///查询团队总人数、姓名countTeam
    case searchTeamNameAndNumber(id: Int)
    
    ///月保费目标完成情况
    case baofeiDetailOfMonth(time: String)
    
    ///查看团队目标完成度
    case searchTeamTarget(time: String)
    
    ///统计个人部分
    case countPersonal(visitDate: String)
    
    ///统计团队部分
    case countTeam(visitDate: String)
    
    ///团队申请列表
    case teamApplyList(id: Int)
    
    //MARK: -
    func asURLRequest() throws -> URLRequest {
        
        var path: String {
            switch self {
            //工作
            case .todayNotice:
                return "client/selectHomeRemindToday.do"
                
            case .dayReport:
                return "aims/selectHomeTotalVisitToday.do"
                
            case .monthReport:
                return "aims/selectHomeTotalVisitMonth.do"
                
            //用户
            case .register:
                return "user/addUser.do"
                
            case .getAuthCode:
                return "user/sendCode.do"
                
            case .loginOut:
                return "user/logOut.do"
                
            case .userDetail:
                return "user/selectUserById.do"
                
            case .editUser:
                return "user/editUser.do"
                
            case .userCallback:
                return "user/editUserFeedBack.do"
                
            case .uploadLogFile:
                return "upload/uploadFile.do"
                
            //日程
            case .addNewAgenda:
                return "visit/addVisit.do"
                
            case .agendaList:
                return "visit/selectVisitType.do"
                
            case .deleteAgenda:
                return "visit/delVisit.do"
                
            case .editAgenda:
                return "visit/editVisit.do"
                
            case .nearAgendaWithToday:
                return "visit/selectVisitList.do"
                
            case .searchAgendaByDay:
                return "visit/selectVisitByDate.do"
                
            case .searchAgendaByMonth:
                return "visit/selectVisitByMonth.do"
            
            case .detailAgenda:
                return "visit/selectVisitByName.do"
                
            case .meWorkLog:
                return "visit/selectMyLogDay.do"
                
            case .commitMeWorkLog:
                return "visit/editVisitBatch.do"
                
                
            //客户
            case .addClient:
                return "client/addClient.do"
                
            case .deleteClient:
                return "client/delClient.do"
                
            case .editClient:
                return "client/editClient.do"
                
            case .validateClient:
                return "client/selectClientName.do"
                
            case .detailClient:
                return "client/selectClientById.do"
                
            case .clientList:
                return "client/selectClientByUserId.do"
                
            case .addClientMaintain:
                return "client/addClientSpend.do"
                
            case .deleteClientMaintain:
                return "client/delSpendById.do"
                
            case .clientMaintainList:
                return "client/selectClientSpend.do"
                
            case .addClientNotice:
                return "client/addClientRemind.do"
                
            case .deleteClientNotice:
                return "client/delById.do"
                
            case .clientNoticeList:
                return "client/selectRemindList.do"
                
            case .clientNoticeAll:
                return "client/selectRemindListAll.do"
                
            case .editClientRemind:
                return "client/editClientRemind.do"
                
            case .nearClient:
                return "client/selectPeopleNearby.do"
                
            case .clientFilter:
                return "client/selectClientByUserIdChoose.do"
                
            case .clientNoticeFilter:
                return "client/selectClientByUserId.do"
                
                
            //团队
            case .createTeam:
                return "team/addTeam.do"
                
            case .addApplication:
                return "team/addApplication.do"
                
            case .teamNameList:
                return "team/TeamList"
                
            case .editTeam:
                return "team/editTeam.do"
                
            case .uploadLogo:
                return "team/editTeamLogo.do"
                
            case .quitTeam:
                return "team/delApplication.do"
            
            case .deleteTeam:
                return "team/delTeam.do"
                
            case .receptApplication:
                return "team/receptApplication.do"
                
            case .searchTeamMember:
                return "team/selectAllNameByTeamId.do"
                
            case .teamMessage:
                return "team/selectByTeamId.do"
                
            case .addUserActivity:
                return "aims/addActivity.do"
                
            case .addBaoFei:
                return "aims/addAims.do"
                
            case .addTeamBaofei:
                return "aims/addTeamAims.do"
                
            case .teamActivityDetail:
                return "activity/selectVisitByTeamId.do"
                
            case .searchTeamActivityWithYM:
                return "activity/selectVisitByTeamIdAndMonth.do"
                
            case .searchTeamNameAndNumber:
                return "team/selectListName.do"
            
            case .baofeiDetailOfMonth:
                return "team/selectAimsFinish.do"
                
            case .searchTeamTarget:
                return "team/selectAimsFinishByTeam.do"
                
            case .countPersonal:
                return "aims/selectTotalPerson.do"
                
            case .countTeam:
                return "aims/selectTotalTeam.do"
                
            case .teamApplyList:
                return "team/selectNotAplication.do"
                
                
            }
            
        }
        
        
        //MARK: - param
        var param: [String: Any]? = [:]
        
        var singleParam: Any?
        
        
        switch self {
        //工作
        case .todayNotice: break
            
        case .dayReport: break
            
        case .monthReport: break
            
        //用户
        case .register(let userName, let password):
            param = [
                "userName" : userName,
                "password" : password
            ]
            
        case .getAuthCode(let telphone):
            param = [
                "telphone" : telphone
            ]
            
        case .loginOut: break
            
        case .userDetail: break
            
        case .editUser(let args):
            for (k, v) in args {
                param?.updateValue(v, forKey: k)
            }
            
        case .userCallback: break
            
        case .uploadLogFile: break
            
            
        //日程
        case .addNewAgenda(let args):
            for (k, v) in args {
                param?.updateValue(v, forKey: k)
            }
            
        case .agendaList: break
            
        case .deleteAgenda(let id):
            param = [
                "id" : id
            ]
            
        case .editAgenda(let name, let id, let p):
            param = [
                "name" : name,
                "id" : id
            ]
            for (k, v) in p {
                param?.updateValue(v, forKey: k)
            }
            
        case .nearAgendaWithToday: break
            
        case .searchAgendaByDay(let time):
            param = [
                "time" : time
            ]
            
        case .searchAgendaByMonth(let time):
            param = [
                "time" : time
            ]
            
        case .detailAgenda(let id):
            param = [
                "id" : id
            ]
        
        case .meWorkLog(let date):
            param = [
                "time" : date
            ]
            
        case .commitMeWorkLog(let args):
            singleParam = args
            
        //客户
        case .addClient(let args):
            for (k, v) in args {
                param?.updateValue(v, forKey: k)
            }
            
        case .deleteClient(let name):
            param = [
                "name" : name
            ]
            
        case .editClient(let id, let p):
            param = [
                "clientId" : id
            ]
            for (k, v) in p {
                param?.updateValue(v, forKey: k)
            }
            
        case .validateClient(let name):
            param = [
                "name" : name
            ]
            
        case .detailClient(let id):
            param = [
                "clientId" : id
            ]
            
        case .clientList(let matterId):
            param = [
                "matterId" : matterId
            ]
       
//        case .addClientMaintain(let name, let content, let spentDate, let spentMoney, let remarks):
//            param = [
//                "name" : name,
//                "content" : content,
//                "spentDate" : spentDate,
//                "spentMoney" : spentMoney,
//                "remarks" : remarks
//            ]
        case .addClientMaintain(let maintain):
            singleParam = maintain
        
        case .deleteClientMaintain(let id, let clientId):
            param = [
                "id" : id,
                "clientId" : clientId
            ]
            
        case .clientMaintainList(let id):
            param = [
                "clientId" : id
            ]
            
//        case .addClientNotice(let client):
//            param = [
//                "clientRemind" : client
//            ]
        case .addClientNotice(let client):
            singleParam = client
            
        case .deleteClientNotice(let id):
            param = [
                "id" : id
            ]
            
        case .clientNoticeList(let id):
            param = [
                "clientId" : id
            ]
            
        case .clientNoticeAll: break
            
        case .editClientRemind(let id, let args):
            param = [
                "id" : id
            ]
            for (k, v) in args {
                param?.updateValue(v, forKey: k)
            }
            
        case .nearClient(let lat, let lng):
            param = [
                "userLati" : lat,
                "userLongi" : lng
            ]
            
        case .clientFilter(let remind, let isWrite, let matter):
            param = [
                "remind": remind,
                "isWrite": isWrite,
                "matter": matter
            ]
            
        case .clientNoticeFilter(let matterId, let pageSize, let currentPage):
            param = [
                "matterId" : matterId,
                "pageSize" : pageSize,
                "currentPage" : currentPage
            ]
            
            
        //团队
        case .createTeam: break
            
        case .addApplication(let teamId, let remarks):
            param = [
                "teamId" : teamId,
                "status" : 0,
                "remarks" : remarks
            ]
            
        case .teamNameList(let id, let teamName, let ownerId):
            param = [
                "id" : id,
                "teamName" : teamName,
                "ownerId" : ownerId
            ]
            
        case .editTeam(let id, let paramName, let paramValue):
            param = [
                "id" : id,
                paramName : paramValue
            ]
            
        case .uploadLogo: break
            
        case .quitTeam(let id, let teamId):
            param = [
                "id" : id,
                "teamId" : teamId,
                "delStatus" : -1
            ]
            
        case .deleteTeam(let id):
            param = [
                "id" : id
            ]
            
        case .receptApplication(let id, let teamId, let status):
            param = [
                "id" : id,
                "teamId" : teamId,
                "status" : status
            ]
            
        case .searchTeamMember(let id):
            param = [
                "id" : id
            ]
            
        case .teamMessage(let id):
            param = [
                "id" : id
            ]
            
        case .addUserActivity(let activityCount, let teamId, let userId):
            param = [
                "activityCount" : activityCount,
                "teamId" : teamId,
                "userId" : userId
            ]
            
        case .addBaoFei(let targetAmount, let teamId, let userId):
            param = [
                "targetAmount" : targetAmount,
                "teamId" : teamId,
                "userId" : userId
            ]
            
        case .addTeamBaofei(let targetAmount, let teamId, let userId):
            param = [
                "targetAmount" : targetAmount,
                "teamId" : teamId,
                "userId" : userId
            ]
            
        case .teamActivityDetail: break
            
        case .searchTeamActivityWithYM(let time, let userId):
            param = [
                "time" : time,
                "userId" : userId
            ]
            
        case .searchTeamNameAndNumber: break
            
        case .baofeiDetailOfMonth(let time):
            param = [
                "time" : time
            ]
            
        case .searchTeamTarget(let time):
            param = [
                "time" : time
            ]
            
        case .countPersonal(let visitDate):
            param = [
                "visitDate" : visitDate
            ]
            
        case .countTeam(let visitDate):
            param = [
                "visitDate" : visitDate
            ]

        case .teamApplyList(let id):
            param = [
                "id" : id
            ]

        
        
        }
        
        //MARK: - add token
        switch self {
        case .register, .getAuthCode, .addClientNotice, .addClientMaintain, .commitMeWorkLog:
            break
            
        default:
            let token = UserDefaults.standard.string(forKey: "token")
            if token != nil {
                if token!.count > 0 { param?["token"] = token! }
            }
            break
        }
        
        
//        if let token = UserDefaults.standard.string(forKey: "token") {
//            param?["token"] = token.MD5
//        }
        
        
        let url = try baseURLString.asURL()
        var urlReq = URLRequest(url: url.appendingPathComponent(path))
        //post
        urlReq.httpMethod = HTTPMethod.post.rawValue
        //超时时间
        urlReq.timeoutInterval = 15
        
        //MARK: - Content-Type
        switch self {
//        case .getAuthCode:
//            urlReq.setValue("multipart/form-data;text/xml", forHTTPHeaderField: "Content-Type")
            
        case .uploadLogo, .uploadLogFile:
            urlReq.setValue("multipart/form-data;application/json", forHTTPHeaderField: "Content-Type")
        default:
            urlReq.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        
        switch self {
        case .addClientNotice, .addClientMaintain, .commitMeWorkLog:
            if let single = singleParam {
//                print("single param: \(single)")
                urlReq = try JSONEncoding.default.encode(urlReq, withJSONObject: single)
            }
            break
            
        default:
            if let param = param {
//                print(param.getJSONStringFromDictionary())
                urlReq = try JSONEncoding.default.encode(urlReq, with: param)
            }
            break
        }
//        if let param = param {
//            print(param.getJSONStringFromDictionary())
//            urlRequest = try JSONEncoding.default.encode(urlRequest, with: param)
//        }
        return urlReq
    }
    
}


