//
//  SSEmptyView.swift
//  StewartWeather
//
//  Created by Terry Kuo on 2023/8/15.
//

import SwiftUI

struct SSEmptyView: View {
    var body: some View {
        VStack {
            Image(systemName: "tropicalstorm")
                .font(.system(size: 100, weight: .heavy))
                .padding()
            Text("No weather data")
                .font(.headline)
        }
        .foregroundColor(.gray)
    }
}

struct SSEmptyView_Previews: PreviewProvider {
    static var previews: some View {
        SSEmptyView()
    }
}
