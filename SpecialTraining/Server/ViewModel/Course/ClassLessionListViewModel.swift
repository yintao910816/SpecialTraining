//
//  ClassLessionListViewModel.swift
//  SpecialTraining
//
//  Created by yintao on 2019/6/12.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import Foundation

class ClassLessionListViewModel: RefreshVM<ClassListModel> {
    
    init(lessionData: [ClassListModel]) {
        super.init()
        
        reloadSubject
            .subscribe(onNext: { [unowned self] in
                self.datasource.value = lessionData
            })
            .disposed(by: disposeBag)
    }
}
