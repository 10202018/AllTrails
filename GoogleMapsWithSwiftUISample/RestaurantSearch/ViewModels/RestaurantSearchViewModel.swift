import Foundation
import GoogleMaps

/// Presentation logic for the view of Restaurant search queries
class RestaurantSearchViewModel: ObservableObject {
  /// Change-announcing representation for single locations on the map.
  @Published var markers: [GMSMarker] = []
  
  @Published var places: [RestaurantSearchPlace] = []
  
  private let apiKey = "AIzaSyDdzaiCLCaf_tiNEcoQSoJnb5hFZj6PUeY"
  
  /// Fetches list of restaurants via Google Places API.
  ///
  /// Parameter: - `textQuery` value passed from search text field
  func fetchRestaurants(_ textQuery: String) {
    let baseUrl = "https://places.googleapis.com/v1/places:searchText"
    
    let requestBody = RestaurantSearchRequestBody(textQuery: textQuery)
    
    let jsonData = try! JSONEncoder().encode(requestBody)
    
    var request = URLRequest(url: URL(string: baseUrl)!)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue(apiKey, forHTTPHeaderField: "X-Goog-Api-Key")
    request.addValue(
      "places.displayName",
      forHTTPHeaderField: "X-Goog-FieldMask"
    )
    request.addValue(
      "places.formattedAddress",
      forHTTPHeaderField: "X-Goog-FieldMask"
    )
    request.addValue(
      "places.nationalPhoneNumber",
      forHTTPHeaderField: "X-Goog-FieldMask"
    )
    request.addValue(
      "places.currentOpeningHours",
      forHTTPHeaderField: "X-Goog-FieldMask"
    )
    request.httpBody = jsonData
    
    let restaurantSearchTask = URLSession.shared.dataTask(with: request) {
        [weak self] data, response, error in
      if let error = error {
        print("Error: \(error)")
        return
      }
      
      guard let data = data else {
        print("No data received")
        return
      }
      
      do {
        let jsonDecoder = JSONDecoder()
        let restaurantSearchResponse: RestaurantSearchResponse = try jsonDecoder.decode(RestaurantSearchResponse.self, from: data)
        DispatchQueue.main.async {
          self?.places = restaurantSearchResponse.places
        }
      } catch {
        print("Error decoding JSON: \(error)")
      }
    }
    restaurantSearchTask.resume()
  }
  
  /// Fetches forward-geocodes via call to Google Maps API.
  func fetchGeocodes() {
    for place in places {
      let geocodingURL = URL(string: "https://maps.googleapis.com/maps/api/geocode/json?address=\(place.formattedAddress)&key=\(apiKey)")!
      
      let task = URLSession.shared.dataTask(with: geocodingURL) {
          data, response, error in
        if let error = error {
          print("Error: \(error)")
          return
        }
        
        guard let data = data else {
          print("No data received")
          return
        }
        
        do {
          let jsonDecoder = JSONDecoder()
          let geocodingResponse = 
            try jsonDecoder.decode(GeocodingResponse.self, from: data)
          
          for result in geocodingResponse.results {
            let coordinate = result.geometry.location
            var updatedPlace = place
            updatedPlace.latitude = coordinate.lat
            updatedPlace.longitude = coordinate.lng
            
            DispatchQueue.main.async {
              self.places = self.places.map { $0.formattedAddress == updatedPlace.formattedAddress ? updatedPlace : $0 }
              self.updateMarkers(with: self.places)
            }
          }
        } catch {
          print("Error decoding JSON: \(error)")
        }
      }
      
      task.resume()
    }
  }
  
  private func updateMarkers(with places: [RestaurantSearchPlace]) {
    var updatedMarkers = [GMSMarker]()
    for place in places {
      guard 
          let latitude = place.latitude,
          let longitude = place.longitude 
      else {
        continue
      }
      
      let marker = GMSMarker(position:
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
      )
      marker.title = place.name
      marker.snippet = place.formattedAddress
      updatedMarkers.append(marker)
    }
    self.markers = updatedMarkers
  }
}
