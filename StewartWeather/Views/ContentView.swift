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
                    
                    .padding()
                    .background(.yellow.gradient)
                    .cornerRadius(10)
                    .frame(height: 80)
                    ListDataView(forecastListVM: _forecastListVM)
                }
                .ignoresSafeArea(edges: .bottom)
                .padding(.horizontal)
                .navigationTitle("SkySeek")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
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
                        Button(action: {
                            print("show search history")
                            activeSheet = .searchHistory
                            
                        }, label: {
                            SFSymbols.history
                        }) // Search History Button
                        
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
//            VStack {
//                Spacer()
//
//                //.padding(.bottom, 20)
//            } //Picker
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
                    .presentationDetents([.medium])
            case .setting:
                SettingsView()
                    .environmentObject(self.forecastListVM)
                    .presentationDetents([.medium])
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
            .environment(\.managedObjectContext, PersistanceController.shared.container.viewContext)
            .environmentObject(ForecastListViewModel())
    }
}
