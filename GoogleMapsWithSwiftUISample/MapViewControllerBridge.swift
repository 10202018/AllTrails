import GoogleMaps
import SwiftUI

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

struct MapViewControllerBridge: UIViewControllerRepresentable {
  @StateObject var restaurantSearchViewModel: RestaurantSearchViewModel
  @Binding var selectedMarker: GMSMarker?
  @ObservedObject var locationManager = LocationManager()

  private let zoom: Float = 15.0

  func makeUIViewController(context: Context) -> MapViewController {
      restaurantSearchViewModel.fetchGeocodes()
      locationManager.requestLocationPermissions()
//      let uiViewController = MapViewController()
//      initialiseMapCamera(mapView: uiViewController.map)
      return MapViewController()
  }
  
//  private func initialiseMapCamera(mapView: GMSMapView) {
//    var cameraLocation: CLLocationCoordinate2D
//    
//    switch locationManager.authorizationStatus {
//    case .authorizedAlways, .authorizedWhenInUse:
//      cameraLocation = CLLocationCoordinate2D(
//        latitude: locationManager.latitude,
//        longitude: locationManager.longitude)
//    case .notDetermined, .restricted, .denied:
//      cameraLocation = CLLocationCoordinate2D(latitude: 1.0, longitude: 1.0)
//    @unknown default:
//      fatalError()
//    }
//    mapView.camera = GMSCameraPosition.camera(withTarget: cameraLocation, zoom: zoom)
//  }
  

  func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
    restaurantSearchViewModel.markers.forEach { $0.map = uiViewController.map }
    
    selectedMarker?.map = uiViewController.map
    animateToSelectedMarker(viewController: uiViewController)
  }

  private func animateToSelectedMarker(viewController: MapViewController) {
      guard let selectedMarker = selectedMarker else {
        return
      }

      let map = viewController.map
      if map.selectedMarker != selectedMarker {
        map.selectedMarker = selectedMarker
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          map.animate(toZoom: 13)
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            map.animate(with: GMSCameraUpdate.setTarget(selectedMarker.position))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
              map.animate(toZoom: 14)
            })
          }
        }
      }
    }

}

