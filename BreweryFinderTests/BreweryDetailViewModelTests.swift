@testable import BreweryFinder
import XCTest

final class BreweryDetailViewModelTests: XCTestCase {
    func test_address_isFormattedCorrectly() {
        let viewModel = BreweryDetailViewModel(brewery: .exampleBrewery(name: "Test", street: "123 Fake Street", address2: "Suite 2", address3: "In the back", city: "Whoville", state: "Nowhere", postalCode: "12345"))
        
        let address = viewModel.address
        
        XCTAssertEqual(address, "123 Fake Street\nSuite 2\nIn the back\nWhoville, Nowhere 12345")
    }
    
    func test_phone_isFormattedCorrectly() {
        let viewModel = BreweryDetailViewModel(brewery: .exampleBrewery(name: "Four Peaks", phone: "4803039967"))
        
        let phone = viewModel.phone
        
        XCTAssertEqual(phone, "(480) 303-9967")
    }
    
    func test_phone_whenNot10Characters_isLeftUnformatted() {
        let viewModel = BreweryDetailViewModel(brewery: .exampleBrewery(name: "Four Peaks", phone: "480303996"))
        
        let phone = viewModel.phone
        
        XCTAssertEqual(phone, "480303996")
    }
    
    func test_mapAnnotation_isCreatedWithCoordinates() {
        let viewModel = BreweryDetailViewModel(brewery: .exampleBrewery(name: "Four Peaks", latitude: "-112.123", longitude: "33.456"))
        
        let annotation = viewModel.mapAnnotation
        
        XCTAssertEqual(annotation!.coordinate.latitude, -112.123, accuracy: 0.01)
        XCTAssertEqual(annotation!.coordinate.longitude, 33.456, accuracy: 0.01)
    }
    
    func test_mapRegion_includesTheBreweryAndSomePadding() {
        let viewModel = BreweryDetailViewModel(brewery: .exampleBrewery(name: "Four Peaks", latitude: "-112.123", longitude: "33.456"))
        
        let mapRegion = viewModel.mapRegion
        
        XCTAssertEqual(mapRegion!.center.latitude, -112.123, accuracy: 0.01)
        XCTAssertEqual(mapRegion!.center.longitude, 33.456, accuracy: 0.01)

        XCTAssertEqual(mapRegion!.span.latitudeDelta, 0.1, accuracy: 0.01)
        XCTAssertEqual(mapRegion!.span.longitudeDelta, 0.1, accuracy: 0.01)
    }
}
