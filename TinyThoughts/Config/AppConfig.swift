import SwiftUI

enum AppConfig {

    enum Spacing {
        static let spacer: CGFloat = 16
    }
    
    enum Layout {
        static let cardCornerRadius: CGFloat = 12
        static let cardShadowRadius: CGFloat = 5
        static let cardShadowOpacity: Double = 0.1
        static let quickAddButtonSize: CGFloat = 50
    }
    
    enum Padding {
        static let horizontal: CGFloat = 20
        static let vertical: CGFloat = 20
        static let card: CGFloat = 20
        static let spacer: CGFloat = 5
        static let header: CGFloat = 6
        static let text: CGFloat = 8
    }
    
    enum Colors {
        static let shadow = Color.black.opacity(0.1)
        static let threadCount = Color.blue
    }
} 