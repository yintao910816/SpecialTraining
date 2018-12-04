//
//  UserVideosViewModel.swift
//  SpecialTraining
//
//  Created by sw on 04/12/2018.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import Foundation
import RxSwift

class UserVideosViewModel: BaseViewModel {
    
    var userVidesDatasource = Variable([UserVideosModel]())
    
    override init() {
        super.init()
        
        var tempDatas = [UserVideosModel]()
        for _ in 0..<20 {
            tempDatas.append(UserVideosModel())
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) { [unowned self] in
            self.userVidesDatasource.value = tempDatas
        }
    }
}
