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
    
    @IBOutlet weak var buyOutlet: UIButton!
    @IBOutlet weak var addShoppingCarOutlet: UIButton!

    private var viewModel: ClassDetailViewModel!
    
    private var classId: String = ""
    private var shopId: String  = ""
    
    @IBAction func actions(_ sender: UIButton) {
        if sender.tag == 200 {
            // 客服
            NoticesCenter.alert(message: "功能暂未开放，客服系统正在努力完善中...")
        }else if sender.tag == 201 {
            // 电话
            let mob = viewModel.classInfoObser.value.1.mob
            if mob.count > 0 {
                STHelper.phoneCall(with: mob)
            }
        }else if sender.tag == 202 {
            // 加入购物车
            viewModel.insertShoppingCar.onNext(Void())
        }else if sender.tag == 203 {
            // 购买
            viewModel.buySubject.onNext(Void())
        }
    }
    
    override func setupUI() {
        addShoppingCarOutlet.set(cornerRadius: 15, borderCorners: [.topLeft, .bottomLeft])
        buyOutlet.set(cornerRadius: 15, borderCorners: [.topRight, .bottomRight])

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

    private func setClassInfoView(data: (CourseDetailClassModel, ShopInfoModel)) {
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
