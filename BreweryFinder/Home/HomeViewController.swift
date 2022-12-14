import UIKit

protocol HomeViewControllerDelegate: AnyObject {
    func findByLocationButtonTapped() async
}

// The `HomeViewController` provides the home page, which just has a button to start
// the search.
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
                Task { [weak delegate] in
                    await delegate?.findByLocationButtonTapped()
                }
            },
            for: .touchUpInside
        )
    }
}
