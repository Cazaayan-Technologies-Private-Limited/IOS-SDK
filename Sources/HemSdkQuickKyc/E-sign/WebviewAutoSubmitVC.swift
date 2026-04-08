//
//  WebviewAutoSubmitVC.swift
//  t5965458
//
//  Created by manas dutta on 22/12/25.
//

//import UIKit
//import WebKit
//
//class WebviewAutoSubmitVC: UIViewController, WKNavigationDelegate {
//
//    public private(set) var webView: WKWebView!
//    var actionURL: String = ""
//    var xmlMsg: String = ""
//    var txn: String = ""
//    var ReturnURL: String = ""
//    var CompanyName: String = ""
//    var pollingTimer: Timer?
//    var EsignType: String = ""
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        let config = WKWebViewConfiguration()
//        config.preferences.javaScriptEnabled = true
//
//        webView = WKWebView(frame: view.bounds, configuration: config)
//        webView.navigationDelegate = self
//        webView.scrollView.contentInsetAdjustmentBehavior = .always
//        view.addSubview(webView)
//        
//        let navigationView = UIView()
//        navigationView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
//    
//        let closeButton = UIButton(type: .system)
//        closeButton.setTitle("✕ Close", for: .normal)
//        closeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
//        closeButton.backgroundColor = UIColor.black.withAlphaComponent(0.6)
//        closeButton.setTitleColor(.white, for: .normal)
//        closeButton.layer.cornerRadius = 6
//        closeButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
//        closeButton.addTarget(self, action: #selector(closeWebview), for: .touchUpInside)
//        
//        closeButton.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(closeButton)
//        // Layout: Top-right
//        NSLayoutConstraint.activate([
//            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
//            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
//        ])
//        
//        loadHTMLForm()
//        startEsignDonePolling()
//    }
//
//    @objc func closeWebview() {
//        pollingTimer?.invalidate()
//        pollingTimer = nil
//        self.navigationController?.popViewController(animated: true)
//    }
//    
//    func startEsignDonePolling() {
//        pollingTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: { [weak self] _ in
//            self?.checkEsignDone()
//        })
//    }
//    
//    func checkEsignDone() {
//        guard let nav = self.navigationController,
//              let esignVC = nav.viewControllers.first(where: { $0 is ApplicationStatusVC }) as? ApplicationStatusVC,
//              let txn = esignVC.txnId else {
//            return
//        }
//
//        print("⏳ Checking Esign completion...")
//
//        esignVC.esignDone(segmentName: "", transactionID: txn) { [weak self] completed in
//            DispatchQueue.main.async {
//                if completed {
//                    print("🟢 Esign Completed")
//
//                    self?.pollingTimer?.invalidate()
//                    self?.pollingTimer = nil
//
//                    esignVC.showAlert(message: "Esign Completed Successfully!")
//
//                    // Close WebView
//                    self?.navigationController?.popViewController(animated: true)
//                } else {
//                    print("❗ Esign not completed yet...")
//                    // Optional: show message once
//                }
//            }
//        }
//    }
//
//    func loadHTMLForm() {
//        let htmlString = """
//        <!DOCTYPE html>
//        <html>
//        <head>
//        <meta name="viewport"
//              content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
//        </head>
//        <body>
//        <form id="URL" name="URL" method="POST" enctype="multipart/form-data" action="https://esign.egov.proteantech.in/nsdl-esp/authenticate/esign-doc/">
//            <input type="text" name="msg" value='\(xmlMsg)'/>
//            <input type="text" name="txn" value="\(txn)"/>
//            <input type="text" name="ReturnURL" value="\(ReturnURL)"/>
//        <input type="text" name="CompanyName" value="\(CompanyName)"/>
//                <input type="text" name="CompanyName" value="\(EsignType)"/>
//        </form>
//
//        <script type="text/javascript">
//            window.onload = function() {
//                document.getElementById("URL").submit();
//            };
//        </script>
//        </body>
//        </html>
//        """
//        webView.loadHTMLString(htmlString, baseURL: nil)
//        print("html: \(htmlString)")
//    }
//
//    func webView(_ webView: WKWebView,
//                 decidePolicyFor navigationResponse: WKNavigationResponse,
//                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
//
//        if let url = navigationResponse.response.url?.absoluteString {
//            print("📥 NavigationResponse URL:", url)
//
//            if url.contains(ReturnURL) {
//                print("🟢 ReturnURL reached via response")
//
//                extractNSDLResponse()
//            }
//        }
//        decisionHandler(.allow)
//    }
//
//    func extractNSDLResponse() {
//
//        let js = """
//        (function() {
//            return document.documentElement.outerHTML;
//        })();
//        """
//
//        webView.evaluateJavaScript(js) { [weak self] result, error in
//            if let error = error {
//                print("❌ JS Error:", error)
//                return
//            }
//
//            guard let html = result as? String else {
//                print("❌ Unable to read HTML")
//                return
//            }
//
//            print("📄 NSDL HTML Response:")
//            print(html)
//
//            // 🔎 Extract XML from HTML
//            if let xml = self?.extractXML(from: html) {
//
//                print("🟢 Extracted NSDL XML:")
//                print(xml)
//
//                if let nav = self?.navigationController,
//                   let esignVC = nav.viewControllers.first(where: { $0 is ApplicationStatusVC }) as? ApplicationStatusVC {
//                    esignVC.NSDLEsignResponse(decodedResponse: xml)
//                }
//
//            } else {
//                print("⚠️ NSDL XML not found in HTML")
//            }
//        }
//    }
//    
//    func extractXML(from html: String) -> String? {
//
//        // Common NSDL response patterns
//        let patterns = [
//            "<\\?xml[\\s\\S]*?</EsignResp>",
//            "<EsignResp[\\s\\S]*?</EsignResp>"
//        ]
//
//        for pattern in patterns {
//            if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive),
//               let match = regex.firstMatch(in: html, options: [], range: NSRange(html.startIndex..., in: html)) {
//
//                return String(html[Range(match.range, in: html)!])
//            }
//        }
//
//        return nil
//    }
//    
//    func webView(_ webView: WKWebView,
//                 decidePolicyFor navigationAction: WKNavigationAction,
//                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//
//        if let url = navigationAction.request.url?.absoluteString {
//            print("🌐 Navigating: \(url)")
//
//            if url.contains(ReturnURL) {
//                print("🟢 ReturnURL hit")
//            }
//        }
//        decisionHandler(.allow)
//    }
//    
//    func webView(_ webView: WKWebView,
//                 createWebViewWith configuration: WKWebViewConfiguration,
//                 for navigationAction: WKNavigationAction,
//                 windowFeatures: WKWindowFeatures) -> WKWebView? {
//
//        if navigationAction.targetFrame == nil {
//            webView.load(navigationAction.request)
//        }
//        return nil
//    }
//    
//    func convertToDictionary(text: String) -> [String: Any]? {
//        if let data = text.data(using: .utf8) {
//            return try? JSONSerialization.jsonObject(with: data) as? [String: Any]
//        }
//        return nil
//    }
//}
import UIKit
import WebKit

