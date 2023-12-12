import GoogleMaps
import SwiftUI
import UIKit

/// A UIViewController object containing a Google Map (`GMSMapView`).
class MapViewController: UIViewController {

  let map =  GMSMapView(frame: .zero)
  var isAnimating: Bool = false

  override func loadView() {
    super.loadView()
    self.view = map
  }
}
