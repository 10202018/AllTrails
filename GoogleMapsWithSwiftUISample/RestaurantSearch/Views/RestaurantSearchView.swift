import SwiftUI
import GooglePlaces

/// The view for Restaurant search queries.
struct RestaurantSearchView: View {
  private enum Field: Int, CaseIterable {
    case restaurantSearch
  }
  
  @State private var searchText: String
  @StateObject private var restaurantSearchViewModel =
    RestaurantSearchViewModel()
  
  /// Tracks which part of the layout should be receiving user input.
  @FocusState private var focusedField: Field?
  
  @State private var rotationAngle = 0.0
  
  init(searchText: String = "") {
    self.searchText = searchText
  }
  
  var body: some View {
    NavigationStack {
      Section(header: VStack {
        Text("Restaurant Search")
          .font(.largeTitle)
          .bold()
          .gradientForeground(colors: [
            Color.blue,
            Color.green
          ])
          .padding(.bottom, 3)
        Text("Search for your favorite restaurants near you!")
          .font(.caption2)
      }
      .padding(.top, 50)
      ) {
        VStack(alignment: .center) {
          TextField(
            "Restaurant search text field",
            text: $searchText,
            prompt: Text("Ex: 'Gracias Madre', or 'Places near Melrose Ave.'"), axis: .vertical
          )
          .foregroundStyle(Color.gray)
          .focused($focusedField, equals: .restaurantSearch)
          .padding([.top, .bottom], 25)
          .padding([.leading, .trailing], 25)
          .frame(alignment: .center)
          .lineLimit(10)
          .font(.headline)
          
          Button("Search") {
            if !searchText.isEmpty {
              self.rotationAngle += 180
              restaurantSearchViewModel.fetchRestaurants(searchText)
              animateRestaurantSearchCard(2.0)
            }
          }
          .bold()
          .frame(width: 200, height: 40)
          .font(.callout)
          .border(.green, width: 3)
          .clipShape(RoundedRectangle(cornerRadius: 16))
          
          Spacer()
          
            NavigationStack {
              List {
                ForEach(restaurantSearchViewModel.places, id: \.self) {
                    restaurant in
                  NavigationLink {
                    RestaurantDetailView(restaurant: restaurant)
                  } label: {
                    Text(restaurant.displayName.text)
                  }
                }
            }
            .tint(Color.gray)
            .listStyle(GroupedListStyle())
            .background(
              RoundedRectangle(cornerRadius: 30)
              // Used to redraw the line
                .stroke(Color.white.opacity(0.5))
              // Added modifiers after the re-draw (above)
                .background(Color.white.opacity(0.5))
                .background(VisualEffectBlur(blurStyle: .systemThinMaterialDark))
                .shadow(color: Color.blue.opacity(0.5), radius: 60, x: 0, y: 0)
            )
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
      
      HStack(alignment: .center, spacing: 150) {
        NavigationLink(destination: RestaurantMapView(restaurantSearchViewModel: restaurantSearchViewModel), label: {
          Image(systemName: "map")
        })
        .font(.title)
        .padding(.bottom, 20)
        
        NavigationLink(destination: FullListView(viewModel: restaurantSearchViewModel), label: {
          Image(systemName: "list.bullet.clipboard")
        })
        .font(.title)
        .padding(.bottom, 20)
      }
    }
    .overlay(
      RoundedRectangle(cornerRadius: 16.0)
        .stroke(Color.white, lineWidth: 0.0)
        .blendMode(.normal)
        .opacity(0.7)
    )
    .rotation3DEffect(
      Angle(degrees: self.rotationAngle),
      axis: (x: 0.0, y: 1.0, z: 0.0)
    )
    .background()
    .cornerRadius(16.0)
  }

  func animateRestaurantSearchCard(_ duration: Double) {
    withAnimation(.easeInOut(duration: duration)) {
      self.rotationAngle = 360
    }
  }
}

extension View {
  public func gradientForeground(colors: [Color]) -> some View {
    self.overlay(LinearGradient(
      colors: colors,
      startPoint: .topLeading,
      endPoint: .bottomTrailing)
    )
    .mask(self)
  }
}
