//
//  STShoppingCartViewController.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/16.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class STShoppingCartViewController: BaseViewController {

    @IBOutlet weak var bgColorView: UIView!
    @IBOutlet weak var headerContentView: UIView!
    @IBOutlet weak var titleTopCns: NSLayoutConstraint!
    @IBOutlet weak var bgColorHeightCNs: NSLayoutConstraint!
    @IBOutlet weak var jiesuanOutlet: UIButton!
    
    @IBOutlet weak var tableView: BaseTB!
    
    private var viewModel: ShoppingCartViewModel!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupUI() {
        headerContentView.set(cornerRadius: 8, borderCorners: [.topLeft, .topRight])
        
        if UIDevice.current.isX == true {
            titleTopCns.constant = titleTopCns.constant + 44
            bgColorHeightCNs.constant = bgColorHeightCNs.constant + 44
        }
        
        var frame = CGRect.init(x: 0, y: 0, width: PPScreenW, height: bgColorHeightCNs.constant)
        bgColorView.layer.insertSublayer(STHelper.themeColorLayer(frame: frame), at: 0)
        
        frame = .init(x: 0, y: 0, width: 85, height: 45)
        jiesuanOutlet.layer.insertSublayer(STHelper.themeColorLayer(frame: frame), at: 0)
        
        tableView.register(UINib.init(nibName: "ShoppingNameCell", bundle: Bundle.main), forCellReuseIdentifier: "ShoppingNameCellID")
        tableView.register(UINib.init(nibName: "ShoppingListCell", bundle: Bundle.main), forCellReuseIdentifier: "ShoppingListCellID")
    }
    
    override func rxBind() {
        viewModel = ShoppingCartViewModel()

        let datasource = RxTableViewSectionedReloadDataSource<SectionModel<Int, ShopingModelAdapt>>.init(configureCell: { (_, tb, indexPath, model) -> UITableViewCell in
            if model.isShopping == true {
                let cell = tb.dequeueReusableCell(withIdentifier: "ShoppingListCellID") as! ShoppingListCell
                return cell
            }
            let cell = tb.dequeueReusableCell(withIdentifier: "ShoppingNameCellID") as! ShoppingNameCell
            return cell
        })

        viewModel.datasource.asDriver()
            .drive(tableView.rx.items(dataSource: datasource))
            .disposed(by: disposeBag)
     
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
}

extension STShoppingCartViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.cellHeight(indexPath: indexPath)
    }
}
