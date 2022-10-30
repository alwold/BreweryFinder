import UIKit

final class HomeView: UIView {
    let backgroundImage = UIImageView()
    let titleLabel = UILabel()
    let hintLabel = UILabel()
    let findByLocationButton = UIButton()
    
    init() {
        super.init(frame: .zero)
        backgroundImage.image = UIImage(named: "background")
        backgroundColor = .white
        backgroundImage.contentMode = .scaleAspectFill
        addSubview(backgroundImage)
        addSubview(titleLabel)
        addSubview(hintLabel)
        addSubview(findByLocationButton)
        
        setConstraints()

        titleLabel.font = .largeTitle
        titleLabel.text = "Brewery Finder"
        titleLabel.textColor = .homeText
        
        hintLabel.text = "Tap the button below to locate breweries near your current location."
        hintLabel.numberOfLines = 0
        hintLabel.lineBreakMode = .byWordWrapping
        hintLabel.textAlignment = .center
        hintLabel.textColor = .homeText
    }
        
    private func setConstraints() {
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        findByLocationButton.translatesAutoresizingMaskIntoConstraints = false
        
        findByLocationButton.setImage(UIImage(systemName: "location.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 64, weight: .bold, scale: .large)), for: .normal)
        findByLocationButton.tintColor = .white

        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundImage.leftAnchor.constraint(equalTo: leftAnchor),
            backgroundImage.rightAnchor.constraint(equalTo: rightAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 24),
            
            hintLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            hintLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            hintLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            
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
