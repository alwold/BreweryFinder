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

extension NearbyBreweriesViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfRows(in: section)
    }
    
    func numberOfRows(in section: Int) -> Int {
        breweries.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NearbyBreweryCell", for: indexPath) as! NearbyBreweryCell
        
        cell.nameLabel.text = label(row: indexPath.row)
        
        return cell
    }
    
    func label(row: Int) -> String {
        breweries.value[row].name
    }
}
