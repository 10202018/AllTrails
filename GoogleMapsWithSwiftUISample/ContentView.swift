import GoogleMaps
import SwiftUI

/// App view entry-point.
struct ContentView: View {
  @State private var searchText = "Restaurants near me"
  @ObservedObject var locationManager = LocationManager()
  
  
  //  @State private var showImage = true
  //  @State private var isLoaded = false
  
  let allTrailsImage = "martis-trail"
  let color = UIColor(red:72/255, green: 228/255, blue: 76/255, alpha: 1)
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
      
      // Splash
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
  //    ZStack {
  //        Image(imageName)
  //            .resizable()
  //            .scaledToFit()
  //            .opacity(isLoaded ? 1 : 0)
  //            .scaleEffect(isLoaded ? 5 : 0.001) // Scale down initially
  //            .animation(Animation.bouncy(duration: 8).delay(0.5), value: isLoaded) // Bounce animation
  
  
  
  
  //      Image(imageName)
  //          .resizable()
  //          .scaledToFit()
  //          .transition(.opacity) // Fade out transition
  //          .animation(.easeIn(duration: 1)) // Fade animation
  //    .onAppear {
  ////      isLoaded = true  Trigger animation on app launch
  //      DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // Delay for animation duration
  //        showImage = false // Remove image after delay
  //      }
  //    }
  
  
  
  
  
  
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
}
