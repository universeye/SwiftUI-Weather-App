//
//  NSObject+Ext.swift
//  LogoDemo3
//
//  Created by Terry Kuo on 2023/8/13.
//

import Foundation

//MARK: Custom Keyt Filtering
extension NSObject {
    //MARK: Key Values From NSObject
    var values: [String: Any]? {
        get {
            return value(forKeyPath: "requestedValues") as? [String: Any]
        }
        set {
            setValue(newValue, forKeyPath: "requestedValues")
        }
    }
    
    func value(key: String, filter: String) -> NSObject? {
        (value(forKey: key) as? [NSObject])?.first(where: { obj in
            return obj.value(forKeyPath: "filterType") as? String == filter
        })
    }
}
