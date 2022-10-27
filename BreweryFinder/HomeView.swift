import UIKit

final class HomeView: UIView {
    let titleLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        addSubview(titleLabel)
        
        setConstraints()

        titleLabel.text = "Brewery Finder"
    }
        
    private func setConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 64)
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
