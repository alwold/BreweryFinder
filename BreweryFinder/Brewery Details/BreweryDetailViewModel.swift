import MapKit

final class BreweryDetailViewModel {
    private let brewery: Brewery
    let name: String
    let mapAnnotation: MKAnnotation?
    let phone: String?
    let websiteUrl: URL?
    
    init(brewery: Brewery) {
        self.brewery = brewery
        name = brewery.name
        if let coordinate = brewery.coordinate {
            mapAnnotation = MKPlacemark(coordinate: coordinate)
        } else {
            mapAnnotation = nil
        }
        phone = brewery.phone
        if let websiteUrlString = brewery.websiteUrl, let websiteUrl = URL(string: websiteUrlString) {
            self.websiteUrl = websiteUrl
        } else {
            self.websiteUrl = nil
        }
    }
    
    var address: String {
        var address = [brewery.street, brewery.address2, brewery.address3]
            .compactMap { $0 }.joined(separator: "\n")
        address.append("\n\(brewery.city), \(brewery.state) \(brewery.postalCode)")
        return address
    }
    
    var mapRegion: MKCoordinateRegion? {
        if let coordinate = brewery.coordinate {
            return MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        } else {
            return nil
        }
    }
}
