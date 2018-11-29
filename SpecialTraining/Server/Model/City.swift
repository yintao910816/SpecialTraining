//
//  City.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/22.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import Foundation

class CityModel: HJModel {
    
    var city: String   = ""
    var letter: String = ""
    
    class func creatModel(city: String, letter: String) ->CityModel {
        let m = CityModel()
        m.city = city
        m.letter = letter
        return m
    }
}
