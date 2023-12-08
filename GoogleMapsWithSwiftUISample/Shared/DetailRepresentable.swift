import Foundation

/// A required type to which any Restaurant used for presentation in `RestaurantDetailView` must conform.
///
/// This standardization more easily allows for modifications of requirements of the details screen from multiple sources of Restaurants.
protocol DetailRepresentable {
  var name: String { get }
  var formattedAddress: String { get }
  var phoneNumber: String { get }
  var openingHours: [String] { get }
}
