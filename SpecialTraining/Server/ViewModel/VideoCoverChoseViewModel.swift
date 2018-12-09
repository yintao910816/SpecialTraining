//
//  VideoCoverChoseViewModel.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/12/9.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import Foundation
import RxSwift

class VideoCoverChoseViewModel: BaseViewModel {
    
    var datasource = Variable([UIImage]())
    
    init(datas: [UIImage]) {
        super.init()
        
        datasource.value = datas
    }
}
