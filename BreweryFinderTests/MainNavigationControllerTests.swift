@testable import BreweryFinder
import CoreLocation
import XCTest

class MainNavigationControllerTests: XCTestCase {
    // the three part test naming used in these tests is based on Jon Reid's suggested convention:
    // https://qualitycoding.org/unit-test-naming/

    func test_findMyLocationButton_whenAuthorizationStatusNotDetermined_promptsForLocationPermission() {
        let locationService = MockLocationService()
        let sut = MainNavigationController(locationService: locationService)
        
        sut.findByLocationButtonTapped()
        
        print("checking if permission requested")
        XCTAssertTrue(locationService.permissionWasRequested)
    }
}

class MockLocationService: LocationService {
    var permissionWasRequested = false
    
    let authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    func requestWhenInUseAuthorization() async {
        print("requesting permission")
        permissionWasRequested = true
    }
}
