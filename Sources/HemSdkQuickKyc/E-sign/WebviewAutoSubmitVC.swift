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
//import UIKit
//import WebKit
//
//class WebviewAutoSubmitVC: UIViewController, WKNavigationDelegate {
//
//    
//    var webView: WKWebView!
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
//        webView = WKWebView(frame: self.view.bounds)
//        webView.navigationDelegate = self
//        webView.scrollView.contentInsetAdjustmentBehavior = .always
//        view.addSubview(webView)
//        
//        let navigationView = UIView()
//        navigationView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
//        
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
//        
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
//
//    func loadHTMLForm() {
//        
////        let htmlString = """
////        <!DOCTYPE html>
////        <html>
////        <head>
////        <meta name="viewport"
////              content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
////        </head>
////        <body>
////        <form id="PostForm" name="PostForm" method="POST" enctype="multipart/form-data" action="https://esign.egov.proteantech.in/nsdl-esp/authenticate/esign-doc/">
////            <input type="hidden" name="eXml" value="\(xmlMsg.urlEncoded())"/>
////            <input type="hidden" name="txn" value="\(txn)"/>
////            <input type="hidden" name="ReturnURL" value="\(ReturnURL)"/>
////            <input type="hidden" name="CompanyName" value="\(CompanyName)"/>
////        </form>
////
////        <script type="text/javascript">
////            window.onload = function() {
////                document.getElementById("PostForm").submit();
////            };
////        </script>
////        </body>
////        </html>
////        """
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
//    
//    func webView(_ webView: WKWebView,
//                 decidePolicyFor navigationAction: WKNavigationAction,
//                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//
//            if let url = navigationAction.request.url?.absoluteString {
//                print("🌐 Navigating: \(url)")
//
//                // Check if NSDL returned to your ReturnURL
//                if url.contains(ReturnURL) {
//                    print("🟢 NSDL ReturnURL reached!")
//
//                    // Execute JS to get POST data
//                    extractNSDLResponse()
//                }
//            }
//
//            decisionHandler(.allow)
//        }
//    
//    func extractNSDLResponse() {
//        let js = """
//        (function() {
//            var inputs = document.getElementsByTagName('input');
//            var data = {};
//            for (var i = 0; i < inputs.length; i++) {
//                data[inputs[i].name] = inputs[i].value;
//            }
//            var textareas = document.getElementsByTagName('textarea');
//            for (var i = 0; i < textareas.length; i++) {
//                data[textareas[i].name] = textareas[i].value;
//            }
//            return JSON.stringify(data);
//        })();
//        """
//
//        webView.evaluateJavaScript(js) { result, error in
//            if let error = error {
//                print("❌ JS Error reading NSDL response: \(error)")
//                return
//            }
//
//            guard let jsonString = result as? String else { return }
//
//            print("📩 NSDL Response Data: \(jsonString)")
//
//            if let dict = self.convertToDictionary(text: jsonString) {
//
//                // 1️⃣ Prefer new API key "msg"
//                if let msgString = dict["msg"] as? String {
//                    print("📝 NSDL XML Response via msg:")
//                    print(msgString)
//
//                    if let nav = self.navigationController,
//                       let esignVC = nav.viewControllers.first(where: { $0 is ApplicationStatusVC }) as? ApplicationStatusVC {
//                        esignVC.NSDLEsignResponse(decodedResponse: msgString)
//                    }
//                    return
//                }
//
//                // 2️⃣ fallback to old key "response"
//                if let xmlResp = dict["response"] as? String {
//                    print("📝 NSDL XML Response via response:")
//                    print(xmlResp)
//
//                    if let nav = self.navigationController,
//                       let esignVC = nav.viewControllers.first(where: { $0 is ApplicationStatusVC }) as? ApplicationStatusVC {
//                        esignVC.NSDLEsignResponse(decodedResponse: xmlResp)
//                    }
//                    return
//                }
//
//                print("⚠️ No valid NSDL XML response found.")
//            }
//        }
//    }
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
    var esignUrl: String?
    var documentId: String?
    var isDDPI: Bool = false
    
    var pollingAttempts = 0
    let maxPollingAttempts = 20
    weak var parentVC: ApplicationStatusVC?
    
    var fetchedUserId: String?
    var fetchedSessionID: String?
    var decodeArray: String?
    var PanNo: String?
    var RegId: String?
    public var onSDKClose: (() -> Void)?
    
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
        //startEsignDonePolling()
        //loadDDPIURL()
        if isDDPI {
            loadDDPIURL()
            startDDPIPolling()   // ✅ ADD THIS
        } else {
            loadHTMLForm()
            startEsignDonePolling()
        }
        CoreDataHelper.fetchUserId(entityName: "MobileUser") { [weak self] userId, sessionID , decodeByteArrayString in
            guard let self = self else { return }
            
            if let userId = userId, let sessionID = sessionID {
                self.fetchedUserId = userId
                self.fetchedSessionID = sessionID
                self.decodeArray = decodeByteArrayString
                self.ValidateToken()
                print("UserID: \(userId), SessionID: \(sessionID)")
              
            } else {
                print("No UserID or SessionID found.")
            }
        }
    }
    
    func ValidateToken(){
        
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
            guard let tokenId = tokenId else {
                CoreDataHelper.generateToken(
                    decodeByteArrayToString: self.decodeArray ?? "",
                    USERID: self.fetchedUserId ?? "",
                    SessionId: self.fetchedSessionID ?? "",
                    entityName: "TokenMobile", deviceType: "W", in: self.view
                ) { success in
                    if success {
                        // Retry SIXTHAPI after token regeneration
                        self.ValidateToken()
                    } else {
                        print("Token generation failed.")
                    }
                }
                // Handle the case where no tokens are available
                print("No tokens available. Please reload the tokens.")
                return
            }
            let parameters: [String: Any?] = [
                "UserId":  fetchedUserId,
                "TokenId": tokenId
            ]
            print(parameters)
            let Url = "TokenAuthentication/ValidateToken"
            
            apiCall(url: Url, method: "POST", parameters: parameters as [String : Any], view: self.view) { result in
                switch result {
                case .success(let jsonResponse):
                    print("ValidateToken Response: \(jsonResponse)")
                    if let errorCode = jsonResponse["ErrorCode"] as? String {
                        switch errorCode {
                        case "000000":
                            DispatchQueue.main.async {
                                print("api is running")
                            }
                        default:
                            print("Unhandled error code: \(errorCode)")
                        }
                    }
                case .failure(let error):
                    print("Login API call failed: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func startDDPIPolling() {
        guard let documentId = documentId else {
            print("❌ No documentId")
            return
        }

        print("🚀 Starting DDPI Polling...")

        pollingAttempts = 0

        pollingTimer = Timer.scheduledTimer(withTimeInterval: 15.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            self.pollingAttempts += 1

            if self.pollingAttempts >= self.maxPollingAttempts {
                print("⛔ Polling timeout")
                self.stopPolling()
                return
            }

            self.callDDPIStatusAPI(documentId: documentId)
        }
    }
    
    func loadDDPIURL() {
        guard let urlString = esignUrl,
              let url = URL(string: urlString) else {
            print("❌ Invalid DDPI URL")
            return
        }
        
        webView.load(URLRequest(url: url))
    }
    
    
    @objc func closeWebview() {
        if isDDPI, let docId = documentId {
            parentVC?.stopEsignPolling()
        }
        navigationController?.popViewController(animated: true)
    }

    
    func startEsignDonePolling() {
        pollingTimer = Timer.scheduledTimer(withTimeInterval: 15.0, repeats: true, block: { [weak self] _ in
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
extension WebviewAutoSubmitVC {

    func startPolling() {
        guard documentId != nil else { return }

        pollingTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.pollingAttempts += 1

            if self?.pollingAttempts ?? 0 >= self?.maxPollingAttempts ?? 20 {
                print("⛔ DDPI Polling timeout")
                self?.stopPolling()
                return
            }

            self?.checkDDPIStatus()
        }
    }

    func stopPolling() {
        pollingTimer?.invalidate()
        pollingTimer = nil
    }

    func checkDDPIStatus() {

        guard let nav = self.navigationController,
              let vc = nav.viewControllers.first(where: { $0 is ApplicationStatusVC }) as? ApplicationStatusVC,
              let docId = documentId else {
            return
        }

        print("📡 Checking DDPI status...")

        vc.checkDDPIEsignStatus(documentId: docId)

        // 🔥 IMPORTANT: Instead of relying only on print logs,
        // observe ddpiSign update

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if vc.ddpiSign == "1" {
                print("✅ DDPI Completed → Closing SDK")

                self.stopPolling()

                vc.closeSDK()   // 🔥 CLOSE FULL SDK
            }
        }
    }
    
    func callDDPIStatusAPI(documentId: String) {

        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [weak self] tokenId in
            guard let self = self else { return }

            guard let tokenId = tokenId else {
                print("❌ No token, generating new...")

                CoreDataHelper.generateToken(
                    decodeByteArrayToString: "",
                    USERID: "",
                    SessionId: "",
                    entityName: "TokenMobile",
                    deviceType: "W",
                    in: self.view
                ) { success in
                    if success {
                        self.callDDPIStatusAPI(documentId: documentId)
                    }
                }
                return
            }

            let parameters: [String: Any] = [
                "documentId": documentId
            ]

            let url = "NSDLEsign/ValidateIsDDPIEsignDone"

            print("📤 DDPI API Call")

            apiCall(url: url, method: "POST", parameters: parameters, view: self.view) { result in

                switch result {

                case .success(let json):

                                print("📩 DDPI Response:", json)

                                guard let errorCode = json["ErrorCode"] as? String else {
                                    print("❌ Invalid response")
                                    return
                                }

                                if errorCode == "000000" {
                                    print("✅ DDPI API SUCCESS → Calling SIXTH API")

                                    // 👉 CALL SIXTH API HERE
                                    DispatchQueue.main.async {
                                        self.SIXTHAPI(userID: self.fetchedUserId ?? "")
                                    }
                                }

                            case .failure(let error):
                                print("❌ API Error:", error.localizedDescription)
                            }
                        }
                    }
                }
    
    func closeSDKCompletely() {
        
        DispatchQueue.main.async {
            
            // ✅ Notify host app first
            self.onSDKClose?()
            
            // ✅ Close full SDK (important)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                
                window.rootViewController?.dismiss(animated: true)
            } else {
                self.view.window?.rootViewController?.dismiss(animated: true)
            }
        }
    }
    
    func SIXTHAPI(userID:String){
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { tokenId in
            guard let tokenId = tokenId else {
                // Handle the case where no tokens are available
                CoreDataHelper.generateToken(
                    decodeByteArrayToString: self.decodeArray ?? "",
                    USERID: self.fetchedUserId ?? "",
                    SessionId: self.fetchedSessionID ?? "",
                    entityName: "TokenMobile", deviceType: "W", in: self.view
                ) { success in
                    if success {
                        // Retry SIXTHAPI after token regeneration
                        self.SIXTHAPI(userID: userID)
                    } else {
                        print("Token generation failed.")
                    }
                }
                print("No tokens available. Please reload the tokens.")
                return
            }
            let parameters: [String: Any] = [
                "UserId": self.fetchedUserId as Any,
                "TokenId": tokenId
            ]
            print("6th api params\(parameters)")
            let sixthUrl = "ActiveApplication/GetActiveApplicationCL"
            // API call
            apiCall(url: sixthUrl, method: "POST", parameters: parameters, view: self.view,loaderText: "Kindly wait we are fetching your details...") { result in
                switch result {
                case .success(let jsonResponse):
                    print("GetActiveApplicationCL: \(jsonResponse)")
//                    self.panNo = jsonResponse["PanNo"] as? String
//                    self.regId = jsonResponse["RegId"] as? String
//                    self.PANName = jsonResponse["PANName"] as? String
//                    self.EmailId = jsonResponse["EmailId"] as? String
                  
                    if let errorCode = jsonResponse["ErrorCode"] as? String {
                        switch errorCode {
                        case "999992":
                            DispatchQueue.main.async {
                                CoreDataHelper.deleteAllTokens(entityName: "TokenMobile")
                                print("All TokenMobile entries deleted due to error code 999992")
                                
                                // Regenerate tokens
                                CoreDataHelper.generateToken(decodeByteArrayToString: self.decodeArray ?? "", USERID: userID, SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
                                    if success {
                                        // Retry SIXTHAPI after token regeneration
                                        self.SIXTHAPI(userID: userID)
                                    } else {
                                        print("Token generation failed.")
                                    }
                                }
                            }
                            
                        case "000000":
                            print("✅ SIXTH API SUCCESS")

                              let isPdfSign = jsonResponse["IsPdfSign"] as? String ??
                                              String(jsonResponse["IsPdfSign"] as? Int ?? 0)

                              print("🔍 IsPdfSign:", isPdfSign)

                              if isPdfSign == "1" {
                                  print("🔥 DDPI SIGN COMPLETED → CLOSE SDK")

                                  DispatchQueue.main.async {
                                      self.stopPolling()
                                      self.closeSDKCompletely()
                                  }
                              }
                        default:
                            print("Unhandled error code: \(errorCode)")
                        }
                    }
                case .failure(let error):
                    print("SIXTHAPI API call failed: \(error.localizedDescription)")
                }
            }
        }
    }
}
