//
//  SelectedCityViewModel.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/22.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import Foundation
import RxDataSources

class SelectedCityViewModel: RefreshVM<SectionModel<Int, CityModel>> {
    
    var sectionIndexTitles = [String]()
    
    override init() {
        super.init()
        
        sectionIndexTitles = ["J", "J", "J"]
        datasource.value = [SectionModel.init(model: 0, items: [CityModel.creatModel(city: "荆州市", letter: "J")]),
                            SectionModel.init(model: 0, items: [CityModel.creatModel(city: "荆州市", letter: "J")]),
                            SectionModel.init(model: 0, items: [CityModel.creatModel(city: "荆州市", letter: "J")])]
    }
}
