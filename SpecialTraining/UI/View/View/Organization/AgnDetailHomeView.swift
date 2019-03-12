//
//  AgnDetailHomeView.swift
//  SpecialTraining
//
//  Created by yintao on 2019/3/13.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit
import RxSwift

class AgnDetailHomeView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var contentLable: UILabel!

    private let disposeBag = DisposeBag()
    
    let datasource = Variable(AgnDetailInfoModel())
    let contentHeightObser = Variable(CGFloat(0))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView = (Bundle.main.loadNibNamed("AgnDetailHomeView", owner: self, options: nil)?.first as! UIView)
        addSubview(contentView)
        
        contentView.snp.makeConstraints { $0.edges.equalTo(UIEdgeInsets.zero) }
        
        rxBind()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func rxBind() {
        datasource.asDriver()
            .map{ $0.content }
            .drive(onNext: { [weak self] text in
                self?.contentLable.text = text
                self?.contentLable.sizeToFit()
                self?.contentHeightObser.value = self?.contentLable.height ?? 0
            })
            .disposed(by: disposeBag)
    }
}
