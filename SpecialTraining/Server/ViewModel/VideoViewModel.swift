//
//  VideoViewModel.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/17.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import Foundation
import RxSwift

class VideoViewModel: BaseViewModel {
    // OndemandModel
    let videoClassifationSource = Variable([VideoCateListModel]())
    let videoListSource = Variable([VideoListModel]())

    let classifationChangeObser = PublishSubject<VideoCateListModel>()
    
    private var cateModel = VideoCateListModel()
    
    override init() {
        super.init()
        
        classifationChangeObser.subscribe(onNext: { [unowned self] model in
            self.cateModel = model
            let tempDatas = self.videoClassifationSource.value
            self.videoClassifationSource.value = tempDatas.map({ d -> VideoCateListModel in
                d.isSelected = d.cate_name == model.cate_name ? true : false
                return d
            })
            
            self.requestListData(isSeleted: true)
        })
            .disposed(by: disposeBag)
        
        reloadSubject
            .subscribe(onNext: { [weak self] _ in
                self?.requestListData(isSeleted: false)
            })
            .disposed(by: disposeBag)
    }
    
    func requestListData(isSeleted: Bool) {
        hud.noticeLoading()
        
        STProvider.request(.videoList(cate_id: cateModel.id))
            .map(model: OndemandModel.self)
            .subscribe(onSuccess: { [unowned self] data in
                var cateList = [VideoCateListModel]()
                cateList = data.cate_list
                cateList.insert(VideoCateListModel.creatAllCateModel(), at: 0)
                
                if isSeleted == true {
                    cateList = cateList.map({ m -> VideoCateListModel in
                        m.isSelected = m.id == self.cateModel.id ? true : false
                        return m
                    })
                }else {
                    cateList.first?.isSelected = true
                }
                self.videoClassifationSource.value = cateList
                self.videoListSource.value = data.video_list
                
                self.hud.noticeHidden()
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            }
            .disposed(by: disposeBag)
    }
}
