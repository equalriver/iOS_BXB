//
//  BXBAnalyzeCells.swift
//  BXB
//
//  Created by equalriver on 2018/7/1.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit

class AnalyzeCircleView: UIView {
    
    var circleWidth: CGFloat = 0
    
    var circleColor = UIColor.white
    
    var circleProgress: Float = 0
    
    lazy var shapeLayer: CAShapeLayer = {
        let l = CAShapeLayer.init()
        l.lineWidth = circleWidth
        l.strokeColor = kColor_background?.cgColor
        l.fillColor = UIColor.clear.cgColor
        l.lineCap = CAShapeLayerLineCap.round
        return l
    }()
    
    lazy var progressLayer: CAShapeLayer = {
        let l = CAShapeLayer.init()
        l.lineWidth = circleWidth
        l.strokeColor = circleColor.cgColor
        l.fillColor = UIColor.clear.cgColor
        l.lineCap = CAShapeLayerLineCap.round
        return l
    }()
    
    lazy var percentLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 18 * KScreenRatio_6, weight: .semibold)
        l.textAlignment = .center
        return l
    }()
    
    convenience init(circleProgress: String, circleWidth: CGFloat, circleColor: UIColor) {
        self.init()
        self.circleWidth = circleWidth
        self.circleColor = circleColor
        if let f = Float(circleProgress){ self.circleProgress = f }
        
        
        layer.addSublayer(shapeLayer)
        layer.addSublayer(progressLayer)
        percentLabel.textColor = circleColor
        addSubview(percentLabel)
        percentLabel.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
        percentLabel.text = "\(Int(circleProgress)!)" + "%"
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let bez = UIBezierPath.init(ovalIn: CGRect.init(x: circleWidth / 2, y: circleWidth / 2, width: width - circleWidth, height: height - circleWidth))
        shapeLayer.path = bez.cgPath
        progressLayer.path = bez.cgPath
        
        //进度终点
        progressLayer.strokeEnd = CGFloat(circleProgress) * 0.01
        
        //旋转以调整进度起点
        transform = CGAffineTransform.init(rotationAngle: CGFloat.pi * 1.3)
        percentLabel.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi * 0.7)
    }
    
}

//MARK: - 本月目标
class AnalyzeCurrentTargetCell: BXBBaseTableViewCell {
    
    public var data = AnalyzeData(){
        willSet{
            //保费att
            let baofei = "\(newValue.PolicyPerson.completedAmount)"
            let baofeiTarget = "\(newValue.PolicyPerson.targetAmount)"
            let baofeiAtt = NSMutableAttributedString.init(string: baofei + "/" + baofeiTarget)
            baofeiAtt.addAttributes([.font: kFont_text_weight, .foregroundColor: kColor_theme!], range: NSMakeRange(0, baofei.count))
            baofeiAtt.addAttributes([.font: kFont_text_weight, .foregroundColor: kColor_dark!], range: NSMakeRange(baofei.count, baofeiAtt.length - baofei.count))
            baofeiNumLabel.attributedText = baofeiAtt
            
            //活动量att
            let activity = "\(newValue.VisitPerson.activityCount)"
            let activityTarget = "\(newValue.VisitPerson.finishVisit)"
            let activityAtt = NSMutableAttributedString.init(string: activity + "/" + activityTarget)
            activityAtt.addAttributes([.font: kFont_text_weight, .foregroundColor: kColor_analyze_orange!], range: NSMakeRange(0, activity.count))
            activityAtt.addAttributes([.font: kFont_text_weight, .foregroundColor: kColor_dark!], range: NSMakeRange(activity.count, activityAtt.length - activity.count))
            activityNumLabel.attributedText = activityAtt
            
            //cycle view
            if baofeiCircle != nil { baofeiCircle.removeFromSuperview() }
            if activityCircle != nil { activityCircle.removeFromSuperview() }
            
            let baofeiPro = CGFloat(newValue.PolicyPerson.completedAmount) / (CGFloat(newValue.PolicyPerson.targetAmount) == 0 ? 1 : CGFloat(newValue.PolicyPerson.targetAmount))
            let activityPro = CGFloat(newValue.VisitPerson.activityCount) / (CGFloat(newValue.VisitPerson.finishVisit) == 0 ? 1 : CGFloat(newValue.VisitPerson.finishVisit))
            
            let baofeiStr = baofeiPro >= 1.0 ? "100" : String.init(format: "%.2f", baofeiPro).components(separatedBy: ".").last!
            let activityStr = activityPro >= 1.0 ? "100" : String.init(format: "%.2f", activityPro).components(separatedBy: ".").last!
            
            baofeiCircle = AnalyzeCircleView.init(circleProgress: baofeiStr, circleWidth: 3, circleColor: kColor_theme!)
            activityCircle = AnalyzeCircleView.init(circleProgress: activityStr, circleWidth: 3, circleColor: kColor_analyze_orange!)
            contentView.addSubview(baofeiCircle)
            contentView.addSubview(activityCircle)
            baofeiCircle.snp.makeConstraints { (make) in
                make.size.equalTo(CGSize.init(width: 80 * KScreenRatio_6, height: 80 * KScreenRatio_6))
                make.top.equalTo(baofeiNumLabel.snp.bottom).offset(35 * KScreenRatio_6)
                make.centerX.equalTo(baofeiNumLabel)
            }
            activityCircle.snp.makeConstraints { (make) in
                make.size.top.equalTo(baofeiCircle)
                make.centerX.equalTo(activityNumLabel)
            }
        }
    }

