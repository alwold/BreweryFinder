import UIKit

protocol BreweryDetailViewControllerDelegate: AnyObject {
    func websiteButtonTapped(for: URL)
}

final class BreweryDetailViewController: UIViewController {
    private let viewModel: BreweryDetailViewModel
    
    weak var delegate: BreweryDetailViewControllerDelegate? {
        get {
            viewModel.delegate
        }
        set {
            viewModel.delegate = newValue
        }
    }
    
    init(brewery: Brewery) {
        self.viewModel = BreweryDetailViewModel(brewery: brewery)
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = BreweryDetailView()
    }
    
    var breweryDetailView: BreweryDetailView {
        view as! BreweryDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        breweryDetailView.nameLabel.text = viewModel.name
        if let mapAnnotation = viewModel.mapAnnotation {
            breweryDetailView.mapView.addAnnotation(mapAnnotation)
        }
        breweryDetailView.addressLabel.text = viewModel.address
        if let phone = viewModel.phone {
            breweryDetailView.phoneButton.setTitle(phone, for: .normal)
        } else {
            breweryDetailView.phoneButton.isHidden = true
        }
        if let websiteUrl = viewModel.websiteUrl {
            breweryDetailView.websiteButton.setTitle(websiteUrl.absoluteString, for: .normal)
        } else {
            breweryDetailView.websiteButton.isHidden = true
        }
        if let mapRegion = viewModel.mapRegion {
            breweryDetailView.mapView.setRegion(mapRegion, animated: false)
        }
        
        breweryDetailView.phoneButton.addAction(UIAction { [viewModel] _ in
            viewModel.phoneButtonTapped()
        }, for: .touchUpInside)
        breweryDetailView.websiteButton.addAction(UIAction { [viewModel] _ in
            viewModel.websiteButtonTapped()
        }, for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
