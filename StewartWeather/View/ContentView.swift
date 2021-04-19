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
    let persistenceController = PersistanceController.shared
    @StateObject var locationManager = LocationManager()
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var isShowingSheet = false
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    HStack {
                        TextField("Enter Location", text: $forecastListVM.location,
                                  onCommit: {
                                    forecastListVM.getWeatherForecast()
                                  })
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            .overlay ( //delete textField icon
                                Button(action: {
                                    forecastListVM.location = ""
                                    forecastListVM.getWeatherForecast() //so that we can set the storageLocation and set the forecasts array to empty
                                }) {
                                    SFSymbols.xmark
                                        .foregroundColor(.gray)
                                }
                                .padding(.horizontal),alignment: .trailing
                            )
                        
                        
                        //Search Button
                        Button(action: {
                            if forecastListVM.location.isEmpty {
                                forecastListVM.appError2 = AppError2(errorString: "Please enter a city")
                                forecastListVM.getWeatherForecast()
                                //print(forecastListVM.location.isEmpty)
                            } else {
                                forecastListVM.getWeatherForecast()
                            }
                        }, label: {
                            SFSymbols.magnifier
                                .font(.title2)
                        })
                    }
                    
                    
                    //Text("Location Status: \(locationManager.statusString)")
                    //Text("\(locationManager.lastLocation?.coordinate.latitude ?? 0)")
                    
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
                            ListingView(day: day)
                        }
                        .listStyle(PlainListStyle())
                    }
                }
                .padding(.horizontal)
                .navigationTitle("DZWeather")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        
                        
                        Button(action: {
                            isShowingSheet.toggle()
                        }, label: {
                            SFSymbols.history
                        }) // Search History Button
                        
                        
                        Button(action: {
                            //Get Location Action
                            locationManager.getCurrent()
                            forecastListVM.getWeatherForecastWithLatLon(lat: locationManager.latt ?? 0, lon: locationManager.lonn ?? 0)
                        }, label: {
                            SFSymbols.location
                        }) // Location Button
                        
                    }
                }
                .alert(item: $forecastListVM.appError2) { appAlert in
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
        .sheet(isPresented: $isShowingSheet, content: {
            SearchHistoryView(isShowingSheet: $isShowingSheet).environment(\.managedObjectContext, persistenceController.container.viewContext)
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
