import SwiftUI
import GooglePlaces

/// The view for Restaurant search queries.
struct RestaurantSearchView: View {
  private enum Field: Int, CaseIterable {
    case restaurantSearch
  }
  
  @State private var searchText: String
  @StateObject private var restaurantSearchViewModel = RestaurantSearchViewModel()
  
  /// Tracks which part of the layout should be receiving user input.
  @FocusState private var focusedField: Field?
  
  init(searchText: String = "") {
    self.searchText = searchText
  }
  
  var body: some View {
    NavigationStack {
      Section(header: VStack {
        Text("Restaurant Search")
          .font(.largeTitle)
          .bold()
          .padding(.bottom, 3)
        Text("Search for your favorite restaurants near you!")
          .font(.caption2)
      }
      .padding(.top, 50)
      ) {
        VStack(alignment: .center) {
          TextField("Restaurant search text field", text: $searchText, prompt: Text("Ex: 'Gracias Madre', or 'Places near Melrose Ave.'"), axis: .vertical)
            .focused($focusedField, equals: .restaurantSearch)
            .padding([.top, .bottom], 25)
            .frame(alignment: .center)
            .lineLimit(10)
          
          Button("Search") {
            if !searchText.isEmpty {
              restaurantSearchViewModel.fetchRestaurants(searchText)
            }
          }
          .padding()
          
          Spacer()
          
          NavigationStack {
            List {
              ForEach(restaurantSearchViewModel.places, id: \.self) { restaurant in
                NavigationLink {
                  RestaurantDetailView(restaurant: restaurant)
                } label: {
                  Text(restaurant.displayName.text)
                }
              }
            }
          }
        }
        .onAppear(perform: {
          restaurantSearchViewModel.fetchRestaurants(searchText)
        })
        .toolbar {
          ToolbarItem(placement: .keyboard) {
            Button("Done") {
              focusedField = nil
            }
          }
        }
        
      }
      .headerProminence(.increased)
      
      HStack {
        NavigationLink(destination: RestaurantMapView(restaurantSearchViewModel: restaurantSearchViewModel), label: {
          Image(systemName: "magnifyingglass.circle.fill")
        })
        .font(.title)
        .padding(.bottom, 20)
        
        NavigationLink(destination: Text("Placeholder GeocodedMapView"), label: {
          Image(systemName: "magnifyingglass.circle")
        })
        .font(.title)
        .padding(.bottom, 20)
      }
    }
  }
}
