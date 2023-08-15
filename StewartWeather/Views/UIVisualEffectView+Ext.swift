//
//  UIVisualEffectView+Ext.swift
//  LogoDemo3
//
//  Created by Terry Kuo on 2023/8/12.
//

import UIKit

extension UIVisualEffectView {
    
    //MARK: Adjusting Blur Radius in UIVisualEffectView
    //MARK: Steps
    ///Extracting private class BackDropView Class
    ///Then from that view extracting ViewEffects like Gaussian Blur & Saturation
    ///With the Help of this we can acheive glass morphism
    ///
    
    var backDrop: UIView? {
            //Private class
        return subView(forClass: NSClassFromString("_UIVisualEffectBackdropView"))
    }
    
    //MARK: Extracting Guassian Blur From BackDropView
    var gaussianBlur: NSObject? {
        backDrop?.value(key: "filters", filter: "gaussianBlur")
    }
    
    //MARK: Extracting Saturation From BackDropView
    var saturation: NSObject? {
        return backDrop?.value(key: "filters", filter: "colorSaturate")
    }
    
    //MARK: Updating Blur radius and saturation
    var gaussianBlurRadius: CGFloat {
        get {
            ///we know the key for gaussian blur = "inputRadius"
            return gaussianBlur?.values?["inputRadius"] as? CGFloat ?? 0
        }
        set {
            gaussianBlur?.values?["inputRadius"] = newValue
            applyNewEffects()
        }
    }
    
    func applyNewEffects() {
        //Updating the Backdrop view with the New Filter Updates
        UIVisualEffectView.animate(withDuration: 0.5) {
            self.backDrop?.perform(Selector(("applyRequestedFilterEffects")))
        }
        
    }
    
    var saturationAmount: CGFloat {
        get {
            ///we know the key for gaussian blur = "inputAmount"
            return saturation?.values?["inputAmount"] as? CGFloat ?? 0
        }
        set {
            saturation?.values?["inputAmount"] = newValue
        }
    }
}

