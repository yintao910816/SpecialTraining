//
//  STMineAccountDetailViewController.swift
//  SpecialTraining
//
//  Created by yintao on 2019/3/9.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class STMineAccountDetailViewController: BaseViewController {

    @IBOutlet weak var awardsOutlet: UILabel!
    @IBOutlet weak var statueOutlet: UILabel!
    @IBOutlet weak var statementOutlet: UILabel!
    @IBOutlet weak var applyTimeOutlet: UILabel!
    @IBOutlet weak var receiveAwardOutlet: UILabel!
    @IBOutlet weak var orderOutlet: UILabel!
    
    private var item_id: String = ""
    private var level:   String = ""
    
    private var viewModel: MineAccountDetailViewModel!
    
    override func setupUI() {
        
    }
    
    override func rxBind() {
        viewModel = MineAccountDetailViewModel.init(item_id: item_id, level: level)
        
        viewModel.countAwardsObser.asDriver()
            .drive(awardsOutlet.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.currentStatusObser.asDriver()
            .drive(statueOutlet.rx.text)
            .disposed(by: disposeBag)

        viewModel.statementObser.asDriver()
            .drive(statementOutlet.rx.text)
            .disposed(by: disposeBag)

        viewModel.applyTimeObser.asDriver()
            .drive(applyTimeOutlet.rx.text)
            .disposed(by: disposeBag)

        viewModel.receiveTimeObser.asDriver()
            .drive(receiveAwardOutlet.rx.text)
            .disposed(by: disposeBag)

        viewModel.orderNumObser.asDriver()
            .drive(orderOutlet.rx.text)
            .disposed(by: disposeBag)

        viewModel.reloadSubject.onNext(Void())
    }
    
    override func prepare(parameters: [String : Any]?) {
        item_id = (parameters!["item_id"] as! String)
        level = (parameters!["level"] as! String)
    }
}
