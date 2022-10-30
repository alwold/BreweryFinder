@testable import BreweryFinder
import CoreLocation
import XCTest

class MainNavigationControllerTests: XCTestCase {
    // the three part test naming used in these tests is based on Jon Reid's suggested convention:
    // https://qualitycoding.org/unit-test-naming/

    func test_findMyLocationButton_whenAuthorizationStatusNotDetermined_promptsForLocationPermission() async {
        let locationService = MockLocationService()
        let sut = await MainNavigationController(locationService: locationService)
        
        await sut.findByLocationButtonTapped()
        
        print("checking if permission requested")
        XCTAssertTrue(locationService.permissionWasRequested)
    }
}

class MockLocationService: LocationService {
    func getLocation() async throws -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: -112, longitude: 33)
    }
    
    var permissionWasRequested = false
    
    let authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    func requestWhenInUseAuthorization() async -> CLAuthorizationStatus {
        print("requesting permission")
        permissionWasRequested = true
        return .authorizedWhenInUse
    }
}