class WebviewAutoSubmitVC: UIViewController, WKNavigationDelegate {

    
    var webView: WKWebView!
    var actionURL: String = ""
    var xmlMsg: String = ""
    var txn: String = ""
    var ReturnURL: String = ""
    var CompanyName: String = ""
    var pollingTimer: Timer?
    var EsignType: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView(frame: self.view.bounds)
        webView.navigationDelegate = self
        webView.scrollView.contentInsetAdjustmentBehavior = .always
        view.addSubview(webView)
        
        let navigationView = UIView()
        navigationView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("✕ Close", for: .normal)
        closeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        closeButton.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.layer.cornerRadius = 6
        closeButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
        closeButton.addTarget(self, action: #selector(closeWebview), for: .touchUpInside)
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        
        // Layout: Top-right
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        
        loadHTMLForm()
        startEsignDonePolling()
    }

      
    @objc func closeWebview() {
        pollingTimer?.invalidate()
        pollingTimer = nil
        self.navigationController?.popViewController(animated: true)
    }
    
    func startEsignDonePolling() {
        pollingTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: { [weak self] _ in
            self?.checkEsignDone()
        })
    }
    
    func checkEsignDone() {
        guard let nav = self.navigationController,
              let esignVC = nav.viewControllers.first(where: { $0 is ApplicationStatusVC }) as? ApplicationStatusVC,
              let txn = esignVC.txnId else {
            return
        }

        print("⏳ Checking Esign completion...")

        esignVC.esignDone(segmentName: "", transactionID: txn) { [weak self] completed in
            DispatchQueue.main.async {
                if completed {
                    print("🟢 Esign Completed")

                    self?.pollingTimer?.invalidate()
                    self?.pollingTimer = nil

                    esignVC.showAlert(message: "Esign Completed Successfully!")

                    // Close WebView
                    self?.navigationController?.popViewController(animated: true)
                } else {
                    print("❗ Esign not completed yet...")
                    // Optional: show message once
                }
            }
        }
    }


    func loadHTMLForm() {
        
//        let htmlString = """
//        <!DOCTYPE html>
//        <html>
//        <head>
//        <meta name="viewport"
//              content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
//        </head>
//        <body>
//        <form id="PostForm" name="PostForm" method="POST" enctype="multipart/form-data" action="https://esign.egov.proteantech.in/nsdl-esp/authenticate/esign-doc/">
//            <input type="hidden" name="eXml" value="\(xmlMsg.urlEncoded())"/>
//            <input type="hidden" name="txn" value="\(txn)"/>
//            <input type="hidden" name="ReturnURL" value="\(ReturnURL)"/>
//            <input type="hidden" name="CompanyName" value="\(CompanyName)"/>
//        </form>
//
//        <script type="text/javascript">
//            window.onload = function() {
//                document.getElementById("PostForm").submit();
//            };
//        </script>
//        </body>
//        </html>
//        """
        let htmlString = """
        <!DOCTYPE html>
        <html>
        <head>
        <meta name="viewport"
              content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
        </head>
        <body>
        <form id="URL" name="URL" method="POST" enctype="multipart/form-data" action="https://esign.egov.proteantech.in/nsdl-esp/authenticate/esign-doc/">
            <input type="text" name="msg" value='\(xmlMsg)'/>
            <input type="text" name="txn" value="\(txn)"/>
            <input type="text" name="ReturnURL" value="\(ReturnURL)"/>
        <input type="text" name="CompanyName" value="\(CompanyName)"/>
                <input type="text" name="CompanyName" value="\(EsignType)"/>
        </form>

        <script type="text/javascript">
            window.onload = function() {
                document.getElementById("URL").submit();
            };
        </script>
        </body>
        </html>
        """
        webView.loadHTMLString(htmlString, baseURL: nil)
        print("html: \(htmlString)")
    }
    
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

            if let url = navigationAction.request.url?.absoluteString {
                print("🌐 Navigating: \(url)")

                // Check if NSDL returned to your ReturnURL
                if url.contains(ReturnURL) {
                    print("🟢 NSDL ReturnURL reached!")

                    // Execute JS to get POST data
                    extractNSDLResponse()
                }
            }

            decisionHandler(.allow)
        }
    
    func extractNSDLResponse() {
        let js = """
        (function() {
            var inputs = document.getElementsByTagName('input');
            var data = {};
            for (var i = 0; i < inputs.length; i++) {
                data[inputs[i].name] = inputs[i].value;
            }
            var textareas = document.getElementsByTagName('textarea');
            for (var i = 0; i < textareas.length; i++) {
                data[textareas[i].name] = textareas[i].value;
            }
            return JSON.stringify(data);
        })();
        """

        webView.evaluateJavaScript(js) { result, error in
            if let error = error {
                print("❌ JS Error reading NSDL response: \(error)")
                return
            }

            guard let jsonString = result as? String else { return }

            print("📩 NSDL Response Data: \(jsonString)")

            if let dict = self.convertToDictionary(text: jsonString) {

                // 1️⃣ Prefer new API key "msg"
                if let msgString = dict["msg"] as? String {
                    print("📝 NSDL XML Response via msg:")
                    print(msgString)

                    if let nav = self.navigationController,
                       let esignVC = nav.viewControllers.first(where: { $0 is ApplicationStatusVC }) as? ApplicationStatusVC {
                        esignVC.NSDLEsignResponse(decodedResponse: msgString)
                    }
                    return
                }

                // 2️⃣ fallback to old key "response"
                if let xmlResp = dict["response"] as? String {
                    print("📝 NSDL XML Response via response:")
                    print(xmlResp)

                    if let nav = self.navigationController,
                       let esignVC = nav.viewControllers.first(where: { $0 is ApplicationStatusVC }) as? ApplicationStatusVC {
                        esignVC.NSDLEsignResponse(decodedResponse: xmlResp)
                    }
                    return
                }

                print("⚠️ No valid NSDL XML response found.")
            }
        }
    }
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            return try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        }
        return nil
    }
}
