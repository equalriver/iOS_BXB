//
//  BXBWorkVCCells.swift
//  BXB
//
//  Created by equalriver on 2018/9/26.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation

//MARK: - top buttons
class BXBWorkTopButtonsCell: UICollectionViewCell {
    
    lazy var iconIV: UIImageView = {
        let v = UIImageView()
        return v
    }()
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_3
        l.textColor = kColor_text
        l.textAlignment = .center
        return l
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(iconIV)
        contentView.addSubview(titleLabel)
        iconIV.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 30 * KScreenRatio_6, height: 30 * KScreenRatio_6))
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(15 * KScreenRatio_6)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.width.bottom.centerX.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconIV.image = nil
        titleLabel.text = nil
    }
}

//MARK: - 今日待办
protocol BXBWorkAgendaDelegate: NSObjectProtocol {
    func didClickAddNewAgenda()
    func didClickFinish(sender: UIButton, cell: UITableViewCell)
}
class BXBWorkAgendaCell: BXBBaseTableViewCell {
    
    weak public var delegate: BXBWorkAgendaDelegate?
    
    public var data: AgendaData! {
        willSet{
            finishBtn.isHidden = false
            nameLabel.isHidden = false
            timeLabel.isHidden = false
            emptyLabel.isHidden = true
            emptyIV.isHidden = true
            emptyBtn.isHidden = true
            addAgendaBtn.isHidden = true
            nameLabel.text = newValue.visitTypeName + " " + newValue.name
            timeLabel.text = newValue.visitTime
        }
    }
    
    public var isAddAgenda = false {
        willSet{
            finishBtn.isHidden = newValue
            nameLabel.isHidden = newValue
            timeLabel.isHidden = newValue
            emptyLabel.isHidden = newValue
            emptyIV.isHidden = newValue
            emptyBtn.isHidden = newValue
            addAgendaBtn.isHidden = !newValue
        }
    }
    public var isNoData = false {
        willSet{
            finishBtn.isHidden = newValue
            nameLabel.isHidden = newValue
            timeLabel.isHidden = newValue
            emptyLabel.isHidden = !newValue
            emptyIV.isHidden = !newValue
            emptyBtn.isHidden = !newValue
            addAgendaBtn.isHidden = newValue
        }
    }
    lazy var finishBtn: UIButton = {
        let b = UIButton()
        b.setImage(UIImage.init(named: "work_勾选框"), for: .normal)
        b.setImage(UIImage.init(named: "work_勾选框_勾选"), for: .selected)
        b.addBlock(for: .touchUpInside, block: { [unowned self](btn) in
            self.delegate?.didClickFinish(sender: b, cell: self)
        })
        return b
    }()
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
    lazy var emptyLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = kColor_text
        l.text = "恭喜你，今天已没有任务!"
        l.textAlignment = .center
        l.isHidden = true
        return l
    }()
    lazy var emptyIV: UIImageView = {
        let iv = UIImageView.init(image: UIImage.init(named: "work_今日代办_空白页"))
        iv.isHidden = true
        return iv
    }()
    lazy var emptyBtn: UIButton = {
        let b = UIButton()
        b.titleLabel?.font = kFont_text_3_weight
        b.setTitle("新建日程", for: .normal)
        b.setTitleColor(UIColor.white, for: .normal)
        b.backgroundColor = kColor_theme
        b.layer.cornerRadius = kCornerRadius
        b.layer.masksToBounds = true
        b.isHidden = true
        b.addBlock(for: .touchUpInside, block: { [unowned self](btn) in
            self.delegate?.didClickAddNewAgenda()
        })
        return b
    }()
    lazy var addAgendaBtn: UIButton = {
        let b = UIButton()
        b.titleLabel?.font = kFont_text_weight
        b.setTitle("  新建日程", for: .normal)
        b.setTitleColor(kColor_subText, for: .normal)
        b.setImage(UIImage.init(named: "work_新建日程_首页"), for: .normal)
        b.isHidden = true
        b.addBlock(for: .touchUpInside, block: { [unowned self](btn) in
            self.delegate?.didClickAddNewAgenda()
        })
        return b
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        isNeedSeparatorView = false
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(finishBtn)
        contentView.addSubview(nameLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(emptyLabel)
        contentView.addSubview(emptyBtn)
        contentView.addSubview(addAgendaBtn)
        contentView.addSubview(emptyIV)
        finishBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(5 * KScreenRatio_6)
            make.size.equalTo(CGSize.init(width: 45 * KScreenRatio_6, height: 45 * KScreenRatio_6))
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(finishBtn.snp.right)
            make.right.equalToSuperview().offset(-20 * KScreenRatio_6)
            make.top.equalToSuperview()
        }
        timeLabel.snp.makeConstraints { (make) in
            make.left.width.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
        addAgendaBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 130 * KScreenRatio_6, height: 30 * KScreenRatio_6))
            make.left.centerY.equalToSuperview()
        }
        emptyLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10 * KScreenRatio_6)
            make.left.equalToSuperview().offset(20 * KScreenRatio_6)
        }
        emptyBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 114 * KScreenRatio_6, height: 34 * KScreenRatio_6))
            make.left.equalToSuperview().offset(20 * KScreenRatio_6)
            make.top.equalTo(emptyLabel.snp.bottom).offset(13 * KScreenRatio_6)
        }
        emptyIV.snp.makeConstraints { (make) in
            make.height.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20 * KScreenRatio_6)
            make.width.equalTo(80 * KScreenRatio_6)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        timeLabel.text = nil
    }
}



