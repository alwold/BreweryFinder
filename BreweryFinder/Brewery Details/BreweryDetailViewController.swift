import UIKit

final class BreweryDetailViewController: UIViewController {
    private let brewery: Brewery
    
    init(brewery: Brewery) {
        self.brewery = brewery
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = BreweryDetailView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
