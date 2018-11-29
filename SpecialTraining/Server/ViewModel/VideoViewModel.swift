//
//  VideoViewModel.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/17.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import Foundation
import RxSwift

class VideoViewModel: RefreshVM<OndemandModel> {
    
    let videoClassifationSource = Variable([VideoClassificationModel]())
    
    let classifationChangeObser = PublishSubject<VideoClassificationModel>()
    
    override init() {
        super.init()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.videoClassifationSource.value = [VideoClassificationModel.creatModel(title: "全部", selected: true),
                                                  VideoClassificationModel.creatModel(title: "关注"),
                                                  VideoClassificationModel.creatModel(title: "音乐"),
                                                  VideoClassificationModel.creatModel(title: "乐器")]
            
            self.datasource.value = [OndemandModel.creatModel(w: 120, h: 180),
                                     OndemandModel.creatModel(w: 100, h: 140),
                                     OndemandModel.creatModel(w: 120, h: 150),
                                     OndemandModel.creatModel(w: 120, h: 130),
                                     OndemandModel.creatModel(w: 114, h: 142),
                                     OndemandModel.creatModel(w: 200, h: 290),
                                     OndemandModel.creatModel(w: 90, h: 130),
                                     OndemandModel.creatModel(w: 130, h: 190),
                                     OndemandModel.creatModel(w: 160, h: 170),
                                     OndemandModel.creatModel(w: 120, h: 120)
            ]
        }
        
        classifationChangeObser.subscribe(onNext: { [unowned self] model in
            let tempDatas = self.videoClassifationSource.value
            self.videoClassifationSource.value = tempDatas.map({ d -> VideoClassificationModel in
                d.isSelected = d.title == model.title ? true : false
                return d
            })
        })
            .disposed(by: disposeBag)
    }
    
    
}
