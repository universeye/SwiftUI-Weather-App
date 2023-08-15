//
//  CustumModifier.swift
//  LogoDemo3
//
//  Created by Terry Kuo on 2023/8/14.
//

import SwiftUI

struct CustumModifier: ViewModifier {
    var font: Font
    func body(content: Content) -> some View {
        content
            .font(font)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .kerning(1.2)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

