import Foundation
import UIKit

final class NearbyBreweriesViewModel: NSObject {
    
}

extension NearbyBreweriesViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NearbyBreweryCell", for: indexPath) as! NearbyBreweryCell
        
        cell.nameLabel.text = "Foo"
        
        return cell
    }
}
