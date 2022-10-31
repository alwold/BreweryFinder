import MapKit
import UIKit

final class BreweryDetailView: UIView {
    let nameLabel = UILabel()
    let mapView = MKMapView()
    let addressLabel = UILabel()
    let phoneButton = UIButton()
    let websiteButton = UIButton()
    
    init() {
        super.init(frame: .zero)
        addSubview(nameLabel)
        addSubview(mapView)
        addSubview(addressLabel)
        addSubview(phoneButton)
        addSubview(websiteButton)
        
        setConstraints()
        
        backgroundColor = .white
        
        nameLabel.textAlignment = .center
        nameLabel.font = .largeTitle
        nameLabel.textColor = .homeText
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        
        addressLabel.numberOfLines = 0
        addressLabel.lineBreakMode = .byWordWrapping
        
        phoneButton.setTitleColor(.blue, for: .normal)
        websiteButton.setTitleColor(.blue, for: .normal)
        
        mapView.showsUserLocation = true
    }
    
    private func setConstraints() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneButton.translatesAutoresizingMaskIntoConstraints = false
        websiteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            mapView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            mapView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            mapView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.33),
            mapView.heightAnchor.constraint(equalTo: mapView.widthAnchor),
            
            addressLabel.centerYAnchor.constraint(equalTo: mapView.centerYAnchor),
            addressLabel.leadingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: 8),
            
            phoneButton.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 16),
            phoneButton.leadingAnchor.constraint(equalTo: mapView.leadingAnchor),
            
            websiteButton.topAnchor.constraint(equalTo: phoneButton.bottomAnchor, constant: 8),
            websiteButton.leadingAnchor.constraint(equalTo: phoneButton.leadingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#if DEBUG
import SwiftUI

struct BreweryDetailView_Preview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let view = BreweryDetailView()
            view.nameLabel.text = "Four Peaks Brewing Company"
            view.addressLabel.text = "1340 E 8th St #104\nTempe, AZ 85281"
            view.phoneButton.setTitle("(480) 303-9967", for: .normal)
            view.websiteButton.setTitle("https://www.fourpeaks.com", for: .normal)
            return view
        }
    }
}
#endif
