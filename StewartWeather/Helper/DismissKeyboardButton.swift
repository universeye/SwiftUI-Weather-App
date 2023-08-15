//
//  DismissKeyboardButton.swift
//  SUM
//
//  Created by Terry Kuo on 2022/10/13.
//

import SwiftUI

struct DismissKeyboardButton: View {
    @State private var isUsingKB: Bool = false
    
    var body: some View {
        Button {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
            withAnimation(.easeInOut(duration: 0.6)) {
                isUsingKB = false
            }
            
        } label: {
            Image(systemName: "keyboard.chevron.compact.down")
                .foregroundColor(Color(UIColor.label))
                .font(.system(size: 14, weight: .semibold))
        }
        .onAppear {
            withAnimation(.easeIn(duration: 0.3)) {
                isUsingKB = true
            }
            
        }
        .scaleEffect(isUsingKB ? 1 : 0.2)
        .animation(.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.8), value: isUsingKB)
    }
}

struct DismissKeyboardButton_Previews: PreviewProvider {
    static var previews: some View {
        DismissKeyboardButton()
    }
}
