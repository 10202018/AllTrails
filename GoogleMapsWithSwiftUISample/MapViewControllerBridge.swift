import GoogleMaps
import SwiftUI

struct MapViewControllerBridge: UIViewControllerRepresentable {

  func makeUIViewController(context: Context) -> MapViewController {
    // Replace this line
    return UIViewController() as! MapViewController
  }

  func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
  }
}

