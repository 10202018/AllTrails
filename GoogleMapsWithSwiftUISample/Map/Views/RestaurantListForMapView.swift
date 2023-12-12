import SwiftUI
import GoogleMaps

struct RestaurantListForMapView: View {
  @StateObject var restaurantSearchViewModel: RestaurantSearchViewModel
  
    var buttonAction: (GMSMarker) -> Void
//    var handleAction: () -> Void
  
    var body: some View {
          GeometryReader { geometry in
              // List of Restaurants
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

//#Preview {
//    RestaurantListForMapView()
//}
