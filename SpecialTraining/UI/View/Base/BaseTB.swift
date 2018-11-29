//
//  BaseTB.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/16.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit
import RxSwift

class BaseTB: UITableView {

    private lazy var disposeBag: DisposeBag = { return DisposeBag() }()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        defaultSetup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        defaultSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func defaultSetup() {
        separatorStyle = .none
        
        rx.itemSelected.asDriver()
            .drive(onNext: { [weak self] indexPath in
                self?.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    deinit {
        PrintLog("\(self) ------ 已释放")
    }

}
