//
//  VCServer.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/3/15.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import UIKit

protocol VMNavigation {
    
}

extension VMNavigation {

    static func push(_ ctrl: UIViewController.Type, _ parameters: [String: Any]?) {
        NSObject().visibleViewController?.navigationController?.pushViewController(creatCtrl(ctrl, parameters), animated: true)
    }
    
    private static func creatCtrl(_ ctrl: UIViewController.Type, _ parameters: [String: Any]?) ->UIViewController {
        let fileManager = FileManager.default
        var returnCtrl: UIViewController
        let fileName = NSStringFromClass(ctrl).replacingOccurrences(of: (Bundle.main.projectName + "."), with: "")
        
        if fileManager.dirExists(forFileName: fileName, forType: "nib") {
            returnCtrl = ctrl.init(nibName: fileName, bundle: Bundle.main)
        }else {
            returnCtrl = ctrl.init()
        }
        
        returnCtrl.prepare(parameters: parameters)
        return returnCtrl
    }
    
    static func sbPush(_ sbName: String, _ ctrlID: String, bundle: Bundle = Bundle.main, parameters: [String: Any]? = nil, title: String? = nil) {
        let sb = UIStoryboard.init(name: sbName, bundle: bundle)
        let ctrler = sb.instantiateViewController(withIdentifier: ctrlID)
        ctrler.navigationItem.title = title
        ctrler.prepare(parameters: parameters)
        NSObject().visibleViewController?.navigationController?.pushViewController(ctrler, animated: true)
    }
    
//    static func seguePush(segueID: String, parameters: [String: Any]? = nil, title: String? = nil) {
//
//    }
}

@objc protocol VCServer {
    
    @objc optional func prepare(parameters: [String: Any]?)
    
    /**
     UIViewController 可以重新此方法，设置LoadingView的高度
     */
    @objc optional func loadingViewHeight() ->CGFloat
}

extension UIViewController: VCServer {

    func loadingViewHeight() -> CGFloat { return PPScreenH - 44 - UIApplication.shared.statusBarFrame.height }

    func prepare(parameters: [String : Any]?) { }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

//MARK:
//MARK: 空列表界面UI
extension UIView {
    
    struct RuntimeKey {
        static let emptyContentView = UnsafeRawPointer.init(bitPattern: "EmptyContentViewKey".hashValue)
    }
    
    func presentEmptyDataUI(positionY: CGFloat = 0, hasTabBar: Bool = false) {

        if emptyContentView == nil {
            let h = hasTabBar == true ? height - positionY - LayoutSize.bottomVirtualArea - 49 : height - positionY
            emptyContentView = EmptyDataView.init(frame: .init(x: 0, y: positionY, width: width, height: h))
        }
        
        if emptyContentView?.superview == nil {
            addSubview(emptyContentView!)
            bringSubviewToFront(emptyContentView!)
        }
    }
    
    func dissmisEmptyDataUI() {
        if emptyContentView != nil && emptyContentView?.superview != nil {
            emptyContentView!.removeFromSuperview()
        }
    }
    
    @IBInspectable private var emptyContentView: EmptyDataView? {
        get {
            return objc_getAssociatedObject(self, RuntimeKey.emptyContentView!) as? EmptyDataView
        }
        set {
            objc_setAssociatedObject(self, RuntimeKey.emptyContentView!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func toDeinit() {
        emptyContentView?.removeFromSuperview()
        emptyContentView = nil

        objc_removeAssociatedObjects(self)
    }
}
