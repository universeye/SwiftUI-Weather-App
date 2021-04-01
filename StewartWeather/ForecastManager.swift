//
//  ForecastManager.swift
//  StewartWeather
//
//  Created by Terry Kuo on 2021/4/1.
//

import Foundation

struct ForecastManager: Identifiable {
    var id = UUID()
    
    //var date = String
    var high: Int
    var low: Int
    var clouds: Int
    var pop: Double
    var humidity: Int
    var description: String
}

class ForecstContainer: ObservableObject {
    
    @Published var forecastData = [ForecastManager]()
}

extension ForecastManager {
    static var dummyData: [ForecastManager] = [ForecastManager(high: 40, low: 10, clouds: 4, pop: 4.5, humidity: 59, description: "Dummy 1"),
                                               ForecastManager(high: 40, low: 10, clouds: 7, pop: 4.5, humidity: 59, description: "Dummy 2")]
    
    static var realData: [ForecastManager] = []
}
