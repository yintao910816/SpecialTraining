//
//  STMineWithdrawAccountViewController.swift
//  SpecialTraining
//
//  Created by xujun on 2018/12/21.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class STMineWithdrawAccountViewController: BaseViewController {

    @IBOutlet weak var balanceLbl: UILabel!
    @IBOutlet weak var freezenLbl: UILabel!
    @IBOutlet weak var withdrawLbl: UILabel!
    @IBOutlet weak var tipLbl: UILabel!
    @IBOutlet weak var bindBtn: UIButton!
    @IBOutlet weak var tableView: BaseTB!
    
    override func setupUI() {
        title = "提现账户"
    }
    
    override func rxBind() {
        
    }

}
