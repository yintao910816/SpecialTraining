//
//  PublishChoseOrganizationViewModel.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/12/10.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import Foundation
import RxSwift

class PublishChoseOrganizationViewModel: BaseViewModel {
    
    var datasource = Variable([ChoseOrganizationModel]())
    
    override init() {
        super.init()
        
        datasource.value = ChoseOrganizationModel.testCreatModels()
    }
}
