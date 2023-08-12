//
//  ForecastViewModel.swift
//  StewartWeather
//
//  Created by Terry Kuo on 2021/4/4.
//

import Foundation


struct ForecastViewModel {
    let forecast: Daily
    var system: Int
    
    //MARK: - Date Formatter

    private static var dateFormatter: DateFormatter{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, MM/d"
        return dateFormatter
    }
    
    //MARK: - Number Formatter
    private static var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 1
        return numberFormatter
    }
    
    private static var numberFormatter2: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        return numberFormatter
    }
    
    //MARK: - Celsius Converter
    
    func convert(temp: Double) -> Double{
        let celsius = temp
        if system == 0 {
            return celsius
        } else {
            return celsius * 9 / 5 + 32
        }
    }
    
    
    //MARK: - Computed Properties

    var day: String {
        return Self.dateFormatter.string(from: forecast.dt)
    }
    
    var overview: String {
        forecast.weather[0].description.capitalized
    }
    
    var high: String {
        return "H: \(Self.numberFormatter.string(for: convert(temp: forecast.temp.max)) ?? "0")°"
    }
    
    var low: String {
        return "L: \(Self.numberFormatter.string(for: convert(temp: forecast.temp.min)) ?? "0")°"
    }
    
    var pop : String {
        return "💧\(Self.numberFormatter2.string(for: forecast.pop) ?? "0%")"
    }
    
    var clouds: String {
        return "☁️ \(forecast.clouds)%"
    }
    
    var humidity: String {
        return "Humidity: \(forecast.humidity)%"
    }
    
    var weatherIconUrl: URL {
        let weatherIconUrlString = "https://openweathermap.org/img/wn/\(forecast.weather[0].icon)@2x.png"
        return URL(string: weatherIconUrlString)!
    }

    
    enum ActiveSheet: Identifiable {
        case searchHistory, setting
        
        var id: Int {
            hashValue
        }
    }

}




