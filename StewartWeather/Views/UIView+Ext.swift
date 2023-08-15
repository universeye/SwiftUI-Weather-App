//
//  UIView+Ext.swift
//  LogoDemo3
//
//  Created by Terry Kuo on 2023/8/13.
//

import UIKit

extension UIView {
    func subView(forClass: AnyClass?) -> UIView? {
        return subviews.first { view in
            type(of: view) == forClass
        }
    }
}
