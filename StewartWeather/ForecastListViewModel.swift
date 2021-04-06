//
//  ForecastListViewModel.swift
//  StewartWeather
//
//  Created by Terry Kuo on 2021/4/6.
//

import Foundation
import CoreLocation

class ForecastListViewModel: ObservableObject {
    
    @Published var forecasts: [ForecastViewModel] = []
    var location: String = ""
    
    func getWeatherForecast() {
        let apiService = APIService.shared
        
        CLGeocoder().geocodeAddressString(location) { (placemarks, error) in
            if let err = error {
                print(err)
            }

            if let lat = placemarks?.first?.location?.coordinate.latitude,
               let lon = placemarks?.first?.location?.coordinate.longitude {
                apiService.getJSON(urlString: "https://api.openweathermap.org/data/2.5/onecall?&units=metric&exclude=current,minutely,hourly,alerts&appid=64e55479deb9cc0b215e611a0a14b40f&lat=\(lat)&lon=\(lon)",
                                   dateDecodingStrategy: .secondsSince1970) { (result: Result<WeatherData, APIService.APIError>) in
                    
                    
                    
                    switch result {
                    case .success(let forecast):
                        DispatchQueue.main.async {
                            self.forecasts = forecast.daily.map { ForecastViewModel(forecast: $0) }
                        }
                       
                    case .failure(let apiError):
                        switch apiError {
                        case .error(let errorString):
                            print(errorString)
                        }
                    }
                }
            }
        }
    }
    
}
