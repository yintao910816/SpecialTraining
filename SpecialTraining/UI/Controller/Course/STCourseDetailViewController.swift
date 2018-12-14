//
//  STCourseDetailViewController.swift
//  SpecialTraining
//
//  Created by yintao on 2018/12/14.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class STCourseDetailViewController: BaseViewController {

    private var viewModel: CourseDetailViewModel!
    
    private var splendidnessContentTB: SplendidnessContentTableView!
    
    @IBOutlet weak var scrollOutlet: UIScrollView!
    
    @IBOutlet weak var conentOutlet: UIButton!
    @IBOutlet weak var courseTimeOutlet: UIButton!
    @IBOutlet weak var courseAudioOutlet: UIButton!
    @IBOutlet weak var courseSchoolOutlet: UIButton!
    
    @IBAction func actions(_ sender: UIButton) {

        if sender == conentOutlet {
            set(button: conentOutlet, offsetX: 0)
        }else if sender == courseTimeOutlet {
            set(button: courseTimeOutlet, offsetX: scrollOutlet.width)
        }else if sender == courseAudioOutlet {
            set(button: courseAudioOutlet, offsetX: scrollOutlet.width * 2)
        }else if sender == courseSchoolOutlet {
            set(button: courseSchoolOutlet, offsetX: scrollOutlet.width * 3)
        }

    }
    
    private func set(button: UIButton, offsetX: CGFloat) {
        let btns = [conentOutlet, courseTimeOutlet, courseAudioOutlet, courseSchoolOutlet]
        
        if let selectedBtn = btns.first(where: { $0?.isSelected == true }), selectedBtn != nil {
            if selectedBtn != button {
                selectedBtn!.isSelected = false
                selectedBtn!.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                
                button.isSelected = true
                button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
                scrollOutlet.setContentOffset(.init(x: offsetX, y: 0), animated: true)
            }
        }else {
            button.isSelected = true
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            scrollOutlet.setContentOffset(.init(x: offsetX, y: 0), animated: true)
        }
    }
    
    private func set(scroll offsetX: CGFloat) {
        let idx = Int(offsetX / scrollOutlet.width)
        let btns = [conentOutlet, courseTimeOutlet, courseAudioOutlet, courseSchoolOutlet]
        let curBtn = btns[idx]!
        
        if let selectedBtn = btns.first(where: { $0?.isSelected == true }),
            selectedBtn != nil {
            if selectedBtn != curBtn {
                selectedBtn!.isSelected = false
                selectedBtn!.titleLabel?.font = UIFont.systemFont(ofSize: 14)

                curBtn.isSelected = true
                curBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            }
        }else {
            curBtn.isSelected = true
            curBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        }
    }

    override func setupUI() {
        navigationItem.title = "课程详情"
        
        set(button: conentOutlet, offsetX: 0)
        
        scrollOutlet.contentSize = .init(width: 4*PPScreenW, height: scrollOutlet.height)
        
        splendidnessContentTB = SplendidnessContentTableView()
        
        scrollOutlet.addSubview(splendidnessContentTB)
        
        splendidnessContentTB.snp.makeConstraints{
            $0.left.equalTo(scrollOutlet.snp.left)
            $0.top.equalTo(scrollOutlet.snp.top)
            $0.height.equalTo(scrollOutlet.snp.height)
            $0.width.equalTo(PPScreenW)
        }
        
//        expericeColView.snp.makeConstraints{
//            $0.left.equalTo(scrollOutlet.snp.left).offset(PPScreenW)
//            $0.top.equalTo(scrollOutlet.snp.top)
//            $0.height.equalTo(scrollOutlet.snp.height)
//            $0.width.equalTo(PPScreenW)
//        }
//
//        organizationColView.snp.makeConstraints{
//            $0.left.equalTo(scrollOutlet.snp.left).offset(2*PPScreenW)
//            $0.top.equalTo(scrollOutlet.snp.top)
//            $0.height.equalTo(scrollOutlet.snp.height)
//            $0.width.equalTo(PPScreenW)
//        }
        
//        if #available(iOS 11, *) {
//            scrollOutlet.contentInsetAdjustmentBehavior = .never
//            organizationColView.contentInsetAdjustmentBehavior = .never
//            recomendColView.contentInsetAdjustmentBehavior = .never
//        }else {
//            automaticallyAdjustsScrollViewInsets = false
//        }

    }
    
    override func rxBind() {
        viewModel = CourseDetailViewModel()
        
        viewModel.splendidnessContentSource
            .asDriver()
            .drive(splendidnessContentTB.datasource)
            .disposed(by: disposeBag)
        
    }
}

extension STCourseDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        set(scroll: scrollOutlet.contentOffset.x)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            set(scroll: scrollOutlet.contentOffset.x)
        }
    }
    
}

