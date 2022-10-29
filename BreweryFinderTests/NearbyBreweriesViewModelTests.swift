@testable import BreweryFinder
import CoreLocation
import XCTest

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