    lazy var baofeiTitle: UILabel = {
        let l = UILabel()
        l.font = kFont_text_2
        l.textColor = kColor_theme
        l.textAlignment = .center
        l.text = "保费目标"
        return l
    }()
    
    lazy var activityTitle: UILabel = {
        let l = UILabel()
        l.font = kFont_text_2
        l.textColor = kColor_analyze_orange
        l.textAlignment = .center
        l.text = "活动量目标"
        return l
    }()
    
    lazy var baofeiNumLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        return l
    }()
    
    lazy var activityNumLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        return l
    }()
    
    lazy var baofeiPointView: UIView = {
        let v = UIView()
        v.backgroundColor = kColor_theme
        v.layer.cornerRadius = 2.5
        v.layer.masksToBounds = true
        return v
    }()
    
    lazy var activityPointView: UIView = {
        let v = UIView()
        v.backgroundColor = kColor_analyze_orange
        v.layer.cornerRadius = 2.5
        v.layer.masksToBounds = true
        return v
    }()
    
    lazy var baofeiSubTitle: UILabel = {
        let l = UILabel()
        l.font = kFont_text_2
        l.textColor = kColor_subText
        l.text = "本月保费目标"
        return l
    }()
    
    lazy var activitySubTitle: UILabel = {
        let l = UILabel()
        l.font = kFont_text_2
        l.textColor = kColor_subText
        l.text = "本月活动量目标"
        return l
    }()
    
    var baofeiCircle: AnalyzeCircleView!
    
    var activityCircle: AnalyzeCircleView!
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        isNeedSeparatorView = false
        contentView.addSubview(baofeiTitle)
        contentView.addSubview(activityTitle)
        contentView.addSubview(baofeiNumLabel)
        contentView.addSubview(activityNumLabel)
        contentView.addSubview(baofeiPointView)
        contentView.addSubview(activityPointView)
        contentView.addSubview(baofeiSubTitle)
        contentView.addSubview(activitySubTitle)

        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeConstraints() {
        baofeiTitle.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(15 * KScreenRatio_6)
            make.width.equalTo(kScreenWidth / 2)
            make.left.equalTo(contentView)
        }
        activityTitle.snp.makeConstraints { (make) in
            make.centerY.width.equalTo(baofeiTitle)
            make.right.equalTo(contentView)
        }
        baofeiNumLabel.snp.makeConstraints { (make) in
            make.top.equalTo(baofeiTitle.snp.bottom).offset(5)
            make.left.width.equalTo(baofeiTitle)
        }
        activityNumLabel.snp.makeConstraints { (make) in
            make.right.equalTo(contentView)
            make.centerY.width.equalTo(baofeiNumLabel)
        }
        baofeiPointView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 5, height: 5))
            make.left.equalTo(contentView).offset(40 * KScreenRatio_6)
            make.bottom.equalTo(contentView).offset(-30 * KScreenRatio_6)
        }
        baofeiSubTitle.snp.makeConstraints { (make) in
            make.centerY.equalTo(baofeiPointView)
            make.left.equalTo(baofeiPointView.snp.right).offset(5)
        }
        activityPointView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(222 * KScreenRatio_6)
            make.size.equalTo(CGSize.init(width: 5, height: 5))
            make.centerY.equalTo(baofeiPointView)
        }
        activitySubTitle.snp.makeConstraints { (make) in
            make.centerY.equalTo(baofeiPointView)
            make.left.equalTo(activityPointView.snp.right).offset(5)
        }
    }
    

    
}


