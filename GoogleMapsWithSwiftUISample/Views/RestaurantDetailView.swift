import SwiftUI

/// A shared view for the presentation of restaurant details used by concrete types conforming to
/// `DetailRepresentable`.
struct RestaurantDetailView<T: DetailRepresentable>: View {
  let restaurant: T
  
  var body: some View {
    VStack(spacing: 10) {
      Text(restaurant.name)
        .font(.system(size: 50, weight: .bold))
        .bold()
        .padding()
        .lineLimit(nil)
      
      Text(restaurant.formattedAddress)
        .font(.title2)

      Link(
        restaurant.phoneNumber,
        destination: URL(string: "tel:\(restaurant.phoneNumber)")!
      )
      .font(.title2)
      .padding(.bottom, 30)
      
      Text("Hours of Operation")
        .font(.title2)
      
      ForEach(restaurant.openingHours, id: \.self) { dayHours in
        Text(dayHours)
          .padding(.bottom, 5)
          .font(.callout)
      }
      
      Spacer()
    }
    .multilineTextAlignment(.center)
    .padding()
    .textSelection(.enabled)
  }
}
