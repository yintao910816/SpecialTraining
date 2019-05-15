


//
//  STAddFriendsViewController.swift
//  SpecialTraining
//
//  Created by yintao on 2019/5/15.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class STAddFriendsViewController: BaseViewController {

    @IBOutlet weak var searcOutlet: UITextField!

    private var viewModel: AddFriendsViewModel!
    
    override func setupUI() {
        
    }
    
    override func rxBind() {
        
        viewModel = AddFriendsViewModel.init(searchTap: addBarItem(title: "查找"), searchText: searcOutlet.rx.text.orEmpty.asDriver())
    }
}
