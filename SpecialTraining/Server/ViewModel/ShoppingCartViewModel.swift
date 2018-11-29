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
    
    let datasource = Variable([SectionModel<Int ,ShopingModelAdapt>]())
    
    override init() {
        super.init()
        
        let section: SectionModel<Int ,ShopingModelAdapt> = SectionModel.init(model: 0,
                                                                              items: [ShopingNameModel(),
                                                                                      ShoppingListModel(),
                                                                                      ShoppingListModel(),
                                                                                      ShopingNameModel(),
                                                                                      ShoppingListModel()])
        datasource.value = [section]
    }
    
    func cellHeight(indexPath: IndexPath) -> CGFloat {
        let model = datasource.value[0].items[indexPath.row]
        return model.height
    }
}
