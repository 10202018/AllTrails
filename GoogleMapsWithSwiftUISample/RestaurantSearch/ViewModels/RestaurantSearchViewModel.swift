import Foundation
import GoogleMaps

class RestaurantSearchViewModel: ObservableObject {
  // TODO: add all properties up top
  @Published var markers: [GMSMarker] = []
  @Published var places: [RestaurantSearchPlace] = []
  
  func fetchRestaurants(_ textQuery: String) {
    let baseUrl = "https://places.googleapis.com/v1/places:searchText"
    let apiKey = "AIzaSyDdzaiCLCaf_tiNEcoQSoJnb5hFZj6PUeY"
    
    let requestBody = RestaurantSearchRequestBody(textQuery: textQuery)
    
    let jsonData = try! JSONEncoder().encode(requestBody)
    
    var request = URLRequest(url: URL(string: baseUrl)!)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue(apiKey, forHTTPHeaderField: "X-Goog-Api-Key")
    request.addValue("places.displayName", forHTTPHeaderField: "X-Goog-FieldMask")
    request.addValue("places.formattedAddress", forHTTPHeaderField: "X-Goog-FieldMask")
    request.addValue("places.nationalPhoneNumber", forHTTPHeaderField: "X-Goog-FieldMask")
    request.addValue("places.currentOpeningHours", forHTTPHeaderField: "X-Goog-FieldMask")
    request.httpBody = jsonData
    
    let restaurantSearchTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
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

  func fetchGeocodes() {
    // TODO: make api key globally available
    let apiKey = "AIzaSyDdzaiCLCaf_tiNEcoQSoJnb5hFZj6PUeY"
    var placesWithCoordinates = [PlaceWithCoordinates]()
    
    for place in places {
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
        
        do {
          let jsonDecoder = JSONDecoder()
          let geocodingResponse = try jsonDecoder.decode(GeoCodingResponse.self, from: data)
          
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
          guard let latitude = place.latitude, let longitude = place.longitude else { continue }
          let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
          marker.title = place.name
          marker.snippet = place.formattedAddress
          updatedMarkers.append(marker)
      }
      self.markers = updatedMarkers
  }
  
}
