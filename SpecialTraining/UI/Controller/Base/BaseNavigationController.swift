//
//  BaseNavigationController.swift
//  ComicsReader
//
//  Created by 尹涛 on 2018/5/17.
//  Copyright © 2018年 yintao. All rights reserved.
//

import UIKit
import Foundation

class BaseNavigationController: UINavigationController {

    /**
     * 是否开启右滑返回手势
     */
    var isSideBackEnable: Bool! {
        didSet {
            isSideBackEnable == true ? startSideBack() : stopSideBack()
        }
    }
    
    private func startSideBack() {
        interactivePopGestureRecognizer?.delegate = self
    }
    
    private func stopSideBack() {
        interactivePopGestureRecognizer?.delegate = nil
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        isSideBackEnable = true

//        let frame = CGRect.init(x: 0, y: -(LayoutSize.topVirtualArea + 20), width: PPScreenW, height: (LayoutSize.topVirtualArea + 64))
//        if #available(iOS 11, *) {
//            navigationBar.layer.insertSublayer(STHelper.themeColorLayer(frame: frame), at: 0)
//        }else {
//            navigationBar.layer.insertSublayer(STHelper.themeColorLayer(frame: frame), at: 1)
//        }
        self.navigationBar.barTintColor   =  ST_MAIN_COLOR
        navigationBar.isTranslucent       = false
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor :UIColor.white]
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.children.count > 0
        { // 非根控制器
            viewController.hidesBottomBarWhenPushed = true

            let backButton : UIButton = UIButton(type : .system)
            backButton.setImage(UIImage(named :"navigationButtonReturn")?.withRenderingMode(.alwaysOriginal), for: .normal)
            backButton.setImage(UIImage(named :"navigationButtonReturnClick")?.withRenderingMode(.alwaysOriginal), for: .highlighted)
            backButton.addTarget(self, action :#selector(backAction), for: .touchUpInside)
            backButton.sizeToFit()
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView:backButton)
        }

        super.pushViewController(viewController, animated: animated)
    }
    
    //MARK
    //MARK: action
    @objc func backAction() {
        popViewController(animated: true)
    }
    
    deinit {
        PrintLog("\(self) ---- 已释放")
    }
    
}

extension BaseNavigationController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return (viewControllers.count > 1 && isSideBackEnable)
    }
}
