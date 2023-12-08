import SwiftUI
import GooglePlaces
import GoogleMaps

struct RestaurantSearchView: View {
  private enum Field: Int, CaseIterable {
    case restaurantSearch
  }
  
  @State private var searchText = ""
  @StateObject private var viewModel = RestaurantSearchViewModel()
  @FocusState private var focusedField: Field?
  
  var body: some View {
    Section(header: VStack {
      Text("Restaurant Search")
        .font(.largeTitle)
        .padding(.bottom, 3)
      Text("Search for your favorite restaurants near you!")
        .font(.caption2)
    }
      .listRowInsets(EdgeInsets(
        top: 0,
        leading: 0,
        bottom: 0,
        trailing: 0))
    ) {
      VStack(alignment: .center) {
        TextField("Restaurant search text field", text: $searchText, prompt: Text("Ex: 'Gracias Madre', or 'Places near Melrose Ave.'"), axis: .vertical)
          .focused($focusedField, equals: .restaurantSearch)
          .padding([.top, .bottom], 25)
          .frame(alignment: .center)
          .lineLimit(10)
        
        Button("Search") {
          if !searchText.isEmpty {
            viewModel.fetchRestaurants(searchText)
          }
        }
        .padding()
        
        Spacer()
        
        NavigationStack {
          List {
            ForEach(viewModel.places, id: \.self) { restaurant in
              NavigationLink {
                RestaurantDetailView(restaurant: restaurant)
              } label: {
                Text(restaurant.displayName.text)
              }
            }
          }
        }
      }
      .toolbar {
        ToolbarItem(placement: .keyboard) {
          Button("Done") {
            focusedField = nil
          }
        }
      }
      
    }
    .headerProminence(.increased)
  }
}
