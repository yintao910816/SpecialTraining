//
//  STClassLessionListViewController.swift
//  SpecialTraining
//
//  Created by yintao on 2019/6/12.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit
import RxDataSources

class STClassLessionListViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: ClassLessionListViewModel!
    var lessionList: [ClassListModel] = []
    
    override func setupUI() {
        tableView.rowHeight = 87
        tableView.register(UINib.init(nibName: "TeacherLessionsCell", bundle: Bundle.main),
                           forCellReuseIdentifier: "TeacherLessionsCellID")
    }
    
    override func rxBind() {
        viewModel = ClassLessionListViewModel.init(lessionData: lessionList)
        
        viewModel.datasource.asDriver()
            .drive(tableView.rx.items(cellIdentifier: "TeacherLessionsCellID", cellType: TeacherLessionsCell.self)) {
                _, model, cell in
                cell.model = model
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(ClassListModel.self)
        .asDriver()
            .drive(onNext: { [weak self] model in
                let webVC = BaseWebViewController()
                webVC.url = APIAssistance.lessionDetailH5URL(id: model.lesson_id)
                self?.navigationController?.pushViewController(webVC, animated: true)
            })
        .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
    
    override func prepare(parameters: [String : Any]?) {
        if let data = parameters?["data"] as? [ClassListModel] {
            lessionList = data
        }
    }
}
