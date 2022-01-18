# Tabby

## Requirements

iOS 13.0+
Swift 5.3+
Xcode 12.0+

## Integration

### Swift Package Manager (recommended)

```
dependencies: [
    .package(url: "https://github.com/tabby-ai/tabby-ios-sdk.git", .upToNextMajor(from: "1.1.0"))
]

```

## SDK usage

### 1. Init Tabby when your app starts (AppDelegete or @main)

`TabbySDK.shared.setup(withApiKey: "__API_KEY_HERE__")`

### 2. Prepare view

```swift
import Tabby

let customerPayment = Payment(
    amount: "340",
    currency: .AED,
    description: "tabby Store Order #3",
    buyer: Buyer(
    email: "successful.payment@tabby.ai",
    phone: "500000001",
    name: "Yazan Khalid"
        dob: nil
    ), order: Order(
        reference_id: "#xxxx-xxxxxx-xxxx",
        items: [
            OrderItem(
                description: "Jersey",
                product_url: "https://tabby.store/p/SKU123",
                quantity: 1,
                reference_id: "SKU123",
                title: "Pink jersey",
                unit_price: "300"
            )],
        shipping_amount: "50",
        tax_amount: "100"
    ),
    shipping_address: ShippingAddress(
        address: "Sample Address #2",
        city: "Dubai"
    )
)

let myTestPayment = TabbyCheckoutPayload(merchant_code: "ae", lang: .en, payment: customerPayment)

...
in your CartScreenView etc in .onAppear or viewDidLoad
...
.onAppear() {
    TabbySDK.shared.configure(forPayment: myTestPayment) { result in
        switch result {
        case .success(let s):
            // 1. Do something with sessionId (this step is optional)
            print("sessionId: \(s.sessionId)")
            // 2. Do something with paymentId (this step is optional)
            print("paymentId: \(s.paymentId)")
            // 2. Grab avaibable products from session and enable proper
            // payment method buttons in your UI (this step is required)
            print("tabby available products: \(s.tabbyProductTypes)")
            if (s.tabbyProductTypes.contains(.installments)) {
                self.isTabbyInstallmentsAvailable = true
            }
            if (s.tabbyProductTypes.contains(.pay_later)) {
                self.isTabbyPaylatersAvailable = true
            }
        case .failure(let error):
            // Do something when Tabby checkout session POST requiest failed
            print(error)
        }
    }
}
```

### 3. Launch Tabby checkout

SDK is built for your convenience - once `TabbySDK.shared.configure(forPayment: myTestPayment) { result in ... }` is called - you can render something like this
if modal / sheet / seguway / NavigationLink / ViewController etc - whatever fits your UI and app structure. With both SwiftUI and UIKit

```swift
.sheet(isPresented: $isTabbyOpened, content: {
    TabbyCheckout(productType: openedProduct, onResult: { result in
        print("TABBY RESULT: \(result) !")
        switch result {
        case .authorized:
            // Do something else when Tabby authorized customer
            // probably navigation back to Home screen, refetching, etc.
            self.isTabbyOpened = false
            break
        case .rejected:
            // Do something else when Tabby rejected customer
            self.isTabbyOpened = false
            break
        case .close:
            // Do something else when customer closed Tabby checkout
            self.isTabbyOpened = false
            break
        case .expired:
            // Do something else when session expired
            // We strongly recommend to create new session here by calling
            // TabbySDK.shared.configure(forPayment: myTestPayment) { result in ... }
            self.isTabbyOpened = false
            break
        }
    })
})
```

![Checkout](./docs/Checkout.gif)

### Full example code goes here

```swift

struct CheckoutExampleWithTabby: View {
    @State var isTabbyInstallmentsAvailable = false
    @State var isTabbyPaylatersAvailable = false

    @State var openedProduct: TabbyProductType = .installments
    @State var isTabbyOpened: Bool = false

    var body: some View {
        VStack {
            Button(action: {
                openedProduct = .installments
                isTabbyOpened = true
            }, label: {
                HStack {
                    Text("My Tabby 'Installments' fancy Button")
                        .font(.headline)
                        .foregroundColor(isTabbyInstallmentsAvailable ? .black : .white)
                }
            })
            .disabled(!isTabbyInstallmentsAvailable)

            Button(action: {
                openedProduct = .pay_later
                isTabbyOpened = true
            }, label: {
                HStack {
                    Text("My Tabby 'PayLater' fancy Button")
                        .font(.headline)
                        .foregroundColor(isTabbyPaylatersAvailable ? .black : .white)
                }
            })
            .disabled(!isTabbyPaylatersAvailable)

        }
        .sheet(isPresented: $isTabbyOpened, content: {
            TabbyCheckout(productType: openedProduct, onResult: { result in
                print("TABBY RESULT: \(result)!!!")
                switch result {
                case .authorized:
                    // Do something else when Tabby authorized customer
                    // probably navigation back to Home screen, refetching, etc.
                    self.isTabbyOpened = false
                    break
                case .rejected:
                    // Do something else when Tabby rejected customer
                    self.isTabbyOpened = false
                    break
                case .close:
                    // Do something else when customer closed Tabby checkout
                    self.isTabbyOpened = false
                    break
                case .expired:
                    // Do something else when session expired
                    // We strongly recommend to create new session here by calling
                    // TabbySDK.shared.configure(forPayment: myTestPayment) { result in ... }
                    self.isTabbyOpened = false
                    break
                }
            })
        })
        .onAppear() {
            TabbySDK.shared.configure(forPayment: myTestPayment) { result in
                switch result {
                case .success(let s):
                    // 1. Do something with sessionId (this step is optional)
                    print("sessionId: \(s.sessionId)")
                    // 2. Do something with paymentId (this step is optional)
                    print("paymentId: \(s.paymentId)")
                    // 3. Grab avaibable products from session and enable proper
                    // payment method buttons in your UI (this step is required)
                    // Feel free to ignore products you don't need or don't want to handle in your App
                    print("tabby available products: \(s.tabbyProductTypes)")
                    // If you want to handle installments product - check for .installments in response 
                    if (s.tabbyProductTypes.contains(.installments)) {
                        self.isTabbyInstallmentsAvailable = true
                    }
                    // If you want to handle pay_later product - check for .pay_later in response
                    if (s.tabbyProductTypes.contains(.pay_later)) {
                        self.isTabbyPaylatersAvailable = true
                    }
                case .failure(let error):
                    // Do something when Tabby checkout session POST requiest failed
                    print(error)
                }
            }
        }
    }
}
```

![Checkout](./docs/Checkout.png)

## Snippets usage

### TabbyPresentationSnippet

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

<!-- ![UIKit](./docs/UIKit.png) -->

## Result

![Snippet EN](./docs/TabbyPresentationSnippet_EN.gif)
![Snippet AR](./docs/TabbyPresentationSnippet_AR.gif)

### TabbyCheckoutSnippet

```swift
import UIKit
import SwiftUI
import Tabby

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            let vc = UIHostingController(
                rootView: Tabby.TabbyCheckoutSnippet(
                    amount: 350,
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

## Result

![Snippet EN](./docs/TabbyCheckoutSnippet_EN.png)
![Snippet AR](./docs/TabbyCheckoutSnippet_AR.png)
