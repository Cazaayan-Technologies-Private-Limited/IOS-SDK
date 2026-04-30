////
////  VerticsVC.swift
////  t5
////
////  Created by manas dutta on 12/12/25.
////
//
//import UIKit
//import WebKit
//
//public protocol VerticsVCDelegate: AnyObject {
//    func didReceiveApiResponse(data: [String: Any], identifier1: String, identifier3: String)
//}
//
//public class VerticsVC: UIViewController, WKNavigationDelegate {
//    
//    // MARK: - UI
//    private var webView: WKWebView!
//    private let activityIndicator = UIActivityIndicatorView(style: .medium)
//    private let navigationBar = UIView()
//    private let cancelButton = UIButton(type: .system)
//    
//    // MARK: - Data
//    public var DigiLockerURL: String?
//    public var TransactionID: String?
//    public var identifier1: String?
//    public var flag: String?
//    public var panNo: String?
//    public var mobiledecodeArray: String?
//    public var RegId: String?
//    public var fetchedUserId: String?
//    public var fetchedSessionID: String?
//    public weak var delegate: VerticsVCDelegate?
//    public var identifier3: String?
//    
//    private var timer: DispatchSourceTimer?
//    private var isProcessCompleted = false
//    private var isApiInProgress = false
//    
//    // MARK: - Lifecycle
//    public override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        
//        setupNavigationBar()
//        setupWebView()
//        setupLoader()
//        fetchUserDetails()
//        loadWebView()
//        //startApiCallTimer()
//        // navigationBar.isHidden = true
//    }
//    
//    private func safelyCloseWebViewAndPop() {
//        // 1. Stop timer
//        timer?.cancel()
//        timer = nil
//        
//        // 2. Stop WebView loading
//        webView?.stopLoading()
//        webView?.navigationDelegate = nil
//        
//        // 3. Delay pop to next runloop (VERY IMPORTANT)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//            if self.navigationController?.topViewController === self {
//                self.navigationController?.popViewController(animated: true)
//            }
//        }
//    }
//    
//    public init() {
//        super.init(nibName: nil, bundle: Bundle.module)
//    }
//     
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)   // ✅ DO NOT crash
//    }
//    
//    // MARK: - UI Setup
//    private func setupNavigationBar() {
//        navigationBar.backgroundColor = .white
//        navigationBar.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(navigationBar)
//        
//        cancelButton.setTitle("Cancel", for: .normal)
//        cancelButton.translatesAutoresizingMaskIntoConstraints = false
//        cancelButton.addTarget(self, action: #selector(CancelBtn), for: .touchUpInside)
//        navigationBar.addSubview(cancelButton)
//        
//        NSLayoutConstraint.activate([
//            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            navigationBar.heightAnchor.constraint(equalToConstant: 50),
//            
//            cancelButton.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor, constant: 16),
//            cancelButton.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor)
//        ])
//    }
//    
//    private func setupWebView() {
//        webView = WKWebView()
//        webView.navigationDelegate = self
//        webView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(webView)
//        
//        NSLayoutConstraint.activate([
//            webView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
//            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//    }
//    
//    private func setupLoader() {
//        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
//        activityIndicator.hidesWhenStopped = true
//        view.addSubview(activityIndicator)
//        
//        NSLayoutConstraint.activate([
//            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
//        
//        activityIndicator.startAnimating()
//    }
//    
//    // MARK: - Data Fetch
//    private func fetchUserDetails() {
//        print("PAN: \(panNo ?? "Not Found")")
//        
//        CoreDataHelper.fetchUserId(entityName: "MobileUser") { [weak self] userId, sessionID, decodeByteArray in
//            guard let self = self else { return }
//            self.fetchedUserId = userId
//            self.fetchedSessionID = sessionID
//            self.mobiledecodeArray = decodeByteArray
//        }
//    }
//    
//    // MARK: - Load WebView
//    private func loadWebView() {
//        guard let urlString = DigiLockerURL,
//              let url = URL(string: urlString) else {
//            print("❌ Invalid DigiLocker URL")
//            return
//        }
//        webView.load(URLRequest(url: url))
//    }
//    
//    // MARK: - Actions
//    @objc private func CancelBtn() {
//        if identifier3 == "DigiLockerA" {
//            let alert = UIAlertController(
//                title: "Alert",
//                message: "Are you sure you have completed the DigiLocker process? Leaving now will require restarting.",
//                preferredStyle: .alert
//            )
//            
//            alert.addAction(UIAlertAction(title: "YES", style: .default) { _ in
//                self.navigationController?.popViewController(animated: true)
//            })
//            
//            alert.addAction(UIAlertAction(title: "NO", style: .cancel))
//            alert.view.tintColor = UIColor(red: 0.43, green: 0.21, blue: 0.43, alpha: 1.0)
//            
//            present(alert, animated: true)
//        } else if identifier3 == "NomineeVC" {
//                self.navigationController?.popViewController(animated: true)
//        }
//    }
//    
//    // MARK: - WKNavigationDelegate
//    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        activityIndicator.stopAnimating()
//        print("✅ WebView Loaded Successfully")
//        startApiCallTimer()
//    }
//    
//    func ValidatesaveDigiLocker(completion: @escaping (Bool) -> Void) {
//        // Prevent duplicate API hits
//        guard !isApiInProgress else { return }
//        isApiInProgress = true
//        
//        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [weak self] tokenId in
//            guard let self = self else { return }
//            // 🔁 Token missing → generate & retry
//            guard let tokenId = tokenId else {
//                self.isApiInProgress = false
//                
//                CoreDataHelper.generateToken(
//                    decodeByteArrayToString: self.mobiledecodeArray ?? "",
//                    USERID: self.fetchedUserId ?? "",
//                    SessionId: self.fetchedSessionID ?? "",
//                    entityName: "TokenMobile",
//                    deviceType: "W",
//                    in: self.view
//                ) { success in
//                    if success {
//                        // Retry AFTER token generation
//                        self.ValidatesaveDigiLocker(completion: completion)
//                    } else {
//                        completion(false)
//                    }
//                }
//                return
//            }
//            // ✅ Token available → call API
//            let parameters: [String: Any] = [
//                "UserId": self.fetchedUserId ?? "",
//                "TokenId": tokenId,
//                "RegId": self.RegId ?? "",
//                "PanNo": self.panNo ?? "",
//                "TransactionID": self.TransactionID ?? "",
//                "Flag": self.flag ?? "0"
//            ]
//            
//            print("➡️ ValidateIsDigiLockerDone params:", parameters)
//            
//            apiCall(
//                url: "AadhaarData/ValidateIsDigiLockerDone",
//                method: "POST",
//                parameters: parameters,
//                view: self.view
//            ) { result in
//                
//                DispatchQueue.main.async {
//                    self.isApiInProgress = false
//                    
//                    switch result {
//                    case .success(let json):
//                        print("✅ DigiLocker Response:", json)
//                        
//                        let errorCode = json["ErrorCode"] as? String ?? ""
//                        
//                        if errorCode == "000000" || errorCode == "000023" {
//                            self.timer?.cancel()
//                            self.delegate?.didReceiveApiResponse(
//                                data: json,
//                                identifier1: self.identifier1 ?? "", identifier3: self.identifier3 ?? ""
//                            )
//                            self.safelyCloseWebViewAndPop()
//                            completion(true)
//                        } else {
//                            completion(false)
//                        }
//                        
//                    case .failure(let error):
//                        print("❌ API failed:", error.localizedDescription)
//                        completion(false)
//                    }
//                }
//            }
//        }
//    }
//    
//    func startApiCallTimer() {
//        timer?.cancel()
//        
//        timer = DispatchSource.makeTimerSource(queue: .main)
//        timer?.schedule(deadline: .now() + 5, repeating: 5)
//        
//        timer?.setEventHandler { [weak self] in
//            self?.ValidatesaveDigiLocker { success in
//                if success {
//                    self?.timer?.cancel()
//                }
//            }
//        }
//        timer?.resume()
//    }
//    deinit {
//        timer?.cancel()
//    }
//}
//

