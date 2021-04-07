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
    
    struct AppError: Identifiable {
        let id = UUID().uuidString
        let errorString: String
    }
    
    
    @Published var isLoading: Bool = false
    @Published var forecasts: [ForecastViewModel] = []
    var appError: AppError? = nil
    var appError2: AppError2? = nil
    
    @AppStorage("location") var location: String = ""
    @AppStorage("system") var system: Int = 0 {
        didSet {
            for i in 0..<forecasts.count {
                forecasts[i].system = system
            }
        }
    }
    
    init() {
        if location != "" {
            getWeatherForecast()
        }
    }

    
    
    
    //MARK: - Get Weather Forecast Function

    func getWeatherForecast() {
        isLoading = true
        let apiService = APIService.shared
        CLGeocoder().geocodeAddressString(location) { (placemarks, error) in
            if let err = error {
                self.isLoading = false
                self.appError = AppError(errorString: err.localizedDescription)
                self.appError2 = AppError2(errorString: err.localizedDescription)
                print(err.localizedDescription)
            }
            
            if let lat = placemarks?.first?.location?.coordinate.latitude,
               let lon = placemarks?.first?.location?.coordinate.longitude {
                apiService.getJSON(urlString: "https://api.openweathermap.org/data/2.5/onecall?&units=metric&exclude=current,minutely,hourly,alerts&appid=64e55479deb9cc0b215e611a0a14b40f&lat=\(lat)&lon=\(lon)",dateDecodingStrategy: .secondsSince1970) { (result: Result<WeatherData, APIService.APIError>) in
                    
                    
                    
                    switch result {
                    case .success(let forecast):
                        //if success getting data, save it into forecasts array
                        DispatchQueue.main.async {
                            
                            self.forecasts = forecast.daily.map { ForecastViewModel(forecast: $0, system: self.system) }
                            self.isLoading = false
                            print(self.forecasts)
                            print(self.forecasts[0].day)
                        }
                       
                    case .failure(let apiError):
                        switch apiError {
                        case .error(let errorString):
                            self.isLoading = false
                            self.appError = AppError(errorString: errorString) //error already localized
                            self.appError2 = AppError2(errorString: errorString)
                            print(errorString)
                        }
                    }
                }
            }
        }
    }
    
}
