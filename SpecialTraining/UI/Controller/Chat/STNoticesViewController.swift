//
//  STNoticesViewController.swift
//  SpecialTraining
//
//  Created by yintao on 2019/5/15.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class STNoticesViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func setupUI() {
        tableView.rowHeight = 50
        tableView.register(UINib.init(nibName: "FriendsApplyCell", bundle: Bundle.main),
                           forCellReuseIdentifier: "FriendsApplyCellID")
    }
    
    override func rxBind() {
        
    }
}
