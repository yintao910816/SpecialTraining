//
//  STMainTabBarController.swift
//  SpecialTraining
//
//  Created by sw on 03/12/2018.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class STMainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        loadSBUserInterface()
    }
    
    private func loadSBUserInterface(){
        let sbNames = ["STHome", "STVideo", "STMessage", "STShopping", "STMine"]
        let rootCtrlIds = ["homeRootVC", "videoRootVC", "messageRootVC", "shoppingRootVC", "mineRootVC"]
        var instantiateCtrls = [UIViewController]()

        for idx in 0..<sbNames.count {
            let homeRootController = UIStoryboard.init(name: sbNames[idx], bundle: Bundle.main).instantiateViewController(withIdentifier: rootCtrlIds[idx])
            instantiateCtrls.append(homeRootController)
        }
        
        viewControllers = instantiateCtrls
    }
    
}
