import MapKit
import UIKit

final class NearbyBreweriesView: UIView {
    let mapView = MKMapView()
    let tableView = UITableView()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        addSubview(tableView)
        addSubview(mapView)
        addSubview(activityIndicator)
        
        setConstraints()
        
        tableView.register(NearbyBreweryCell.self, forCellReuseIdentifier: "NearbyBreweryCell")
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        
        mapView.showsUserLocation = true
        
        activityIndicator.startAnimating()
    }
    
    private func setConstraints() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mapView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.35),
            
            tableView.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#if DEBUG
import SwiftUI

struct NearbyBreweriesView_Preview: PreviewProvider {
    class SampleDataSource: NSObject, UITableViewDataSource {
        func numberOfSections(in tableView: UITableView) -> Int {
            1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            2
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NearbyBreweryCell", for: indexPath) as! NearbyBreweryCell
            cell.nameLabel.text = "Sample Brewery"
            return cell
        }
    }
    static var previews: some View {
        UIViewPreview {
            let view = NearbyBreweriesView()
            let dataSource = SampleDataSource()
            view.tableView.dataSource = dataSource
            return view
        }
    }
}
#endif
