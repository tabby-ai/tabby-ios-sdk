# Tabby

## Requirements

iOS 13.0+
Swift 5.3+
Xcode 12.0+

## Integration

### Swift Package Manager (recommended)

```
dependencies: [
    .package(url: "https://github.com/tabby-ai/tabby-ios-sdk.git", .upToNextMajor(from: "0.0.1"))
]

```

```swift
import UIKit
import SwiftUI
import Tabby

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            let vc = UIHostingController(
                rootView: Tabby.TabbyPresentationSnippet(
                    amount: 800,
                    currency: .AED,
                    lang: Lang.en)
            )
            addChild(vc)
            vc.view.frame = view.frame
            view.addSubview(vc.view)
            vc.didMove(toParent: self)
        } else {
            // Fallback on earlier versions
        }
    }
}
```

![UIKit](./docs/UIKit.png)

## Result

![Snippet EN](./docs/TabbyPresentationSnippet_EN.gif)
![Snippet AR](./docs/TabbyPresentationSnippet_AR.gif)
