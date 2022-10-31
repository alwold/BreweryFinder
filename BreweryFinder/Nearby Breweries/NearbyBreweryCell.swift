import UIKit

final class NearbyBreweryCell: UITableViewCell {
    let boxView = UIView()
    let nameLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(boxView)
        boxView.addSubview(nameLabel)
        
        setConstraints()

        boxView.backgroundColor = .primary
        boxView.layer.shadowOffset = CGSize(width: 2, height: 2)
        boxView.layer.shadowColor = UIColor.primary.cgColor
        boxView.layer.shadowRadius = 2
        boxView.layer.shadowOpacity = 1
        boxView.layer.cornerRadius = 8
                
        nameLabel.font = .cardTitle
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.textColor = .white
    }
    
    private func setConstraints() {
        boxView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            boxView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            boxView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            boxView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            boxView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
            
            nameLabel.centerXAnchor.constraint(equalTo: boxView.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: boxView.centerYAnchor),
            nameLabel.topAnchor.constraint(equalTo: boxView.topAnchor, constant: 30),
            nameLabel.leadingAnchor.constraint(equalTo: boxView.leadingAnchor, constant: 16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#if DEBUG
import SwiftUI

struct NearbyBreweryCell_Preview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let cell = NearbyBreweryCell(style: .default, reuseIdentifier: nil)
            cell.nameLabel.text = "Four Peaks Brewing Co and stuff like that"
            return cell
        }
        .frame(width: 360, height: 200)
    }
}
#endif
