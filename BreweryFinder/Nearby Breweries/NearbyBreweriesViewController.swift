import Combine
import UIKit

final class NearbyBreweriesViewController: UIViewController {
    private let viewModel: NearbyBreweriesViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    var nearbyBreweriesView: NearbyBreweriesView {
        view as! NearbyBreweriesView
    }
    
    init(locationService: LocationService) {
        viewModel = NearbyBreweriesViewModel(locationService: locationService)
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = NearbyBreweriesView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nearbyBreweriesView.tableView.dataSource = viewModel
        viewModel.breweriesUpdated
            .receive(on: DispatchQueue.main)
            .sink { [nearbyBreweriesView] in
            nearbyBreweriesView.tableView.reloadData()
        }.store(in: &cancellables)
        
        viewModel.mapAnnotations
            .receive(on: DispatchQueue.main)
            .sink { [nearbyBreweriesView] annotations in
                nearbyBreweriesView.mapView.removeAnnotations(nearbyBreweriesView.mapView.annotations)
                nearbyBreweriesView.mapView.addAnnotations(annotations)
            }
            .store(in: &cancellables)
        
        viewModel.mapRegion
            .receive(on: DispatchQueue.main)
            .sink { [nearbyBreweriesView] region in
                nearbyBreweriesView.mapView.setRegion(region, animated: true)
            }
            .store(in: &cancellables)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Task {
            await viewModel.viewDidAppear()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
