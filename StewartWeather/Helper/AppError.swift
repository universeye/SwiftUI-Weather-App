//
//  AppError.swift
//  StewartWeather
//
//  Created by Terry Kuo on 2021/4/7.
//

import Foundation

struct AppError2: Identifiable {
    let id = UUID().uuidString
    let errorString: String
}
