import Foundation
import Combine

public protocol RestaurantSearchServiceDataPublisher {
  func publisher() -> AnyPublisher<Data, URLError>
}
