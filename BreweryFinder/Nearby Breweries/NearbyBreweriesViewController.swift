import UIKit

final class NearbyBreweriesViewController: UIViewController {
    private let viewModel = NearbyBreweriesViewModel()
    
    var nearbyBreweriesView: NearbyBreweriesView {
        view as! NearbyBreweriesView
    }
    
    override func loadView() {
        view = NearbyBreweriesView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nearbyBreweriesView.tableView.dataSource = viewModel
    }
}
