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
		
		context.coordinator.observation = webView.observe(\.estimatedProgress, options: .new) { _, change in
			if let newValue = change.newValue {
				DispatchQueue.main.async {
					self.progress = newValue
				}
			}
		}
		
		let request = URLRequest(url: url)
		webView.load(request)
		
		return webView
	}
	
	func updateUIView(_ uiView: WKWebView, context: Context) {
	}
	
	class Coordinator: NSObject, WKNavigationDelegate {
		var parent: WebView
		var observation: NSKeyValueObservation?
		
		init(_ parent: WebView) {
			self.parent = parent
		}
		
		func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
			DispatchQueue.main.async {
				self.parent.isLoading = true
			}
		}
		
		func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
			DispatchQueue.main.async {
				self.parent.isLoading = false
			}
		}
		
		func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
			let nsError = error as NSError
			if nsError.code == NSURLErrorCancelled {
				return
			}
			DispatchQueue.main.async {
				self.parent.isLoading = false
			}
		}
		
		func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
			let nsError = error as NSError
			if nsError.code == NSURLErrorCancelled {
				return
			}
			DispatchQueue.main.async {
				self.parent.isLoading = false
			}
		}
		
		deinit {
			observation?.invalidate()
		}
	}
}
