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
        let searchService = StubSearchService(breweries: [.example1])
        let viewModel = NearbyBreweriesViewModel(locationService: locationService, searchService: searchService)
        
        let expectation = expectation(description: "breweriesUpdated")
        
        var breweriesUpdatedReceivedEvent = false
        let cancellable = viewModel.breweriesUpdated.sink { _ in
            breweriesUpdatedReceivedEvent = true
            expectation.fulfill()
        }

        await viewModel.viewDidAppear()
        
        await waitForExpectations(timeout: 1)
        
        XCTAssert(breweriesUpdatedReceivedEvent)

    }
    
    func test_table_hasARowForEachBrewery() async {
        let locationService = StubLocationService(location: CLLocationCoordinate2D(latitude: -112.123, longitude: 33.456))
        let searchService = StubSearchService(breweries: [.example1, .example2])
        let viewModel = NearbyBreweriesViewModel(locationService: locationService, searchService: searchService)
        await viewModel.viewDidAppear()
        
        let rows = viewModel.numberOfRows(in: 0)
        
        XCTAssertEqual(rows, 2)
    }
    
    func test_table_showsTheNameOfTheBrewery() async {
        let locationService = StubLocationService(location: CLLocationCoordinate2D(latitude: -112.123, longitude: 33.456))
        let searchService = StubSearchService(breweries: [.exampleBrewery(name: "Four Peaks"), .exampleBrewery(name: "Fate")])
        let viewModel = NearbyBreweriesViewModel(locationService: locationService, searchService: searchService)
        await viewModel.viewDidAppear()
        
        XCTAssertEqual(viewModel.label(row: 0), "Four Peaks")
    }
}