import UIKit
import WebKit

public protocol VerticsVCDelegate: AnyObject {
    func didReceiveApiResponse(data: [String: Any], identifier1: String, identifier3: String)
}

public class VerticsVC: UIViewController, WKNavigationDelegate {
    
    // MARK: - UI
    private var webView: WKWebView!
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private let navigationBar = UIView()
    private let cancelButton = UIButton(type: .system)
    
    // MARK: - Data
    public var DigiLockerURL: String?
    public var TransactionID: String?
    public var identifier1: String?
    public var flag: String?
    public var panNo: String?
    public var mobiledecodeArray: String?
    public var RegId: String?
    public var fetchedUserId: String?
    public var fetchedSessionID: String?
    public weak var delegate: VerticsVCDelegate?
    public var identifier3: String?
    
    private var timer: DispatchSourceTimer?
    private var isProcessCompleted = false
    private var isApiInProgress = false
    
    // MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupWebView()
        setupLoader()
        fetchUserDetails()
        loadWebView()
        //startApiCallTimer()
        // navigationBar.isHidden = true
    }
    
    private func safelyCloseWebViewAndPop() {
        // 1. Stop timer
        timer?.cancel()
        timer = nil
        
        // 2. Stop WebView loading
        webView?.stopLoading()
        webView?.navigationDelegate = nil
        
        // 3. Delay pop to next runloop (VERY IMPORTANT)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if self.navigationController?.topViewController === self {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    public init() {
        super.init(nibName: nil, bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)   // ✅ DO NOT crash
    }
    
    // MARK: - UI Setup
    private func setupNavigationBar() {
        navigationBar.backgroundColor = .white
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationBar)
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(CancelBtn), for: .touchUpInside)
        navigationBar.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 50),
            
            cancelButton.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor, constant: 16),
            cancelButton.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor)
        ])
    }
    
    private func setupWebView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupLoader() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        activityIndicator.startAnimating()
    }
    
    // MARK: - Data Fetch
    private func fetchUserDetails() {
        print("PAN: \(panNo ?? "Not Found")")
        
        CoreDataHelper.fetchUserId(entityName: "MobileUser") { [weak self] userId, sessionID, decodeByteArray in
            guard let self = self else { return }
            self.fetchedUserId = userId
            self.fetchedSessionID = sessionID
            self.mobiledecodeArray = decodeByteArray
        }
    }
    
    // MARK: - Load WebView
    private func loadWebView() {
        guard let urlString = DigiLockerURL,
              let url = URL(string: urlString) else {
            print("❌ Invalid DigiLocker URL")
            return
        }
        webView.load(URLRequest(url: url))
    }
    
    // MARK: - Actions
    @objc private func CancelBtn() {
        if identifier3 == "DigiLockerA" {
            let alert = UIAlertController(
                title: "Alert",
                message: "Are you sure you have completed the DigiLocker process? Leaving now will require restarting.",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "YES", style: .default) { _ in
                self.navigationController?.popViewController(animated: true)
            })
            
            alert.addAction(UIAlertAction(title: "NO", style: .cancel))
            alert.view.tintColor = UIColor(red: 0.43, green: 0.21, blue: 0.43, alpha: 1.0)
            
            present(alert, animated: true)
        } else if identifier3 == "NomineeVC" {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - WKNavigationDelegate
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
        print("✅ WebView Loaded Successfully")
        startApiCallTimer()
    }
    
    func ValidatesaveDigiLocker(completion: @escaping @Sendable (Bool) -> Void) {
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [weak self] tokenId in
            guard let self = self else { return }
            // 🔁 Token missing → generate & retry
            guard let tokenId = tokenId else {
                self.isApiInProgress = false
                
                CoreDataHelper.generateToken(
                    decodeByteArrayToString: self.mobiledecodeArray ?? "",
                    USERID: self.fetchedUserId ?? "",
                    SessionId: self.fetchedSessionID ?? "",
                    entityName: "TokenMobile",
                    deviceType: "W",
                    in: self.view
                ) { success in
                    if success {
                        // Retry AFTER token generation
                        self.ValidatesaveDigiLocker(completion: completion)
                    } else {
                        completion(false)
                    }
                }
                return
            }
            // ✅ Token available → call API
            let parameters: [String: Any] = [
                "UserId": self.fetchedUserId ?? "",
                "TokenId": tokenId,
                "RegId": self.RegId ?? "",
                "PanNo": self.panNo ?? "",
                "TransactionID": self.TransactionID ?? "",
                "Flag": self.flag ?? "0"
            ]
            
            print("➡️ ValidateIsDigiLockerDone params:", parameters)
            
            apiCall(
                url: "AadhaarData/ValidateIsDigiLockerDone",
                method: "POST",
                parameters: parameters,
                view: self.view
            ) { result in
                
                DispatchQueue.main.async {
                    self.isApiInProgress = false
                    
                    switch result {
                    case .success(let json):
                        print("✅ DigiLocker Response:", json)
                        
                        let errorCode = json["ErrorCode"] as? String ?? ""
                        
                        if errorCode == "000000" || errorCode == "000023" {
                            self.timer?.cancel()
                            self.delegate?.didReceiveApiResponse(
                                data: json,
                                identifier1: self.identifier1 ?? "", identifier3: self.identifier3 ?? ""
                            )
                            self.safelyCloseWebViewAndPop()
                            completion(true)
                        } else {
                            completion(false)
                        }
                        
                    case .failure(let error):
                        print("❌ API failed:", error.localizedDescription)
                        completion(false)
                    }
                }
            }
        }
    }
    
    func startApiCallTimer() {
        timer?.cancel()
        
        timer = DispatchSource.makeTimerSource(queue: .main)
        timer?.schedule(deadline: .now() + 5, repeating: 5)
        
        timer?.setEventHandler { [weak self] in
            self?.ValidatesaveDigiLocker { success in
                if success {
                    self?.timer?.cancel()
                }
            }
        }
        timer?.resume()
    }
    deinit {
        timer?.cancel()
    }
}
//import UIKit
//import WebKit
//
//public protocol VerticsVCDelegate: AnyObject {
//    func didReceiveApiResponse(data: [String: Any], identifier1: String)
//}
//
//public class VerticsVC: UIViewController, WKNavigationDelegate {
//    
//    // MARK: - UI
//    private var webView: WKWebView!
//    private let activityIndicator = UIActivityIndicatorView(style: .medium)
//    private let navigationBar = UIView()
//    private let cancelButton = UIButton(type: .system)
//    
//    // MARK: - Data
//    public var DigiLockerURL: String?
//    public var TransactionID: String?
//    public var identifier1: String?
//    public var flag: String?
//    public var panNo: String?
//    public var mobiledecodeArray: String?
//    public var RegId: String?
//    public var fetchedUserId: String?
//    public var fetchedSessionID: String?
//    public weak var delegate: VerticsVCDelegate?
//    public var identifier3: String?
//    
//    private var timer: DispatchSourceTimer?
//    private var isProcessCompleted = false
//    private var isApiInProgress = false
//    
//    // MARK: - Lifecycle
//    public override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        
//        setupNavigationBar()
//        setupWebView()
//        setupLoader()
//        fetchUserDetails()
//        loadWebView()
//        //startApiCallTimer()
//        // navigationBar.isHidden = true
//    }
//    
//    private func safelyCloseWebViewAndPop() {
//        // 1. Stop timer
//        timer?.cancel()
//        timer = nil
//        
//        // 2. Stop WebView loading
//        webView?.stopLoading()
//        webView?.navigationDelegate = nil
//        
//        // 3. Delay pop to next runloop (VERY IMPORTANT)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//            if self.navigationController?.topViewController === self {
//                self.navigationController?.popViewController(animated: true)
//            }
//        }
//    }
//    
//    public init() {
//        super.init(nibName: nil, bundle: Bundle.module)
//    }
//     
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)   // ✅ DO NOT crash
//    }
//    
//    // MARK: - UI Setup
//    private func setupNavigationBar() {
//        navigationBar.backgroundColor = .white
//        navigationBar.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(navigationBar)
//        
//        cancelButton.setTitle("Cancel", for: .normal)
//        cancelButton.translatesAutoresizingMaskIntoConstraints = false
//        cancelButton.addTarget(self, action: #selector(CancelBtn), for: .touchUpInside)
//        navigationBar.addSubview(cancelButton)
//        
//        NSLayoutConstraint.activate([
//            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            navigationBar.heightAnchor.constraint(equalToConstant: 50),
//            
//            cancelButton.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor, constant: 16),
//            cancelButton.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor)
//        ])
//    }
//    
//    private func setupWebView() {
//        webView = WKWebView()
//        webView.navigationDelegate = self
//        webView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(webView)
//        
//        NSLayoutConstraint.activate([
//            webView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
//            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//    }
//    
//    private func setupLoader() {
//        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
//        activityIndicator.hidesWhenStopped = true
//        view.addSubview(activityIndicator)
//        
//        NSLayoutConstraint.activate([
//            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
//        
//        activityIndicator.startAnimating()
//    }
//    
//    // MARK: - Data Fetch
//    private func fetchUserDetails() {
//        print("PAN: \(panNo ?? "Not Found")")
//        
//        CoreDataHelper.fetchUserId(entityName: "MobileUser") { [weak self] userId, sessionID, decodeByteArray in
//            guard let self = self else { return }
//            self.fetchedUserId = userId
//            self.fetchedSessionID = sessionID
//            self.mobiledecodeArray = decodeByteArray
//        }
//    }
//    
//    // MARK: - Load WebView
//    private func loadWebView() {
//        guard let urlString = DigiLockerURL,
//              let url = URL(string: urlString) else {
//            print("❌ Invalid DigiLocker URL")
//            return
//        }
//        webView.load(URLRequest(url: url))
//    }
//    
//    // MARK: - Actions
//    @objc private func CancelBtn() {
//        if identifier3 == "DigiLockerA" {
//            let alert = UIAlertController(
//                title: "Alert",
//                message: "Are you sure you have completed the DigiLocker process? Leaving now will require restarting.",
//                preferredStyle: .alert
//            )
//            
//            alert.addAction(UIAlertAction(title: "YES", style: .default) { _ in
//                self.navigationController?.popViewController(animated: true)
//            })
//            
//            alert.addAction(UIAlertAction(title: "NO", style: .cancel))
//            alert.view.tintColor = UIColor(red: 0.43, green: 0.21, blue: 0.43, alpha: 1.0)
//            
//            present(alert, animated: true)
//        } else if identifier3 == "NomineeVC" {
//                self.navigationController?.popViewController(animated: true)
//        }
//    }
//    
//    // MARK: - WKNavigationDelegate
//    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        activityIndicator.stopAnimating()
//        print("✅ WebView Loaded Successfully")
//        startApiCallTimer()
//    }
//    
//    func ValidatesaveDigiLocker(completion: @escaping (Bool) -> Void) {
//        // Prevent duplicate API hits
//        guard !isApiInProgress else { return }
//        isApiInProgress = true
//        
//        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [weak self] tokenId in
//            guard let self = self else { return }
//            // 🔁 Token missing → generate & retry
//            guard let tokenId = tokenId else {
//                self.isApiInProgress = false
//                
//                CoreDataHelper.generateToken(
//                    decodeByteArrayToString: self.mobiledecodeArray ?? "",
//                    USERID: self.fetchedUserId ?? "",
//                    SessionId: self.fetchedSessionID ?? "",
//                    entityName: "TokenMobile",
//                    deviceType: "W",
//                    in: self.view
//                ) { success in
//                    if success {
//                        // Retry AFTER token generation
//                        self.ValidatesaveDigiLocker(completion: completion)
//                    } else {
//                        completion(false)
//                    }
//                }
//                return
//            }
//            // ✅ Token available → call API
//            let parameters: [String: Any] = [
//                "UserId": self.fetchedUserId ?? "",
//                "TokenId": tokenId,
//                "RegId": self.RegId ?? "",
//                "PanNo": self.panNo ?? "",
//                "TransactionID": self.TransactionID ?? "",
//                "Flag": self.flag ?? "0"
//            ]
//            
//            print("➡️ ValidateIsDigiLockerDone params:", parameters)
//            
//            apiCall(
//                url: "AadhaarData/ValidateIsDigiLockerDone",
//                method: "POST",
//                parameters: parameters,
//                view: self.view
//            ) { result in
//                
//                DispatchQueue.main.async {
//                    self.isApiInProgress = false
//                    
//                    switch result {
//                    case .success(let json):
//                        print("✅ DigiLocker Response:", json)
//                        
//                        let errorCode = json["ErrorCode"] as? String ?? ""
//                        
//                        if errorCode == "000000" || errorCode == "000023" {
//                            self.timer?.cancel()
//                            self.delegate?.didReceiveApiResponse(
//                                data: json,
//                                identifier1: self.identifier1 ?? ""
//                            )
//                            self.safelyCloseWebViewAndPop()
//                            completion(true)
//                        } else {
//                            completion(false)
//                        }
//                        
//                    case .failure(let error):
//                        print("❌ API failed:", error.localizedDescription)
//                        completion(false)
//                    }
//                }
//            }
//        }
//    }
//    
//    func startApiCallTimer() {
//        timer?.cancel()
//        
//        timer = DispatchSource.makeTimerSource(queue: .main)
//        timer?.schedule(deadline: .now() + 5, repeating: 5)
//        
//        timer?.setEventHandler { [weak self] in
//            self?.ValidatesaveDigiLocker { success in
//                if success {
//                    self?.timer?.cancel()
//                }
//            }
//        }
//        timer?.resume()
//    }
//    deinit {
//        timer?.cancel()
//    }
//}
