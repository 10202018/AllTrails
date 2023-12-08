import GoogleMaps
import SwiftUI

class NearbySearchViewModel: ObservableObject {
  @Published var places: [NearbySearchPlaces] = []

  func getNearbyPlaces() {
    let baseUrl = "https://places.googleapis.com/v1/places:searchNearby"
    let apiKey = "AIzaSyDdzaiCLCaf_tiNEcoQSoJnb5hFZj6PUeY"

    let location = CLLocationCoordinate2D(latitude: 37.7937, longitude: -122.3965)
    let radius = 500.0

    let requestBody = NearbySearchRequestBody(
        includedTypes: ["restaurant"],
        maxResultCount: 20,
        locationRestriction: LocationRestriction(
            circle: Circle(
                center: Coordinate(latitude: location.latitude, longitude: location.longitude),
                radius: radius
            )
        )
    )

    let jsonData = try! JSONEncoder().encode(requestBody)

    var request = URLRequest(url: URL(string: baseUrl)!)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue(apiKey, forHTTPHeaderField: "X-Goog-Api-Key")
    request.addValue("places.displayName", forHTTPHeaderField: "X-Goog-FieldMask")
    request.addValue("places.formattedAddress", forHTTPHeaderField: "X-Goog-FieldMask")
    request.addValue("places.nationalPhoneNumber", forHTTPHeaderField: "X-Goog-FieldMask")
    request.addValue("places.currentOpeningHours", forHTTPHeaderField: "X-Goog-FieldMask")
    request.addValue("places.rating", forHTTPHeaderField: "X-Goog-FieldMask")
    request.httpBody = jsonData

    let nearbyPlacesTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
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
          let nearbySearchResponse: NearbySearchResponse = try jsonDecoder.decode(NearbySearchResponse.self, from: data)
          
          var topRatedPlaces = [NearbySearchPlaces]()
          for place in nearbySearchResponse.places {
            if place.rating >= 4.0 {
              topRatedPlaces.append(place)
            }
          }

          DispatchQueue.main.async {
            self?.places = topRatedPlaces
          }
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
    nearbyPlacesTask.resume()
  }
}
