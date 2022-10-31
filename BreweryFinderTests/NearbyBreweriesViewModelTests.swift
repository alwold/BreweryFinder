@testable import BreweryFinder
import CoreLocation
import MapKit
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
    
    func test_table_showsNameTypeAndDistance() async {
        let locationService = StubLocationService(location: CLLocationCoordinate2D(latitude: 33.456, longitude: -112.123))
        let searchService = StubSearchService(breweries: [.exampleBrewery(name: "Four Peaks", breweryType: "large", latitude: "33.419396", longitude: "-111.915975"), .exampleBrewery(name: "Fate")])
        let viewModel = NearbyBreweriesViewModel(locationService: locationService, searchService: searchService)
        await viewModel.viewDidAppear()
        
        let nearbyBrewery = viewModel.nearbyBrewery(at: 0)
        XCTAssertEqual(nearbyBrewery.name, "Four Peaks")
        XCTAssertEqual(nearbyBrewery.type, "large")
        XCTAssertEqual(nearbyBrewery.distance, "12 miles away")
    }
    
    func test_mapAnnotations_showBreweriesThatHaveCoordinates() async {
        let locationService = StubLocationService(location: CLLocationCoordinate2D(latitude: -112.123, longitude: 33.456))
        let searchService = StubSearchService(
            breweries: [
                .exampleBrewery(name: "Four Peaks", latitude: "-112.456", longitude: "33.789"),
                .exampleBrewery(name: "Fate", latitude: "-113", longitude: "34"),
                .exampleBrewery(name: "Unknown Location", latitude: "", longitude: "")
            ])
        let viewModel = NearbyBreweriesViewModel(locationService: locationService, searchService: searchService)
        var receivedAnnotations: [MKAnnotation]?
        let expectation = expectation(description: "wait for map annotations")
        let cancellable = viewModel.mapAnnotations.sink { annotations in
            receivedAnnotations = annotations
            expectation.fulfill()
        }

        await viewModel.viewDidAppear()
        
        await waitForExpectations(timeout: 1)
        
        XCTAssertEqual(receivedAnnotations?.count, 2)
    }
    
    func test_mapRegion_includesAllBreweries() async {
        let locationService = StubLocationService(location: CLLocationCoordinate2D(latitude: -112.123, longitude: 33.456))
        let searchService = StubSearchService(
            breweries: [
                .exampleBrewery(name: "Four Peaks", latitude: "-112", longitude: "33"),
                .exampleBrewery(name: "Fate", latitude: "-113", longitude: "34"),
            ])
        let viewModel = NearbyBreweriesViewModel(locationService: locationService, searchService: searchService)
        var receivedMapRegion: MKCoordinateRegion?
        let expectation = expectation(description: "wait for map region")
        let cancellable = viewModel.mapRegion.sink { region in
            receivedMapRegion = region
            expectation.fulfill()
        }

        await viewModel.viewDidAppear()
        
        await waitForExpectations(timeout: 1)
        
        guard let receivedMapRegion else {
            XCTFail("No map region received")
            return
        }
        XCTAssertEqual(receivedMapRegion.center.latitude, -112.5, accuracy: 0.1)
        XCTAssertEqual(receivedMapRegion.center.longitude, 33.5, accuracy: 0.1)
        XCTAssertEqual(receivedMapRegion.span.latitudeDelta, 1, accuracy: 0.1)
        XCTAssertEqual(receivedMapRegion.span.longitudeDelta, 1, accuracy: 0.1)
    }
    
    func test_activityIndicator_whenDataIsLoading_isShown() async {
        let locationService = StubLocationService(location: CLLocationCoordinate2D(latitude: -112.123, longitude: 33.456))
        let searchService = StubSearchService(breweries: [.example1])
        let viewModel = NearbyBreweriesViewModel(locationService: locationService, searchService: searchService)

        let expectation = expectation(description: "wait for activity indicator")
        var receivedShowActivityIndicator: Bool?
        let cancellable = viewModel.showActivityIndicator
            .dropFirst().first() // ignore the initial value, which is set to false, then wait for just the first event
            .sink { showActivityIndicator in
                receivedShowActivityIndicator = showActivityIndicator
                expectation.fulfill()
            }
        
        await viewModel.viewDidAppear()
        
        await waitForExpectations(timeout: 1)
        
        XCTAssertEqual(receivedShowActivityIndicator, true)
    }
    
    func test_activityIndicator_whenDataIsLoaded_isHidden() async {
        let locationService = StubLocationService(location: CLLocationCoordinate2D(latitude: -112.123, longitude: 33.456))
        let searchService = StubSearchService(breweries: [.example1])
        let viewModel = NearbyBreweriesViewModel(locationService: locationService, searchService: searchService)

        let expectation = expectation(description: "wait for activity indicator")
        var receivedShowActivityIndicator: Bool?
        let cancellable = viewModel.showActivityIndicator
            .dropFirst(2) // initial value should be false, then we should get a true when loading starts (drop those two)
            .first() // then finally a false when loading is done, which is what we are checking for
            .sink { showActivityIndicator in
                receivedShowActivityIndicator = showActivityIndicator
                expectation.fulfill()
            }
        
        await viewModel.viewDidAppear()
        
        await waitForExpectations(timeout: 1)
        
        XCTAssertEqual(receivedShowActivityIndicator, false)

    }
}
