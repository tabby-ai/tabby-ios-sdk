import SwiftUI
import WebKit

// MARK: - Tabby Snippet

@available(iOS 14.0, macOS 11.0, *)
public struct TabbySnippetView: View {

    private let url: URL
    private let lang: Lang

    // MARK: State
    @State private var webViewHeight: CGFloat = 80
    @State private var isLoaded = false
    @State private var openURLAction: OpenURLAction?

    // MARK: Init
    public init(
        amount: Double,
        currency: Currency,
        lang: Lang = .en
    ) {
        let price = Int(amount)
        let urlString = "\(BaseURL.WebView.Widgets.url)?price=\(price)&currency=\(currency.rawValue)&lang=\(lang.rawValue)&publicKey=\(TabbySDK.shared.apiKey)"
        self.url = URL(string: urlString)!
        self.lang = lang
    }

    // MARK: Body
    public var body: some View {
        TabbyWebView(
            url: url,
            initializationData: nil,
            isScrollEnabled: false,
            onLoaded: { isLoaded = true },
            onOpenURL: { openURLAction = $0 },
            onDimensionsChanged: { webViewHeight = $0.height }
        )
        .frame(height: webViewHeight)
        .opacity(isLoaded ? 1 : 0)
        .animation(.easeInOut(duration: 0.3), value: isLoaded)
        .animation(.easeInOut(duration: 0.2), value: webViewHeight)
        .fullScreenCover(item: $openURLAction) { action in
            FullScreenWebView(urlAction: action, lang: lang) { openURLAction = nil }
        }
    }
}

// MARK: - Full‑Screen WebView

@available(iOS 14.0, macOS 11.0, *)
private struct FullScreenWebView: View {
    let urlAction: OpenURLAction
    let lang: Lang
    let onDismiss: () -> Void

    var body: some View {
        if let url = URL(string: urlAction.url) {
            ZStack(alignment: lang == .ar ? .topLeading : .topTrailing) {
                TabbyWebView(
                    url: url,
                    initializationData: urlAction.data,
                    isScrollEnabled: true,
                    onLoaded: {},
                    onOpenURL: { _ in },
                    onDimensionsChanged: { _ in }
                )

                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .font(.title)
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
                .padding()
            }
        }
    }
}

// MARK: - SwiftUI Wrapper for WKWebView

private struct TabbyWebView: UIViewRepresentable {
    let url: URL
    let initializationData: String?
    let isScrollEnabled: Bool
    let onLoaded: () -> Void
    let onOpenURL: (OpenURLAction) -> Void
    let onDimensionsChanged: (WebViewDimensions) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(
            initializationData: initializationData,
            onLoaded: onLoaded,
            onOpenURL: onOpenURL,
            onDimensionsChanged: onDimensionsChanged
        )
    }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = .nonPersistent()
        config.userContentController.add(context.coordinator, name: "tabbyMobileSDK")

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.scrollView.isScrollEnabled = isScrollEnabled
        
        context.coordinator.webView = webView
        load(in: webView)
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        guard webView.url != url else { return }
        context.coordinator.webView = webView
        load(in: webView)
    }

    // MARK: Private helper
    private func load(in webView: WKWebView) {
        let request = URLRequest(url: url)
        webView.load(request)
    }

    // MARK: Coordinator
    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        private let initializationData: String?
        private let onLoaded: () -> Void
        private let onOpenURL: (OpenURLAction) -> Void
        private let onDimensionsChanged: (WebViewDimensions) -> Void
        
        weak var webView: WKWebView?

        init(initializationData: String?,
             onLoaded: @escaping () -> Void,
             onOpenURL: @escaping (OpenURLAction) -> Void,
             onDimensionsChanged: @escaping (WebViewDimensions) -> Void) {
            self.initializationData = initializationData
            self.onLoaded = onLoaded
            self.onOpenURL = onOpenURL
            self.onDimensionsChanged = onDimensionsChanged
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // Send initialization data if available (as per documentation)
            if let data = initializationData {
                sendInitializationData(data, to: webView)
            }
            onLoaded()
        }
        
        private func sendInitializationData(_ data: String, to webView: WKWebView) {
            let initMessage = InitializationDataMessage(type: "initializationData", data: data)
            
            do {
                let jsonData = try JSONEncoder().encode(initMessage)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    let script = """
                        window.postMessage(\(jsonString), '*');
                    """
                    webView.evaluateJavaScript(script) { result, error in
                        if let error = error {
                            print("Error sending initialization data: \(error)")
                        }
                    }
                }
            } catch {
                print("Error encoding initialization data: \(error)")
            }
        }

        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            guard let messageBody = message.body as? String,
                  let data = messageBody.data(using: .utf8) else {
                print("Invalid message format received")
                return
            }
            
            route(data)
        }

        private func route(_ data: Data) {
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let type = json["type"] as? String {
                    
                    switch type {
                    case "onLearnMoreClicked":
                        let action = try JSONDecoder().decode(OpenURLAction.self, from: data)
                        onOpenURL(action)
                        
                    case "onChangeDimensions":
                        let dims = try JSONDecoder().decode(DimensionsMessage.self, from: data)
                        onDimensionsChanged(dims.data)
                        
                    default:
                        print("Unknown message type: \(type)")
                    }
                }
            } catch {
                print("Error decoding message: \(error)")
            }
        }
    }
}

// MARK: - Messages

private struct OpenURLAction: Codable, Identifiable {
    let type: String
    let url: String
    let data: String
    
    var id: String { "\(type)-\(url)" }
}

private struct DimensionsMessage: Codable {
    let type: String
    let data: WebViewDimensions
}

private struct WebViewDimensions: Codable {
    let width: CGFloat
    let height: CGFloat
}

private struct InitializationDataMessage: Codable {
    let type: String
    let data: String
}
