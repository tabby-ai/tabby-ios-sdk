import SwiftUI

extension Text {
    
    @available(iOS 14.0, macOS 11, *)
    func tabbyStyle(_ typography: Typography) -> Text {
        self.font(Font(typography.font))
    }
}
