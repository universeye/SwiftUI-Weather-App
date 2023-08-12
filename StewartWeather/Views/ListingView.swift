//
//  ListingView.swift
//  StewartWeather
//
//  Created by Terry Kuo on 2021/4/8.
//

import SwiftUI
import SDWebImageSwiftUI

struct ListingView: View {
    
    var day = ForecastListViewModel().forecasts[0]
    
    var body: some View {
        VStack(alignment:.leading) {
            Text(day.day).bold()
            HStack(spacing: 16) {
                WebImage(url: day.weatherIconUrl)
                    .resizable()
                    .placeholder {
                        ProgressView()
                    }
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 70, height: 70)
                    .background(RoundedRectangle(cornerRadius: 10).fill(.cyan.gradient))
                    .shadow(radius: 2)
                VStack(alignment:.leading, spacing: 4) {
                    Text(day.overview)
                        .font(.title2)
                        .bold()
                    HStack {
                        Text(day.high)
                            .foregroundColor(.red)
                        Text(day.low)
                            .foregroundColor(.blue)
                        Text(day.clouds)
                        Text(day.pop)
                    }
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    Text(day.humidity)
                        .font(.callout)
                        .foregroundColor(Color(uiColor: .systemGray))
                }
            }
        }
    }
}

struct ListingView_Previews: PreviewProvider {
    static var previews: some View {
        ListDataView()
            .environmentObject(ForecastListViewModel())
    }
}
