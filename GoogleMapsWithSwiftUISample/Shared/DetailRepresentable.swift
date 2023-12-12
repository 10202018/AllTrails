import Foundation

/// A required type to which any Restaurant used for presentation in `RestaurantDetailView` must
/// conform.
///
/// Adds clear extensibility for future modifications of requirements of the details screen (ie: from multiple API
/// sources).
protocol DetailRepresentable {
  var name: String { get }
  var formattedAddress: String { get }
  var phoneNumber: String { get }
  var openingHours: [String] { get }
}
