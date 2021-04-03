//
//  SFSymbols.swift
//  StewartWeather
//
//  Created by Terry Kuo on 2021/4/4.
//

import Foundation
import SwiftUI

enum SFSymbols: String, View {
    
    case load = ""
    
    var body: some View {
        Image(systemName: self.rawValue)
    }
}
