//
//  BXBAgendaDetailPopoverVC.swift
//  BXB
//
//  Created by equalriver on 2018/8/23.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit

protocol AgendaDetailPopoverDelegate: NSObjectProtocol {
    func didSelectedPopoverItem(index: Int)
}

class BXBAgendaDetailPopoverVC: UIViewController {
    
    weak public var delegate: AgendaDetailPopoverDelegate?
    
    lazy var tableView: UITableView = {
        let t = UITableView.init(frame: CGRect.zero, style: .plain)
        t.separatorStyle = .none
        t.dataSource = self
        t.delegate = self
        t.showsVerticalScrollIndicator = false
        return t
    }()
    
    public var dataArr = Array<String>(){
        willSet{
            if newValue.contains("编辑"){ imgs.append(#imageLiteral(resourceName: "popover_bianji")) }
            if newValue.contains("删除"){ imgs.append(#imageLiteral(resourceName: "popover_shanchu")) }
        }
    }
    var imgs = Array<UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.center.size.equalTo(view)
        }
    }
}


extension BXBAgendaDetailPopoverVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50 * KScreenRatio_6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AgendaDetailPopoverCell.init(style: .default, reuseIdentifier: nil)
        guard dataArr.count == imgs.count else { return cell }
        cell.setData(img: imgs[indexPath.row], title: dataArr[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        delegate?.didSelectedPopoverItem(index: indexPath.row)
        dismiss(animated: true, completion: nil)
    }
    
}


class AgendaDetailPopoverCell: BXBBaseTableViewCell {
    
    lazy var imgIV: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.textColor = kColor_text
//        l.textAlignment = .center
        l.font = kFont_text
        return l
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(imgIV)
        imgIV.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(15 * KScreenRatio_6)
            make.centerY.equalTo(contentView)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.height.centerY.right.equalTo(contentView)
            make.left.equalTo(contentView).offset(53 * KScreenRatio_6)
        }
    }
    
    func setData(img: UIImage, title: String) {
        imgIV.image = img
        titleLabel.text = title

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
