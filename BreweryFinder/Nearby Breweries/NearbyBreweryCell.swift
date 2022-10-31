import UIKit

final class NearbyBreweryCell: UITableViewCell {
    let boxView = UIView()
    let nameLabel = UILabel()
    let typeLabel = UILabel()
    let chevron = UIImageView(image: UIImage(systemName: "chevron.right", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .regular, scale: .large)))
    let distanceLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(boxView)
        boxView.addSubview(nameLabel)
        boxView.addSubview(typeLabel)
        boxView.addSubview(distanceLabel)
        boxView.addSubview(chevron)
        
        setConstraints()
        
        backgroundColor = .white

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
        
        typeLabel.textColor = .white
        
        distanceLabel.textColor = .white
        
        chevron.tintColor = .white
    }
    
    private func setConstraints() {
        boxView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        chevron.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            boxView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            boxView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            boxView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            boxView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
            
            nameLabel.topAnchor.constraint(equalTo: boxView.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: boxView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: chevron.leadingAnchor, constant: -16),
            
            typeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            typeLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            distanceLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 8),
            distanceLabel.leadingAnchor.constraint(equalTo: typeLabel.leadingAnchor),
            distanceLabel.bottomAnchor.constraint(equalTo: boxView.bottomAnchor, constant: -16),
            
            chevron.centerYAnchor.constraint(equalTo: boxView.centerYAnchor),
            chevron.trailingAnchor.constraint(equalTo: boxView.trailingAnchor, constant: -16)
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
            cell.typeLabel.text = "Microbrewery"
            cell.distanceLabel.text = "4.2 miles away"
            return cell
        }
        .frame(width: 360, height: 200)
    }
}
#endif
