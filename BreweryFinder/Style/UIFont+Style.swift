import UIKit

extension UIFont {
    static var largeTitle: UIFont {
        let base = UIFont.boldSystemFont(ofSize: 48)
        let fontMetrics = UIFontMetrics(forTextStyle: .largeTitle)
        return fontMetrics.scaledFont(for: base)
    }
}
