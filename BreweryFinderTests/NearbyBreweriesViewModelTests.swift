@testable import BreweryFinder
import CoreLocation
import XCTest

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

final class NearbyBreweriesViewModelTests: XCTestCase {
    func test_appear_requestsLocation() async {
        let locationService = SpyLocationService()
        let viewModel = NearbyBreweriesViewModel(locationService: locationService)
        
        await viewModel.viewDidAppear()
        
        XCTAssert(locationService.getLocationWasCalled)
    }
    
    func test_appear_searchesForBreweries() async {
        let locationService = StubLocationService(location: CLLocationCoordinate2D(latitude: -112.123, longitude: 33.456))
        let searchService = SpySearchService()
        let viewModel = NearbyBreweriesViewModel(locationService: locationService, searchService: searchService)
        
        await viewModel.viewDidAppear()
        
        XCTAssertEqual(searchService.breweriesNearWasCalledWithLocation?.latitude, -112.123)
        XCTAssertEqual(searchService.breweriesNearWasCalledWithLocation?.longitude, 33.456)
    }
    
    func test_appear_whenBreweriesUpdated_refreshesTable() async {
        let locationService = StubLocationService(location: CLLocationCoordinate2D(latitude: -112.123, longitude: 33.456))
        let searchService = StubSearchService()
        let viewModel = NearbyBreweriesViewModel(locationService: locationService, searchService: searchService)
        
        let expectation = expectation(description: "breweriesWerUpdated")
        
        var breweriesUpdatedReceivedEvent = false
        let cancellable = viewModel.breweriesUpdated.sink { _ in
            breweriesUpdatedReceivedEvent = true
            expectation.fulfill()
        }

        await viewModel.viewDidAppear()
        
        await waitForExpectations(timeout: 1)
        
        XCTAssert(breweriesUpdatedReceivedEvent)

    }
}
