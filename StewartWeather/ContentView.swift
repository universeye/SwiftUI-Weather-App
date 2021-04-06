//
//  ContentView.swift
//  StewartWeather
//
//  Created by Terry Kuo on 2021/3/26.
//

import SwiftUI

struct ContentView: View {
//    @State private var location: String = ""
//    @State var forecast: WeatherData? = nil
    @StateObject private var forecastListVM = ForecastListViewModel()
//    let dateFormatter = DateFormatter()
//    init() { //when the content view is initialized, the assigns this string to the date formatter property of the day formatter
//        dateFormatter.dateFormat = "E, MM, d"
//    }
    
    
    var body: some View {
        NavigationView {
            VStack {
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