//MARK: - 工作简报
class AnalyzeWorkReportCell: UITableViewCell {
    
    public var data = BXBWorkData() {
        didSet{
            contentCV.reloadData()
        }
    }

    lazy var contentCV: UICollectionView = {
        let l = UICollectionViewFlowLayout()
        l.itemSize = CGSize.init(width: 172 * KScreenRatio_6, height: 50 * KScreenRatio_6)
        l.sectionInset = UIEdgeInsets.init(top: 5, left: 0, bottom: 10 * KScreenRatio_6, right: 0)
        l.minimumLineSpacing = 0
        l.minimumInteritemSpacing = 0
        let cv = UICollectionView.init(frame: .zero, collectionViewLayout: l)
        cv.backgroundColor = UIColor.white
        cv.dataSource = self
        cv.delegate = self
        cv.isScrollEnabled = false
        cv.register(BXBWorkReportCVCell.self, forCellWithReuseIdentifier: "BXBWorkReportCVCell")
        return cv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(contentCV)
        contentCV.snp.makeConstraints { (make) in
            make.width.height.centerX.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - 业务活动量
class AnalyzeActivityCell: BXBBaseTableViewCell {
    
    public var dataArr = Array<AnalyzeVisitTypeList>(){
        didSet{
            guard datas.count == dataArr.count else { return }
            
            var points = Array<CGPoint>()
            
            let sortsArr = dataArr.sorted { (obj_1, obj_2) -> Bool in
                return obj_1.visitCount < obj_2.visitCount
            }
            
            let maxCount = sortsArr.last!.visitCount
            
            
            for v1 in dataArr {
                for v2 in datas {
                    if v2.visitTepyName == v1.visitTepyName { v2.visitCount = v1.visitCount }
                }
            }
            for (i, v) in datas.enumerated() {
                
                var p = CGPoint()
                
                if maxCount == 0 {
                    p = getMatterPoint(ratio: 0.2, index: i)
                }
                else {
                    let r = CGFloat(v.visitCount) / CGFloat(maxCount) + 0.2 > 0.9 ? 0.9 : CGFloat(v.visitCount) / CGFloat(maxCount) + 0.2
                    p = getMatterPoint(ratio: r, index: i)
                }
                
                points.append(p)
            }
            bezier.removeAllPoints()
            bezier.move(to: points[0])
            for (i, v) in points.enumerated() {
                if i != 0 { bezier.addLine(to: v) }
            }
            bezier.close()
            shapeLayer.path = bezier.cgPath
            
            shapeView.layer.removeAllSublayers()
            shapeView.layer.insertSublayer(shapeLayer, at: 0)
            
            matterCV.reloadData()
        }
    }
    
    let datas: [AnalyzeVisitTypeList] = [AnalyzeVisitTypeList.initData(name: "接洽"), AnalyzeVisitTypeList.initData(name: "面谈"), AnalyzeVisitTypeList.initData(name: "增员"), AnalyzeVisitTypeList.initData(name: "签单"), AnalyzeVisitTypeList.initData(name: "建议书"), AnalyzeVisitTypeList.initData(name: "保单服务"), AnalyzeVisitTypeList.initData(name: "客户服务")]
    
    lazy var radarIV: UIImageView = {
        let v = UIImageView.init(image: UIImage.init(named: "me_雷达图背景"))
        return v
    }()
    lazy var bezier: UIBezierPath = {
        let b = UIBezierPath.init()
        return b
    }()
    lazy var shapeLayer: CAShapeLayer = {
        let l = CAShapeLayer.init()
        l.fillColor = UIColor.init(hexString: "#92c8fb99")?.cgColor
        return l
    }()
    lazy var shapeView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.clear
        return v
    }()
    lazy var matterCV: UICollectionView = {
        let l = AnalyzeActivityLayout()
        let cv = UICollectionView.init(frame: .zero, collectionViewLayout: l)
        cv.backgroundColor = UIColor.clear
        cv.dataSource = self
        cv.delegate = self
        cv.isScrollEnabled = false
        cv.register(AnalyzeActivityCVCell.self, forCellWithReuseIdentifier: "AnalyzeActivityCVCell")
        return cv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        isNeedSeparatorView = false
        contentView.addSubview(radarIV)
        radarIV.addSubview(shapeView)
        contentView.addSubview(matterCV)
        radarIV.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 160 * KScreenRatio_6, height: 160 * KScreenRatio_6))
            make.center.equalToSuperview()
        }
        shapeView.snp.makeConstraints { (make) in
            make.size.centerX.centerY.equalToSuperview()
        }
        matterCV.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: kScreenWidth - 80 * KScreenRatio_6, height: 300 * KScreenRatio_6))
            make.center.equalToSuperview()
        }
        radarIV.layer.transform = CATransform3DIdentity
        radarIV.layer.transform = CATransform3DMakeRotation(-45.0 / 180, 0, 0, 1)
        
        shapeView.transform = CGAffineTransform.init(rotationAngle: 0.2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getMatterPoint(ratio: CGFloat, index: Int) -> CGPoint {
        let angle: CGFloat = (360.0 / 7) * CGFloat(index)
        let center = CGPoint.init(x: 80 * KScreenRatio_6, y: 80 * KScreenRatio_6)
        let radius = ratio * 80 * KScreenRatio_6
        
        return CGPoint.init(x: center.x + radius * cos(angle * .pi / 180), y: center.y + radius * sin(angle * .pi / 180))
    }
    
    
}

