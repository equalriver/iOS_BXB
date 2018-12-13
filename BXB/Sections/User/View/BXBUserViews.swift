
//
//  BXBUserViews.swift
//  BXB
//
//  Created by equalriver on 2018/8/20.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation


class BXBUserHeadView: UIView {
    
    public var data = UserData() {
        willSet{
            headIV.isHidden = newValue.name.count != 0
            headLabel.isHidden = newValue.name.count == 0
            titleLabel.text = newValue.name.count > 0 ? newValue.name : "注册/登录"
            subTitleLabel.text = newValue.signature.count > 0 ? newValue.signature : "签名未设置"
            if newValue.name.isIncludeChinese {
                if newValue.name.isAllChinese { headLabel.text = newValue.name.last?.description }
                else { headLabel.text = newValue.name.first?.description }
            }
            else { headLabel.text = newValue.name.first?.description }
        }
    }
    
    lazy var headIV: UIImageView = {
        let iv = UIImageView.init(image: #imageLiteral(resourceName: "me_默认头像"))
        return iv
    }()
    lazy var headLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = UIColor.white
        l.backgroundColor = kColor_theme
        l.textAlignment = .center
        l.layer.cornerRadius = 25 * KScreenRatio_6
        l.layer.masksToBounds = true
        l.layer.drawsAsynchronously = true
        l.isHidden = true
        return l
    }()
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = kColor_dark
        l.text = "注册/登录"
        return l
    }()
    lazy var subTitleLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 15 * KScreenRatio_6)
        l.textColor = kColor_subText
        l.text = "签名未设置"
        return l
    }()
    lazy var rightIV: UIImageView = {
        let iv = UIImageView.init(image: #imageLiteral(resourceName: "rightArrow"))
        return iv
    }()
    lazy var sepView: UIView = {
        let v = UIView()
        v.backgroundColor = kColor_background
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        addSubview(headIV)
        addSubview(headLabel)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(rightIV)
        addSubview(sepView)
        headIV.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 50 * KScreenRatio_6, height: 50 * KScreenRatio_6))
            make.left.equalTo(self).offset(15 * KScreenRatio_6)
            make.centerY.equalTo(self)
        }
        headLabel.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 50 * KScreenRatio_6, height: 50 * KScreenRatio_6))
            make.left.equalTo(self).offset(15 * KScreenRatio_6)
            make.centerY.equalTo(self)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headLabel.snp.right).offset(20 * KScreenRatio_6)
            make.top.equalTo(self).offset(28 * KScreenRatio_6)
            make.right.equalTo(self).offset(-50 * KScreenRatio_6)
        }
        subTitleLabel.snp.makeConstraints { (make) in
            make.left.width.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom)
        }
        rightIV.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(-15 * KScreenRatio_6)
        }
        sepView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: kScreenWidth, height: 1))
            make.centerX.bottom.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - 活动量
protocol UserTargetViewDelegate: NSObjectProtocol {
    func didClickActivity()
    func didClickUserBaofei()
    func didClickTeamBaofei()
}

class BXBUserTargetView: UIView {
    
    weak public var delegate: UserTargetViewDelegate?
    
    public var data = UserAimsData() {
        willSet{
            activityCountLabel.text = newValue.activityCount == 0 ? "未设置" : "\(newValue.activityCount)"
            meBaofeiCountLabel.text = newValue.targetAmount == 0 ? "未设置" : "\(newValue.targetAmount)"
            teamBaofeiCountLabel.text = newValue.targetAmountTeam == 0 ? "未设置" : "\(newValue.targetAmountTeam)"
        }
    }
    
