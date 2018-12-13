//
//  BXBAnalyzePopoverVC.swift
//  BXB
//
//  Created by equalriver on 2018/7/25.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation

protocol AnalyzePopoverDelegate: NSObjectProtocol {
    func didSelectedPopoverItem(month: String)
}

class BXBAnalyzePopoverVC: UIViewController {
    
    weak public var delegate: AnalyzePopoverDelegate?
    
    public var currentMonth = 0
    
    lazy var tableView: UITableView = {
        let t = UITableView.init(frame: CGRect.zero, style: .plain)
        t.separatorStyle = .none
        t.dataSource = self
        t.delegate = self
        t.showsVerticalScrollIndicator = false
        return t
    }()
    
    lazy var dataArr: Array<String> = {
        var arr = Array<String>()
        for v in 1..<13 {
            arr.append("\(v)月")
        }
        return arr
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.frame = view.bounds
    }
    
}


extension BXBAnalyzePopoverVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40 * KScreenRatio_6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AnalyzePopoverCell.init(style: .default, reuseIdentifier: nil)
        cell.titleLabel.text = dataArr[indexPath.row]
        let m = dataArr[indexPath.row].components(separatedBy: "月")
        guard m.count > 0 else { return cell }
        if Int(m.first!)! == currentMonth { cell.titleLabel.textColor = kColor_theme }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var mon = ""
        
        if indexPath.row + 1 < 10 {
            mon = "0" + "\(indexPath.row + 1)"
        }
        else { mon = "\(indexPath.row + 1)" }
        delegate?.didSelectedPopoverItem(month: mon)
        dismiss(animated: true, completion: nil)
    }
    
}


class AnalyzePopoverCell: BXBBaseTableViewCell {
    
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.textColor = kColor_text
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 19 * KScreenRatio_6)
        return l
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.size.centerX.centerY.equalTo(contentView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
