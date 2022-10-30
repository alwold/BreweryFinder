@testable import BreweryFinder
import CoreLocation

class SpyLocationService: LocationService {
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    var getLocationWasCalled = false
    var permissionWasRequested = false
    
    func getLocation() async throws -> CLLocationCoordinate2D {
        getLocationWasCalled = true
        return CLLocationCoordinate2D(latitude: -112, longitude: 33)
    }
    
    func requestWhenInUseAuthorization() async -> CLAuthorizationStatus {
        permissionWasRequested = true
        return .authorizedWhenInUse
    }
}

struct StubLocationService: LocationService {
    let authorizationStatus: CLAuthorizationStatus
    let location: CLLocationCoordinate2D
    
    init(authorizationStatus: CLAuthorizationStatus = .authorizedAlways, location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 33, longitude: -112)) {
        self.authorizationStatus = authorizationStatus
        self.location = location
    }
    
    func requestWhenInUseAuthorization() async -> CLAuthorizationStatus {
        .authorizedAlways
    }
    
    func getLocation() async throws -> CLLocationCoordinate2D {
        location
    }
}
