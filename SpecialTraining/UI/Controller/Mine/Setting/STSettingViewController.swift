//
//  STSettingViewController.swift
//  SpecialTraining
//
//  Created by yintao on 2019/3/1.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit
import RxDataSources

class STSettingViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: SettingViewModel!
    
    override func setupUI() {
        navigationItem.title = "设置"
        
        tableView.rowHeight = 50
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
    }
    
    override func rxBind() {
        viewModel = SettingViewModel()
        
        viewModel.pushNoticeSettingSubject
            .subscribe(onNext: { [unowned self] in
                self.performSegue(withIdentifier: "noticeSettingSegue", sender: nil)
            })
            .disposed(by: disposeBag)
        
        viewModel.pushUseTipsSubject
            .subscribe(onNext: { [unowned self] in
                self.performSegue(withIdentifier: "useTipsSegue", sender: nil)
            })
            .disposed(by: disposeBag)

        let datasource = RxTableViewSectionedReloadDataSource<SectionModel<Int, String>>.init(configureCell: { _, tb, indexPath, title in
            let cell = tb.dequeueReusableCell(withIdentifier: "cellID")!
            cell.backgroundColor = .white
            cell.textLabel?.text = title
            cell.selectionStyle = .none
            cell.accessoryType  = .disclosureIndicator
            return cell
        })
        
        viewModel.datasource.asDriver()
            .drive(tableView.rx.items(dataSource: datasource))
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(String.self)
            .asDriver()
            .drive(viewModel.cellDidSelected)
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)

        viewModel.reloadSubject.onNext(Void())
    }

}

extension STSettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear//RGB(245, 245, 245)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12
    }
}
