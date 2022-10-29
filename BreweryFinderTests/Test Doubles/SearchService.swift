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
    let breweries: [Brewery]
    
    func breweriesNear(location: CLLocationCoordinate2D) async throws -> [Brewery] {
        breweries
    }
}

extension Brewery {
    static var example1: Brewery {
        exampleBrewery(name: "Four Peaks Brewing Company")
    }
    
    static var example2: Brewery {
        exampleBrewery(name: "Fate Brewing Co")
    }
    
    static func exampleBrewery(name: String, latitude: String = "", longitude: String = "") -> Brewery {
        Brewery(name: name, breweryType: "", street: nil, address2: nil, address3: nil, city: "", state: "", postalCode: "", country: "", longitude: longitude, latitude: latitude, phone: nil, websiteUrl: nil)
    }
}
