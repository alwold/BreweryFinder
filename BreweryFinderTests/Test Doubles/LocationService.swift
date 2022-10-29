@testable import BreweryFinder
import CoreLocation

class SpyLocationService: LocationService {
    var authorizationStatus: CLAuthorizationStatus = .authorizedAlways
    var getLocationWasCalled = false
    
    func getLocation() async throws -> CLLocationCoordinate2D {
        getLocationWasCalled = true
        return CLLocationCoordinate2D(latitude: -112, longitude: 33)
    }
    
    func requestWhenInUseAuthorization() async -> CLAuthorizationStatus {
        return .authorizedAlways
    }
}

struct StubLocationService: LocationService {
    let authorizationStatus: CLAuthorizationStatus = .authorizedAlways
    let location: CLLocationCoordinate2D
    
    func requestWhenInUseAuthorization() async -> CLAuthorizationStatus {
        .authorizedAlways
    }
    
    func getLocation() async throws -> CLLocationCoordinate2D {
        location
    }
}
