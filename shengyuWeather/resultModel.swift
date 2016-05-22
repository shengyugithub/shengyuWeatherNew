//
//  resultModel.swift
//  shengyuWeather
//
//  Created by 盛钰 on 16/5/12.
//  Copyright © 2016年 shengyu. All rights reserved.
//

import Foundation

struct coordInfo{
    var lon = 0.0
    var lat = 0.0
}

struct weatherInfo {
    var id = 0
    var main = ""
    var description = ""
    var icon = ""
}

class weatherModel{
    var coord : coordInfo
    var weather : weatherInfo
    var date : String = ""
    var id: Double = 0.0
    var name: String = ""
    init(){
        coord = coordInfo()
        weather = weatherInfo()
    }
}