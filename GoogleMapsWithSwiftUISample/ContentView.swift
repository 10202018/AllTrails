import GoogleMaps
import SwiftUI

/// App view entry-point.
struct ContentView: View {
  @State private var searchText = "Restaurants near me"
  @ObservedObject var locationManager = LocationManager()
  
  let allTrailsImage = "martis-trail"
  
  let color = UIColor(
    red:72/255, green: 228/255, blue: 76/255, alpha: 1
  )
  @State var animate: Bool = false
  @State var showSplash: Bool = true
  
  var body: some View {
    VStack {
      ZStack {
        
        // Content
        ZStack {
          NavigationStack {
            RestaurantSearchView(searchText: searchText)
          }
          .onAppear {
            locationManager.requestLocationPermissions()
          }
        }
        
        // AllTrails Image Splash
        ZStack {
          Color(color)
          
          Image(allTrailsImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 185, height: 185)
            .scaleEffect(animate ? 7 : 1.0)
            .animation(Animation.bouncy(duration: 3.5, extraBounce: 0.15))
        }
        .ignoresSafeArea()
        .animation(.default)
        .opacity(showSplash ? 1 : 0)
      }
    }
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now()) {
        animate.toggle()
      }
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
        showSplash.toggle()
      }
    }
  }
}
