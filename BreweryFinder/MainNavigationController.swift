import UIKit
import CoreLocation
import SafariServices

class MainNavigationController: UINavigationController {
    private let homeViewController = HomeViewController()
    private let locationService: LocationService
    
    init(locationService: LocationService = CoreLocationService()) {
        self.locationService = locationService
        super.init(rootViewController: homeViewController)
        homeViewController.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - HomeViewControllerDelegate
extension MainNavigationController: HomeViewControllerDelegate {
    func findByLocationButtonTapped() async {
        let authorizationStatus = locationService.authorizationStatus
        if authorizationStatus == .notDetermined {
            let authorizationStatus = await locationService.requestWhenInUseAuthorization()

            handle(authorizationStatus: authorizationStatus)
        } else {
            handle(authorizationStatus: authorizationStatus)
        }
    }
    
    func handle(authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            let viewController = NearbyBreweriesViewController(locationService: locationService)
            viewController.delegate = self
            pushViewController(viewController, animated: true)
        case .denied:
            let alert = UIAlertController(title: "Location access disabled", message: "It looks like location access has been disabled. If you'd like to find breweries, you'll need to enable it in settings.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Open Settings", style: .default) {_ in
                if let url = URL(string: UIApplication.openNotificationSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(alert, animated: true)
        case .restricted, .notDetermined:
            // unrecoverable
            print("show error")
        }

    }
}

// MARK: - NearbyBreweriesViewControllerDelegate
extension MainNavigationController: NearbyBreweriesViewControllerDelegate {
    func breweryTapped(brewery: Brewery) {
        let viewController = BreweryDetailViewController(brewery: brewery)
        viewController.delegate = self
        pushViewController(viewController, animated: true)
    }
    
    func cancelButtonTapped() {
        popViewController(animated: true)
    }
}

// MARK: - BreweryDetailViewControllerDelegate
extension MainNavigationController: BreweryDetailViewControllerDelegate {
    func websiteButtonTapped(for url: URL) {
        let viewController = SFSafariViewController(url: url)
        present(viewController, animated: true)
    }
}
