import MapKit

final class BreweryDetailViewModel {
    private let brewery: Brewery
    let name: String
    let mapAnnotation: MKAnnotation?
    let websiteUrl: URL?
    weak var delegate: BreweryDetailViewControllerDelegate?
    
    init(brewery: Brewery) {
        self.brewery = brewery
        name = brewery.name
        if let coordinate = brewery.coordinate {
            mapAnnotation = MKPlacemark(coordinate: coordinate)
        } else {
            mapAnnotation = nil
        }
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
    
    var phone: String? {
        if var phone = brewery.phone {
            if phone.count == 10 {
                phone.insert("(", at: phone.startIndex)
                phone.insert(")", at: phone.index(phone.startIndex, offsetBy: 4))
                phone.insert(" ", at: phone.index(phone.startIndex, offsetBy: 5))
                phone.insert("-", at: phone.index(phone.endIndex, offsetBy: -4))
            }
            return phone
        } else {
            return nil
        }
    }
    
    var mapRegion: MKCoordinateRegion? {
        if let coordinate = brewery.coordinate {
            return MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        } else {
            return nil
        }
    }
    
    func phoneButtonTapped() {
        if let phone = brewery.phone, let url = URL(string: "tel:\(phone)") {
            UIApplication.shared.open(url)
        }
    }
    
    func websiteButtonTapped() {
        if let urlString = brewery.websiteUrl, let url = URL(string: urlString) {
            delegate?.websiteButtonTapped(for: url)
        }
    }
}
