//
//  LocationManager.swift
//  StewartWeather
//
//  Created by Terry Kuo on 2021/4/8.
//
import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager()
    @Published var city: String?
    @Published var latt: CLLocationDegrees?
    @Published var lonn: CLLocationDegrees?
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var lastLocation: CLLocation? {
        didSet {
            self.latt = lastLocation?.coordinate.latitude
            self.lonn = lastLocation?.coordinate.longitude
            
        }
    }
    
        
        
        
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
    }

   
    
    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }
        
        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
        print(#function, statusString)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation = location
        print(#function, location)
    }
    
    func getCurrent() {
        locationManager.startUpdatingLocation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.locationManager.stopUpdatingLocation()
        }
       
    }
}
