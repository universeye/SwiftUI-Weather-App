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
    @State var forecast: WeatherData? = nil
    
    let dateFormatter = DateFormatter()
    init() { //when the content view is initialized, the assigns this string to the date formatter property of the day formatter
        dateFormatter.dateFormat = "E, MM, d"
    }
    
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Enter Location", text: $location)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button(action: {
                        getWeatherForecast(for: location)
                    }, label: {
                        SFSymbols.magnifier
                            .font(.title3)
                    })
                }
                if let forecast = forecast {
                    //Text(String(forecast.daily[0].temp.max))
                    
                    VStack(alignment:.leading) {
                        //List(0..<forecast.daily.count) { index in
                        List(forecast.daily, id: \.dt) { day in
                            VStack(alignment:.leading) {
                                Text(dateFormatter.string(from: day.dt)).bold()
                                HStack {
                                    SFSymbols.load
                                        .font(.title)
                                        .frame(width: 50, height: 50)
                                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.green))
                                    VStack (alignment:.leading) {
                                        Text("\(day.weather[0].description.capitalized)")
                                        HStack {
                                            Text("High: \(day.temp.max, specifier: "%.0f")")
                                            Text("Low: \(day.temp.min, specifier: "%.0f")")
                                        }
                                        
                                        HStack {
                                            Text("Clouds: \(day.clouds)" + ",")
                                            Text("POP: \(day.pop)")
                                        }
                                        
                                        Text("Humidity: \(day.humidity)")
                                    }
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                } else {
                    Spacer()
                }
            }
            .padding(.horizontal)
            .navigationTitle("Mobile Weather")
        }
    }
    
    
    func getWeatherForecast(for location: String) {
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
                        self.forecast = forecast
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
