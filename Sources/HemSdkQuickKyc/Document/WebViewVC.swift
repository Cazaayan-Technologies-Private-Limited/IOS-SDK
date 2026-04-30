//
//  WebViewVC.swift
//  t5
//
//  Created by manas dutta on 22/12/25.
//
import UIKit
import WebKit
import UniformTypeIdentifiers

protocol WebViewDelegate: AnyObject {
    func webViewDidFinishLoad(ocrcount: Int, response: [String: Any]?)
}

class WebViewVC: UIViewController, WKNavigationDelegate, WKUIDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate  {
    
    @IBOutlet weak var stackview: UIStackView!
    @IBOutlet weak var webview: WKWebView!
    @IBOutlet weak var holderView: UIView!
    
    weak var delegate: WebViewDelegate?
    var location: String?
    var url: String?
    var transactionId: String?
    var regID: String?
    var panNo: String?
    var userId: String?
    var latitude: String?
    var longitude: String?
    var ocrCount: Int? = 1
    private var timer: DispatchSourceTimer?
    var uploadCompletionHandler: (([URL]?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(location,"location")
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true
        webConfiguration.mediaTypesRequiringUserActionForPlayback = []
        
        webview = WKWebView(frame: .zero, configuration: webConfiguration)
        webview.uiDelegate = self
        webview.navigationDelegate = self
        webview.translatesAutoresizingMaskIntoConstraints = false
        
        holderView.addSubview(webview)
        
        // Set constraints for webview inside holderView
        NSLayoutConstraint.activate([
            webview.leadingAnchor.constraint(equalTo: holderView.leadingAnchor),
            webview.trailingAnchor.constraint(equalTo: holderView.trailingAnchor),
            webview.topAnchor.constraint(equalTo: holderView.topAnchor),
            webview.bottomAnchor.constraint(equalTo: holderView.bottomAnchor)
        ])
        
        if let urlString = url, let requestURL = URL(string: urlString) {
            let request = URLRequest(url: requestURL)
            webview.load(request)
        }
        
        startApiCallTimer()
    }
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        let alert = UIAlertController(title: "Alert", message: "Are you sure you have completed the Capturing Image Process? because once you exit this screen without completing the Process, all the process done will be lost and you have to perform the same process again.", preferredStyle: .alert)
        
        // Add YES action
        let yesAction = UIAlertAction(title: "YES", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        })
        
        // Add NO action
        let noAction = UIAlertAction(title: "NO", style: .cancel, handler: nil)
        
        // Present the alert
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        // Set the text color of the YES button
        let colorHex = UIColor(red: 0.43, green: 0.21, blue: 0.43, alpha: 1.0) // Hex #6D366E
        alert.view.tintColor = colorHex
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Handle File Upload
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        if message == "upload-file" {
            // showUploadOptions()
            completionHandler(true)
        } else {
            completionHandler(false)
        }
    }
    
    func ValidateIsPhotoDone(completion: @escaping @Sendable (Bool) -> Void) {
        let parameters: [String: Any] = [
            "TransactionID": transactionId ?? "",
            "URL": "",
            "ErrorMessage": "",
            "ErrorCode": "",
            "RegId": regID ?? "",
            "PanNo": panNo ?? "",
            "UserId": userId ?? "",
            "Flag": "Insert",
            "Latitude": latitude ?? "",
            "Longitude": longitude ?? "",
            "Location": location ?? "",
            "OCR_Count": "\(ocrCount ?? 1)",
        ]
        
        let apiUrl = "MultiPartImageUpload/ValidateIsPhotoDone"
        
        Task { @MainActor in
            apiCall(url: apiUrl, method: "POST", parameters: parameters, view: self.view) { result in
                switch result {
                case .success(let jsonResponse):
                    print("ValidateIsPhotoDone:-\(jsonResponse)")
                    
                    guard let errorCode = jsonResponse["ErrorCode"] as? String else {
                        completion(false)
                        return
                    }
                    
                    switch errorCode {
                    case "000000":
                        self.ocrCount = 0
                        self.navigationController?.popViewController(animated: true)
                        self.delegate?.webViewDidFinishLoad(ocrcount: 0, response: jsonResponse)
                        completion(true)
                        
                    case "801005", "801006":
                        if (self.ocrCount ?? 0) < 3 {
                            self.ocrCount = (self.ocrCount ?? 0) + 1
                        }
                        self.navigationController?.popViewController(animated: true)
                        self.delegate?.webViewDidFinishLoad(ocrcount: self.ocrCount ?? 1, response: jsonResponse)
                        completion(true)
                        
                    default:
                        completion(false)
                    }
                    
                case .failure(let error):
                    print("API Error: \(error)")
                    completion(false)
                }
            }
        }
    }
    
    func startApiCallTimer() {
        timer?.cancel()
        
        let newTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global(qos: .background))
        newTimer.schedule(deadline: .now(), repeating: 10.0)
        newTimer.setEventHandler { [weak self] in
            self?.ValidateIsPhotoDone { success in
                if success {
                    self?.timer?.cancel()
                }
            }
        }
        timer = newTimer
        timer?.resume()
    }
    deinit {
        timer?.cancel()
    }
}