class AnalyzeActivityCVCell: UICollectionViewCell {
    
    
    lazy var matterLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = kColor_dark
        l.textAlignment = .center
        return l
    }()
    lazy var numLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_3
        l.textColor = kColor_subText
        l.textAlignment = .center
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(matterLabel)
        contentView.addSubview(numLabel)
        matterLabel.snp.makeConstraints { (make) in
            make.top.width.centerX.equalToSuperview()
            make.height.equalTo(20 * KScreenRatio_6)
        }
        numLabel.snp.makeConstraints { (make) in
            make.top.equalTo(matterLabel.snp.bottom)
            make.width.centerX.bottom.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        matterLabel.text = nil
        numLabel.text = nil
    }
}

class AnalyzeActivityLayout: UICollectionViewLayout {
    
    var itemCount = 0
    
    var attributeArr = Array<UICollectionViewLayoutAttributes>()
    
    let matters = ["接洽", "面谈", "增员", "签单", "建议书", "保单服务", "客户服务"]
    
    override func prepare() {
        super.prepare()
        guard collectionView != nil else { return }
        itemCount = collectionView!.numberOfItems(inSection: 0)
        
        let radius = collectionView!.width * 0.4
        
        let center = CGPoint.init(x: collectionView!.width / 2, y: collectionView!.height / 2)
        
        for i in 0..<itemCount {
            let att = UICollectionViewLayoutAttributes.init(forCellWith: IndexPath.init(item: i, section: 0))
            let w = matters[i].getStringWidth(font: UIFont.systemFont(ofSize: 20 * KScreenRatio_6), height: 20 * KScreenRatio_6)
            att.size = CGSize.init(width: w, height: 40)
            
            let arg = 2 * .pi * Double(i) / Double(itemCount)
            let x = Double(center.x) + cos(arg) * Double(radius)
            let y = Double(center.y) + sin(arg) * Double(radius)
            att.center = CGPoint.init(x: x, y: y)
            
            attributeArr.append(att)
        }
    }
    
