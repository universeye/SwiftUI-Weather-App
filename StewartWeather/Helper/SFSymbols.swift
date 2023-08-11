//
//  SFSymbols.swift
//  StewartWeather
//
//  Created by Terry Kuo on 2021/4/4.
//

import Foundation
import SwiftUI

enum SFSymbols: String, View {
    
    case magnifier = "magnifyingglass"
    case load = "slowmo"
    case hourGlass = "hourglass"
    case xmark = "xmark"
    case location = "location.fill"
    case history = "clock.arrow.circlepath"
    case add = "plus"
    case setting = "gearshape.2.fill"
    
    var body: some View {
        Image(systemName: self.rawValue)
    }
}
