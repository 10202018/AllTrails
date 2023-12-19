import SwiftUI
import GoogleMaps

/// View for list of Restaurants in MapView.
///
/// Presented in Z-Stack on top of GMSMapView.
struct RestaurantListForMapView: View {
  @StateObject var restaurantSearchViewModel: RestaurantSearchViewModel
  
    var buttonAction: (GMSMarker) -> Void
  
    var body: some View {
      GeometryReader { geometry in
          List {
            ForEach(self.restaurantSearchViewModel.markers, id: \.self) { marker in
              Button(action: {
                buttonAction(marker)
              }) {
                Text(marker.title ?? "")
              }
            }
          }
          .frame(maxWidth: .infinity)
        }
      }
}
