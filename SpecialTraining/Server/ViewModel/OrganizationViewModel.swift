//
//  OrganizationViewModel.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/23.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import Foundation
import RxSwift

class OrganizationViewModel: BaseViewModel {
    
    // 实体店数据
    var physicalStoreDatasource = Variable([PhysicalStoreModel]())
    // 活动介绍数据
    var activityBrefDatasource = Variable([ActivityBrefModel]())
    // 推荐课程
    var recommendCourseDatasource = Variable([RecommendCourseModel]())
    // 老师风采
    var teachersDatasource = Variable([TeachersModel]())

    override init() {
        super.init()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) { [unowned self] in
            self.physicalStoreDatasource.value   = [PhysicalStoreModel(), PhysicalStoreModel(), PhysicalStoreModel(), PhysicalStoreModel()]
            self.activityBrefDatasource.value    = [ActivityBrefModel(), ActivityBrefModel(), ActivityBrefModel(), ActivityBrefModel()]
            self.recommendCourseDatasource.value    = [RecommendCourseModel(), RecommendCourseModel(), RecommendCourseModel(),
                                                       RecommendCourseModel()]
            self.teachersDatasource.value = [TeachersModel.creatModel(imgW: 120, imgH: 180),
                                             TeachersModel.creatModel(imgW: 100, imgH: 140),
                                             TeachersModel.creatModel(imgW: 120, imgH: 150),
                                             TeachersModel.creatModel(imgW: 120, imgH: 130),
                                             TeachersModel.creatModel(imgW: 114, imgH: 142),
                                             TeachersModel.creatModel(imgW: 200, imgH: 290),
                                             TeachersModel.creatModel(imgW: 90, imgH: 130),
                                             TeachersModel.creatModel(imgW: 130, imgH: 190),
                                             TeachersModel.creatModel(imgW: 160, imgH: 170),
                                             TeachersModel.creatModel(imgW: 120, imgH: 120)]
        }
    }
}
