//
//  ContentView.swift
//  StewartWeather
//
//  Created by Terry Kuo on 2021/3/26.
//

/// BUG1 : Still adding empty value to CoreData when there is no string in the textfield

import SwiftUI
import SDWebImageSwiftUI

struct ContentView: View {
    
    //MARK: - Properties
    private let persistenceController = PersistanceController.shared //CoreData
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Items.entity(), sortDescriptors: [NSSortDescriptor(key: "city", ascending: true)]) var itmes: FetchedResults<Items>
    
    @EnvironmentObject var forecastListVM: ForecastListViewModel
    @StateObject private var locationManager = LocationManager()  //Location
    @State var activeSheet: ForecastViewModel.ActiveSheet? //searchHistory, setting
    
    //MARK: - Body
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    HStack {
                        TextField("Enter Location", text: $forecastListVM.location,
                                  onCommit: {
                                    //print("foreCastListVM.location is \(forecastListVM.location)")
                                    saveToCoreData(newCity: forecastListVM.location)
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
                                .padding(.horizontal),alignment: .trailing)
                        
                        Button(action: {
                            if forecastListVM.location.isEmpty {
                                forecastListVM.appError2 = AppError2(errorString: "Please enter a city")
                                forecastListVM.getWeatherForecast()
                                //print(forecastListVM.location.isEmpty)
                            } else {
                                saveToCoreData(newCity: forecastListVM.location)
                                forecastListVM.getWeatherForecast()
                            }
                        }, label: {
                            SFSymbols.magnifier
                                .font(.title2)
                        }) //Search Button
                    } //TextField
                    
                    
                    //MARK: - --

                    //Text("Location Status: \(locationManager.statusString)")
                    //Text("\(locationManager.lastLocation?.coordinate.latitude ?? 0)")
                    ListDataView(forecastListVM: _forecastListVM)
//                    GeometryReader { geo in
//                        RefreshScrollView(width: geo.size.width, height: geo.size.height, forecastListVM: _forecastListVM)
//                       RefreshScrollView(width: geo.size.width, height: geo.size.height, forecastListVM: forecastListVM)
//                   }
                   
                    
                    

                }
                .padding(.horizontal)
                .navigationTitle("DZWeather")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button(action: {
                            print("show search history")
                            activeSheet = .searchHistory
                            
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
                    
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            activeSheet = .setting
                            
                        } label: {
                            SFSymbols.setting
                        }
                        .disabled(true)
                        
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
            VStack {
                Spacer()
                Picker(selection: $forecastListVM.system, label: Text("System")) {
                    Text("°C").tag(0)
                    Text("°F").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(maxWidth: 320)
                //.padding(.bottom, 20)
            } //Picker
            if forecastListVM.isLoading {
                LoadingView()
            }
        }
        .sheet(item: $activeSheet) { (item) in
            switch item {
            case .searchHistory:
                SearchHistoryView()
                    .environment(\.managedObjectContext, self.managedObjectContext)
                    .environmentObject(self.forecastListVM)
            case .setting:
                SettingsView()
            }
        }
    }
    
    //MARK: - Save to CoreData Function
    func saveToCoreData(newCity: String) {
        let newItem = Items(context: managedObjectContext)
        var count = 0
        if newCity == "" || newCity == "Unknown" {
            print("empty")
        } else {
            for i in 0..<itmes.count {
                if newCity == itmes[i].city {
                    count += 1
                }
            }
            
            if count > 0 {
                print("already saved this item")
            } else {
                newItem.city = newCity
                persistenceController.save()
            }
        }
    }
}


//MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
