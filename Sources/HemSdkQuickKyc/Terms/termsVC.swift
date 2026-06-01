//
//  termsVC.swift
//  t5
//
//  Created by manas dutta on 12/12/25.
//

//import UIKit
//import WebKit
//
//class termsVC: UIViewController, WKNavigationDelegate {
//    
//    @IBOutlet weak var holderviewMain: UIView!
//    @IBOutlet weak var label: UILabel!
//    //@IBOutlet weak var cancelBtn: UIButton!
//   // @IBOutlet weak var holderviewMinoer: UIView!
//   // @IBOutlet weak var webView: WKWebView!
//    
//    var dismissHandler: (() -> Void)?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Set corner radius for views
//        self.holderviewMain.layer.cornerRadius = 15
//        //self.holderviewMinoer.layer.cornerRadius = 15
//        //self.webView.layer.cornerRadius = 15
//        // Set WKWebView's navigation delegate
//        //webView.navigationDelegate = self
//        // Load the URL in the WKWebView
////        if let url = URL(string: "https://instakyc.plindia.com/Content/TermsAndConditions.html") {
////            let request = URLRequest(url: url)
//           // webView.load(request)
//        }
//    }
//    
////    override func viewDidDisappear(_ animated: Bool) {
////        super.viewDidDisappear(animated)
////        dismissHandler?()
////    }
////    
////    @IBAction func cancelBtn(_ sender: UIButton) {
////        dismiss(animated: true)
////    }
////}
//
////extension termsVC{
////    // When the web content finishes loading, inject the CSS for increasing text size
////    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
////        // Inject CSS to increase the font size of all text
////        let cssString = "body { font-size: 220%; }"  // Adjust the percentage as needed
////        let jsString = "var style = document.createElement('style'); style.innerHTML = '\(cssString)'; document.head.appendChild(style);"
////        webView.evaluateJavaScript(jsString, completionHandler: nil)
////    }
////}



    import UIKit
    import WebKit

class termsVC: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var holderviewMain: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var holderviewMinoer: UIView!
    @IBOutlet weak var webView: WKWebView!
    
    var dismissHandler: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set corner radius for views
        self.holderviewMain.layer.cornerRadius = 15
        self.holderviewMinoer.layer.cornerRadius = 15
        self.webView.layer.cornerRadius = 15
        // Set WKWebView's navigation delegate
        webView.navigationDelegate = self
        // Load the URL in the WKWebView
        if let url = URL(string: "file:///Users/manasdatta/Downloads/tc.html") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dismissHandler?()
    }
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

extension termsVC{
    // When the web content finishes loading, inject the CSS for increasing text size
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Inject CSS to increase the font size of all text
        let cssString = "body { font-size: 220%; }"  // Adjust the percentage as needed
        let jsString = "var style = document.createElement('style'); style.innerHTML = '\(cssString)'; document.head.appendChild(style);"
        webView.evaluateJavaScript(jsString, completionHandler: nil)
    }
}
