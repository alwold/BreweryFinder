import Combine
import Foundation
import MapKit
import UIKit

final class NearbyBreweriesViewModel: NSObject {
    private let locationService: LocationService
    private let searchService: SearchService
    private let breweries = CurrentValueSubject<[Brewery], Never>([])
    private let showActivityIndicatorSubject = CurrentValueSubject<Bool, Never>(false)
    private let errorSubject = PassthroughSubject<String, Never>()
    private var userLocation: CLLocationCoordinate2D?
    private let distanceFormatter = MKDistanceFormatter()

    var breweriesUpdated: AnyPublisher<Void, Never> {
        breweries
            .dropFirst()
            .map { _ in }
            .eraseToAnyPublisher()
    }
    
    var mapAnnotations: AnyPublisher<[MKAnnotation], Never> {
        breweries
            .dropFirst()
            .map { breweries in
                breweries.compactMap { brewery in
                    guard let location = brewery.location else {
                        return nil
                    }
                    return MKPlacemark(coordinate: location.coordinate)
            }
        }
        .eraseToAnyPublisher()
    }
    
    var mapRegion: AnyPublisher<MKCoordinateRegion, Never> {
        breweries.compactMap { breweries in
            guard
                let minLatitude = breweries.compactMap(\.location?.coordinate.latitude).min(),
                let maxLatitude = breweries.compactMap(\.location?.coordinate.latitude).max(),
                let minLongitude = breweries.compactMap(\.location?.coordinate.longitude).min(),
                let maxLongitude = breweries.compactMap(\.location?.coordinate.longitude).max() else {
                    return nil
                }
            
            let latitudeSpan = maxLatitude - minLatitude
            let longitudeSpan = maxLongitude - minLongitude
            
            return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: maxLatitude - (latitudeSpan / 2), longitude: maxLongitude - longitudeSpan / 2), span: MKCoordinateSpan(latitudeDelta: latitudeSpan, longitudeDelta: longitudeSpan))
        }
        .eraseToAnyPublisher()
    }
    
    var showActivityIndicator: AnyPublisher<Bool, Never> {
        showActivityIndicatorSubject.eraseToAnyPublisher()
    }
    
    var error: AnyPublisher<String, Never> {
        errorSubject.eraseToAnyPublisher()
    }
    
    init(locationService: LocationService, searchService: SearchService = OpenBreweryDBSearchService()) {
        self.locationService = locationService
        self.searchService = searchService
    }
    
    func viewDidAppear() async {
        await findBreweries()
    }
    
    func findBreweries() async {
        showActivityIndicatorSubject.send(true)
        do {
            let location = try await locationService.getLocation()
            userLocation = location
            breweries.send(try await searchService.breweriesNear(location: location))
            showActivityIndicatorSubject.send(false)
        } catch {
            self.errorSubject.send("We're sorry, we were unable to locate the nearby breweries. We may be able to find them if you try again.")
            print("error loading breweries: \(error)")
            showActivityIndicatorSubject.send(false)
        }
    }
    
    func brewery(at index: Int) -> Brewery {
        breweries.value[index]
    }
}

struct NearbyBrewery {
    let name: String
    let type: String
    let distance: String?
}

extension NearbyBreweriesViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfRows(in: section)
    }
    
    func numberOfRows(in section: Int) -> Int {
        breweries.value.count
    }
    
    func nearbyBrewery(at row: Int) -> NearbyBrewery {
        let brewery = breweries.value[row]

        let name = brewery.name
        let type = brewery.breweryType
        let distance: String?
        if let location = brewery.location, let userLocation {
            let distanceInMeters = location.distance(from: CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude))
            let distanceString = distanceFormatter.string(fromDistance: distanceInMeters)
            distance = "\(distanceString) away"
        } else {
            distance = nil
        }
        return NearbyBrewery(name: name, type: type, distance: distance)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NearbyBreweryCell", for: indexPath) as! NearbyBreweryCell
        
        let brewery = nearbyBrewery(at: indexPath.row)
        cell.nameLabel.text = brewery.name
        cell.typeLabel.text = brewery.type
        cell.distanceLabel.text = brewery.distance
        
        return cell
    }
}