    override var collectionViewContentSize: CGSize {
        get {
            return collectionView?.size ?? .zero
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributeArr
    }
}

//MARK: - 签单用户总览
class AnalyzeUserSignCell: BXBBaseTableViewCell {
    
    public var data: AnalyzePolicyList! {
        willSet{
            nameLabel.text = newValue.name
            timeLabel.text = newValue.policyDate
            numLabel.text = "\(newValue.policyNum)单 " + "\(newValue.amount)元"
        }
    }
    
    lazy var nameLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = kColor_dark
        return l
    }()
    lazy var timeLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_3
        l.textColor = kColor_subText
        return l
    }()
    lazy var numLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_2_weight
        l.textColor = kColor_theme
        l.textAlignment = .right
        return l
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(numLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20 * KScreenRatio_6)
            make.top.equalToSuperview().offset(15 * KScreenRatio_6)
            make.width.equalTo(kScreenWidth / 2)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.left.width.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
        numLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20 * KScreenRatio_6)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        timeLabel.text = nil
        numLabel.text = nil
    }
    
    
}

/*
class AnalyzeClientInteractionCollectionCell: UICollectionViewCell {
    
    public var percent: CGFloat = 0.0 {
        willSet{
            progressView.snp.updateConstraints { (make) in
                make.height.equalTo(newValue * 155 * KScreenRatio_6)
            }
        }
    }
    
    public var data = AnalyzeClientType(){
        willSet{
            countLabel.text = "\(newValue.clientCount)"
            nameLabel.text = newValue.name
        }
    }
    
    lazy var countLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_3
        l.textColor = kColor_theme
        l.textAlignment = .center
        return l
    }()
    
    lazy var bgView: UIView = {
        let v = UIView()
        v.backgroundColor = kColor_background
        v.layer.cornerRadius = 2
        v.layer.masksToBounds = true
        return v
    }()
    
    lazy var progressView: UIView = {
        let v = UIView()
        v.backgroundColor = kColor_theme
        v.layer.cornerRadius = 2
        v.layer.masksToBounds = true
        return v
    }()
    
    lazy var sepView: UIView = {
        let v = UIView()
        v.backgroundColor = kColor_background
        return v
    }()
    
    lazy var nameLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_3
        l.textColor = kColor_text
        l.textAlignment = .center
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(countLabel)
        contentView.addSubview(bgView)
        bgView.addSubview(progressView)
        contentView.addSubview(sepView)
        contentView.addSubview(nameLabel)
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        countLabel.text = nil
        nameLabel.text = nil
    }
    
    func makeConstraints() {
        countLabel.snp.makeConstraints { (make) in
            make.centerX.top.width.equalTo(contentView)
        }
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(countLabel.snp.bottom).offset(15 * KScreenRatio_6)
            make.centerX.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 4, height: 155 * KScreenRatio_6))
        }
        progressView.snp.makeConstraints { (make) in
            make.width.centerX.bottom.equalTo(bgView)
            make.height.equalTo(0.01)
        }
        sepView.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.top.equalTo(bgView.snp.bottom)
            make.width.centerX.equalTo(contentView)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.bottom.centerX.equalTo(contentView)
            make.width.equalTo(contentView)
        }
    }
}


class AnalyzeClientInteractionCell: BXBBaseTableViewCell {
    
    ///互动目标次数
    public var total = 0.001
 
    public var dataArr = Array<AnalyzeClientType>(){
        willSet{
            clientCV.reloadData()
        }
    }
    
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 14 * KScreenRatio_6)
        l.textColor = kColor_theme
        l.text = "互动次数"
        return l
    }()
    
    lazy var clientCV: UICollectionView = {
        let l = UICollectionViewFlowLayout()
        l.itemSize = CGSize.init(width: 60 * KScreenRatio_6, height: 220 * KScreenRatio_6)
        l.scrollDirection = .horizontal
        l.sectionInset = UIEdgeInsets.init(top: 0, left: 15 * KScreenRatio_6, bottom: 0, right: 0)
        l.minimumLineSpacing = 5
        l.minimumInteritemSpacing = 5
        let cv = UICollectionView.init(frame: .zero, collectionViewLayout: l)
        cv.backgroundColor = UIColor.white
        cv.showsHorizontalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(AnalyzeClientInteractionCollectionCell.self, forCellWithReuseIdentifier: "AnalyzeClientInteractionCollectionCell")
        return cv
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(clientCV)
        titleLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(contentView).offset(15 * KScreenRatio_6)
        }
        clientCV.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: kScreenWidth, height: 230 * KScreenRatio_6))
            make.top.equalTo(titleLabel.snp.bottom).offset(15 * KScreenRatio_6)
            make.centerX.equalTo(contentView)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
 */

