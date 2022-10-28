@testable import BreweryFinder
import CoreLocation
import XCTest

final class OpenBreweryDBSearchServiceTests: XCTestCase {
    let sampleBreweryJSON = """
    [{
        "id": "10-56-brewing-company-knox",
        "name": "10-56 Brewing Company",
        "brewery_type": "micro",
        "street": "400 Brown Cir",
        "address_2": null,
        "address_3": null,
        "city": "Knox",
        "state": "Indiana",
        "county_province": null,
        "postal_code": "46534",
        "country": "United States",
        "longitude": "-86.627954",
        "latitude": "41.289715",
        "phone": "6308165790",
        "website_url": null,
        "updated_at": "2022-10-26T04:22:06.870Z",
        "created_at": "2022-10-26T04:22:06.870Z"
    }]
    """
    
    func test_breweries_sendsRequestToAPI() async throws {
        let session = SpyURLSession()
        let service = OpenBreweryDBSearchService(session: session)
        
        _ = try? await service.breweriesNear(location: CLLocationCoordinate2D(latitude: 33.123, longitude: -112.123))
        
        XCTAssertEqual(session.receivedRequest?.url?.absoluteString, "https://api.openbrewerydb.org/breweries?by_dist=33.123,-112.123")
    }
    
    func test_breweries_decodesAndReturnsResponse() async throws {
        let session = StubURLSession(data: sampleBreweryJSON.data(using: .utf8)!)
        let service = OpenBreweryDBSearchService(session: session)
        
        let breweries = try await service.breweriesNear(location: CLLocationCoordinate2D(latitude: 33.123, longitude: -112.123))

        XCTAssertEqual(breweries.count, 1, "Expected to receive 1 brewery")
        XCTAssertEqual(breweries.first?.name, "10-56 Brewing Company")
        XCTAssertEqual(breweries.first?.breweryType, "micro")
        XCTAssertEqual(breweries.first?.street, "400 Brown Cir")
        XCTAssertNil(breweries.first?.address2)
        XCTAssertNil(breweries.first?.address3)
        XCTAssertEqual(breweries.first?.city, "Knox")
        XCTAssertEqual(breweries.first?.state, "Indiana")
        XCTAssertEqual(breweries.first?.postalCode, "46534")
        XCTAssertEqual(breweries.first?.country, "United States")
        XCTAssertEqual(breweries.first?.longitude, "-86.627954")
        XCTAssertEqual(breweries.first?.latitude, "41.289715")
        XCTAssertEqual(breweries.first?.phone, "6308165790")
        XCTAssertNil(breweries.first?.websiteUrl)
    }
    
    // TODO non-200 response codes?
}


// The test doubles below loosely follow the nomenclature outlined here:
// https://martinfowler.com/bliki/TestDouble.html

final class SpyURLSession: URLSessionProtocol {
    var receivedRequest: URLRequest?
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        receivedRequest = request
        return ("".data(using: .utf8)!, URLResponse())
    }
}

struct StubURLSession: URLSessionProtocol {
    let data: Data
    
    func data(for: URLRequest) async throws -> (Data, URLResponse) {
        return (data, URLResponse())
    }
}
