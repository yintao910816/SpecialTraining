


//
//  STExpericeCourseDetailViewController.swift
//  SpecialTraining
//
//  Created by yintao on 2019/5/11.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class STExpericeCourseDetailViewController: BaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var carouselView: CarouselView!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var priceOutlet: UILabel!
    @IBOutlet weak var contentOutlet: UILabel!
    @IBOutlet weak var contentWidthCns: NSLayoutConstraint!
    @IBOutlet weak var backTopCns: NSLayoutConstraint!
    
    private var viewModel: ExpericeCourseDetailViewModel!
    private var courseId: String = ""
    
    @IBAction func actions(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    override func setupUI() {
backTopCns.constant += LayoutSize.fitTopArea
    }
    
    override func rxBind() {
        viewModel = ExpericeCourseDetailViewModel.init(courseId: courseId)
        
        viewModel.courseInfoObser.asDriver()
            .drive(onNext: { [weak self] data in
                guard let strongSelf = self else { return }
                strongSelf.carouselView.setData(source: PhotoModel.creatPhotoModels(photoList: data.course_info.pic_list))
                strongSelf.titleOutlet.text = data.course_info.title
                strongSelf.priceOutlet.text = "¥: \(data.course_info.about_price)"
                strongSelf.contentOutlet.text = data.course_info.introduce
                strongSelf.contentOutlet.sizeToFit()
                
//                strongSelf.contentWidthCns.constant = strongSelf.scrollView.width - 30
                strongSelf.scrollView.contentSize = .init(width: strongSelf.view.width,
                                                          height: 330.0 + strongSelf.contentOutlet.height)
            })
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
 
    override func prepare(parameters: [String : Any]?) {
        courseId = (parameters!["courseId"] as! String)
    }
}
