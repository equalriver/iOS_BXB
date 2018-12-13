//
//  AddNewClientEditInfoVC.swift
//  BXB
//
//  Created by equalriver on 2018/6/20.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit

class AddNewClientEditInfoVC: BXBBaseNavigationVC {
    
    public var clientData: ClientData! {
        
        willSet{

            switch titleInfo {
            case "姓名":
                inputTF.text = newValue.name
                
            case "手机":
                inputTF.text = newValue.phone
                
            case "性别":
                selectedValue = newValue.sex
                
            case "婚姻状态":
                selectedValue = newValue.marriageStatus
                
            default:
                break
            }
        }
    }
    
    public var data: UserData! {
        willSet{
            
            switch titleInfo {
            case "姓名":
                inputTF.text = newValue.name
                
            case "手机":
                inputTF.text = newValue.phone
                
            case "性别":
                selectedValue = newValue.sex
                
            case "婚姻状态":
                selectedValue = newValue.marriageStatus
                
            case "签名":
                inputTV.text = newValue.signature
                
            case "简介":
                inputTV.text = newValue.introduce
                
            default:
                break
            }
        }
    }
    
    public var titleInfo = ""{
        willSet{
            
            naviBar.rightBarButtons = [saveButton]
            
            inputTF.attributedPlaceholder = NSAttributedString.init(string: "请输入" + newValue, attributes: [NSAttributedString.Key.font: kFont_text_2, NSAttributedString.Key.foregroundColor: kColor_subText!])
            
            if newValue == "学历" {
                titleArr = ["高中及以下", "专科", "本科", "硕士及以上"]
                naviBar.rightBarButtons = []
            }
            if newValue == "性别" {
                titleArr = ["男", "女"]
                naviBar.rightBarButtons = []
            }
            if newValue == "婚姻状态" {
                titleArr = ["已婚", "未婚"]
                naviBar.rightBarButtons = []
            }
            if newValue == "姓名" || newValue == "手机" || newValue == "年收入" {
                tableView.isHidden = true
                inputTF.isHidden = false
                inputBgView.isHidden = false
            }
            if newValue == "手机" {
                inputTF.keyboardType = .numbersAndPunctuation
                inputTF.attributedPlaceholder = NSAttributedString.init(string: "请输入新的手机号", attributes: [NSAttributedString.Key.font: kFont_text_2, NSAttributedString.Key.foregroundColor: kColor_subText!])
            }
            if newValue == "年收入" {
                inputTF.attributedPlaceholder = NSAttributedString.init(string: "万元", attributes: [NSAttributedString.Key.font: kFont_text_2, NSAttributedString.Key.foregroundColor: kColor_subText!])
                inputTF.keyboardType = .numbersAndPunctuation
            }
            if newValue == "简介" || newValue == "签名" {
                tableView.isHidden = true
                inputTV.isHidden = false
                remarkCountLabel.isHidden = false
                inputBgView.isHidden = false
                inputTV.placeholderText = "请输入" + newValue
            }
            
            tableView.reloadData()
        }
    }
    
//    public var detailText = "" {
//        willSet{
//            if titleInfo == "签名" { inputTF.text = newValue }
//            if titleInfo == "简介" { inputTV.text = newValue }
//        }
//    }
    
    var selectedValue = ""

    private var titleArr = [""]
    
    private var handle: ((_ info: String) -> Void)!
    
