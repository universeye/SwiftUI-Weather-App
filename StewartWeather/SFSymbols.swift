//
//  SFSymbols.swift
//  StewartWeather
//
//  Created by Terry Kuo on 2021/4/1.
//

import Foundation
import SwiftUI

enum SFSymbols: String, View  {
    case magnifier = "magnifyingglass.circle.fill"
    case load = "slowmo"
    
    var body: some View {
        Image(systemName: self.rawValue)
    }
}
