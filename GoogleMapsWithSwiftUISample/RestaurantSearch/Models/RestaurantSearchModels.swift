import Foundation

// MARK: RestaurantSearch Request
struct RestaurantSearchRequestBody: Codable {
  let textQuery: String
}

// MARK: RestaurantSearch Response
struct RestaurantSearchResponse: Hashable, Codable  {
  var places: [RestaurantSearchPlace]
  
  static func == (lhs: RestaurantSearchResponse, rhs: RestaurantSearchResponse) -> Bool {
    lhs.places == rhs.places
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(places.description.utf8CString)
  }
}

/// A model representing places used for viewing on map.
struct RestaurantSearchPlace: Codable, Hashable, DetailRepresentable {
  let formattedAddress: String
  let displayName: RestaurantSearchDisplayName
  let nationalPhoneNumber: String?
  let currentOpeningHours: RestaurantSearchCurrentOpeningHours?
  var latitude: Double?
  var longitude: Double?

  var name: String {
    displayName.text
  }
  
  var phoneNumber: String {
    return nationalPhoneNumber ?? ""
  }
  
  var openingHours: [String] {
    return currentOpeningHours?.weekdayDescriptions ?? [""]
  }
  
  static func == (lhs: RestaurantSearchPlace, rhs: RestaurantSearchPlace) -> Bool {
    lhs.formattedAddress == rhs.formattedAddress
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(formattedAddress)
  }
}

struct RestaurantSearchDisplayName: Codable {
  let text: String
  let languageCode: RestaurantSearchLanguageCode
}

struct RestaurantSearchCurrentOpeningHours: Codable {
  let openNow: Bool
  let periods: [RestaurantSearchPeriods]
  let weekdayDescriptions: [String]
}

struct RestaurantSearchPeriods: Codable {
  let open: RestaurantSearchPeriodDetails
  let close: RestaurantSearchPeriodDetails
}

struct RestaurantSearchPeriodDetails: Codable {
  let day: Int
  let hour: Int
  let minute: Int
  let date: RestaurantSearchDatePeriod
}

struct RestaurantSearchDatePeriod: Codable {
  let year: Int
  let month: Int
  let day: Int
}

enum RestaurantSearchLanguageCode: String, Codable {
  case en = "en"
  case es = "es"
  case usa = "usa"
  case fr = "fr"
}
