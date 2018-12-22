//
//  STHomeViewController.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/16.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit
import SnapKit

class STHomeViewController: BaseViewController {

    @IBOutlet weak var scrollOutlet: UIScrollView!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var nearByCourseOutlet: UIButton!
    @IBOutlet weak var expericeOutlet: UIButton!
    @IBOutlet weak var recommnedOrganizationOutlet: UIButton!

    private var recomendColView: HomeRecommendCollectionView!
    private var organizationColView: HomeOrganizationTableView!
    private var expericeColView: HomeExpericeCollectionView!
    
    private let viewModel = HomeViewModel()

    @IBAction func actions(_ sender: UIButton) {
        if sender == nearByCourseOutlet {
            set(button: nearByCourseOutlet, offsetX: 0)
        }else if sender == expericeOutlet {
            set(button: expericeOutlet, offsetX: scrollOutlet.width)
        }else if sender == recommnedOrganizationOutlet {
            set(button: recommnedOrganizationOutlet, offsetX: scrollOutlet.width * 2)
        }
    }
    
    private func set(button: UIButton, offsetX: CGFloat) {
        let btns = [nearByCourseOutlet, expericeOutlet, recommnedOrganizationOutlet]

        if let selectedBtn = btns.first(where: { $0?.isSelected == true }), selectedBtn != nil {
            if selectedBtn != button {
                selectedBtn!.isSelected = false
                selectedBtn!.backgroundColor = RGB(242, 242, 242)

                button.isSelected = true
                button.backgroundColor = ST_MAIN_COLOR_DARK
                scrollOutlet.setContentOffset(.init(x: offsetX, y: 0), animated: true)
            }
        }else {
            button.isSelected = true
            button.backgroundColor = ST_MAIN_COLOR_DARK
            scrollOutlet.setContentOffset(.init(x: offsetX, y: 0), animated: true)
        }
    }
    
    private func set(scroll offsetX: CGFloat) {
        let idx = Int(offsetX / scrollOutlet.width)
        let btns = [nearByCourseOutlet, expericeOutlet, recommnedOrganizationOutlet]
        let curBtn = btns[idx]!
        
        if let selectedBtn = btns.first(where: { $0?.isSelected == true }),
            selectedBtn != nil {
            if selectedBtn != curBtn {
                selectedBtn!.isSelected = false
                selectedBtn!.backgroundColor = RGB(242, 242, 242)
                
                curBtn.isSelected = true
                curBtn.backgroundColor = ST_MAIN_COLOR_DARK
            }
        }else {
            curBtn.isSelected = true
            curBtn.backgroundColor = ST_MAIN_COLOR_DARK
        }
    }

    override func setupUI() {
        set(button: nearByCourseOutlet, offsetX: 0)

        addBarItem(normal: "nav_map_icon", right: true).asDriver()
            .drive(onNext: { [unowned self] in
                self.performSegue(withIdentifier: "mapSegue", sender: nil)
            })
            .disposed(by: disposeBag)
        
        scrollOutlet.contentSize = .init(width: 3*PPScreenW, height: scrollOutlet.height)

        recomendColView = HomeRecommendCollectionView()
        organizationColView = HomeOrganizationTableView()
        expericeColView = HomeExpericeCollectionView()
        
        scrollOutlet.addSubview(recomendColView)
        scrollOutlet.addSubview(organizationColView)
        scrollOutlet.addSubview(expericeColView)

        recomendColView.snp.makeConstraints{
            $0.left.equalTo(scrollOutlet.snp.left)
            $0.top.equalTo(scrollOutlet.snp.top)
            $0.height.equalTo(scrollOutlet.snp.height)
            $0.width.equalTo(PPScreenW)
        }
        
        expericeColView.snp.makeConstraints{
            $0.left.equalTo(scrollOutlet.snp.left).offset(PPScreenW)
            $0.top.equalTo(scrollOutlet.snp.top)
            $0.height.equalTo(scrollOutlet.snp.height)
            $0.width.equalTo(PPScreenW)
        }
        
        organizationColView.snp.makeConstraints{
            $0.left.equalTo(scrollOutlet.snp.left).offset(2*PPScreenW)
            $0.top.equalTo(scrollOutlet.snp.top)
            $0.height.equalTo(scrollOutlet.snp.height)
            $0.width.equalTo(PPScreenW)
        }
        
        if #available(iOS 11, *) {
            scrollOutlet.contentInsetAdjustmentBehavior = .never
            organizationColView.contentInsetAdjustmentBehavior = .never
            recomendColView.contentInsetAdjustmentBehavior = .never
        }else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    override func rxBind() {
        viewModel.navigationItemTitle.asDriver()
            .drive(onNext: { [unowned self] (ret, title) in
                PrintLog(title)
                self.navigationItem.leftBarButtonItem?.title = title
            })
            .disposed(by: disposeBag)

        viewModel.nearByCourseSourse.asDriver()
            .drive(recomendColView.datasource)
            .disposed(by: disposeBag)
        
        viewModel.expericeDatasource.asDriver()
            .drive(expericeColView.datasource)
            .disposed(by: disposeBag)

        viewModel.nearByOrgnazitionSource.asDriver()
            .drive(organizationColView.datasource)
            .disposed(by: disposeBag)
        
        organizationColView.cellSelected
            .subscribe(onNext: { [unowned self] model in
                self.performSegue(withIdentifier: "organizationSegue", sender: model.agn_id)
            })
            .disposed(by: disposeBag)
        
        recomendColView.rx.modelSelected(NearByCourseItemModel.self)
            .subscribe(onNext: { [unowned self] model in
                self.performSegue(withIdentifier: "courseDetailSegue", sender: nil)
            })
            .disposed(by: disposeBag)
        
        expericeColView.rx.modelSelected(ExperienceCourseItemModel.self)
            .subscribe(onNext: { [unowned self] model in
                self.performSegue(withIdentifier: "courseDetailSegue", sender: nil)
            })
            .disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "organizationSegue" {
            let ctrl = segue.destination as! STOrganizationViewController
            ctrl.prepare(parameters: ["agn_id": sender as! String])
        }
    }
    
}

extension STHomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        set(scroll: scrollOutlet.contentOffset.x)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            set(scroll: scrollOutlet.contentOffset.x)
        }
    }

}
