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
        List(forecastListVM.forecasts, id: \.day) { day in
            ListingView(day: day)
                .listRowSeparator(.hidden)
                
        }
        .scrollContentBackground(.hidden)
//        .listStyle(.plain)
//        .background(Color(uiColor: .clear))
        
    }
}

struct ListData_Previews: PreviewProvider {
    static var previews: some View {
        ListDataView()
            .environmentObject(ForecastListViewModel())
    }
}
