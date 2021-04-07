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
            Color.black.opacity(0.2).ignoresSafeArea()
            VStack {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
                    .scaleEffect(1)
                
                Text("Loading...")
                    .opacity(0.8)
                    .padding(.top, 5)
            }
            .frame(width: 120, height: 80)
            .background(Color(.systemBackground)).opacity(0.8)
            .cornerRadius(10)
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
