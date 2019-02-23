//
//  STPayBackInfoViewController.swift
//  SpecialTraining
//
//  Created by yintao on 2019/2/24.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class STPayBackInfoViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private lazy var payBackSuccessView: PayBackSuccessView = {
        let header = PayBackSuccessView.init(frame: .init(x: 0, y: 0, width: self.view.width, height: 412))
        return header
    }()
    
    private lazy var waitForDealView: WaitForDealView = {
        let header = WaitForDealView.init(frame: .init(x: 0, y: 0, width: self.view.width, height: 615))
        return header
    }()
    
    override func setupUI() {
        if arc4random() % 2 == 1 {
            navigationItem.title = "退款成功"
            tableView.tableHeaderView = payBackSuccessView
        }else {
            navigationItem.title = "退款状态"
            tableView.tableHeaderView = waitForDealView
        }
    }
    
    override func rxBind() {
        
    }

}
