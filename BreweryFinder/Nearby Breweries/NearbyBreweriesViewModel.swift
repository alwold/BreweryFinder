import Combine
import Foundation
import UIKit

final class NearbyBreweriesViewModel: NSObject {
    private let locationService: LocationService
    private let searchService: SearchService
    private var breweries: [Brewery] = []
    private let breweriesUpdatedSubject = PassthroughSubject<Void, Never>()

    var breweriesUpdated: AnyPublisher<Void, Never> {
        breweriesUpdatedSubject.eraseToAnyPublisher()
    }
    
    init(locationService: LocationService) {
        self.locationService = locationService
        self.searchService = OpenBreweryDBSearchService()
    }
    
    func viewDidAppear() async {
        // TODO show activity indicator
        do {
            print("getting location")
            let location = try await locationService.getLocation()
            print("location: \(location)")
            breweries = try await searchService.breweriesNear(location: location)
            print("breweries: \(breweries)")
            breweriesUpdatedSubject.send()
        } catch {
            print("error: \(error)")
        }
        // TODO look up breweries
        // TODO hide activity indicator
    }
}

extension NearbyBreweriesViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        breweries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NearbyBreweryCell", for: indexPath) as! NearbyBreweryCell
        
        cell.nameLabel.text = breweries[indexPath.row].name
        
        return cell
    }
}
