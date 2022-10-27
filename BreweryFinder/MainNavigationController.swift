import UIKit

final class MainNavigationController: UINavigationController {
    let homeViewController = HomeViewController()
    
    init() {
        super.init(rootViewController: homeViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
