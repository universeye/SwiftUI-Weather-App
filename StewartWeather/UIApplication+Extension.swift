//
//  UIApplication+Extension.swift
//  StewartWeather
//
//  Created by Terry Kuo on 2021/4/7.
//

import UIKit

extension UIApplication {
    
    //dismiss keyboard
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