    lazy var activityCountLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = kColor_dark
        l.text = "未设置"
        l.textAlignment = .center
        l.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(actionBlock: { [unowned self](la) in
            self.delegate?.didClickActivity()
        })
        l.addGestureRecognizer(tap)
        return l
    }()
    lazy var activityLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_3
        l.textColor = kColor_subText
        l.text = "活动量目标"
        l.textAlignment = .center
        l.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(actionBlock: { [unowned self](la) in
            self.delegate?.didClickActivity()
        })
        l.addGestureRecognizer(tap)
        return l
    }()
    lazy var meBaofeiCountLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = kColor_dark
        l.text = "未设置"
        l.textAlignment = .center
        l.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(actionBlock: { [unowned self](la) in
            self.delegate?.didClickUserBaofei()
        })
        l.addGestureRecognizer(tap)
        return l
    }()
    lazy var meBaofeiLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_3
        l.textColor = kColor_subText
        l.text = "我的保费目标"
        l.textAlignment = .center
        l.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(actionBlock: { [unowned self](la) in
            self.delegate?.didClickUserBaofei()
        })
        l.addGestureRecognizer(tap)
        return l
    }()
    lazy var teamBaofeiCountLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = kColor_dark
        l.text = "未设置"
        l.textAlignment = .center
        l.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(actionBlock: { [unowned self](la) in
            self.delegate?.didClickTeamBaofei()
        })
        l.addGestureRecognizer(tap)
        return l
    }()
    lazy var teamBaofeiLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_3
        l.textColor = kColor_subText
        l.text = "团队保费目标"
        l.textAlignment = .center
        l.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(actionBlock: { [unowned self](la) in
            self.delegate?.didClickTeamBaofei()
        })
        l.addGestureRecognizer(tap)
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        backgroundColor = UIColor.white
        addSubview(activityCountLabel)
        addSubview(activityLabel)
        addSubview(meBaofeiLabel)
        addSubview(meBaofeiCountLabel)
        addSubview(teamBaofeiLabel)
        addSubview(teamBaofeiCountLabel)
        activityCountLabel.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: kScreenWidth / 3, height: 22 * KScreenRatio_6))
            make.top.equalTo(self).offset(10 * KScreenRatio_6)
            make.left.equalTo(self)
        }
        activityLabel.snp.makeConstraints { (make) in
            make.size.left.equalTo(activityCountLabel)
            make.top.equalTo(activityCountLabel.snp.bottom)
        }
        meBaofeiCountLabel.snp.makeConstraints { (make) in
            make.size.centerY.equalTo(activityCountLabel)
            make.left.equalTo(activityCountLabel.snp.right)
        }
        meBaofeiLabel.snp.makeConstraints { (make) in
            make.size.centerY.equalTo(activityLabel)
            make.centerX.equalTo(meBaofeiCountLabel)
        }
        teamBaofeiCountLabel.snp.makeConstraints { (make) in
            make.size.centerY.equalTo(activityCountLabel)
            make.left.equalTo(meBaofeiCountLabel.snp.right)
        }
        teamBaofeiLabel.snp.makeConstraints { (make) in
            make.size.centerY.equalTo(activityLabel)
            make.centerX.equalTo(teamBaofeiCountLabel)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


//MARK: - 我的团队
protocol UserTeamViewDelegate: NSObjectProtocol {
    func didClickJoinTeam()
    func didClickCreateTeam()
}

class BXBUserTeamView: UIView {
    
    weak public var delegate: UserTeamViewDelegate?
    
    public var data = UserData() {
        willSet{
            if newValue.addName.count == 0 { joinTeamView.isHidden = true }
            if newValue.createTeamCount == 0 { createTeamView.isHidden = true }
            
            if newValue.addName.count > 0 {
                
                joinTeamView.isHidden = false
                joinTeamView.setData(img: newValue.addLogo, teamName: newValue.addTeamName, teamType: "(我加入的团队)", managerName: newValue.addName, count: newValue.addTeamCount)
                bringSubviewToFront(joinTeamView)
                
                joinTeamBtn.setImage(nil, for: .normal)
            }
            else {
                joinTeamBtn.setImage(#imageLiteral(resourceName: "me_加入团队"), for: .normal)
                joinTeamView.isHidden = true
            }
            
            if newValue.createTeamCount != 0 {
                
                createTeamView.isHidden = false
                createTeamView.setData(img: newValue.createLogo, teamName: newValue.createTeamName, teamType: "(我创建的团队)", managerName: newValue.name, count: newValue.createTeamCount)
                bringSubviewToFront(createTeamView)

                createTeamBtn.setImage(nil, for: .normal)
            }
            else {
                createTeamBtn.setImage(#imageLiteral(resourceName: "me_创建团队"), for: .normal)
                createTeamView.isHidden = true
            }
        }
    }
    
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = kColor_text
        l.text = "我的团队"
        return l
    }()
    lazy var joinTeamBtn: UIButton = {
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "me_加入团队"), for: .normal)
        b.addBlock(for: .touchUpInside, block: { [unowned self](btn) in
            self.delegate?.didClickJoinTeam()
        })
        return b
    }()
    lazy var createTeamBtn: UIButton = {
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "me_创建团队"), for: .normal)
        b.addBlock(for: .touchUpInside, block: { [unowned self](btn) in
            self.delegate?.didClickCreateTeam()
        })
        return b
    }()
    lazy var joinTeamView: BXBUserTeamContentView = {
        let v = BXBUserTeamContentView()
        v.addBlock(for: .touchUpInside, block: { [unowned self](btn) in
            self.delegate?.didClickJoinTeam()
        })
        v.isHidden = true
        return v
    }()
    lazy var createTeamView: BXBUserTeamContentView = {
        let v = BXBUserTeamContentView()
        v.addBlock(for: .touchUpInside, block: { [unowned self](btn) in
            self.delegate?.didClickCreateTeam()
        })
        v.isHidden = true
        return v
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = kColor_background
        addSubview(titleLabel)
        addSubview(joinTeamBtn)
        addSubview(createTeamBtn)
        addSubview(joinTeamView)
        addSubview(createTeamView)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20 * KScreenRatio_6)
            make.top.right.equalTo(self)
            make.height.equalTo(30 * KScreenRatio_6)
        }
        joinTeamBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 160 * KScreenRatio_6, height: 190 * KScreenRatio_6))
            make.top.equalTo(titleLabel.snp.bottom).offset(10 * KScreenRatio_6)
            make.left.equalTo(self).offset(15 * KScreenRatio_6)
        }
        createTeamBtn.snp.makeConstraints { (make) in
            make.size.top.equalTo(joinTeamBtn)
            make.right.equalTo(self).offset(-15 * KScreenRatio_6)
        }
        joinTeamView.snp.makeConstraints { (make) in
            make.center.size.equalTo(joinTeamBtn)
        }
        createTeamView.snp.makeConstraints { (make) in
            make.center.size.equalTo(createTeamBtn)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class BXBUserTeamContentView: UIButton {
    
    lazy var teamImgIV: UIImageView = {
        let iv = UIImageView.init(image: #imageLiteral(resourceName: "team_placeholder"))
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        return iv
    }()
    lazy var teamNameLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = kColor_dark
        return l
    }()
    lazy var subTeamNameLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_3
        l.textColor = kColor_theme
        return l
    }()
    lazy var managerLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_3
        l.textColor = kColor_subText
        l.text = "管理员"
        return l
    }()
    lazy var memberLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_3
        l.textColor = kColor_subText
        l.text = "组员"
        l.textAlignment = .right
        return l
    }()
    lazy var managerNameLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_2
        l.textColor = kColor_dark
        return l
    }()
    lazy var memberCountLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_2
        l.textColor = kColor_dark
        l.textAlignment = .right
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        
        layer.cornerRadius = 3
        layer.masksToBounds = true
        addSubview(teamImgIV)
        addSubview(teamNameLabel)
        addSubview(subTeamNameLabel)
        addSubview(managerLabel)
        addSubview(memberLabel)
        addSubview(managerNameLabel)
        addSubview(memberCountLabel)
        teamImgIV.snp.makeConstraints { (make) in
            make.top.width.centerX.equalTo(self)
            make.height.equalTo(90 * KScreenRatio_6)
        }
        teamNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10 * KScreenRatio_6)
            make.top.equalTo(teamImgIV.snp.bottom).offset(10 * KScreenRatio_6)
            make.right.equalTo(self)
        }
        subTeamNameLabel.snp.makeConstraints { (make) in
            make.left.width.equalTo(teamNameLabel)
            make.top.equalTo(teamNameLabel.snp.bottom).offset(2)
        }
        managerLabel.snp.makeConstraints { (make) in
            make.left.equalTo(teamNameLabel)
            make.top.equalTo(subTeamNameLabel.snp.bottom).offset(10 * KScreenRatio_6)
            make.width.equalTo(70 * KScreenRatio_6)
        }
        memberLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-10 * KScreenRatio_6)
            make.centerY.width.equalTo(managerLabel)
        }
        managerNameLabel.snp.makeConstraints { (make) in
            make.left.width.equalTo(managerLabel)
            make.top.equalTo(managerLabel.snp.bottom).offset(5)
        }
        memberCountLabel.snp.makeConstraints { (make) in
            make.width.centerY.equalTo(managerNameLabel)
            make.right.equalTo(self).offset(-10 * KScreenRatio_6)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(img: String, teamName: String, teamType: String, managerName: String, count: Int) {
        teamImgIV.setImageWith(URL.init(string: img), placeholder: #imageLiteral(resourceName: "team_placeholder"))
        teamNameLabel.text = teamName
        subTeamNameLabel.text = teamType
        managerNameLabel.text = managerName
        memberCountLabel.text = "\(count)人"
    }
    
}


//MARK: - 联系我们，用户反馈
protocol UserOtherViewDelegate: NSObjectProtocol {
    func analyze()
    func userFeedback()
}

class BXBUserOtherView: UIView {
    
    weak public var delegate: UserOtherViewDelegate?
    
    lazy var contentView: UIView = {
        let v = UIView()
        v.layer.contents = #imageLiteral(resourceName: "agenda_白色底").cgImage
        return v
    }()
    lazy var analyzeLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text
        l.textColor = kColor_dark
        l.text = "我的统计"
        l.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(actionBlock: { [unowned self](t) in
            self.delegate?.analyze()
        })
        l.addGestureRecognizer(tap)
        return l
    }()
    lazy var sepView: UIView = {
        let v = UIView()
        v.backgroundColor = kColor_background
        return v
    }()
    lazy var feedbackLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text
        l.textColor = kColor_dark
        l.text = "用户反馈"
        l.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(actionBlock: { [unowned self](t) in
            self.delegate?.userFeedback()
        })
        l.addGestureRecognizer(tap)
        return l
    }()
    lazy var rightArrowIV_1: UIImageView = {
        let v = UIImageView.init(image: #imageLiteral(resourceName: "rightArrow"))
        v.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(actionBlock: { [unowned self](t) in
            self.delegate?.analyze()
        })
        v.addGestureRecognizer(tap)
        return v
    }()
    lazy var rightArrowIV_2: UIImageView = {
        let v = UIImageView.init(image: #imageLiteral(resourceName: "rightArrow"))
        v.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(actionBlock: { [unowned self](t) in
            self.delegate?.userFeedback()
        })
        v.addGestureRecognizer(tap)
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = kColor_background
        addSubview(contentView)
        contentView.addSubview(analyzeLabel)
        contentView.addSubview(sepView)
        contentView.addSubview(feedbackLabel)
        contentView.addSubview(rightArrowIV_1)
        contentView.addSubview(rightArrowIV_2)
        contentView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 345 * KScreenRatio_6, height: 120 * KScreenRatio_6))
            make.center.equalTo(self)
        }
        analyzeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(17 * KScreenRatio_6)
            make.left.equalTo(contentView).offset(20 * KScreenRatio_6)
            make.size.equalTo(CGSize.init(width: 320 * KScreenRatio_6, height: 25 * KScreenRatio_6))
        }
        sepView.snp.makeConstraints { (make) in
            make.center.width.equalTo(contentView)
            make.height.equalTo(1)
        }
        feedbackLabel.snp.makeConstraints { (make) in
            make.size.left.equalTo(analyzeLabel)
            make.bottom.equalTo(contentView).offset(-15 * KScreenRatio_6)
        }
        rightArrowIV_1.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-15 * KScreenRatio_6)
            make.centerY.equalTo(analyzeLabel)
        }
        rightArrowIV_2.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-15 * KScreenRatio_6)
            make.centerY.equalTo(feedbackLabel)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}










