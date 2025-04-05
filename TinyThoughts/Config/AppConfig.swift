import SwiftUI

enum AppConfig {
    enum Grid {
        static let columns = [GridItem(.adaptive(minimum: 300), spacing: 16)]
        static let spacing: CGFloat = 16
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
    }
    
    enum Colors {
        static let shadow = Color.black.opacity(0.1)
        static let threadCount = Color.blue
    }
} 