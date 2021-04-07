//
//  Forecast.swift
//  StewartWeather
//
//  Created by Terry Kuo on 2021/3/26.
//

import Foundation

struct WeatherData: Decodable {
    var daily: [Daily]
}



struct Daily: Decodable {
    var dt: Date
    var temp: Temp
    var humidity: Int
    var weather: [Weather]
    var clouds: Int
    var pop: Double
}

struct Temp: Decodable {
    var day: Double
    var min: Double
    var max: Double
}


struct Weather: Codable{
    var id: Int
    var main: String
    var description: String
    var icon: String
}
