//
//  ContentView.swift
//  StewartWeather
//
//  Created by Terry Kuo on 2021/3/26.
//

import SwiftUI

struct ContentView: View {

    @StateObject private var forecastListVM = ForecastListViewModel()

    
    
    var body: some View {
        NavigationView {
            VStack {
                Picker(selection: $forecastListVM.system, label: Text("System")) {
                    Text("°C").tag(0)
                    Text("°F").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 100)
                .padding(.vertical)
                HStack {
                    TextField("Enter Location", text: $forecastListVM.location)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button(action: {
                        forecastListVM.getWeatherForecast()
                    }, label: {
                        SFSymbols.magnifier
                            .font(.title3)
                    })
                }
                
                    
                    VStack(alignment:.leading) {
                        //List(0..<forecast.daily.count) { index in
                        List(forecastListVM.forecasts, id: \.day) { day in
                            VStack(alignment:.leading) {
                                Text(day.day).bold()
                                HStack {
                                    SFSymbols.load
                                        .font(.title)
                                        .frame(width: 50, height: 50)
                                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.green))
                                    VStack (alignment:.leading) {
                                        //Text("\(day.weather[0].description.capitalized)")
                                        Text(day.overview)
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
                        .listStyle(PlainListStyle())
                    }
            }
            .padding(.horizontal)
            .navigationTitle("Mobile Weather")
        }
    }
    
    

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