    lazy var tableView: UITableView = {
        let tb = UITableView.init(frame: .zero, style: .plain)
        tb.backgroundColor = kColor_background
        tb.separatorStyle = .none
        tb.dataSource = self
        tb.delegate = self
        tb.isScrollEnabled = false
        tb.layer.masksToBounds = true
        tb.layer.cornerRadius = kCornerRadius
        return tb
    }()
    lazy var inputBgView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        v.isHidden = true
        v.layer.masksToBounds = true
        v.layer.cornerRadius = kCornerRadius
        return v
    }()
    lazy var inputTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "请输入要修改的信息"
        tf.font = kFont_text_2_weight
        tf.textColor = kColor_dark
        tf.clearButtonMode = .whileEditing
        tf.backgroundColor = UIColor.white
        tf.isHidden = true
        tf.addTarget(self, action: #selector(textFieldEditChange(sender:)), for: .editingChanged)
        return tf
    }()
    lazy var inputTV: YYTextView = {
        let tf = YYTextView()
        tf.placeholderText = "请输入要修改的信息"
        tf.font = kFont_text_2_weight
        tf.placeholderFont = kFont_text_2
        tf.textColor = kColor_dark
        tf.backgroundColor = UIColor.white
        tf.isHidden = true
        tf.delegate = self
        return tf
    }()
    lazy var remarkCountLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .right
        l.isHidden = true
        return l
    }()
    lazy var saveButton: UIButton = {
        let b = UIButton()
        b.titleLabel?.font = kFont_naviBtn_weight
        b.setTitle("保存", for: .normal)
        b.setTitleColor(kColor_theme, for: .normal)
        return b
    }()

    //MARK: -
    convenience init(callback: @escaping (_ info: String) -> Void) {
        self.init()
        handle = callback
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = kColor_background
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if titleInfo == "简介" || titleInfo == "签名" {
            
            inputBgView.snp.updateConstraints { (make) in
                make.size.equalTo(CGSize.init(width: 345 * KScreenRatio_6, height: 100 * KScreenRatio_6))
            }
            
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if inputTF.isHidden == false {
            inputTF.becomeFirstResponder()
        }
    }
    
    func initUI() {
        view.addSubview(tableView)
        view.addSubview(inputBgView)
        inputBgView.addSubview(inputTF)
        inputBgView.addSubview(inputTV)
        view.addSubview(remarkCountLabel)
        title = titleInfo
        tableView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.size.equalTo(CGSize.init(width: 345 * KScreenRatio_6, height: CGFloat(titleArr.count) * 55 * KScreenRatio_6))
            make.top.equalTo(naviBar.snp.bottom).offset(15 * KScreenRatio_6)
        }
        inputBgView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 345 * KScreenRatio_6, height: 55 * KScreenRatio_6))
            make.top.equalTo(naviBar.snp.bottom).offset(15 * KScreenRatio_6)
            make.centerX.equalTo(view)
        }
        inputTF.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 345 * KScreenRatio_6 - 30 * KScreenRatio_6, height: 55 * KScreenRatio_6))
            make.center.equalTo(inputBgView)
        }
        inputTV.snp.makeConstraints { (make) in
            make.center.equalTo(inputBgView)
            make.size.equalTo(CGSize.init(width: 345 * KScreenRatio_6 - 30 * KScreenRatio_6, height: 80 * KScreenRatio_6))
        }
        remarkCountLabel.snp.makeConstraints { (make) in
            make.right.equalTo(view).offset(-25 * KScreenRatio_6)
            make.top.equalTo(inputTV.snp.bottom).offset(15 * KScreenRatio_6)
            make.left.equalTo(view)
        }
    }

    
    //MARK: - action
    @objc func textFieldEditChange(sender: UITextField) {
        
        guard sender.hasText else { return }
        
        if titleInfo == "手机" {
            sender.text = String(sender.text!.prefix(11)).filter({ (c) -> Bool in
                return String(c).isAllNumber
            })
        }
        else if titleInfo == "姓名" {
            guard sender.markedTextRange == nil else { return }
            if sender.text!.count > kNameTextLimitCount {
                sender.text = String(sender.text!.prefix(kNameTextLimitCount))
            }
            
        }
        else {
            sender.text = sender.text!.filter({ (c) -> Bool in
                return String(c).isIncludeEmoji == false
            })
        }

    }
    
    override func rightButtonsAction(sender: UIButton) {
        super.rightButtonsAction(sender: sender)
        if titleInfo == "姓名" || titleInfo == "手机" || titleInfo == "年收入" {
            if inputTF.hasText == false {
                view.makeToast("未填写\(titleInfo)")
                return
            }
            else{
                if titleInfo == "手机" {
                    if inputTF.text!.isPhoneNumber == false || inputTF.text!.count != 11 {
                        view.makeToast("手机号不正确")
                        return
                    }
                }
                if titleInfo == "年收入" {
                    if inputTF.text!.isAllNumber == false {
                        view.makeToast("请输入数字")
                        return
                    }
                }
                selectedValue = inputTF.text!
                
            }
        }
        if titleInfo == "简介" || titleInfo == "签名" {
            selectedValue = inputTV.text ?? ""
        }
        
        handle(selectedValue)
        navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}

//MARK: - YYTextViewDelegate
extension AddNewClientEditInfoVC: YYTextViewDelegate {
    
    func textViewDidChange(_ textView: YYTextView) {
        
        if textView.hasText && textView.text.isIncludeEmoji {
            
            textView.text = textView.text!.filter({ (c) -> Bool in
                return String(c).isIncludeEmoji == false
            })
            return
        }
        
        if textView.text.count > kRemarkTextLimitCount_2 {
            let sub = textView.text.prefix(kRemarkTextLimitCount_2)
            textView.text = String(sub)
            return
        }
        let s1 = "\(textView.text.count)"
        let s2 = "/\(kRemarkTextLimitCount_2)"
        let att = NSMutableAttributedString.init(string: s1 + s2)
        att.addAttributes([NSAttributedString.Key.font: kFont_text_3, NSAttributedString.Key.foregroundColor: kColor_theme!], range: NSMakeRange(0, s1.count))
        att.addAttributes([NSAttributedString.Key.font: kFont_text_3, NSAttributedString.Key.foregroundColor: kColor_subText!], range: NSMakeRange(s1.count, s2.count))
        remarkCountLabel.attributedText = att
    }
}

extension AddNewClientEditInfoVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55 * KScreenRatio_6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AddNewClientEditInfoCell.init(style: .default, reuseIdentifier: nil)
        cell.titleLabel.text = titleArr[indexPath.row]
        if titleArr.count - 1 == indexPath.row {
            cell.isNeedSeparatorView = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedValue = titleArr[indexPath.row]
        handle(selectedValue)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.setSelected(selectedValue == titleArr[indexPath.row], animated: true)
    }
    
}

class AddNewClientEditInfoCell: BXBBaseTableViewCell {
    
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.textColor = kColor_dark
        l.font = kFont_text_weight
        return l
    }()
    
    lazy var rightIV: UIImageView = {
        let iv = UIImageView.init(image: #imageLiteral(resourceName: "bxb_选中_筛选栏"))
        iv.isHidden = true
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(rightIV)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.height.equalTo(contentView)
            make.left.equalTo(contentView).offset(15 * KScreenRatio_6)
            make.width.equalTo(200 * KScreenRatio_6)
        }
        rightIV.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).offset(-15 * KScreenRatio_6)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        rightIV.isHidden = !selected
        
    }
}








