import GoogleMaps
import SwiftUI

/// App view entry-point.
struct ContentView: View {
  @State private var searchText = "Restaurants near me"
  @ObservedObject var locationManager = LocationManager()
  
  var body: some View {
    NavigationStack {
          RestaurantSearchView(searchText: searchText)
    }
    .onAppear {
      locationManager.requestLocationPermissions()
    }
  }
  
  struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      ContentView()
    }
  }
}
