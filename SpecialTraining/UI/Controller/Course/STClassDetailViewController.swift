//
//  STClassDetailViewController.swift
//  SpecialTraining
//
//  Created by yintao on 2019/4/25.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit
import RxDataSources

class STClassDetailViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var iconOutlet: UIButton!
    @IBOutlet weak var classNameOutlet: UILabel!
    @IBOutlet weak var classTimeOutlet: UILabel!
    @IBOutlet weak var priceOutlet: UILabel!
    @IBOutlet weak var addressOutlet: UILabel!
    @IBOutlet weak var shopNameOutlet: UILabel!
    
    private var viewModel: ClassDetailViewModel!
    
    private var classId: String = ""
    private var shopId: String  = ""
    
    override func setupUI() {
        iconOutlet.imageView?.contentMode = .scaleAspectFill
        
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.register(UINib.init(nibName: "TeacherLessionsCell", bundle: Bundle.main),
                           forCellReuseIdentifier: "TeacherLessionsCellID")
    }
    
    override func rxBind() {
        viewModel = ClassDetailViewModel.init(classId: classId, shopId: shopId)
        
        viewModel.lessonListObser.asDriver()
            .drive(tableView.rx.items(cellIdentifier: "TeacherLessionsCellID",
                                      cellType: TeacherLessionsCell.self))
            { _, model, cell in
                cell.model = model
            }
            .disposed(by: disposeBag)
        
        viewModel.classInfoObser.asDriver()
            .drive(onNext: { [weak self] data in
                self?.setClassInfoView(data: data)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }

    private func setClassInfoView(data: (ClassInfoModel, ShopInfoModel)) {
        iconOutlet.setImage(data.0.pic)
        classNameOutlet.text = data.0.class_name
        classTimeOutlet.text = "上课时间:\n\(data.0.describe)"
        priceOutlet.text = "¥:\(data.0.price)"
        addressOutlet.text = data.1.address
        shopNameOutlet.text = data.1.shop_name
    }
    
    override func prepare(parameters: [String : Any]?) {
        classId = (parameters!["classId"] as! String)
        shopId  = (parameters!["shopId"] as! String)
    }
    
}

extension STClassDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.lessonListObser.value[indexPath.row].cellHeight
    }
}
