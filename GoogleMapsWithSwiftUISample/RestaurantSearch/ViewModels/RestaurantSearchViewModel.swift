import Foundation

class RestaurantSearchViewModel: ObservableObject {
  // TODO: add all properties up top
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
  
  
}
