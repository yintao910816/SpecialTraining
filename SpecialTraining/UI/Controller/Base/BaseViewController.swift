//
//  BaseViewController.swift
//  ComicsReader
//
//  Created by 尹涛 on 2018/5/16.
//  Copyright © 2018年 yintao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BaseViewController: UIViewController {

    lazy var disposeBag: DisposeBag = { return DisposeBag() }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        rxBind()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UIApplication.shared.statusBarStyle != .lightContent {
            UIApplication.shared.statusBarStyle = .lightContent
        }

        if UIApplication.shared.isStatusBarHidden == true {
            UIApplication.shared.isStatusBarHidden = false
        }
        navigationController?.setNavigationBarHidden(false, animated: animated)
        let imageView = findHarilineImageViewUnder(view: (self.navigationController?.navigationBar)!)
        imageView.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if navigationController?.viewControllers.contains(self) == false {
            toDeinit()
            view.toDeinit()
        }
    }
    
    func findHarilineImageViewUnder(view: UIView) -> UIImageView {
        if view.isKind(of: UIImageView.self) && view.bounds.height <= 1.0{
            return view as! UIImageView
        } else {
            for subview in view.subviews {
                let imageView = self.findHarilineImageViewUnder(view: subview)
                
                return imageView
                
            }
        }
        return UIImageView()
    }

    deinit {
        PrintLog("\(self) ---- 已释放")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
