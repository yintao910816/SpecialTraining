//
//  UIView+Layer.swift
//  ComicsReader
//
//  Created by 尹涛 on 2018/9/5.
//  Copyright © 2018年 yintao. All rights reserved.
//

import UIKit

extension UIView {
    
    func set(cornerRadius radius: CGFloat,
             borderWidth width: CGFloat = 0,
             borderColor corlor: UIColor = .clear,
             borderCorners corners: UIRectCorner) {

        // 得到view的遮罩路径
        let maskPath = UIBezierPath.init(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: .init(width: radius, height: radius))
        // 创建layer
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.lineWidth = width
        maskLayer.strokeColor = corlor.cgColor
        maskLayer.path = maskPath.cgPath
        
        layer.mask = maskLayer
    }
    
    func creat(cornerRadius radius: CGFloat,
             borderWidth width: CGFloat = 0,
             borderColor corlor: UIColor = .clear,
             borderCorners corners: UIRectCorner) ->CAShapeLayer {
        
        // 得到view的遮罩路径
        let maskPath = UIBezierPath.init(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: .init(width: radius, height: radius))
        // 创建layer
        let maskLayer = CAShapeLayer()
        maskLayer.lineWidth = width
        maskLayer.strokeColor = corlor.cgColor
        maskLayer.path = maskPath.cgPath
        
        layer.mask = maskLayer
        
        return maskLayer
    }
    
    // 绘制view边框虚线
    func drawDashLine(strokeColor: UIColor,
                      lineWidth: CGFloat = 2,
                      lineLength: Int = 4,
                      lineSpacing: Int = 4,
                      corners: UIRectSide) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = bounds
        shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        //每一段虚线长度 和 每两段虚线之间的间隔
        shapeLayer.lineDashPattern = [NSNumber(value: lineLength), NSNumber(value: lineSpacing)]
        let path = CGMutablePath()
        if corners.contains(.left) {
            path.move(to: CGPoint(x: 0, y: bounds.height))
            path.addLine(to: CGPoint(x: 0, y: 0)) }
        if corners.contains(.top){
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: bounds.width, y: 0))
        }
        if corners.contains(.right){
            path.move(to: CGPoint(x: bounds.width, y: 0))
            path.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
        }
        if corners.contains(.bottom){
            path.move(to: CGPoint(x: bounds.width, y: bounds.height))
            path.addLine(to: CGPoint(x: 0, y: bounds.height))
        }
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
    
    // 带圆角的view设置阴影
    func setShadowAndRadius(borderWidth: CGFloat = 0.3, borderColor: UIColor = .groupTableViewBackground) ->CALayer {
        let subLayer = CALayer()
        
        subLayer.backgroundColor = UIColor.white.cgColor
        subLayer.masksToBounds = false
        
        subLayer.shadowColor = UIColor.gray.cgColor
        subLayer.shadowOffset = .init(width: 0, height: 10) // 设置阴影的偏移量
        subLayer.shadowOpacity = 0.5 //不透明度
        subLayer.shadowRadius = 5  //设置阴影所照射的范围
        
        return subLayer
    }
}

public struct UIRectSide : OptionSet {
    
    public let rawValue: Int
    
    public static let left = UIRectSide(rawValue: 1 << 0)
    
    public static let top = UIRectSide(rawValue: 1 << 1)
    
    public static let right = UIRectSide(rawValue: 1 << 2)
    
    public static let bottom = UIRectSide(rawValue: 1 << 3)
    
    public static let all: UIRectSide = [.top, .right, .left, .bottom]
    
    
    
    public init(rawValue: Int) {
        
        self.rawValue = rawValue
        
    }
    
}
