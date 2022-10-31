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
    
    static func exampleBrewery(name: String, breweryType: String = "", street: String? = nil, address2: String? = nil, address3: String? = nil, city: String = "", state: String = "", postalCode: String = "", latitude: String = "", longitude: String = "", phone: String? = nil) -> Brewery {
        Brewery(name: name, breweryType: breweryType, street: street, address2: address2, address3: address3, city: city, state: state, postalCode: postalCode, country: "", longitude: longitude, latitude: latitude, phone: phone, websiteUrl: nil)
    }
}
