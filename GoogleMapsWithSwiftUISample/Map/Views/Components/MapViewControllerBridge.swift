import GoogleMaps
import SwiftUI

/// A structure that bridges a UIKit view to a SwiftUI view.
///
/// This is the class that will make MapViewController accessible in SwiftUI.
struct MapViewControllerBridge: UIViewControllerRepresentable {
  @StateObject var restaurantSearchViewModel: RestaurantSearchViewModel
  @Binding var selectedMarker: GMSMarker?
  @ObservedObject var locationManager = LocationManager()

  private let zoom: Float = 15.0

  func makeUIViewController(context: Context) -> MapViewController {
      restaurantSearchViewModel.fetchGeocodes()
      locationManager.requestLocationPermissions()
      return MapViewController()
  }

  func updateUIViewController(
    _ uiViewController: MapViewController,
    context: Context
  ) {
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
          DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            map.animate(
              with: GMSCameraUpdate.setTarget(selectedMarker.position)
            )
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
              map.animate(toZoom: 14)
            })
          }
        }
      }
    }

}

