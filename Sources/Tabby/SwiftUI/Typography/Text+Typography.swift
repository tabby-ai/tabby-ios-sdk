import SwiftUI

extension Text {
    
    @available(iOS 13.0, macOS 11, *)
    func tabbyStyle(_ typography: Typography) -> Text {
        self.font(Font(typography.font))
    }
}
