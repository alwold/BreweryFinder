import UIKit

protocol HomeViewControllerDelegate: AnyObject {
    func findByLocationButtonTapped()
}

final class HomeViewController: UIViewController {
    weak var delegate: HomeViewControllerDelegate?

    private var homeView: HomeView {
        view as! HomeView
    }
    
    override func loadView() {
        view = HomeView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeView.findByLocationButton.addAction(
            UIAction { [weak delegate] _ in
                delegate?.findByLocationButtonTapped()
            },
            for: .touchUpInside
        )
    }
}