//MARK: - 今日提醒
protocol BXBWorkNoticeDelegate: NSObjectProtocol {
    func didClickFollow(cell: BXBWorkNoticeCell)
}
class BXBWorkNoticeCell: BXBBaseTableViewCell {
    
    weak public var delegate: BXBWorkNoticeDelegate?
    
    public var data: NoticeDetailData! {
        willSet{
            nameLabel.isHidden = false
            timeLabel.isHidden = false
            emptyLabel.isHidden = true
            emptyIV.isHidden = true
            followBtn.isHidden = false
            
            let s = newValue.name + " " + newValue.matter + " "
            let att = NSMutableAttributedString.init(string: s + newValue.remindName)
            att.addAttributes([.font: kFont_text_weight, .foregroundColor: kColor_dark!], range: NSMakeRange(0, s.count))
            att.addAttributes([.font: kFont_text_3, .foregroundColor: kColor_subText!], range: NSMakeRange(s.count, newValue.remindName.count))
            nameLabel.attributedText = att
            
            guard let date = dateFormatter.date(from: newValue.times) else { return }
            
            if newValue.difTime == "0" {
                timeLabel.text = dateFormatter_out.string(from: date) + " 今天"
            }
            else {
                timeLabel.text = dateFormatter_out.string(from: date) + " 距今\(newValue.difTime)天"
            }
        }
    }
    public var isNoData = false {
        willSet{
            nameLabel.isHidden = newValue
            timeLabel.isHidden = newValue
            emptyLabel.isHidden = !newValue
            emptyIV.isHidden = !newValue
            followBtn.isHidden = newValue
        }
    }
    
    lazy var nameLabel: UILabel = {
        let l = UILabel()
        return l
    }()
    lazy var timeLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_3
        l.textColor = kColor_subText
        return l
    }()
    lazy var emptyLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = kColor_text
        l.text = "暂时没有提醒消息"
        l.textAlignment = .center
        l.isHidden = true
        return l
    }()
    lazy var emptyIV: UIImageView = {
        let iv = UIImageView.init(image: UIImage.init(named: "work_今题提醒_空白页"))
        iv.isHidden = true
        return iv
    }()
    lazy var followBtn: UIButton = {
        let b = UIButton()
        b.setImage(UIImage.init(named: "work_跟进"), for: .normal)
        b.addBlock(for: .touchUpInside, block: { [unowned self](btn) in
            self.delegate?.didClickFollow(cell: self)
        })
        return b
    }()
    lazy var dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()
    lazy var dateFormatter_out: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy年MM月dd日"
        return f
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        isNeedSeparatorView = false
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(nameLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(followBtn)
        contentView.addSubview(emptyLabel)
        contentView.addSubview(emptyIV)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20 * KScreenRatio_6)
            make.right.equalToSuperview().offset(-80 * KScreenRatio_6)
            make.top.equalToSuperview()
        }
        timeLabel.snp.makeConstraints { (make) in
            make.left.width.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
        followBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 50 * KScreenRatio_6, height: 25 * KScreenRatio_6))
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15 * KScreenRatio_6)
        }
        emptyLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().multipliedBy(0.9)
            make.left.equalToSuperview().offset(20 * KScreenRatio_6)
        }
        emptyIV.snp.makeConstraints { (make) in
            make.height.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20 * KScreenRatio_6)
            make.width.equalTo(80 * KScreenRatio_6)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.attributedText = nil
        timeLabel.text = nil
    }
}




