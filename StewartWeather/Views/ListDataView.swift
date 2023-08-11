//
//  ListData.swift
//  StewartWeather
//
//  Created by Terry Kuo on 2021/4/22.
//

import SwiftUI

struct ListDataView: View {
    
    @EnvironmentObject var forecastListVM: ForecastListViewModel
    
    var body: some View {
        VStack(alignment:.leading) {
            //List(0..<forecast.daily.count) { index in
            List(forecastListVM.forecasts, id: \.day) { day in
                ListingView(day: day)
            }
            .padding(.bottom, 4)
            .listStyle(PlainListStyle())
        }
    }
}
//
//struct ListData_Previews: PreviewProvider {
//    static var previews: some View {
//        ListDataView()
//    }
//}
