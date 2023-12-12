import Foundation
import GoogleMaps
import Combine

// MARK: GeoCoding NearbyPlace
struct NearbyPlace: Codable {
  var name: String
  var placeId: String
  var geometry: Geometry
  var vicinity: String?
  var latitude: Double?
  var longitude: Double?
}

struct Geometry: Codable {
  var location: GeoCoordinate
}

struct GeoCoordinate: Codable {
  var lat: Double
  var lng: Double
}

// MARK: GeoCoding Response
struct GeoCodingResponse: Codable {
  let results: [Result]
  let status: String
}

struct Result: Codable {
  let addressComponents: [AddressComponent]
  let formattedAddress: String
  let geometry: ResultGeometry
  let placeID: String
//  let plusCode: PlusCode
  let types: [String]
  
  enum CodingKeys: String, CodingKey {
    case addressComponents = "address_components"
    case formattedAddress = "formatted_address"
    case geometry
    case placeID = "place_id"
//    case plusCode = "plus_code"
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

struct PlusCode: Codable {
  let compoundCode, globalCode: String
  
  enum CodingKeys: String, CodingKey {
    case compoundCode = "compound_code"
    case globalCode = "global_code"
  }
}

struct PlaceWithCoordinates {
//  let place: NearbySearchPlaces
  let latitude: Double
  let longitude: Double
}

class GeocodingSearchViewModel: ObservableObject {
  // TODO: Consolidate GeocodingSearchViewModel and RestaurantSearchViewModel
  @Published private var markers: [GMSMarker] = []
  private var restaurantSearchViewModel = RestaurantSearchViewModel()
  
  func fetchGeocodes() {
    // TODO: make api key globally available
    let apiKey = "AIzaSyDdzaiCLCaf_tiNEcoQSoJnb5hFZj6PUeY"
    var placesWithCoordinates = [PlaceWithCoordinates]()
    
    for place in restaurantSearchViewModel.places {
//      guard place.latitude == nil || place.longitude == nil else { continue }
      let geocodingURL = URL(string: "https://maps.googleapis.com/maps/api/geocode/json?address=\(place.formattedAddress)&key=\(apiKey)")!
      
      let task = URLSession.shared.dataTask(with: geocodingURL) { data, response, error in
        if let error = error {
          print("Error: \(error)")
          return
        }
        
        guard let data = data else {
          print("No data received")
          return
        }
        
//        let printableData = String(decoding: data, as: UTF8.self)
//        print(printableData)
        
        
        do {
          let jsonDecoder = JSONDecoder()
          let geocodingResponse = try jsonDecoder.decode(GeoCodingResponse.self, from: data)
          
//          print("How many results are there? \(geocodingResponse.results.count)")
          
          for result in geocodingResponse.results {
            let coordinate = result.geometry.location
            var updatedPlace = place
            updatedPlace.latitude = coordinate.lat
            updatedPlace.longitude = coordinate.lng
            print("ORIGINAL PLACE'S FORMATTED ADDRESS: \(result.formattedAddress) \n vs. UPDATED PLACE'S FORMATTED ADDRESS: \(updatedPlace.formattedAddress)")

            DispatchQueue.main.async {
              self.restaurantSearchViewModel.places = self.restaurantSearchViewModel.places.map { $0.formattedAddress == updatedPlace.formattedAddress ? updatedPlace : $0 }
//              self.updateMarkers(with: self.restaurantSearchViewModel.places)
            }
            
            
            
            
            
            
          }
//
//          if let geocodingResult = geocodingResponse.results.first {
//            let coordinate = geocodingResult.geometry.location
//            let placeWithCoordinates = PlaceWithCoordinates(place: place, latitude: coordinate.lat, longitude: coordinate.lng)
//            placesWithCoordinates.append(placeWithCoordinates)
//          }
        } catch {
          print("Error decoding JSON: \(error)")
        }
      }
      
      task.resume()
    }
  }
  self.places = placesWithCoordinates

  private func updateMarkers(with places: [RestaurantSearchPlace]) {
      var updatedMarkers = [GMSMarker]()
      for place in places {
          guard let latitude = place.latitude, let longitude = place.longitude else { continue }
          let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
          marker.title = place.name
          marker.snippet = place.formattedAddress
          updatedMarkers.append(marker)
      }
      self.markers = updatedMarkers
  }
}
