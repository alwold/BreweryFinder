import UIKit

/// Extension to provide quick access to pre-defined fonts for use throughout the app. The fonts are scaled via dynamic type.
extension UIFont {
    /// Use for large title fonts (e.g. home screen)
    static var largeTitle: UIFont {
        let base = UIFont.boldSystemFont(ofSize: 48)
        let fontMetrics = UIFontMetrics(forTextStyle: .largeTitle)
        return fontMetrics.scaledFont(for: base)
    }
    
    /// Use for titles on cards in the nearby breweries screen
    static var cardTitle: UIFont {
        let base = UIFont.boldSystemFont(ofSize: 24)
        let fontMetrics = UIFontMetrics(forTextStyle: .largeTitle)
        return fontMetrics.scaledFont(for: base)
    }
    
    /// Use for title on the brewery detail screen
    static var detailTitle: UIFont {
        let base = UIFont.boldSystemFont(ofSize: 30)
        let fontMetrics = UIFontMetrics(forTextStyle: .largeTitle)
        return fontMetrics.scaledFont(for: base)
    }
}
