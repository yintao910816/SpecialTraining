//
//  ShoppingCartViewModel.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/17.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

class ShoppingCartViewModel: BaseViewModel {
    
    let datasource = Variable([SectionModel<Int ,ShoppingListModel>]())
    
    override init() {
        super.init()
        
        let section = [SectionModel.init(model: 0,
                                         items: [ShoppingListModel(),
                                                 ShoppingListModel(),
                                                 ShoppingListModel(),
                                                 ShoppingListModel(),
                                                 ShoppingListModel.init(isLastRow: true)]),
                       SectionModel.init(model: 1,
                                         items: [ShoppingListModel(),
                                                 ShoppingListModel(),
                                                 ShoppingListModel(),
                                                 ShoppingListModel(),
                                                 ShoppingListModel.init(isLastRow: true)]),
                       SectionModel.init(model: 2,
                                         items: [ShoppingListModel(),
                                                 ShoppingListModel(),
                                                 ShoppingListModel(),
                                                 ShoppingListModel(),
                                                 ShoppingListModel.init(isLastRow: true)])]
        datasource.value = section
    }
    
    func cellHeight(indexPath: IndexPath) -> CGFloat {
        let model = datasource.value[0].items[indexPath.row]
        return model.height
    }
}
