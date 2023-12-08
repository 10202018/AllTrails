import GoogleMaps
import SwiftUI

// MARK: - NearbySearch Request
struct NearbySearchRequestBody: Codable {
    let includedTypes: [String]
    let maxResultCount: Int
    let locationRestriction: LocationRestriction
}

struct LocationRestriction: Codable {
    let circle: Circle
}

struct Circle: Codable {
    let center: Coordinate
    let radius: Double
}

struct Coordinate: Codable {
    let latitude: Double
    let longitude: Double
}

// MARK: - NearbySearch Response
struct NearbySearchResponse: Hashable, Codable {
  static func == (lhs: NearbySearchResponse, rhs: NearbySearchResponse) -> Bool {
    lhs.places == rhs.places
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(places.description.utf8CString)
  }
  
  var places: [NearbySearchPlaces]
}

struct NearbySearchPlaces: Codable, Hashable, DetailRepresentable {
  let displayName: NearbySearchDisplayName
  let formattedAddress: String
  let nationalPhoneNumber: String?
  let currentOpeningHours: NearbySearchCurrentOpeningHours?
  let rating: Double
  
  var name: String {
    displayName.text
  }

  var phoneNumber: String {
    return nationalPhoneNumber ?? ""
  }
  
  var openingHours: [String] {
    return currentOpeningHours?.weekdayDescriptions ?? [""]
  }

  static func == (lhs: NearbySearchPlaces, rhs: NearbySearchPlaces) -> Bool {
    lhs.formattedAddress == rhs.formattedAddress
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(formattedAddress)
  }
}

struct NearbySearchDisplayName: Codable {
    let text: String
    let languageCode: LanguageCode
}

struct NearbySearchCurrentOpeningHours: Codable {
  let openNow: Bool
  let periods: [NearbySearchPeriods]
  let weekdayDescriptions: [String]
}

struct NearbySearchPeriods: Codable {
  let open: NearbySearchPeriodDetails
  let close: NearbySearchPeriodDetails
}

struct NearbySearchPeriodDetails: Codable {
  let day: Int
  let hour: Int
  let minute: Int
  let date: NearbySearchDatePeriod
}

struct NearbySearchDatePeriod: Codable {
  let year: Int
  let month: Int
  let day: Int
}

enum LanguageCode: String, Codable {
    case en = "en"
}

struct AddressComponent: Codable {
    let longName, shortName: String
    let types: [String]

    enum CodingKeys: String, CodingKey {
        case longName = "long_name"
        case shortName = "short_name"
        case types
    }
}

struct ResultGeometry: Codable {
    let location: Location
    let locationType: String
    let viewport: Viewport

    enum CodingKeys: String, CodingKey {
        case location
        case locationType = "location_type"
        case viewport
    }
}

struct Location: Codable {
    let lat, lng: Double
}

struct Viewport: Codable {
    let northeast, southwest: Location
}

struct PlusCode: Codable {
    let compoundCode, globalCode: String

    enum CodingKeys: String, CodingKey {
        case compoundCode = "compound_code"
        case globalCode = "global_code"
    }
}
