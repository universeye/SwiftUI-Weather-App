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
    @State private var activeSheet: ForecastViewModel.ActiveSheet? //searchHistory, setting
    @State private var isUsingKB: Bool = false
    
    @State private var blurView: UIVisualEffectView = .init()
    @State private var defaultBlurRadius: CGFloat = 10
    @State private var defaultSaturationAmount: CGFloat = 1.8
    @State private var isShow: Bool = false
    
    init() {
        UINavigationBar.appearance().tintColor = .systemGreen
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.label]
    }
    
    //MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                
                
                
                VStack(spacing: 0) {
                    HStack {
                        TextField("Enter Location", text: $forecastListVM.location,
                                  onCommit: {
                            //print("foreCastListVM.location is \(forecastListVM.location)")
                            saveToCoreData(newCity: forecastListVM.location)
                            forecastListVM.getWeatherForecast()
                            
                        })
                        .tint(Color(uiColor: .secondaryLabel))
                        .foregroundColor(.black)
                        .overlay ( //delete textField icon
                            Button(action: {
                                forecastListVM.location = ""
                                forecastListVM.getWeatherForecast() //so that we can set the storageLocation and set the forecasts array to empty
                            }) {
                                SFSymbols.xmark
                                    .foregroundColor(Color(uiColor: .systemGray))
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
                                .foregroundColor(.black)
                        }) //Search Button
                    } //TextField
                    .padding(12)
                    .background(Color("button").gradient)
                    .cornerRadius(15)
                    .padding(.horizontal)
                    
                    if forecastListVM.forecasts.isEmpty {
                        SSEmptyView()
                            .frame(maxHeight: .infinity)
                    } else {
                        listData()
                    }
                }
                .navigationTitle("SkySeek")
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        DismissKeyboardButton()
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
                VStack {
                    Spacer()
                    HStack(spacing: 16) {
                        Button {
                            //Get Location Action
                            locationManager.getCurrent()
                            forecastListVM.getWeatherForecastWithLatLon(lat: locationManager.latt ?? 0, lon: locationManager.lonn ?? 0)
                            forecastListVM.location = ""
                        } label: {
                            HStack {
                                SFSymbols.location
                                Text("Current Location")
                                
                            }
                            .foregroundColor(.black)
                            .padding()
                            .background(Color("button").gradient)
                            .cornerRadius(15)
                            .shadow(radius: 2)
                            .overlay {
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.black.opacity(0.2), lineWidth: 2)
                            }
                        }
                        Button {
                            //Get Location Action
                            saveToCoreData(newCity: forecastListVM.location)
                            forecastListVM.getWeatherForecast()
                        } label: {
                            HStack {
                                SFSymbols.magnifier
                                Text("Search")
                                
                            }
                            .foregroundColor(.black)
                            .padding()
                            .background(Color("button").gradient)
                            .cornerRadius(15)
                            .shadow(radius: 2)
                            .overlay {
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.black.opacity(0.2), lineWidth: 2)
                            }
                        }
                    }
                    .padding(.top)
                    .padding(.bottom, 8)
                }
                
                //            if forecastListVM.isLoading {
                //                LoadingView()
                //            }
            }
            .background(
                Image("bgimage")
                    .resizable()
                    .scaleEffect(1.2)
                    .scaledToFill()
                    .ignoresSafeArea()
                    .opacity(0.7))
            
        }
        .accentColor(Color("button"))
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
    
    @ViewBuilder
    func listData() -> some View {
        List(forecastListVM.forecasts, id: \.day) { day in
            GlassMorphismCardView(blurView: $blurView, defaultBlurRadius: $defaultBlurRadius, defaultSaturationAmount: $defaultSaturationAmount, isShow: $forecastListVM.isLoading, day: day)
//                .onChange(of: forecastListVM.isLoading) { newValue in
//                    blurView.gaussianBlurRadius = (!forecastListVM.isLoading ? 10 : defaultBlurRadius)
//                    blurView.saturationAmount = (!forecastListVM.isLoading ? 1.8 : defaultSaturationAmount)
//                }
                .animation(.easeIn(duration: 0.5), value: forecastListVM.isLoading)
                .listRowBackground(Color(uiColor: .clear))
        }
        
        .refreshable(action: {
            forecastListVM.getWeatherForecast()
        })
        .animation(.easeIn(duration: 0.5), value: forecastListVM.isLoading)
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .scrollDismissesKeyboard(.immediately)
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
