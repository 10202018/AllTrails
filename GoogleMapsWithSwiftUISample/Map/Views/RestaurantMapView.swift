import GoogleMaps
import SwiftUI

struct RestaurantMapView: View {
  @StateObject var restaurantSearchViewModel: RestaurantSearchViewModel
  @State var zoomInCenter: Bool = false
  @State var expandList: Bool = false
  @State var selectedMarker: GMSMarker?
  @State var yDragTranslation: CGFloat = 0
  
  var body: some View {
    
    let scrollViewHeight: CGFloat = 80
    
    GeometryReader { geometry in
      ZStack {
        let diameter = zoomInCenter ? geometry.size.width : (geometry.size.height * 2)
        MapViewControllerBridge(restaurantSearchViewModel: restaurantSearchViewModel, selectedMarker: $selectedMarker)
          .clipShape(
            Circle()
              .size(
                width: diameter,
                height: diameter
              )
              .offset(
                CGPoint(
                  x: (geometry.size.width - diameter) / 2,
                  y: (geometry.size.height - diameter) / 2
                )
              )
          )
          .animation(.easeIn)
          .background(Color(red: 254.0/255.0, green: 1, blue: 220.0/255.0))
        
        RestaurantListForMapView(restaurantSearchViewModel: restaurantSearchViewModel, buttonAction: { marker in
          guard self.selectedMarker != marker else { return }
          self.selectedMarker = marker
          self.zoomInCenter = false
          self.expandList = false
        })
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .offset(
          x: 0,
          y: geometry.size.height - (expandList ? scrollViewHeight + 150 : scrollViewHeight)
        )
        .offset(x: 0, y: self.yDragTranslation)
        .animation(.spring())
        .gesture(
          DragGesture().onChanged { value in
            self.yDragTranslation = value.translation.height
          }.onEnded { value in
            self.expandList = (value.translation.height < -120)
            self.yDragTranslation = 0
          }
        )
      }
    }
  }
}

#Preview {
  RestaurantMapView(restaurantSearchViewModel: RestaurantSearchViewModel())
}
