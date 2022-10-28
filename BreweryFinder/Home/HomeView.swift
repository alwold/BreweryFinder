import UIKit

final class HomeView: UIView {
    let backgroundImage = UIImageView(image: UIImage(named: "background"))
    
    let titleLabel = UILabel()
    
    let findByLocationButton = UIButton()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        backgroundImage.contentMode = .scaleAspectFill
        addSubview(backgroundImage)
        addSubview(titleLabel)
        addSubview(findByLocationButton)
        
        setConstraints()

        titleLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        titleLabel.text = "Brewery Finder"
        titleLabel.textColor = .orange
    }
        
    private func setConstraints() {
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        findByLocationButton.translatesAutoresizingMaskIntoConstraints = false
        
        findByLocationButton.setImage(UIImage(systemName: "location.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 64, weight: .bold, scale: .large)), for: .normal)
        findByLocationButton.tintColor = .orange

        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundImage.leftAnchor.constraint(equalTo: leftAnchor),
            backgroundImage.rightAnchor.constraint(equalTo: rightAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 64),
            
            findByLocationButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            findByLocationButton.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#if DEBUG
import SwiftUI

struct HomeView_Preview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            HomeView()
        }
    }
}
#endif