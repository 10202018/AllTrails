import SwiftUI

struct FullListView: View {
  @StateObject var viewModel: RestaurantSearchViewModel
  
  var body: some View {
    Section(header: VStack {
      Text("Expanded List View")
        .font(.largeTitle)
        .bold()
        .foregroundStyle(Color.white.opacity(0.7))
    }
    .padding(.top, 50)
    ) {
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
}
