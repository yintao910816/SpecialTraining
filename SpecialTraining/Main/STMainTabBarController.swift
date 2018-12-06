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
        
        let selectedImages = ["", "video_selected", "chat_selected", "shoppingcar_selected", "mine_selected"]
        let unselectedImages = ["", "video_unselected", "chat_unselected", "shoppingcar_unselected", "mine_unselected"]

        let titles = ["优培训", "直播/点播", "消息", "购物车", "我的"]
        
        var instantiateCtrls = [MainNavigationController]()

        for idx in 0..<sbNames.count {
            var rootNav = UIStoryboard.init(name: sbNames[idx], bundle: Bundle.main).instantiateViewController(withIdentifier: rootCtrlIds[idx]) as! MainNavigationController
            setTabBarItem(nav: &rootNav, title: titles[idx], imageName: unselectedImages[idx], selectImageName: selectedImages[idx])
            instantiateCtrls.append(rootNav)
        }
        
        viewControllers = instantiateCtrls
    }
    
    private func setTabBarItem(nav: inout MainNavigationController, title: String, imageName: String, selectImageName: String){
        let image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
        let selectImage = UIImage(named: selectImageName)?.withRenderingMode(.alwaysOriginal)
        
        nav.viewControllers.first?.tabBarItem.title = title
        nav.viewControllers.first?.tabBarItem = UITabBarItem (title: title , image:image ,selectedImage : selectImage)
    }

    
}
