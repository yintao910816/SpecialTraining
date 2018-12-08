////
////  UIView+Frame.swift
////  ComicsReader
////
////  Created by 尹涛 on 2018/5/17.
////  Copyright © 2018年 yintao. All rights reserved.
////
//
//import UIKit
//
//extension UIView {
//    
//    public var x: CGFloat {
//        get {
//            return self.frame.origin.x
//        }
//        set {
//            var frame: CGRect = self.frame
//            frame.origin.x = newValue
//            self.frame = frame
//        }
//    }
//    
//    public var y: CGFloat {
//        get {
//            return self.frame.origin.y
//        }
//        set {
//            var frame: CGRect = self.frame
//            frame.origin.y = newValue
//            self.frame = frame
//        }
//    }
//    
//    public var width: CGFloat {
//        get {
//            return self.frame.size.width
//        }
//        set {
//            var frame: CGRect = self.frame
//            frame.size.width = newValue
//            self.frame = frame
//        }
//    }
//    
//    public var height: CGFloat {
//        get {
//            return self.frame.size.height
//        }
//        set {
//            var frame: CGRect = self.frame
//            frame.size.height = newValue
//            self.frame = frame
//        }
//    }
//    
//    public var size: CGSize {
//        get {
//            return self.frame.size
//        }
//        set {
//            var frame: CGRect = self.frame
//            frame.size = newValue
//            self.frame = frame
//        }
//    }
//    
//    public var origin: CGPoint {
//        get {
//            return self.frame.origin
//        }
//        set {
//            var frame: CGRect = self.frame
//            frame.origin = newValue
//            self.frame = frame
//        }
//    }
//    
//    public var centerX: CGFloat {
//        get {
//            return self.center.x
//        }
//        set {
//            var center: CGPoint = self.center
//            center.x = newValue
//            self.center = center
//        }
//    }
//    
//    public var centerY: CGFloat {
//        get {
//            return self.center.y
//        }
//        set {
//            var center: CGPoint = self.center
//            center.y = newValue
//            self.center = center
//        }
//    }
//    
//    
//}
//
