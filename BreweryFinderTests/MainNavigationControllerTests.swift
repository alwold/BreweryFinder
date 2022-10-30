@testable import BreweryFinder
import CoreLocation
import SafariServices
import XCTest

class SpyMainNavigationController: MainNavigationController {
    var viewControllerWasPushed: UIViewController?
    var viewControllerWasPresented: UIViewController?
    var viewControllerWasPopped: Bool = false
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewControllerWasPushed = viewController
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        viewControllerWasPresented = viewControllerToPresent
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        viewControllerWasPopped = true
        return nil
    }
}

class MainNavigationControllerTests: XCTestCase {
    func test_findBreweriesButton_whenAuthorizationStatusNotDetermined_promptsForLocationPermission() async {
        let locationService = SpyLocationService()
        let sut = await MainNavigationController(locationService: locationService)
        
        await sut.findByLocationButtonTapped()
        
        XCTAssertTrue(locationService.permissionWasRequested)
    }
    
    func test_findBreweriesButton_whenAuthorizationStatusAllowed_goesToNearbyBreweriesVC() async {
        let locationService = StubLocationService(location: CLLocationCoordinate2D(latitude: 33, longitude: -112))
        let sut = await SpyMainNavigationController(locationService: locationService)
        
        await sut.findByLocationButtonTapped()
        
        let viewController = await sut.viewControllerWasPushed
        XCTAssert(viewController is NearbyBreweriesViewController)
    }
    
    func test_findBreweriesButton_whenLocationDenied_showsAlert() async {
        let locationService = StubLocationService(authorizationStatus: .denied)
        let sut = await SpyMainNavigationController(locationService: locationService)
        
        await sut.findByLocationButtonTapped()
        
        let viewController = await sut.viewControllerWasPresented
        XCTAssert(viewController is UIAlertController)
    }
    
    func test_findBreweriesButton_whenLocationRestricted_showsAlert() async {
        let locationService = StubLocationService(authorizationStatus: .restricted)
        let sut = await SpyMainNavigationController(locationService: locationService)
        
        await sut.findByLocationButtonTapped()
        
        let viewController = await sut.viewControllerWasPresented
        XCTAssert(viewController is UIAlertController)
    }
    
    func test_breweryTap_showsBreweryDetail() async {
        let sut = await SpyMainNavigationController()
        
        await sut.breweryTapped(brewery: .example1)
        
        let viewController = await sut.viewControllerWasPushed
        XCTAssert(viewController is BreweryDetailViewController)
    }
    
    func test_cancelingAfterFindingBreweriesFails_returnsToPreviousViewController() async {
        let sut = await SpyMainNavigationController()
        
        await sut.cancelButtonTapped()
        
        let viewControllerWasPopped = await sut.viewControllerWasPopped
        XCTAssert(viewControllerWasPopped)
    }
    
    func test_tappingBreweryURL_showsWebSiteInASafariViewController() async {
        let sut = await SpyMainNavigationController()
        
        await sut.websiteButtonTapped(for: URL(string: "https://www.fourpeaks.com")!)
        
        let viewController = await sut.viewControllerWasPresented
        XCTAssert(viewController is SFSafariViewController)
    }
}
