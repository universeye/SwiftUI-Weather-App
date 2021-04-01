//
//  ContentView.swift
//  StewartWeather
//
//  Created by Terry Kuo on 2021/3/26.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @State private var location: String = ""
    @StateObject var forecastContainer = ForecstContainer()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Enter Location", text: $location)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button(action: {
                        //getWeatherForecast(for: location)
                        getWeatherWithString(for: location)
                        
                    }, label: {
                        SFSymbols.magnifier
                            .font(.title3)
                    })
                } //HStack
                Divider()
                
                List(forecastContainer.forecastData) { data in
                    HStack {
                        SFSymbols.load
                        VStack {
                            Text(data.description).bold()
                            Text("Clouds: \(data.clouds)")
                        }
                    }
                    
                }
                .listStyle(PlainListStyle())
                
                Spacer()
            }
            .padding(.horizontal)
            .navigationTitle("Mobile Weather")
        }
    }
    
    
    func getWeatherWithString(for location: String) {
        
        let apiService = APIService.shared
        
        apiService.getJSON(urlString: "https://api.openweathermap.org/data/2.5/onecall?&units=metric&exclude=current,minutely,hourly,alerts&appid=64e55479deb9cc0b215e611a0a14b40f&q=\(location)") { (result: Result<WeatherData, APIService.APIError>) in
            
            let weather = ForecastManager(high: 40, low: 403, clouds: 13, pop: 43, humidity: 4, description: "fdefieh")
            DispatchQueue.main.async {
                forecastContainer.forecastData.append(weather)
            }
        }
    }
    
    func getWeatherForecast(for location: String) {
        let apiService = APIService.shared
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "E, MM, d"

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
                        //print(forecast.daily[0].temp.max)
                        for day in forecast.daily {
                            
                            print("Get Weather for \(location)")
                            print("===============================")
                            print(dateFormatter.string(from: day.dt))
                            print("Max temperature: \(day.temp.max)")
                            print("Min temperature: \(day.temp.min)")
                            print("Hum: \(day.humidity)")
                            print("Des: \(day.weather[0].description)")
                            print("Clouds: \(day.clouds)")
                            print("pop: \(day.pop)")
                            print("iconURL: \(day.weather[0].weatherIconUrl)")
                            
                            
                            
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
