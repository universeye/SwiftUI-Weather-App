//
//  ListingView.swift
//  StewartWeather
//
//  Created by Terry Kuo on 2021/4/8.
//

import SwiftUI
import SDWebImageSwiftUI

struct ListingView: View {
    
    var day =  ForecastListViewModel().forecasts[0]
    
    var body: some View {
        VStack(alignment:.leading) {
            Text(day.day).bold()
            HStack {
                WebImage(url: day.weatherIconUrl)
                    .resizable()
                    .placeholder {
                        SFSymbols.load
                    }
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    //.background(RoundedRectangle(cornerRadius: 10))
                VStack (alignment:.leading) {
                    //Text("\(day.weather[0].description.capitalized)")
                    Text(day.overview)
                        .font(.title2)
                    HStack {
                        Text(day.high)
                        Text(day.low)
                    }
                    HStack {
                        Text(day.clouds)
                        Text(day.pop)
                    }
                    Text(day.humidity)
                }
            }
        }
    }
}

