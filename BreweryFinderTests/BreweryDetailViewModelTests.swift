@testable import BreweryFinder
import XCTest

final class BreweryDetailViewModelTests: XCTestCase {
    func test_phone_isFormattedCorrectly() {
        let viewModel = BreweryDetailViewModel(brewery: .exampleBrewery(name: "Four Peaks", phone: "4803039967"))
        
        let phone = viewModel.phone
        
        XCTAssertEqual(phone, "(480) 303-9967")
    }
}
