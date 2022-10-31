import CoreLocation
import Foundation

/// `Brewery` represents a brewery that has been retrieved from the Open Brewery API.
struct Brewery: Decodable {
    let name: String
    let breweryType: String
    let street: String?
    let address2: String?
    let address3: String?
    let city: String
    let state: String
    let postalCode: String
    let country: String
    let longitude: String
    let latitude: String
    let phone: String?
    let websiteUrl: String?
    
    var location: CLLocation? {
        guard let latitude = Double(latitude), let longitude = Double(longitude) else { return nil }
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}

/// `SearchService` provides an interface for searching for breweries based on location.
protocol SearchService {
    /// Search for breweries near the given location.
    ///
    /// - Parameter location: the location around which to search
    /// - Returns: A list of breweries near the search location
    func breweriesNear(location: CLLocationCoordinate2D) async throws -> [Brewery]
}

protocol URLSessionProtocol {
    func data(for: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

class OpenBreweryDBSearchService: SearchService {
    struct SearchError: Error {
        let message: String
        
        var localizedDescription: String {
            "Error performing search: \(message)"
        }
    }
    
    private let session: URLSessionProtocol
    private let baseURL = URL(string: "https://api.openbrewerydb.org")!
    private let decoder = JSONDecoder()
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func breweriesNear(location: CLLocationCoordinate2D) async throws -> [Brewery] {
        let (data, _) = try await session.data(for: request(path: "/breweries", query: ["by_dist": "\(location.latitude),\(location.longitude)"]))
        
        // it would probably be ideal to check the response code here, but the data should also fail to decode in the case where there's an error, and the user experience will be the same
        
        return try decoder.decode([Brewery].self, from: data)
    }
    
    private func request(path: String, query: [String: String]) throws -> URLRequest {
        guard var urlComponents = URLComponents(url: baseURL.appendingPathComponent("/breweries"), resolvingAgainstBaseURL: false) else {
            throw SearchError(message: "URLComponents could not be built from URL")
        }
        urlComponents.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let url = urlComponents.url else {
            throw SearchError(message: "URLComponents could not be converted to URL")
        }
        return URLRequest(url: url)
    }
}
