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
    
    private var recomendColView: HomeRecommendCollectionView!
    private var organizationColView: HomeOrganizationTableView!
    
    private let viewModel = HomeViewModel()

    @IBAction func actions(_ sender: UIButton) {
        switch sender.tag {
        case 500:
            if scrollOutlet.contentOffset.x != 0 {
                scrollOutlet.setContentOffset(.init(x: 0, y: 0), animated: true)
                (topView.viewWithTag(500) as! UIButton).isSelected = true
                (topView.viewWithTag(501) as! UIButton).isSelected = false
            }
        case 501:
            if scrollOutlet.contentOffset.x == 0 {
                scrollOutlet.setContentOffset(.init(x: scrollOutlet.width, y: 0), animated: true)
                (topView.viewWithTag(500) as! UIButton).isSelected = false
                (topView.viewWithTag(501) as! UIButton).isSelected = true
            }
        default:
            break
        }
    }
    
    override func setupUI() {
        
        addBarItem(normal: "nav_map_icon", right: true).asDriver()
            .drive(onNext: { [unowned self] in
                self.performSegue(withIdentifier: "mapSegue", sender: nil)
            })
            .disposed(by: disposeBag)
        
        scrollOutlet.contentSize = .init(width: 2*PPScreenW, height: scrollOutlet.height)

        recomendColView = HomeRecommendCollectionView()
        organizationColView = HomeOrganizationTableView()
        
        scrollOutlet.addSubview(recomendColView)
        scrollOutlet.addSubview(organizationColView)
        
        recomendColView.snp.makeConstraints{
            $0.left.equalTo(scrollOutlet.snp.left)
            $0.top.equalTo(scrollOutlet.snp.top)
            $0.height.equalTo(scrollOutlet.snp.height)
            $0.width.equalTo(PPScreenW)
        }
        
        organizationColView.snp.makeConstraints{
            $0.left.equalTo(recomendColView.snp.right)
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
        viewModel.colDatasource.asDriver()
            .drive(recomendColView.datasource)
            .disposed(by: disposeBag)
        
        viewModel.tabviewDatasource.asDriver()
            .drive(organizationColView.datasource)
            .disposed(by: disposeBag)
        
        viewModel.navigationItemTitle.asDriver()
            .drive(onNext: { [unowned self] (ret, title) in
                PrintLog(title)
                self.navigationItem.leftBarButtonItem?.title = title
            })
            .disposed(by: disposeBag)
        
        organizationColView.cellSelected
            .subscribe(onNext: { [unowned self] model in
                self.performSegue(withIdentifier: "organizationSegue", sender: nil)
            })
            .disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "organizationSegue" {
//            let ctrl = segue.destination as! STOrganizationViewController
        }
    }
    
}

extension STHomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let flag = scrollOutlet.contentOffset.x == 0
        (topView.viewWithTag(500) as! UIButton).isSelected = flag
        (topView.viewWithTag(501) as! UIButton).isSelected = !flag
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            let flag = scrollOutlet.contentOffset.x == 0
            (topView.viewWithTag(500) as! UIButton).isSelected = flag
            (topView.viewWithTag(501) as! UIButton).isSelected = !flag
        }
    }

}
