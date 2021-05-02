//
//  LoadingView.swift
//  StewartWeather
//
//  Created by Terry Kuo on 2021/4/7.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.3).ignoresSafeArea()
            VStack {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
                    .scaleEffect(1)
                
                Text("Loading...")
                    .foregroundColor(.black)
                    .opacity(0.8)
                    .padding(.top, 6)
            }
            .frame(width: 120, height: 100)
            .padding(.top, 3)
            .background(Color(.white)).opacity(0.9)
            .cornerRadius(10)
            
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
