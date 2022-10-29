import Combine
import Foundation
import MapKit
import UIKit

final class NearbyBreweriesViewModel: NSObject {
    private let locationService: LocationService
    private let searchService: SearchService
    private let breweries = CurrentValueSubject<[Brewery], Never>([])
    private let breweriesUpdatedSubject = PassthroughSubject<Void, Never>()

    var breweriesUpdated: AnyPublisher<Void, Never> {
        breweries.map { _ in }.eraseToAnyPublisher()
    }
    
    var mapAnnotations: AnyPublisher<[MKAnnotation], Never> {
        breweries.map { breweries in
            breweries.compactMap { brewery in
                guard let coordinate = brewery.coordinate else {
                    return nil
                }
                return MKPlacemark(coordinate: coordinate)
            }
        }
        .eraseToAnyPublisher()
    }
    
    var mapRegion: AnyPublisher<MKCoordinateRegion, Never> {
        breweries.compactMap { breweries in
            guard
                let minLatitude = breweries.compactMap(\.coordinate?.latitude).min(),
                let maxLatitude = breweries.compactMap(\.coordinate?.latitude).max(),
                let minLongitude = breweries.compactMap(\.coordinate?.longitude).min(),
                let maxLongitude = breweries.compactMap(\.coordinate?.longitude).max() else {
                    return nil
                }
            
            let latitudeSpan = maxLatitude - minLatitude
            let longitudeSpan = maxLongitude - minLongitude
            
            return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: maxLatitude - (latitudeSpan / 2), longitude: maxLongitude - longitudeSpan / 2), span: MKCoordinateSpan(latitudeDelta: latitudeSpan, longitudeDelta: longitudeSpan))
        }
        .eraseToAnyPublisher()
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
            breweries.send(try await searchService.breweriesNear(location: location))
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
        breweries.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NearbyBreweryCell", for: indexPath) as! NearbyBreweryCell
        
        cell.nameLabel.text = breweries.value[indexPath.row].name
        
        return cell
    }
}