//MARK: - 工作简报
protocol BXBWorkReportDelegate: NSObjectProtocol {
    func didClickRightButton(sender: UIButton)
}
class BXBWorkReportView: UIView {
    
    weak public var delegate: BXBWorkReportDelegate?
    
    public var data = BXBWorkData() {
        willSet{
            contentCV.reloadData()
        }
    }
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_2
        l.textColor = kColor_text
        l.text = "工作简报"
        return l
    }()
    lazy var rightBtn: UIButton = {
        let b = UIButton()
        let att_1 = NSMutableAttributedString.init(string: "日/月")
        att_1.addAttributes([NSAttributedString.Key.font: kFont_text_2_weight, NSAttributedString.Key.foregroundColor: kColor_dark!], range: NSMakeRange(0, 1))
        att_1.addAttributes([NSAttributedString.Key.font: kFont_text_3, NSAttributedString.Key.foregroundColor: kColor_subText!], range: NSMakeRange(1, 2))
        let att_2 = NSMutableAttributedString.init(string: "日/月")
        att_2.addAttributes([NSAttributedString.Key.font: kFont_text_3, NSAttributedString.Key.foregroundColor: kColor_subText!], range: NSMakeRange(0, 2))
        att_2.addAttributes([NSAttributedString.Key.font: kFont_text_2_weight, NSAttributedString.Key.foregroundColor: kColor_dark!], range: NSMakeRange(2, 1))
        b.setAttributedTitle(att_1, for: .normal)
        b.setAttributedTitle(att_2, for: .selected)
        b.addBlock(for: .touchUpInside, block: { [unowned self](btn) in
            self.delegate?.didClickRightButton(sender: b)
        })
        return b
    }()
    lazy var sepView: UIView = {
        let v = UIView()
        v.backgroundColor = kColor_separatorView
        return v
    }()
    lazy var contentCV: UICollectionView = {
        let l = UICollectionViewFlowLayout()
        l.itemSize = CGSize.init(width: 172 * KScreenRatio_6, height: 50 * KScreenRatio_6)
        l.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 10 * KScreenRatio_6, right: 0)
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(rightBtn)
        addSubview(sepView)
        addSubview(contentCV)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20 * KScreenRatio_6)
            make.top.equalToSuperview().offset(15 * KScreenRatio_6)
        }
        rightBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 60 * KScreenRatio_6, height: 30 * KScreenRatio_6))
            make.centerY.equalTo(titleLabel)
            make.right.equalToSuperview()
        }
        sepView.snp.makeConstraints { (make) in
            make.width.centerX.equalToSuperview()
            make.height.equalTo(0.5)
            make.top.equalTo(titleLabel.snp.bottom).offset(15 * KScreenRatio_6)
        }
        contentCV.snp.makeConstraints { (make) in
            make.width.bottom.centerX.equalToSuperview()
            make.top.equalTo(sepView.snp.bottom)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BXBWorkReportCVCell: UICollectionViewCell {
    
    lazy var iconIV: UIImageView = {
        let v = UIImageView()
        return v
    }()
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_2
        l.textColor = kColor_subText
        return l
    }()
    lazy var countLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = kColor_dark
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(iconIV)
        contentView.addSubview(titleLabel)
        contentView.addSubview(countLabel)
        iconIV.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 25 * KScreenRatio_6, height: 25 * KScreenRatio_6))
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20 * KScreenRatio_6)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10 * KScreenRatio_6)
            make.right.equalToSuperview().offset(-20 * KScreenRatio_6)
            make.left.equalTo(iconIV.snp.right).offset(15 * KScreenRatio_6)
        }
        countLabel.snp.makeConstraints { (make) in
            make.left.width.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconIV.image = nil
        titleLabel.text = nil
        countLabel.text = nil
    }
}

extension BXBWorkReportView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BXBWorkReportCVCell", for: indexPath) as! BXBWorkReportCVCell
        cell.iconIV.image = [UIImage.init(named: "work_新增客户"), UIImage.init(named: "work_增员"), UIImage.init(named: "work_活动量"), UIImage.init(named: "work_成交单数")][indexPath.item]
        cell.titleLabel.text = ["新增客户", "增员", "活动量", "成交单数"][indexPath.item]
        cell.countLabel.text = ["\(data.addClientTotal)", "\(data.zengYuanTotal)", "\(data.finishVisit)", "\(data.policyNum)"][indexPath.item]
        return cell
    }
}
