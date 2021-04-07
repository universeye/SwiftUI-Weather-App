//
//  ContentView.swift
//  StewartWeather
//
//  Created by Terry Kuo on 2021/3/26.
//

import SwiftUI
import SDWebImageSwiftUI

struct ContentView: View {
    
    @StateObject private var forecastListVM = ForecastListViewModel()
    
    var body: some View {
        ZStack {
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
                        
                        Picker(selection: $forecastListVM.system, label: Text("System")) {
                            Text("°C").tag(0)
                            Text("°F").tag(1)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(maxWidth: 320)
                        .padding(.bottom, 20)
                        
                        VStack(alignment:.leading) {
                            //List(0..<forecast.daily.count) { index in
                            List(forecastListVM.forecasts, id: \.day) { day in
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
                    .alert(item: $forecastListVM.appError) { appAlert in
                        Alert(title: Text("Alert"),
                              message: Text(
                                """
                                \(appAlert.errorString)
                                Please try again later
                                """
                              ))
                }
            }
            if forecastListVM.isLoading {
                LoadingView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
