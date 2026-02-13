import SwiftUI
import WebKit

struct BrowserView: View {
    @EnvironmentObject var appState: AppState
    @State private var urlText: String = "https://www.bing.com"
    @State private var isLoading: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            BrowserToolbar(
                urlText: $urlText,
                canGoBack: $appState.canGoBack,
                canGoForward: $appState.canGoForward,
                isLoading: isLoading,
                onGo: {
                    loadURL()
                },
                onRefresh: {
                    // Trigger refresh via NotificationCenter
                    NotificationCenter.default.post(name: .refreshBrowser, object: nil)
                },
                onBack: {
                    NotificationCenter.default.post(name: .goBack, object: nil)
                },
                onForward: {
                    NotificationCenter.default.post(name: .goForward, object: nil)
                }
            )

            WebViewContainer(urlString: $urlText, isLoading: $isLoading)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color.white)
    }

    private func loadURL() {
        var urlString = urlText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !urlString.hasPrefix("http://") && !urlString.hasPrefix("https://") {
            urlString = "https://" + urlString
        }
        urlText = urlString
        NotificationCenter.default.post(name: .loadURL, object: urlString)
    }
}

extension Notification.Name {
    static let loadURL = Notification.Name("loadURL")
    static let refreshBrowser = Notification.Name("refreshBrowser")
    static let goBack = Notification.Name("goBack")
    static let goForward = Notification.Name("goForward")
}

struct BrowserToolbar: View {
    @Binding var urlText: String
    @Binding var canGoBack: Bool
    @Binding var canGoForward: Bool
    let isLoading: Bool
    let onGo: () -> Void
    let onRefresh: () -> Void
    let onBack: () -> Void
    let onForward: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            HStack(spacing: 4) {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14))
                }
                .buttonStyle(.plain)
                .disabled(!canGoBack)

                Button(action: onForward) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                }
                .buttonStyle(.plain)
                .disabled(!canGoForward)

                Button(action: onRefresh) {
                    if isLoading {
                        ProgressView()
                            .scaleEffect(0.6)
                    } else {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 14))
                    }
                }
                .buttonStyle(.plain)
            }
            .frame(width: 80)

            HStack {
                Image(systemName: "lock.fill")
                    .font(.system(size: 10))
                    .foregroundColor(.green)

                TextField("Search or enter website name", text: $urlText)
                    .textFieldStyle(.plain)
                    .font(.system(size: 13))
                    .onSubmit {
                        onGo()
                    }
            }
            .padding(8)
            .background(Color(nsColor: .controlBackgroundColor))
            .clipShape(RoundedRectangle(cornerRadius: 6))

            Button(action: onGo) {
                Image(systemName: "arrow.right.circle.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.blue)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(nsColor: .controlBackgroundColor).opacity(0.5))
    }
}

struct WebViewContainer: View {
    @Binding var urlString: String
    @Binding var isLoading: Bool

    var body: some View {
        WebViewRepresentable(urlString: $urlString, isLoading: $isLoading)
    }
}

struct WebViewRepresentable: NSViewRepresentable {
    @Binding var urlString: String
    @Binding var isLoading: Bool

    func makeNSView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true

        if let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
        }

        context.coordinator.webView = webView
        return webView
    }

    func updateNSView(_ webView: WKWebView, context: Context) {
        NotificationCenter.default.addObserver(
            forName: .loadURL,
            object: nil,
            queue: .main
        ) { notification in
            if let urlString = notification.object as? String,
               let url = URL(string: urlString) {
                webView.load(URLRequest(url: url))
            }
        }

        NotificationCenter.default.addObserver(
            forName: .refreshBrowser,
            object: nil,
            queue: .main
        ) { _ in
            webView.reload()
        }

        NotificationCenter.default.addObserver(
            forName: .goBack,
            object: nil,
            queue: .main
        ) { _ in
            if webView.canGoBack {
                webView.goBack()
            }
        }

        NotificationCenter.default.addObserver(
            forName: .goForward,
            object: nil,
            queue: .main
        ) { _ in
            if webView.canGoForward {
                webView.goForward()
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebViewRepresentable
        weak var webView: WKWebView?

        init(_ parent: WebViewRepresentable) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isLoading = true
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
            parent.urlString = webView.url?.absoluteString ?? ""
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.isLoading = false
        }
    }
}
