//
//  UseTipsViewModel.swift
//  SpecialTraining
//
//  Created by yintao on 2019/3/1.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import Foundation
import RxSwift

class UseTipsViewModel: BaseViewModel {
    
    let datasource = Variable([UseTipsModel]())
    let cellDidSelected = PublishSubject<IndexPath>()
    
    override init() {
        super.init()
        
        reloadSubject.subscribe(onNext: { [weak self] in
            self?.datasource.value = UseTipsModel.creatData()
        })
            .disposed(by: disposeBag)
        
        cellDidSelected
            .subscribe(onNext: { _ in })
            .disposed(by: disposeBag)
    }
}

class UseTipsModel {
    var title: String = ""
    var segue: String = ""
    
    class func creatData() ->[UseTipsModel] {
        let titles = ["如何查看自己购买成功的课程", "如何查看自己购买成功的课程", "如何查看自己购买成功的课程", "如何查看自己购买成功的课程"]
        var datas = [UseTipsModel]()
        for idx in 0..<titles.count {
            let model = UseTipsModel()
            model.title = titles[idx]
            datas.append(model)
        }
        return datas
    }
}
