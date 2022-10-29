@testable import BreweryFinder
import CoreLocation

class SpySearchService: SearchService {
    var breweriesNearWasCalledWithLocation: CLLocationCoordinate2D? = nil
    
    func breweriesNear(location: CLLocationCoordinate2D) async throws -> [Brewery] {
        breweriesNearWasCalledWithLocation = location
        return []
    }
}

struct StubSearchService: SearchService {
    func breweriesNear(location: CLLocationCoordinate2D) async throws -> [Brewery] {
        [.example1, .example2]
    }
}

extension Brewery {
    static var example1: Brewery {
        Brewery(name: "Four Peaks Brewing Co", breweryType: "", street: nil, address2: nil, address3: nil, city: "", state: "", postalCode: "", country: "", longitude: "", latitude: "", phone: nil, websiteUrl: nil)
    }
    
    static var example2: Brewery {
        Brewery(name: "Fate Brewing Co", breweryType: "", street: nil, address2: nil, address3: nil, city: "", state: "", postalCode: "", country: "", longitude: "", latitude: "", phone: nil, websiteUrl: nil)
    }
}
