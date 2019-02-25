//
//  SearchViewModel.swift
//  SpecialTraining
//
//  Created by yintao on 2019/2/25.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class SearchViewModel: BaseViewModel {

    enum CellType {
        case none
        case searchType
        case course
        case organization
    }
    
    var datasource = Variable([SectionModel<Int, SearchDataAdapt>]())
    var cellType: CellType = .none
 
    init(input: Driver<String>) {
        super.init()
        
        input.map{ [weak self] text ->[SectionModel<Int, SearchDataAdapt>] in
            if text.count > 0 {
                self?.cellType = .searchType
                var data = [SectionModel<Int, SearchDataAdapt>]()
                data.append(SectionModel.init(model: 0, items: SearchTypeModel.creatModel(cellTitle: text)))
                return data
            }
            self?.cellType = .none
            return [SectionModel<Int, SearchDataAdapt>]()
            }
            .drive(datasource)
            .disposed(by: disposeBag)
    }
}
