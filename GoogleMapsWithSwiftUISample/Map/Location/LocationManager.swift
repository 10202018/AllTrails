import Foundation
import GoogleMaps

/// Manager for user's current-location and location-permissions.
class LocationManager: NSObject, ObservableObject {
  private var locationManager = CLLocationManager()
  
  @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined {
    willSet { objectWillChange.send() }
  }
  
  @Published var location: CLLocation? {
    willSet { objectWillChange.send() }
  }
  
  var latitude: CLLocationDegrees {
    return location?.coordinate.latitude ?? 0
  }
  
  var longitude: CLLocationDegrees {
    return location?.coordinate.longitude ?? 0
  }
  
  override init() {
    super.init()
    
    locationManager.delegate = self
    
    switch authorizationStatus {
    case .authorizedAlways, .authorizedWhenInUse:
      configureLocationSettings()
    case .notDetermined, .restricted, .denied: break
    @unknown default: fatalError()
    }
  }
  
  func configureLocationSettings() {
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.startUpdatingLocation()
  }
  
  func requestLocationPermissions() {
    locationManager.requestWhenInUseAuthorization()
  }
}

extension LocationManager: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    self.location = location
  }
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    self.authorizationStatus = manager.authorizationStatus

    switch authorizationStatus {
    case .authorizedAlways, .authorizedWhenInUse:
      configureLocationSettings()
    case .notDetermined, .restricted, .denied:
      return
    @unknown default:
      fatalError()
    }
  }
}
