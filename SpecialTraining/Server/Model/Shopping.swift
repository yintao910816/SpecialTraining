//
//  Shopping.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/17.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class ShopingNameModel: HJModel, ShopingModelAdapt {
    
    var height: CGFloat {
        get {
            return 50.0
        }
    }
    
    var isShopping: Bool {
        get {
            return false
        }
    }
}

class ShoppingListModel: HJModel, ShopingModelAdapt {
    
    var height: CGFloat {
        get {
            return 110.0
        }
    }
    
    var isShopping: Bool {
        get {
            return true
        }
    }

}

protocol ShopingModelAdapt {
    
    var height: CGFloat { get }
    
    var isShopping: Bool { get }
}
