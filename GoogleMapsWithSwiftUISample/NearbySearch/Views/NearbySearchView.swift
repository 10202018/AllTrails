import SwiftUI

struct NearbySearchView: View {
  @StateObject var viewModel: NearbySearchViewModel

  var body: some View {
    List {
      ForEach(viewModel.places, id:\.self) { place in
        NavigationLink {
          RestaurantDetailView(restaurant: place)
        } label: {
          Text(place.name)
        }
      }
    }
  }
}
  
