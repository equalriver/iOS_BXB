//
//  BXBBaseTableVC.swift
//  BXB
//
//  Created by equalriver on 2018/7/11.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class BXBBaseTableVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        IQKeyboardManager.shared.enable = false
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
 

   

}
