//
//  ForecastListViewModel.swift
//  StewartWeather
//
//  Created by Terry Kuo on 2021/4/6.
//

import Foundation
import CoreLocation
import SwiftUI

class ForecastListViewModel: ObservableObject {
    
//    struct AppError: Identifiable { //stored error in this to present alert
//        let id = UUID().uuidString
//        let errorString: String
//    }
    
    @Published var isLoading: Bool = false
    @Published var forecasts: [ForecastViewModel] = []
   // var appError: AppError? = nil
    var appError2: AppError2? = nil
    @AppStorage("location") var storageLocation: String = ""
    @Published var location = ""
    @AppStorage("system") var system: Int = 0 {
        didSet {
            for i in 0..<forecasts.count {
                forecasts[i].system = system
            }
        }
    }
    
    init() {
        location = storageLocation
        getWeatherForecast()
    }
    
    func updateLocation(locat: String) {
        self.location = locat
        print("updated location: \(self.location)")
    }
    
    
    //MARK: - Get Weather Forecast Function
    
    func getWeatherForecast() {
        print("getting weather1")
        print("Location is \(location)")
        storageLocation = location //save location to UserDefault
        UIApplication.shared.endEditing() //dismiss keyboard
        
        if location == "" { //if location in textField is empty, clear forecasts array
            print("Location is Empty")
            forecasts = []
        } else { //otherwise call the api to fetch weather data
           
            
            isLoading = true //show loading view
            let apiService = APIServiceCombine.shared
            
            
            CLGeocoder().geocodeAddressString(location) { (placemarks, error) in
                if let err = error as? CLError {
                    
                    switch err.code {
                    case .locationUnknown, .geocodeFoundNoResult, .geocodeFoundPartialResult:
                        self.appError2 = AppError2(errorString: NSLocalizedString("Unable to determine location from this text", comment: ""))
                    case .network:
                        self.appError2 = AppError2(errorString: NSLocalizedString("You do not appear to have a network connection", comment: ""))
                    default: //the rest of the error, not @unknown
                        self.appError2 = AppError2(errorString: err.localizedDescription)
                    }
                    
                    self.isLoading = false
                    //self.appError = AppError(errorString: err.localizedDescription)
                    //self.appError2 = AppError2(errorString: err.localizedDescription)
                    print(err.localizedDescription)
                }
                
                if let lat = placemarks?.first?.location?.coordinate.latitude,
                   let lon = placemarks?.first?.location?.coordinate.longitude {
                    apiService.getJSON(urlString: "https://api.openweathermap.org/data/2.5/onecall?&units=metric&exclude=current,minutely,hourly,alerts&appid=64e55479deb9cc0b215e611a0a14b40f&lat=\(lat)&lon=\(lon)",dateDecodingStrategy: .secondsSince1970) { (result: Result<WeatherData, APIServiceCombine.APIError>) in
                        
                        
                        
                        switch result {
                        case .success(let forecast):
                            //if success getting data, save it into forecasts array
                            DispatchQueue.main.async {
                                self.forecasts = forecast.daily.map { ForecastViewModel(forecast: $0, system: self.system) }
                                self.isLoading = false
                            }
                            
                        case .failure(let apiError):
                            switch apiError {
                            case .error(let errorString):
                                self.isLoading = false
                                //self.appError = AppError(errorString: errorString) //error already localized
                                self.appError2 = AppError2(errorString: errorString) //error already localized
                                print(errorString)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    func getWeatherForecastWithLatLon(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        forecasts = [] //clear data array
        isLoading = true //show loading view
        let apiService = APIServiceCombine.shared
        apiService.getJSON(urlString: "https://api.openweathermap.org/data/2.5/onecall?&units=metric&exclude=current,minutely,hourly,alerts&appid=64e55479deb9cc0b215e611a0a14b40f&lat=\(lat)&lon=\(lon)") { (result: Result<WeatherData, APIServiceCombine.APIError>) in
            
            switch result  {
            
            case .success(let forecast):
                DispatchQueue.main.async {
                    self.forecasts = forecast.daily.map {
                        ForecastViewModel(forecast: $0, system: self.system)
                    }
                    self.isLoading = false
                    self.location = forecast.timezone
                    print("success")
                    print(self.forecasts)
                }
            case .failure(let apiError):
                switch apiError {
                case .error(let errorString):
                    self.isLoading = false
                    self.appError2 = AppError2(errorString: errorString)
                }
            }
        }
    }
}
