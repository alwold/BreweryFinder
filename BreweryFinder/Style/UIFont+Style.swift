import UIKit

extension UIFont {
    static var largeTitle: UIFont {
        let base = UIFont.boldSystemFont(ofSize: 48)
        let fontMetrics = UIFontMetrics(forTextStyle: .largeTitle)
        return fontMetrics.scaledFont(for: base)
    }
    
    static var cardTitle: UIFont {
        let base = UIFont.boldSystemFont(ofSize: 24)
        let fontMetrics = UIFontMetrics(forTextStyle: .largeTitle)
        return fontMetrics.scaledFont(for: base)
    }
    
    static var detailTitle: UIFont {
        let base = UIFont.boldSystemFont(ofSize: 30)
        let fontMetrics = UIFontMetrics(forTextStyle: .largeTitle)
        return fontMetrics.scaledFont(for: base)
    }
}
