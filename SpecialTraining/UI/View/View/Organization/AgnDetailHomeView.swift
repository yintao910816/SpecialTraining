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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentLable: UILabel!
    @IBOutlet weak var bottomCoverOutlet: UIImageView!
    @IBOutlet weak var topCoverOutlet: UIImageView!

    private let disposeBag = DisposeBag()
    
    let datasource = Variable(ShopDetailModel())
    
    @IBAction func actions(_ sender: UIButton) {
    }
    
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
            .drive(onNext: { [weak self] model in self?.setContent(model: model) })
            .disposed(by: disposeBag)
    }
    
    private func setContent(model: ShopDetailModel) {
        contentLable.text = model.content
        contentLable.sizeToFit()
        
        if model.picList.count >= 2 {
            bottomCoverOutlet.setImage(model.picList.first)
            topCoverOutlet.setImage(model.picList[1])
        }else if model.picList.count > 0 {
            bottomCoverOutlet.setImage(model.picList.first)
        }

        scrollView.contentSize = .init(width: width, height: 175 + contentLable.height)
    }
}
