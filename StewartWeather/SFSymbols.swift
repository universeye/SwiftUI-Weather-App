//
//  SFSymbols.swift
//  StewartWeather
//
//  Created by Terry Kuo on 2021/4/4.
//

import Foundation
import SwiftUI

enum SFSymbols: String, View {
    
    case magnifier = "magnifyingglass.circle.fill"
    case load = "slowmo"
    case hourGlass = "hourglass"
    case xmark = "xmark.circle"
    case location = "location.fill"
    case history = "clock.arrow.circlepath"
    
    var body: some View {
        Image(systemName: self.rawValue)
    }
}
