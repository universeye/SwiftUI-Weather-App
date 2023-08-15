//
//  GlassMorphismView.swift
//  LogoDemo3
//
//  Created by Terry Kuo on 2023/8/12.
//

import SwiftUI

struct GlassMorphismView: View {
    @State private var blurView: UIVisualEffectView = .init()
    @State private var defaultBlurRadius: CGFloat = 0
    @State private var defaultSaturationAmount: CGFloat = 0
    @State private var isShow: Bool = false
    
    var body: some View {
        ZStack {
            Color("BG")
                .ignoresSafeArea()
            Image("behancelogo")
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 180)
                .offset(x: 150, y: -90)
            
            Image("jenkinslogo")
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 140)
                .offset(x: -150, y: 90)
            
            Image("watchos10")
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
                .offset(x: -40, y: -100)
            
            GlassMorphismCardView(blurView: $blurView, defaultBlurRadius: $defaultBlurRadius, defaultSaturationAmount: $defaultSaturationAmount, isShow: $isShow)
            
            Toggle("Activate Glass Morphism", isOn: $isShow)
                .onChange(of: isShow) { newValue in
                    blurView.gaussianBlurRadius = (isShow ? 10 : defaultBlurRadius)
                    blurView.saturationAmount = (isShow ? 1.8 : defaultSaturationAmount)
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                .padding(15)
        }
    }
}

struct GlassMorphismView_Previews: PreviewProvider {
    static var previews: some View {
        GlassMorphismView()
            .preferredColorScheme(.dark)
    }
}
