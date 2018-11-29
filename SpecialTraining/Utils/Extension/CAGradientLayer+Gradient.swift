//
//  CAGradientLayer+Gradient.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/17.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

extension CAGradientLayer {
   
    class func gradient(colors: [CGColor], locations: [NSNumber]) ->CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = colors
        gradientLayer.locations = locations
        
        // 横向渐变
        gradientLayer.startPoint = .init(x: 0, y: 0)
        gradientLayer.endPoint   = .init(x: 1, y: 0)
        
        return gradientLayer
    }
}


