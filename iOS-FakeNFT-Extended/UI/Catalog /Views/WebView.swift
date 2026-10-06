import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
	let url: URL
	@Binding var progress: Double
	@Binding var isLoading: Bool
	
	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}
	
	func makeUIView(context: Context) -> WKWebView {
		let webView = WKWebView()
		webView.navigationDelegate = context.coordinator
		
		context.coordinator.setupObservation(for: webView)
		
		let request = URLRequest(url: url)
		webView.load(request)
		
		return webView
	}
	
	func updateUIView(_ uiView: WKWebView, context: Context) {
		if let currentWebViewURL = uiView.url, currentWebViewURL.absoluteString == url.absoluteString {
			return
		}
		
		if !uiView.isLoading {
			let request = URLRequest(url: url)
			uiView.load(request)
		}
	}
	
	@MainActor
	class Coordinator: NSObject, WKNavigationDelegate {
		var parent: WebView
		var observation: NSKeyValueObservation?
		
		init(_ parent: WebView) {
			self.parent = parent
		}
		
		func setupObservation(for webView: WKWebView) {
			observation = webView.observe(\.estimatedProgress, options: .new) { [weak self] _, change in
				guard let self = self, let newValue = change.newValue else { return }
				Task { @MainActor in
					self.parent.progress = newValue
				}
			}
		}
		
		func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
			parent.isLoading = true
		}
		
		func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
			parent.isLoading = false
		}
		
		func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
			let nsError = error as NSError
			if nsError.code == NSURLErrorCancelled { return }
			parent.isLoading = false
		}
		
		func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
			let nsError = error as NSError
			if nsError.code == NSURLErrorCancelled { return }
			parent.isLoading = false
		}
		
		deinit {
			observation?.invalidate()
		}
	}
}