//MARK: - 转化率分析
class AnalyzeChangeCell: BXBBaseTableViewCell {
    
    lazy var bottomLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        return l
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setData(datas: [AnalyzeChangeData], total: CGFloat) {
        contentView.removeAllSubviews()
        contentView.addSubview(bottomLabel)
        bottomLabel.snp.makeConstraints { (make) in
            make.width.centerX.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(-10 * KScreenRatio_6)
        }
        let d = [AnalyzeChangeData.initData(name: "接洽", count: 0), AnalyzeChangeData.initData(name: "面谈", count: 0), AnalyzeChangeData.initData(name: "建议书", count: 0), AnalyzeChangeData.initData(name: "签单", count: 0)]
        for v in datas {
            for n in d {
                if v.visitTepyName == n.visitTepyName { n.visitCount = v.visitCount }
            }
        }
        
        for (k, v) in d.enumerated() {
            
            var color = kColor_theme
            if v.visitTepyName == "面谈" { color = UIColor.init(hexString: "#afb6be") }
            if v.visitTepyName == "建议书" { color = UIColor.init(hexString: "#778694") }
//            if v.visitTepyName == "签单" { color = UIColor.init(hexString: "#f1a764") }
            if v.visitTepyName == "接洽" { color = UIColor.init(hexString: "#d3dae3") }
            let p = CGFloat(v.visitCount) / (total == 0 ? 1 : total)
            
            let cv = makeChangeView(title: v.visitTepyName, color: color!, count: v.visitCount, percent: p > 1 ? 1 : p)
            contentView.addSubview(cv)
            cv.snp.makeConstraints { (make) in
                make.top.equalTo(contentView).offset(10 * KScreenRatio_6 + CGFloat(k) * 40 * KScreenRatio_6)
                make.left.equalTo(contentView).offset(30 * KScreenRatio_6)
                make.right.equalTo(contentView)
                make.height.equalTo(30 * KScreenRatio_6)
            }
        }
    }
    
    func makeChangeView(title: String, color: UIColor, count: Int, percent: CGFloat) -> UIView {
        let v = UIView()
        v.backgroundColor = UIColor.white
        
        let l = UILabel()
        l.font = kFont_text_3
        l.textColor = color
        l.text = title
        v.addSubview(l)
        
        let sepView = UIView()
        sepView.backgroundColor = color
        v.addSubview(sepView)
        
        let countLabel = UILabel()
        countLabel.font = kFont_text
        countLabel.textColor = UIColor.white
        countLabel.textAlignment = .center
        countLabel.backgroundColor = color
        countLabel.layer.cornerRadius = 3
        countLabel.layer.masksToBounds = true
        countLabel.text = "\(count)"
        v.addSubview(countLabel)
        
        l.snp.makeConstraints { (make) in
            make.left.centerY.equalTo(v)
            make.width.equalTo(60 * KScreenRatio_6)
        }
        sepView.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.top.equalTo(l.snp.bottom).offset(2.5)
            make.left.equalTo(l)
            make.right.equalTo(countLabel.snp.left).offset(-2.5)
        }
        countLabel.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: percent * 200 * KScreenRatio_6 + 40, height: 25 * KScreenRatio_6))
            make.center.equalTo(v)
        }
        return v
    }
    
}






















