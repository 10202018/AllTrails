import Foundation

// MARK: GeoCoding Response
struct GeocodingResponse: Codable {
  let results: [Result]
  let status: String
}

struct Result: Codable {
  let addressComponents: [AddressComponent]
  let formattedAddress: String
  let geometry: ResultGeometry
  let placeID: String
  let types: [String]
  
  enum CodingKeys: String, CodingKey {
    case addressComponents = "address_components"
    case formattedAddress = "formatted_address"
    case geometry
    case placeID = "place_id"
    case types
  }
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
