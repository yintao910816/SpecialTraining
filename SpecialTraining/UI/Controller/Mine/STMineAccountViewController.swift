//
//  STMineAccountViewController.swift
//  SpecialTraining
//
//  Created by 徐军 on 2018/11/30.
//  Copyright © 2018年 youpeixun. All rights reserved.
//

import UIKit
import RxSwift

class STMineAccountViewController: BaseViewController {
    
    @IBOutlet weak var tableView: BaseTB!
    override func setupUI() {
        title = "我的账户"
        addBarItem(normal: "", title: "按钮" , right: true).drive(onNext: { [unowned self] (_) in
            PrintLog("点击右上角按钮")
        }).disposed(by: disposeBag)
    }
    
    override func rxBind() {
        
    }
    
    @IBAction func btnClick(_ sender: UIButton) {
        let tag = sender.tag
        switch tag {
        case 1000:
            PrintLog("点击了收付款")
        case 1001:
            PrintLog("点击了零钱")
            performSegue(withIdentifier: "changeSegue", sender: nil)
        case 1002:
            PrintLog("点击了银行卡")
            performSegue(withIdentifier: "bankSegue", sender: nil)
        default:
            break
        }
    }
}
