import SwiftUI
import WebKit

// MARK: - Web View Source

enum WebViewSource: Equatable {
    case url(URL)
    case html(String)
}

// MARK: - Tabby Web Widget View (Reusable Component)

/// Reusable web widget component that wraps WKWebView for Tabby promotional snippets.
///
/// This component handles:
/// - Loading web widgets from Tabby's widget service
/// - Message passing between JavaScript and native code
/// - Dynamic height adjustment based on widget content
/// - Full-screen "Learn More" pop-up modal
/// - RTL layout support for Arabic
///
/// - Note: This is an internal component. Use `TabbySnippetView` or `TabbyCardView` instead.
@available(iOS 14.0, macOS 11.0, *)
struct TabbyWebWidgetView: View {

    private let source: WebViewSource
    private let lang: Lang
    private let analyticsPrefix: String
    private let transparentBackground: Bool

    // MARK: State
    @State private var webViewHeight: CGFloat = 80
    @State private var isLoaded = false
    @State private var openURLAction: OpenURLAction?

    // MARK: Init

    /// Creates a web widget view that loads a remote URL with query parameters.
    init(
        widgetURL: String,
        queryParams: [String: String],
        lang: Lang = .en,
        analyticsPrefix: String = "Snippet",
        transparentBackground: Bool = false
    ) {
        let urlString = "\(widgetURL)?\(queryParams.queryString)"
        self.source = .url(URL(string: urlString)!)
        self.lang = lang
        self.analyticsPrefix = analyticsPrefix
        self.transparentBackground = transparentBackground
    }

    /// Creates a web widget view that loads local HTML content.
    init(
        htmlContent: String,
        lang: Lang = .en,
        analyticsPrefix: String = "Snippet",
        transparentBackground: Bool = false
    ) {
        self.source = .html(htmlContent)
        self.lang = lang
        self.analyticsPrefix = analyticsPrefix
        self.transparentBackground = transparentBackground
    }

    // MARK: Body
    var body: some View {
        TabbyWebView(
            source: source,
            initializationData: nil,
            isScrollEnabled: false,
            transparentBackground: transparentBackground,
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

// MARK: - Full-Screen WebView

@available(iOS 14.0, macOS 11.0, *)
private struct FullScreenWebView: View {
    let urlAction: OpenURLAction
    let lang: Lang
    let onDismiss: () -> Void

    var body: some View {
        if let url = URL(string: urlAction.url) {
            ZStack(alignment: lang == .ar ? .topLeading : .topTrailing) {
                TabbyWebView(
                    source: .url(url),
                    initializationData: urlAction.data,
                    isScrollEnabled: true,
                    transparentBackground: false,
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
    let source: WebViewSource
    let initializationData: String?
    let isScrollEnabled: Bool
    let transparentBackground: Bool
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
        if transparentBackground {
            // WKWebView paints an opaque white canvas regardless of the page's CSS;
            // without this, shouldInheritBg never shows the host app background.
            webView.isOpaque = false
            webView.backgroundColor = .clear
            webView.scrollView.backgroundColor = .clear
        }

        context.coordinator.webView = webView
        load(in: webView, coordinator: context.coordinator)
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        context.coordinator.webView = webView
        // SwiftUI reuses the same WKWebView instance when the merchant changes
        // amount/currency/api key, so the new source must be reloaded explicitly —
        // otherwise the widget keeps showing the first URL forever (MPC-2731).
        if context.coordinator.loadedSource != source {
            load(in: webView, coordinator: context.coordinator)
        }
    }

    // MARK: Private helper
    private func load(in webView: WKWebView, coordinator: Coordinator) {
        coordinator.loadedSource = source
        switch source {
        case .url(let url):
            webView.load(URLRequest(url: url))
        case .html(let html):
            webView.loadHTMLString(html, baseURL: nil)
        }
    }

    // MARK: Coordinator
    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        private let initializationData: String?
        private let onLoaded: () -> Void
        private let onOpenURL: (OpenURLAction) -> Void
        private let onDimensionsChanged: (WebViewDimensions) -> Void

        weak var webView: WKWebView?
        /// Last source actually loaded into the web view; lets `updateUIView` skip redundant reloads.
        var loadedSource: WebViewSource?

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
                    webView.evaluateJavaScript(script) { _, error in
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
