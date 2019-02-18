//
//  ChoseClassificationViewModel.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/12/10.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import Foundation
import RxSwift

class ChoseClassificationViewModel: BaseViewModel {
    
    var datasource = Variable([ChoseClassificationModel]())
    
    override init() {
        super.init()
        
        datasource.value = ChoseClassificationModel.testCreatModels()
    }
    
    func appendClassifications() ->String {
        var classifications = ""
        let selected = datasource.value.filter{ $0.isSelected == true }
        for item in selected {
            if classifications.count == 0 {
                classifications = item.name
            }else {
                classifications = classifications.appending(",\(item.name)")
            }
        }
        return classifications
    }
}
