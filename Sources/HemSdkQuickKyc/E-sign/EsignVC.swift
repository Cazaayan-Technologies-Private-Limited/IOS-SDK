//
//  EsignVC.swift
//  t5
//
//  Created by manas dutta on 18/03/26.
//

//import UIKit
//
//class ApplicationStatusVC: UIViewController, @MainActor AadhaarStackDelegate {
//    
//    func didAcceptTerms(segmentName: String, signKey: String) {
//        print("Terms accepted for segment: \(segmentName)")
//        NSDLEsign(segmentName: segmentName, signKey: signKey)
//    }
//    
//    @IBOutlet weak var nameLbl: UILabel!
//    @IBOutlet weak var onBordingView: UIView!
//    @IBOutlet weak var applicationView: UIView!
//    @IBOutlet weak var waitingView: UIView!
//    @IBOutlet weak var approveView: UIView!
//    @IBOutlet weak var onBordingDateLbl: UILabel!
//    @IBOutlet weak var applicationDateLbl: UILabel!
//    @IBOutlet weak var waitingDateLbl: UILabel!
//    @IBOutlet weak var approveDateLbl: UILabel!
//    @IBOutlet weak var mainView: UIView!
//    @IBOutlet weak var secondView: UIView!
//    @IBOutlet weak var pdfLbl: UILabel!
//    @IBOutlet weak var holderview1: UIView!
//    @IBOutlet weak var holderview2: UIView!
//    @IBOutlet weak var holderview3: UIView!
//    @IBOutlet weak var ekraBtn: UIButton!
//    @IBOutlet weak var aofBtn: UIButton!
//    @IBOutlet weak var ddpiBtn: UIButton!
//    @IBOutlet weak var ekraViewBtn: UIButton!
//    @IBOutlet weak var aofViewBtn: UIButton!
//    @IBOutlet weak var ddpiViewBtn: UIButton!
//    @IBOutlet weak var ekraStack: UIStackView!
//    @IBOutlet weak var ddpiStack: UIStackView!
//    @IBOutlet weak var aofStack: UIStackView!
//    
//    var fetchedUserId: String?
//    var fetchedSessionID: String?
//    var mobiledecodeArray: String?
//    var decodeArray:String?
//    var panNo: String?
//    var regId: String?
//    var PANName : String?
//    var EmailId : String?
//    var isDerivative: String = "N"
//    var networth: String?
//    var networthDate: String?
//    var finalStatus: String?
//    var ekraSign: String = "0"
//    var aofSign: String = "0"
//    var ddpiSign: String = "0"
//    var ekraID: String?
//    var aofID: String?
//    var ddpiID: String?
//    var PanNo : String?
//    var RegId : String?
//    var signedResponse: String?
//    var msg : String?
//    var env : String?
//    var pdfDataList: [[String: Any]] = []
//    var esignRetryCount = 10
//    var companyName: String?
//    var returnurl: String?
//    var txnId: String?
//    var esignType: String?
//    var currentEsignSegment: String?
//    public var onStartEsign: (() -> Void)?
//    public var onSDKClose: (() -> Void)?
//    var documentId: String?
//    var pollingTimer: Timer?
//    var pollingAttempts = 0
//    let maxPollingAttempts = 20
//    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = UIColor.systemGroupedBackground
//        navigationController?.isNavigationBarHidden = true
////        pdfLbl.isHidden = true
////        secondView.isHidden = true
////        mainView.layer.cornerRadius = 20
////        secondView.layer.cornerRadius = 20
////        secondView.layer.borderColor = UIColor.black.cgColor
////        secondView.layer.borderWidth = 1.0
//        SIXTHAPI(userID: fetchedUserId ?? "" )
////        onBordingView.layer.cornerRadius = 25
////        applicationView.layer.cornerRadius = 25
////        waitingView.layer.cornerRadius = 25
////        approveView.layer.cornerRadius = 25
//        
//        CoreDataHelper.fetchUserId(entityName: "MobileUser") { [weak self] userId, sessionID , decodeByteArrayString in
//            guard let self = self else { return }
//            
//            if let userId = userId, let sessionID = sessionID {
//                self.fetchedUserId = userId
//                self.fetchedSessionID = sessionID
//                self.decodeArray = decodeByteArrayString
//                self.ValidateToken()
//                print("UserID: \(userId), SessionID: \(sessionID)")
//                self.ViewAllMultiPDF()
//            } else {
//                print("No UserID or SessionID found.")
//            }
//        }
//       // ViewAllMultiPDF()
//        view.backgroundColor = .appBackground
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(appDidBecomeActive),
//            name: UIApplication.didBecomeActiveNotification,
//            object: nil
//        )
//    }
//    
//    @objc func appDidBecomeActive() {
//        print("🔄 App returned from browser")
//        guard let docId = documentId else { return }
//        
//        // Optional: Do one immediate check
//        checkDDPIEsignStatus(documentId: docId)
//        
//        // Then start polling (but with longer interval, e.g. 8-10 sec to be gentler)
//        startEsignDonePolling(documentId: docId)
//    }
//    
//    @IBAction func ekraBtnTapped(_ sender: UIButton) {
//        handleSegmentBasedOnSignValue(segmentName: "EKRA", signKey: "ekraSign")
//    }
//    
//    private func handleSegmentTap(segmentName: String, signKey: String) {
//        var signValue = getSignValue(forKey: signKey)
//        
//        if signValue == "1" {
//            // Construct URL
//            let baseUrl = "https://signup.hemnxt.com:84/V4.0.0/api/MultiPartImageUpload/PDFDownload"
//            guard let regId = RegId, let userId = fetchedUserId, let panNo = PanNo else {
//                print("Missing parameters for URL construction")
//                return
//            }
//            // Get dynamic ID based on segmentName
//            guard let dynamicID = getDynamicID(forSegment: segmentName) else {
//                print("No valid ID found for segment \(segmentName)")
//                return
//            }
//            
//            CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [weak self] tokenId in
//                guard let self = self else { return }
//                guard let tokenId = tokenId else {
//                    CoreDataHelper.generateToken(
//                        decodeByteArrayToString: self.decodeArray ?? "",
//                        USERID: self.fetchedUserId ?? "",
//                        SessionId: self.fetchedSessionID ?? "",
//                        entityName: "TokenMobile", deviceType: "W", in: self.view
//                    ) { success in
//                        if success {
//                            // Retry SIXTHAPI after token regeneration
//                            self.handleSegmentTap(segmentName: segmentName, signKey: signKey)
//                        } else {
//                            print("Token generation failed.")
//                        }
//                    }
//                    print("No tokens available. Please reload the tokens.")
//                    return
//                }
//                
//                let urlString = "\(baseUrl)?id=\(dynamicID)&RegId=\(regId)&UserId=\(userId)&PanNo=\(panNo)&PDFSegment=\(segmentName)&TokenId=\(tokenId)"
//                print("Constructed URL: \(urlString)")
//                self.openURLInSystemBrowser(urlString: urlString)
//            }
//        } else {
//            print("\(segmentName) button tapped")
//            //NSDLEsign(segmentName: segmentName, signKey: signKey)
//            let sb = UIStoryboard(name: "Esign", bundle: Bundle.module)
//            let vc = sb.instantiateViewController(
//                withIdentifier: "AadhaarStackVC"
//            ) as! AadhaarStackVC
//            vc.modalPresentationStyle = .overCurrentContext
//            vc.modalTransitionStyle = .crossDissolve
//            vc.delegate = self
//            vc.segmentName = segmentName
//            vc.signkey = signKey
//            present(vc, animated: true)
//        }
//    }
//    
//    private func handleSegmentBasedOnSignValue(segmentName: String, signKey: String) {
////        let signValue = getSignValue(forKey: signKey)
////        
////        if signValue == "0" {
////            // If eSign value is 0, present the terms screen
////            presentTermsScreen(segmentName: segmentName, signKey: signKey)
////        } else {
////            // Otherwise, directly handle the segment
////            handleSegmentTap(segmentName: segmentName, signKey: signKey)
////        }
//        let signValue = getSignValue(forKey: signKey)
//        
//        if signValue == "0" {
//            // If eSign value is 0, present the terms screen
//            NSDLEsign(segmentName: segmentName, signKey: signKey)
//        } else {
//            // Otherwise, directly handle the segment
//            handleSegmentTap(segmentName: segmentName, signKey: signKey)
//        }
//    }
//    
//    private func presentTermsScreen(segmentName: String, signKey: String) {
//        let sb = UIStoryboard(name: "Esign", bundle: Bundle.module)
//        let vc = sb.instantiateViewController(
//            withIdentifier: "AadhaarStackVC"
//        ) as! AadhaarStackVC
//        
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.modalTransitionStyle = .crossDissolve
//        vc.delegate = self
//        vc.segmentName = segmentName
//        vc.signkey = signKey
//        
//        present(vc, animated: true)
//    }
//    
//    private func getSignValue(forKey key: String) -> String {
//        switch key {
//        case "ekraSign": return ekraSign
//        case "aofSign": return aofSign
//        case "ddpiSign": return ddpiSign
//        default: return "0"
//        }
//    }
//    
//    private func updateSignValue(forKey key: String, value: String) {
//        switch key {
//        case "ekraSign": ekraSign = value
//        case "aofSign": aofSign = value
//        case "ddpiSign": ddpiSign = value
//        default: break
//        }
//    }
//    
//    private func getDynamicID(forSegment segmentName: String) -> String? {
//        switch segmentName {
//        case "EKRA": return ekraID
//        case "E": return aofID
//        case "DDPI": return ddpiID
//        default: return nil
//        }
//    }
//    
//    private func openURLInSystemBrowser(urlString: String) {
//        guard let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) else {
//            print("Invalid URL or cannot open URL")
//            return
//        }
//        
//        UIApplication.shared.open(url, options: [:]) { success in
//            if success {
//                print("Successfully opened URL in system browser")
//            } else {
//                print("Failed to open URL in system browser")
//            }
//        }
//    }
//    
//    @IBAction func aofBtn(_ sender: UIButton) {
//        if ekraSign == "0" {
//            showAlert(message: "You need to sign the EKRA segment first.")
//        } else {
//            handleSegmentBasedOnSignValue(segmentName: "E", signKey: "aofSign")
//        }
//    }
//    @IBAction func ddpiBtn(_ sender: UIButton) {
//        if ekraSign == "0" && aofSign == "0" {
//            showAlert(message: "You need to sign EKRA & AOF segments.")
//        } else if ekraSign == "0" {
//            showAlert(message: "You need to sign the EKRA segment first.")
//        } else if aofSign == "0" {
//            showAlert(message: "You need to sign the AOF segment first.")
//        } else {
//            handleSegmentBasedOnSignValue(segmentName: "DDPI", signKey: "ddpiSign")
//        }
////        if let docId = documentId {
////            startEsignDonePolling(documentId: docId)
////        }
//    }
//    
////    func startEsignDonePolling(documentId: String) {
////        stopEsignPolling()
////        pollingAttempts = 0
////
////        pollingTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
////            guard let self = self else { return }
////
////            self.pollingAttempts += 1
////
////            if self.pollingAttempts >= self.maxPollingAttempts {
////                print("⛔ Polling timeout")
////                self.stopEsignPolling()
////                return
////            }
////
////            self.checkDDPIEsignStatus(documentId: documentId)
////        }
////    }
//    
//    func startEsignDonePolling(documentId: String) {
//        stopEsignPolling()           // Stop any previous polling
//        pollingAttempts = 0
//        
//        print("🔄 Starting polling for documentId: \(documentId)")
//        
//        // ✅ IMPORTANT: Start background task FIRST
//        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
//            print("⚠️ Background task expiring - iOS is forcing us to stop")
//            self?.stopEsignPolling()
//            self?.endBackgroundTask()
//        }
//        
//        // If background task failed to start (returns .invalid)
//        if backgroundTask == .invalid {
//            print("❌ Failed to start background task")
//            // Still try to poll while app is foreground
//        }
//        
//        // Start timer on main thread
//        DispatchQueue.main.async { [weak self] in
//            guard let self = self else { return }
//            
//            self.pollingTimer = Timer.scheduledTimer(withTimeInterval: 6.0, repeats: true) { [weak self] timer in
//                guard let self = self else {
//                    timer.invalidate()
//                    return
//                }
//                
//                self.pollingAttempts += 1
//                print("📡 Polling attempt \(self.pollingAttempts)/\(self.maxPollingAttempts) at \(Date())")
//                
//                if self.pollingAttempts >= self.maxPollingAttempts {
//                    print("⛔ Polling timeout reached")
//                    self.stopEsignPolling()
//                    return
//                }
//                
//                self.checkDDPIEsignStatus(documentId: documentId)
//            }
//            
//            // Add to common run loop so it fires even when scrolling etc.
//            if let timer = self.pollingTimer {
//                RunLoop.current.add(timer, forMode: .common)
//            }
//        }
//    }
//
//    func stopEsignPolling() {
//        pollingTimer?.invalidate()
//        pollingTimer = nil
//        pollingAttempts = 0
//        endBackgroundTask()
//        print("🛑 Polling stopped")
//    }
//
//    func endBackgroundTask() {
//        if backgroundTask != .invalid {
//            print("🏁 Ending background task")
//            UIApplication.shared.endBackgroundTask(backgroundTask)
//            backgroundTask = .invalid
//        }
//    }
//    
//    func showAlert(message: String) {
//        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        DispatchQueue.main.async {
//            self.present(alert, animated: true, completion: nil)
//        }
//    }
//    
//    @IBAction func QuitBtn(_ sender: UIButton) {
//        self.navigationController?.popViewController(animated: true)
//    }
//    
////    @IBAction func ekraView(_ sender: UIButton) {
////        openPDF(segmentName: "EKRA")
////    }
////
////    @IBAction func aofView(_ sender: UIButton) {
////        openPDF(segmentName: "E")
////    }
//    
////    @IBAction func ddpiView(_ sender: UIButton) {
////        openPDF(segmentName: "DDPI")
////    }
//    
//    
//    @IBAction func ekraView(_ sender: UIButton) {
//        openPDF(segmentName: "EKRA")
//    }
//    
//    @IBAction func aofView(_ sender: UIButton) {
//        openPDF(segmentName: "E")
//    }
//    
//    @IBAction func ddpiView(_ sender: UIButton) {
//        openPDF(segmentName: "DDPI")
//    }
//    
//    func openPDF(segmentName: String) {
//        
//        // ✅ Check if PDF is signed before opening
//        var isSigned = false
//        
//        switch segmentName {
//        case "EKRA":
//            isSigned = (ekraSign == "1")
//        case "E":
//            isSigned = (aofSign == "1")
//        case "DDPI":
//            isSigned = (ddpiSign == "1")
//        default:
//            break
//        }
//        
//        // ❌ If not signed → don't open PDF
//        if !isSigned {
//            showAlert(message: "Please complete eSign first to view the PDF.")
//            return
//        }
//        
//        // ✅ Continue only if signed
//        guard let regId = RegId,
//              let userId = fetchedUserId,
//              let panNo = PanNo,
//              let dynamicID = getDynamicID(forSegment: segmentName) else {
//            print("Missing parameters")
//            return
//        }
//
//        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [weak self] tokenId in
//            guard let self = self else { return }
//            
//            guard let tokenId = tokenId else {
//                CoreDataHelper.generateToken(
//                    decodeByteArrayToString: self.decodeArray ?? "",
//                    USERID: self.fetchedUserId ?? "",
//                    SessionId: self.fetchedSessionID ?? "",
//                    entityName: "TokenMobile",
//                    deviceType: "W",
//                    in: self.view
//                ) { success in
//                    if success {
//                        self.openPDF(segmentName: segmentName)
//                    }
//                }
//                return
//            }
//
//            let baseUrl = "https://signup.hemnxt.com:84/V4.0.0/api/MultiPartImageUpload/PDFDownload"
//            let urlString = "\(baseUrl)?id=\(dynamicID)&RegId=\(regId)&UserId=\(userId)&PanNo=\(panNo)&PDFSegment=\(segmentName)&TokenId=\(tokenId)"
//
//            self.openURLInSystemBrowser(urlString: urlString)
//        }
//    }
//    
//    func ValidateToken(){
//        
//        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
//            guard let tokenId = tokenId else {
//                CoreDataHelper.generateToken(
//                    decodeByteArrayToString: self.decodeArray ?? "",
//                    USERID: self.fetchedUserId ?? "",
//                    SessionId: self.fetchedSessionID ?? "",
//                    entityName: "TokenMobile", deviceType: "W", in: self.view
//                ) { success in
//                    if success {
//                        // Retry SIXTHAPI after token regeneration
//                        self.ValidateToken()
//                    } else {
//                        print("Token generation failed.")
//                    }
//                }
//                // Handle the case where no tokens are available
//                print("No tokens available. Please reload the tokens.")
//                return
//            }
//            let parameters: [String: Any?] = [
//                "UserId":  fetchedUserId,
//                "TokenId": tokenId
//            ]
//            print(parameters)
//            let Url = "TokenAuthentication/ValidateToken"
//            
//            apiCall(url: Url, method: "POST", parameters: parameters as [String : Any], view: self.view) { result in
//                switch result {
//                case .success(let jsonResponse):
//                    print("ValidateToken Response: \(jsonResponse)")
//                    if let errorCode = jsonResponse["ErrorCode"] as? String {
//                        switch errorCode {
//                        case "000000":
//                            DispatchQueue.main.async {
//                                print("api is running")
//                            }
//                        default:
//                            print("Unhandled error code: \(errorCode)")
//                        }
//                    }
//                case .failure(let error):
//                    print("Login API call failed: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
//    
//    func NSDLEsign(segmentName: String, signKey: String) {
//        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [weak self] tokenId in
//            guard let self = self else { return }
//            guard let tokenId = tokenId else {
//                CoreDataHelper.generateToken(
//                    decodeByteArrayToString: self.decodeArray ?? "",
//                    USERID: self.fetchedUserId ?? "",
//                    SessionId: self.fetchedSessionID ?? "",
//                    entityName: "TokenMobile", deviceType: "W", in: self.view
//                ) { success in
//                    if success {
//                        // Retry SIXTHAPI after token regeneration
//                        self.NSDLEsign(segmentName: segmentName, signKey: signKey)
//                    } else {
//                        print("Token generation failed.")
//                    }
//                }
//                print("No tokens available. Please reload the tokens.")
//                return
//            }
//            
//            let parameters: [String: Any?] = [
//                "UserId": fetchedUserId,
//                "TokenId": tokenId,
//                "PanNo": PanNo,
//                "RegId": RegId,
//                "AuthMode": "1",
//                "SegmentName": segmentName,
//                "IsMobOrWeb": "1",
//                "DeviceType": "IOS"
//            ]
//            
//            let url = "NSDLEsign/NSDLEsignRquest"
//            apiCall(url: url, method: "POST", parameters: parameters as [String: Any], view: self.view,loaderText: "processing data for esign,kindly wait until completed...") { result in
//                switch result {
//                case .success(let jsonResponse):
//                    print("NSDLEsignRquest Response: \(jsonResponse)")
//                    self.msg = jsonResponse["eXml"] as? String
//                    self.env = "PROD"
//                    let ErrorMessage = jsonResponse["ErrorMessage"] as? String
//                    self.returnurl = jsonResponse["ReturnURL"] as? String
//                    self.esignType = jsonResponse["EsignType"] as? String ?? ""
//                    let esignUrl = jsonResponse["EsignUrl"] as? String ?? ""
//                    self.txnId = jsonResponse["txn"] as? String ?? ""
//                    let requestURL = jsonResponse["RquestURL"] as? String ?? ""
//                    self.companyName = jsonResponse["CompanyName"] as? String
//                    self.currentEsignSegment = segmentName
//                    self.documentId = jsonResponse["DocumentId"] as? String
//                    if let errorCode = jsonResponse["ErrorCode"] as? String {
//                        switch errorCode {
//                        case "000000":
//                            
////                            if let isDDPIEsign = jsonResponse["IsDDPIEsign"] as? Int,
////                                             isDDPIEsign == 1,
////                                             segmentName == "DDPI" {
////                                              print("✅ DDPI eSign completed immediately - Closing SDK")
////                                              DispatchQueue.main.async {
////                                                  self.closeSDK()
////                                              }
////                                              return
////                                          }
////                            
////                            let isDDPIEsign = jsonResponse["IsDDPIEsign"] as? Int ??
////                                                Int(jsonResponse["IsDDPIEsign"] as? String ?? "0") ?? 0
////
////                            self.documentId = jsonResponse["DocumentId"] as? String
////
////                            // ✅ Start polling ONLY for DDPI
////                            if segmentName == "DDPI", let docId = self.documentId {
////                                print("🚀 Starting DDPI polling with documentId: \(docId)")
////                                self.startEsignDonePolling(documentId: docId)
////                            }
//                            
////                            if segmentName == "DDPI", self.msg == nil {
////                                if !esignUrl.isEmpty {
////                                    DispatchQueue.main.async {
////                                        self.openURLInSystemBrowser(urlString: esignUrl)
////                                    }
////                                    return
////                                }
////                            }
//                            
//                            if segmentName == "DDPI", !esignUrl.isEmpty {
//                                DispatchQueue.main.async {
//                                    self.openURLInSystemBrowser(urlString: esignUrl)
//                                    
//                                    // Start polling AFTER opening browser
//                                    if let docId = self.documentId {
//                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                                            self.startEsignDonePolling(documentId: docId)
//                                        }
//                                    }
//                                }
//                                return
//                            }
//
//                            if self.esignType == "SELF" {
//                                DispatchQueue.main.async {
//                                    let vc = WebviewAutoSubmitVC()
//                                    vc.xmlMsg = self.msg ?? ""
//                                    vc.CompanyName = self.companyName ?? ""
//                                    vc.ReturnURL = self.returnurl ?? ""
//                                    vc.txn = self.txnId ?? ""
//                                    self.navigationController?.pushViewController(vc, animated: true)
//                                }
//                                return
//                            }
//
//                        case "111111":
//                            DispatchQueue.main.async {
//                                print("API is running for segment: \(segmentName)")
//                            }
//                        case "999992":
//                            DispatchQueue.main.async {
//                                CoreDataHelper.deleteAllTokens(
//                                    entityName: "TokenMobile")
//                                print("All TokenMobile entries deleted due to error code 999992")
//                                
//                                CoreDataHelper.generateToken(
//                                    decodeByteArrayToString: self.decodeArray ?? "",
//                                    USERID: self.fetchedUserId ?? "",
//                                    SessionId: self.fetchedSessionID ?? "",
//                                    entityName: "TokenMobile", deviceType: "W",
//                                    in: self.view
//                                ) { success in
//                                    if success {
//                                        // Retry SIXTHAPI after token regeneration
//                                        self.ValidateToken()
//                                    } else {
//                                        print("Token generation failed.")
//                                    }
//                                }
//                            }
//                        default:
//                            print("Unhandled error code: \(errorCode)")
//                            self.showAlert(message: "\(String(describing: ErrorMessage))")
//                        }
//                    }
//                case .failure(let error):
//                    print("API call failed: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
//    
//    func esignDone(segmentName: String, transactionID: String, completion: @escaping (Bool) -> Void) {
//        
//        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [weak self] tokenId in
//            guard let self = self else { return }
//            
//            guard let tokenId = tokenId else {
//                completion(false)
//                return
//            }
//            
//            let parameters: [String: Any?] = [
//                "PanNo": self.PanNo,
//                "RegId": self.RegId,
//                "Segment": segmentName,
//                "SessionId": self.fetchedSessionID,
//                "UserId": self.fetchedUserId,
//                "TokenId": tokenId,
//                "TransactionID": transactionID
//            ]
//            
//            apiCall(url: "NSDLEsign/ValidateIsEsignDone", method: "POST", parameters: parameters as [String: Any], view: self.view) { result in
//                
//                switch result {
//                case .success(let jsonResponse):
//                    let ErrorMessage = jsonResponse["ErrorMessage"] as? String
//                    print("ValidateIsEsignDone: \(jsonResponse)")
//                    if let errorCode = jsonResponse["ErrorCode"] as? String {
//                        switch errorCode {
//                            
//                        case "000000":
//                            DispatchQueue.main.async {
//                                print("api is running")
//                                completion(true)
//                                
//                                self.showAlert(message: "E-sign completed successfully!")
//                                
//                                self.ViewAllMultiPDF()
//                            }
//                            
//                        case "000002":
//                            DispatchQueue.main.async {
//                                print("api is running")
//                                completion(true)
//                                
//                                if let nav = self.navigationController,
//                                   let webVC = nav.viewControllers.last as? WebviewAutoSubmitVC {
//                                    nav.popViewController(animated: true)
//                                }
//                                
//                                self.showAlert(message: "Your e-signature name does not match the name on your PAN.")
//                            }
//                            
//                        default:
//                            print("Unhandled error code: \(errorCode)")
//                            DispatchQueue.main.async {
//                                completion(false)
//                                //self.showAlert(message: ErrorMessage ?? "Unknown error occurred")
//                            }
//                        }
//                    }
//                case .failure(let error):
//                    //self.showAlert(message: "Esign page:api failed--- \(error.localizedDescription)")
//                    print("Login API call failed: \(error.localizedDescription)")
//                    
//                }
//            }
//        }
//    }
//    
////    func checkDDPIEsignStatus(documentId: String) {
////        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [weak self] tokenId in
////            guard let self = self else { return }
////            
////            guard let tokenId = tokenId else {
////                CoreDataHelper.generateToken(
////                    decodeByteArrayToString: self.decodeArray ?? "",
////                    USERID: self.fetchedUserId ?? "",
////                    SessionId: self.fetchedSessionID ?? "",
////                    entityName: "TokenMobile",
////                    deviceType: "W",
////                    in: self.view
////                ) { success in
////                    if success {
////                        self.checkDDPIEsignStatus(documentId: documentId)
////                    }
////                }
////                return
////            }
////
////            let parameters: [String: Any] = [
////                "documentId": documentId
////            ]
////
////            let url = "NSDLEsignController/ValidateIsDDPIEsignDone"
////
////            apiCall(url: url, method: "POST", parameters: parameters, view: self.view) { result in
////                switch result {
////                case .success(let jsonResponse):
////                    print("📩 DDPI Status Response: \(jsonResponse)")
////
////                    if let errorCode = jsonResponse["ErrorCode"] as? String,
////                       errorCode == "000000" {
////
////                        let isDone = jsonResponse["IsEsignDone"] as? Int ??
////                                     Int(jsonResponse["IsEsignDone"] as? String ?? "0") ?? 0
////
////                        print("🔍 DDPI isDone: \(isDone)")
////
////                        // ✅ WRITE YOUR CODE HERE
////                        if isDone == 1 {
////                            DispatchQueue.main.async {
////                                print("✅ DDPI eSign Completed → Closing SDK")
////
////                                self.stopEsignPolling()
////                                self.closeSDK()
////                            }
////                        }
////                    }
////
////                case .failure(let error):
////                    print("❌ DDPI Status API Failed: \(error.localizedDescription)")
////                }
////            }
////        }
////    }
//    func checkDDPIEsignStatus(documentId: String) {
//        print("🔍 Checking DDPI status for documentId: \(documentId)")
//        print("⏰ Time: \(Date())")
//        
//        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [weak self] tokenId in
//            guard let self = self else { return }
//            
//            guard let tokenId = tokenId else {
//                print("❌ No token available, generating new one...")
//                CoreDataHelper.generateToken(
//                    decodeByteArrayToString: self.decodeArray ?? "",
//                    USERID: self.fetchedUserId ?? "",
//                    SessionId: self.fetchedSessionID ?? "",
//                    entityName: "TokenMobile",
//                    deviceType: "W",
//                    in: self.view
//                ) { success in
//                    if success {
//                        self.checkDDPIEsignStatus(documentId: documentId)
//                    }
//                }
//                return
//            }
//
//            let parameters: [String: Any] = [
//                "documentId": documentId
//            ]
//
//            let url = "NSDLEsignController/ValidateIsDDPIEsignDone"
//            print("📤 Calling API: \(url) with params: \(parameters)")
//
//            apiCall(url: url, method: "POST", parameters: parameters, view: self.view) { result in
//                switch result {
//                case .success(let jsonResponse):
//                    print("📩 DDPI Status Response at \(Date()): \(jsonResponse)")
//
//                    if let errorCode = jsonResponse["ErrorCode"] as? String,
//                       errorCode == "000000" {
//                        
//                        // Check for IsPDFSign field
//                        let isPDFSign = jsonResponse["IsPDFSign"] as? String ??
//                                        String(jsonResponse["IsPDFSign"] as? Int ?? 0)
//                        
//                        print("🔍 DDPI IsPDFSign: \(isPDFSign)")
//                        
//                        if isPDFSign == "1" {
//                            print("✅ DDPI eSign Completed (IsPDFSign = 1) → Closing SDK")
//                            DispatchQueue.main.async {
//                                self.stopEsignPolling()
//                                self.ddpiSign = "1"
//                                self.ViewAllMultiPDF()
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                                    self.closeSDK()
//                                }
//                            }
//                        } else {
//                            print("⏳ DDPI eSign not yet completed (IsPDFSign = \(isPDFSign)), waiting for next poll...")
//                        }
//                    } else {
//                        print("⚠️ Error code: \(jsonResponse["ErrorCode"] ?? "unknown")")
//                    }
//
//                case .failure(let error):
//                    print("❌ DDPI Status API Failed: \(error.localizedDescription)")
//                    // Continue polling on network errors
//                }
//            }
//        }
//    }
//
//    
//    func NSDLEsignResponse(decodedResponse: String){
//        
//        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
//            guard let tokenId = tokenId else {
//                // Handle the case where no tokens are available
//                CoreDataHelper.generateToken(
//                    decodeByteArrayToString: self.decodeArray ?? "",
//                    USERID: self.fetchedUserId ?? "",
//                    SessionId: self.fetchedSessionID ?? "",
//                    entityName: "TokenMobile", deviceType: "M", in: self.view
//                ) { success in
//                    if success {
//                        // Retry SIXTHAPI after token regeneration
//                        self.NSDLEsignResponse(decodedResponse: decodedResponse)
//                    } else {
//                        print("Token generation failed.")
//                    }
//                }
//                print("No tokens available. Please reload the tokens.")
//                return
//            }
//            let parameters: [String: Any?] = [
//                "UserId":  fetchedUserId,
//                "TokenId": tokenId,
//                "XMLResponse":decodedResponse
//            ]
//            //print(parameters)
//            
//            let Url = "NSDLEsign/NSDLEsignResponse"
//            
//            apiCall(url: Url, method: "POST", parameters: parameters as [String : Any], view: self.view,loaderText: "please wait...") { result in
//                switch result {
//                case .success(let jsonResponse):
//                    let ErrorMessage = jsonResponse["ErrorMessage"] as? String
//                    print("NSDLEsignResponse Response: \(jsonResponse)")
//                    if let errorCode = jsonResponse["ErrorCode"] as? String {
//                        switch errorCode {
//                        case "000000":
//                            DispatchQueue.main.async {
//                                print("api is running")
//                                self.showAlert(message: "Esign page:successfully submitted")
//                                self.ViewAllMultiPDF()
//                            }
//                        default:
//                            print("Unhandled error code: \(errorCode)")
//                            self.showAlert(message: "Esign page:failed to submit")
//                            self.showAlert(message: ErrorMessage ?? "error occured")
//                        }
//                    }
//                case .failure(let error):
//                    self.showAlert(message: "Esign page:api failed--- \(error.localizedDescription)")
//                    print("Login API call failed: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
//    
//    func  ViewAllMultiPDF(){
//        
//        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
//            guard let tokenId = tokenId else {
//                // Handle the case where no tokens are available
//                CoreDataHelper.generateToken(
//                    decodeByteArrayToString: self.decodeArray ?? "",
//                    USERID: self.fetchedUserId ?? "",
//                    SessionId: self.fetchedSessionID ?? "",
//                    entityName: "TokenMobile", deviceType: "M", in: self.view
//                ) { success in
//                    if success {
//                        // Retry SIXTHAPI after token regeneration
//                        self.ViewAllMultiPDF()
//                    } else {
//                        print("Token generation failed.")
//                    }
//                }
//                print("No tokens available. Please reload the tokens.")
//                return
//            }
//            let parameters: [String: Any?] = [
//                "UserId":  fetchedUserId,
//                "TokenId": tokenId,
//                "PanNo":PanNo,
//                "RegId":RegId,
//                "SessionId":fetchedSessionID
//            ]
//            print(parameters)
//            let Url = "/KYC/ViewAllMultiPDF"
//            //KYC/ViewAllMultiPDF
//            
//            apiCall(url: Url, method: "POST", parameters: parameters as [String : Any], view: self.view,loaderText: "please wait...") { result in
//                switch result {
//                case .success(let jsonResponse):
//                    print("jsonresponse:-> \(jsonResponse)")
//                    if let errorCode = jsonResponse["ErrorCode"] as? String, errorCode == "000000" {
//                        if let pdfList = jsonResponse["PDFForEsignList"] as? [[String: Any]] {
//                            self.pdfDataList = pdfList
//                            
//                            //////////////******************static ddpi = 1**//////////////////
////                            for item in pdfList {
////                                
////                                let segment = item["PDFSegment"] as? String
////
////                                   // 👇 Force DDPI as signed
////                                   let isSigned: Int
////
////                                   if segment == "DDPI" {
////                                       isSigned = 1   // ✅ STATIC VALUE
////                                   } else {
////                                       isSigned = item["IsPDFSign"] as? Int ??
////                                                  Int(item["IsPDFSign"] as? String ?? "0") ?? 0
////                                   }
////
////                                   if segment == "DDPI" && isSigned == 1 {
////                                       print("✅ DDPI Forced Signed → Closing SDK")
////
////                                       DispatchQueue.main.async {
////                                           self.closeSDK()
////                                       }
////                                       return
////                                   }
////                               }
//                                
//                                
//
////                                let segment = item["PDFSegment"] as? String
////                                let isSigned = item["IsPDFSign"] as? Int ?? Int(item["IsPDFSign"] as? String ?? "0")
////
////                                if segment == "DDPI" && isSigned == 1 {
////
////                                    print("✅ DDPI Signed → Closing SDK")
////
////                                    DispatchQueue.main.async {
////                                        self.closeSDK()
////                                    }
////                                    return   // ✅ VERY IMPORTANT (stop further execution)
////                                }
////                            }
////                            for item in pdfList {
////                                
////                                let segment = item["PDFSegment"] as? String
////                                
////                                let isSigned = item["IsPDFSign"] as? Int ??
////                                               Int(item["IsPDFSign"] as? String ?? "0") ?? 0
////
////                                // ✅ Only close when DDPI is actually signed from API
////                                if segment == "DDPI" && isSigned == 1 {
////                                    print("✅ DDPI Signed from API → Closing SDK")
////
////                                    DispatchQueue.main.async {
////                                        self.closeSDK()
////                                    }
////                                    return   // ✅ STOP further execution
////                                }
////                            }
//                            
////                            DispatchQueue.main.async {
////                                // Default state: hide all views
//////                                self.holderview1.isHidden = true
//////                                self.holderview2.isHidden = true
//////                                self.holderview3.isHidden = true
////                                
////                                // Iterate through the PDF list
////                                for pdf in pdfList {
////                                    if let pdfSegment = pdf["PDFSegment"] as? String,
////                                       let isPDFSign = pdf["IsPDFSign"] as? String,
////                                       let id = pdf["Id"] as? String {
////                                        switch pdfSegment {
////                                        case "EKRA":
////                                           
////                                            self.ekraSign = isPDFSign
////                                            self.ekraID = id
////                                            self.ekraStack.isHidden = (isPDFSign == "1")
////                                        case "E":
////                                            self.aofSign = isPDFSign
////                                            self.aofID = id
////                                            self.aofStack.isHidden = (isPDFSign == "1")
////                                        case "DDPI":
////                                            
////                                            self.ddpiSign = isPDFSign
////                                            self.ddpiID = id
////                                            self.ddpiStack.isHidden = (isPDFSign == "1")
////                                        default:
////                                            break
////                                        }
////                                    }
////                                }
////                            }
//                            
//                            DispatchQueue.main.async {
//
//                                for pdf in pdfList {
//                                    if let pdfSegment = pdf["PDFSegment"] as? String,
//                                       let isPDFSign = pdf["IsPDFSign"] as? String,
//                                       let id = pdf["Id"] as? String {
//
//                                        switch pdfSegment {
//                                        case "EKRA":
//                                            self.ekraSign = isPDFSign
//                                            self.ekraID = id
//                                            self.ekraStack.isHidden = (isPDFSign == "1")
//
//                                        case "E":
//                                            self.aofSign = isPDFSign
//                                            self.aofID = id
//                                            self.aofStack.isHidden = (isPDFSign == "1")
//
//                                        case "DDPI":
//                                            // ✅ FORCE STATIC
//                                            self.ddpiSign = isPDFSign
//                                            self.ddpiID = id
//                                            self.ddpiStack.isHidden = (isPDFSign == "1")
//
//                                        default:
//                                            break
//                                        }
//                                    }
//                                }
//
//                                // ✅ FINAL CHECK (ONLY HERE)
////                                if self.ddpiSign == "1"{
////                                    print("✅ EKRA & AOF signed → Closing SDK")
////                                    self.closeSDK()
////                                }
//                            }
//                        }
//                    } else {
//                        print("Unhandled error code: \(jsonResponse["ErrorCode"] ?? "Unknown Error")")
//                    }
//                case .failure(let error):
//                    print("Login API call failed: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
//    
//    func closeSDK() {
//        print("🚀 Closing SDK")
//
//        DispatchQueue.main.async {
//            
//            // ✅ Notify host app first
//            self.onSDKClose?()
//            
//            // ✅ Close full SDK (important)
//            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//               let window = windowScene.windows.first {
//                
//                window.rootViewController?.dismiss(animated: true)
//            } else {
//                self.view.window?.rootViewController?.dismiss(animated: true)
//            }
//        }
//    }
//    
//}
//
//extension ApplicationStatusVC {
//    
//    func SIXTHAPI(userID:String){
//        
//        CoreDataHelper.fetchUserId(entityName: "MobileUser") { [weak self] userId, sessionID , decodeByteArrayString in
//            guard let self = self else { return }
//            
//            if let userId = userId, let sessionID = sessionID {
//                self.fetchedUserId = userId
//                self.fetchedSessionID = sessionID
//                self.decodeArray = decodeByteArrayString
//                print("UserID: \(userId), SessionID: \(sessionID)")
//            } else {
//                print("No UserID or SessionID found.")
//            }
//        }
//        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { tokenId in
//            guard let tokenId = tokenId else {
//                // Handle the case where no tokens are available
//                CoreDataHelper.generateToken(
//                    decodeByteArrayToString: self
//                        .mobiledecodeArray ?? "",
//                    USERID: self.fetchedUserId ?? "",
//                    SessionId: self.fetchedSessionID ?? "",
//                    entityName: "TokenMobile", deviceType: "W",
//                    in: self.view
//                ) { success in
//                    if success {
//                        // Retry SIXTHAPI after token regeneration
//                        self.SIXTHAPI(userID: userID)
//                    } else {
//                        print("Token generation failed.")
//                    }
//                }
//                print("No tokens available. Please reload the tokens.")
//                return
//            }
//            let parameters: [String: Any] = [
//                "UserId": self.fetchedUserId as Any,
//                "TokenId": tokenId
//            ]
//            print("6th api params\(parameters)")
//            let sixthUrl = "ActiveApplication/GetActiveApplicationCL"
//            // API call
//            apiCall(url: sixthUrl, method: "POST", parameters: parameters, view: self.view) { result in
//                switch result {
//                case .success(let jsonResponse):
//                    print("SIXTHAPI Response: \(jsonResponse)")
//                    self.panNo = jsonResponse["PanNo"] as? String
//                    self.regId = jsonResponse["RegId"] as? String
//                    self.PANName = jsonResponse["PANName"] as? String
//                    self.EmailId = jsonResponse["EmailId"] as? String
//                    self.finalStatus = jsonResponse["FinalStatus"] as? String
//                    
//                    if let errorCode = jsonResponse["ErrorCode"] as? String {
//                        switch errorCode {
//                        case "999992":
//                            DispatchQueue.main.async {
//                                CoreDataHelper.deleteAllTokens(entityName: "TokenMobile")
//                                print("All TokenMobile entries deleted due to error code 999992")
//                                
//                                // Regenerate tokens
//                                CoreDataHelper.generateToken(decodeByteArrayToString: self.decodeArray ?? "", USERID: userID, SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
//                                    if success {
//                                        // Retry SIXTHAPI after token regeneration
//                                        self.SIXTHAPI(userID: userID)
//                                    } else {
//                                        print("Token generation failed.")
//                                    }
//                                }
//                            }
//                        case "000000":
//                            print("errorcode 000000 called")
//                            DispatchQueue.main.async{
//                                
//                                self.isDerivative = (jsonResponse["IsDerivative"] as? String ?? "N").uppercased()
//                                self.panNo = jsonResponse["PanNo"] as? String
//                                self.regId = jsonResponse["RegId"] as? String
//                                self.PANName = jsonResponse["PANName"] as? String
//                                //self.updateUIFromSixthAPI(jsonResponse)
//                                //if self.finalStatus == "4"{
//                                DispatchQueue.main.async {
//                                    //                                        self.pdfLbl.isHidden = false
//                                    //                                        self.secondView.isHidden = false
//                                    //                                  }
//                                }
//                            }
//                        default:
//                            print("Unhandled error code: \(errorCode)")
//                        }
//                    }
//                case .failure(let error):
//                    print("SIXTHAPI API call failed: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
//}
//import UIKit
//
//class ApplicationStatusVC: UIViewController, @MainActor AadhaarStackDelegate {
//    
//    func didAcceptTerms(segmentName: String, signKey: String) {
//        print("Terms accepted for segment: \(segmentName)")
//        NSDLEsign(segmentName: segmentName, signKey: signKey)
//    }
//    
//    @IBOutlet weak var nameLbl: UILabel!
//    @IBOutlet weak var onBordingView: UIView!
//    @IBOutlet weak var applicationView: UIView!
//    @IBOutlet weak var waitingView: UIView!
//    @IBOutlet weak var approveView: UIView!
//    @IBOutlet weak var onBordingDateLbl: UILabel!
//    @IBOutlet weak var applicationDateLbl: UILabel!
//    @IBOutlet weak var waitingDateLbl: UILabel!
//    @IBOutlet weak var approveDateLbl: UILabel!
//    @IBOutlet weak var mainView: UIView!
//    @IBOutlet weak var secondView: UIView!
//    @IBOutlet weak var pdfLbl: UILabel!
//    @IBOutlet weak var holderview1: UIView!
//    @IBOutlet weak var holderview2: UIView!
//    @IBOutlet weak var holderview3: UIView!
//    @IBOutlet weak var ekraBtn: UIButton!
//    @IBOutlet weak var aofBtn: UIButton!
//    @IBOutlet weak var ddpiBtn: UIButton!
//    @IBOutlet weak var ekraViewBtn: UIButton!
//    @IBOutlet weak var aofViewBtn: UIButton!
//    @IBOutlet weak var ddpiViewBtn: UIButton!
//    @IBOutlet weak var ekraStack: UIStackView!
//    @IBOutlet weak var ddpiStack: UIStackView!
//    @IBOutlet weak var aofStack: UIStackView!
//    
//    var fetchedUserId: String?
//    var fetchedSessionID: String?
//    var mobiledecodeArray: String?
//    var decodeArray:String?
//    var panNo: String?
//    var regId: String?
//    var PANName : String?
//    var EmailId : String?
//    var isDerivative: String = "N"
//    var networth: String?
//    var networthDate: String?
//    var finalStatus: String?
//    var ekraSign: String = "0"
//    var aofSign: String = "0"
//    var ddpiSign: String = "0"
//    var ekraID: String?
//    var aofID: String?
//    var ddpiID: String?
//    var PanNo : String?
//    var RegId : String?
//    var signedResponse: String?
//    var msg : String?
//    var env : String?
//    var pdfDataList: [[String: Any]] = []
//    var esignRetryCount = 10
//    var companyName: String?
//    var returnurl: String?
//    var txnId: String?
//    var esignType: String?
//    var currentEsignSegment: String?
//    public var onStartEsign: (() -> Void)?
//    public var onSDKClose: (() -> Void)?
//    var documentId: String?
//    var pollingTimer: Timer?
//    var pollingAttempts = 0
//    let maxPollingAttempts = 20
//    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = UIColor.systemGroupedBackground
//        navigationController?.isNavigationBarHidden = true
////        pdfLbl.isHidden = true
////        secondView.isHidden = true
////        mainView.layer.cornerRadius = 20
////        secondView.layer.cornerRadius = 20
////        secondView.layer.borderColor = UIColor.black.cgColor
////        secondView.layer.borderWidth = 1.0
//        SIXTHAPI(userID: fetchedUserId ?? "" )
////        onBordingView.layer.cornerRadius = 25
////        applicationView.layer.cornerRadius = 25
////        waitingView.layer.cornerRadius = 25
////        approveView.layer.cornerRadius = 25
//        
//        CoreDataHelper.fetchUserId(entityName: "MobileUser") { [weak self] userId, sessionID , decodeByteArrayString in
//            guard let self = self else { return }
//            
//            if let userId = userId, let sessionID = sessionID {
//                self.fetchedUserId = userId
//                self.fetchedSessionID = sessionID
//                self.decodeArray = decodeByteArrayString
//                self.ValidateToken()
//                print("UserID: \(userId), SessionID: \(sessionID)")
//                self.ViewAllMultiPDF()
//            } else {
//                print("No UserID or SessionID found.")
//            }
//        }
//       // ViewAllMultiPDF()
//        view.backgroundColor = .appBackground
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(appDidBecomeActive),
//            name: UIApplication.didBecomeActiveNotification,
//            object: nil
//        )
//    }
//    
//    @objc func appDidBecomeActive() {
//        print("🔄 App returned from browser")
//        guard let docId = documentId else { return }
//        
//        // Optional: Do one immediate check
//        checkDDPIEsignStatus(documentId: docId)
//        
//        // Then start polling (but with longer interval, e.g. 8-10 sec to be gentler)
//        startEsignDonePolling(documentId: docId)
//    }
//    
//    @IBAction func ekraBtnTapped(_ sender: UIButton) {
//        handleSegmentBasedOnSignValue(segmentName: "EKRA", signKey: "ekraSign")
//    }
//    
//    private func handleSegmentTap(segmentName: String, signKey: String) {
//        var signValue = getSignValue(forKey: signKey)
//        
//        if signValue == "1" {
//            // Construct URL
//            let baseUrl = "https://signup.hemnxt.com:84/V4.0.0/api/MultiPartImageUpload/PDFDownload"
//            guard let regId = RegId, let userId = fetchedUserId, let panNo = PanNo else {
//                print("Missing parameters for URL construction")
//                return
//            }
//            // Get dynamic ID based on segmentName
//            guard let dynamicID = getDynamicID(forSegment: segmentName) else {
//                print("No valid ID found for segment \(segmentName)")
//                return
//            }
//            
//            CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [weak self] tokenId in
//                guard let self = self else { return }
//                guard let tokenId = tokenId else {
//                    CoreDataHelper.generateToken(
//                        decodeByteArrayToString: self.decodeArray ?? "",
//                        USERID: self.fetchedUserId ?? "",
//                        SessionId: self.fetchedSessionID ?? "",
//                        entityName: "TokenMobile", deviceType: "W", in: self.view
//                    ) { success in
//                        if success {
//                            // Retry SIXTHAPI after token regeneration
//                            self.handleSegmentTap(segmentName: segmentName, signKey: signKey)
//                        } else {
//                            print("Token generation failed.")
//                        }
//                    }
//                    print("No tokens available. Please reload the tokens.")
//                    return
//                }
//                
//                let urlString = "\(baseUrl)?id=\(dynamicID)&RegId=\(regId)&UserId=\(userId)&PanNo=\(panNo)&PDFSegment=\(segmentName)&TokenId=\(tokenId)"
//                print("Constructed URL: \(urlString)")
//                self.openURLInSystemBrowser(urlString: urlString)
//            }
//        } else {
//            print("\(segmentName) button tapped")
//            //NSDLEsign(segmentName: segmentName, signKey: signKey)
//            let sb = UIStoryboard(name: "Esign", bundle: Bundle.module)
//            let vc = sb.instantiateViewController(
//                withIdentifier: "AadhaarStackVC"
//            ) as! AadhaarStackVC
//            vc.modalPresentationStyle = .overCurrentContext
//            vc.modalTransitionStyle = .crossDissolve
//            vc.delegate = self
//            vc.segmentName = segmentName
//            vc.signkey = signKey
//            present(vc, animated: true)
//        }
//    }
//    
//    private func handleSegmentBasedOnSignValue(segmentName: String, signKey: String) {
////        let signValue = getSignValue(forKey: signKey)
////
////        if signValue == "0" {
////            // If eSign value is 0, present the terms screen
////            presentTermsScreen(segmentName: segmentName, signKey: signKey)
////        } else {
////            // Otherwise, directly handle the segment
////            handleSegmentTap(segmentName: segmentName, signKey: signKey)
////        }
//        let signValue = getSignValue(forKey: signKey)
//        
//        if signValue == "0" {
//            // If eSign value is 0, present the terms screen
//            NSDLEsign(segmentName: segmentName, signKey: signKey)
//        } else {
//            // Otherwise, directly handle the segment
//            handleSegmentTap(segmentName: segmentName, signKey: signKey)
//        }
//    }
//    
//    private func presentTermsScreen(segmentName: String, signKey: String) {
//        let sb = UIStoryboard(name: "Esign", bundle: Bundle.module)
//        let vc = sb.instantiateViewController(
//            withIdentifier: "AadhaarStackVC"
//        ) as! AadhaarStackVC
//        
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.modalTransitionStyle = .crossDissolve
//        vc.delegate = self
//        vc.segmentName = segmentName
//        vc.signkey = signKey
//        
//        present(vc, animated: true)
//    }
//    
//    private func getSignValue(forKey key: String) -> String {
//        switch key {
//        case "ekraSign": return ekraSign
//        case "aofSign": return aofSign
//        case "ddpiSign": return ddpiSign
//        default: return "0"
//        }
//    }
//    
//    private func updateSignValue(forKey key: String, value: String) {
//        switch key {
//        case "ekraSign": ekraSign = value
//        case "aofSign": aofSign = value
//        case "ddpiSign": ddpiSign = value
//        default: break
//        }
//    }
//    
//    private func getDynamicID(forSegment segmentName: String) -> String? {
//        switch segmentName {
//        case "EKRA": return ekraID
//        case "E": return aofID
//        case "DDPI": return ddpiID
//        default: return nil
//        }
//    }
//    
//    private func openURLInSystemBrowser(urlString: String) {
//        guard let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) else {
//            print("Invalid URL or cannot open URL")
//            return
//        }
//        
//        UIApplication.shared.open(url, options: [:]) { success in
//            if success {
//                print("Successfully opened URL in system browser")
//            } else {
//                print("Failed to open URL in system browser")
//            }
//        }
//    }
//    
//    @IBAction func aofBtn(_ sender: UIButton) {
//        if ekraSign == "0" {
//            showAlert(message: "You need to sign the EKRA segment first.")
//        } else {
//            handleSegmentBasedOnSignValue(segmentName: "E", signKey: "aofSign")
//        }
//    }
//    @IBAction func ddpiBtn(_ sender: UIButton) {
//        if ekraSign == "0" && aofSign == "0" {
//            showAlert(message: "You need to sign EKRA & AOF segments.")
//        } else if ekraSign == "0" {
//            showAlert(message: "You need to sign the EKRA segment first.")
//        } else if aofSign == "0" {
//            showAlert(message: "You need to sign the AOF segment first.")
//        } else {
//            handleSegmentBasedOnSignValue(segmentName: "DDPI", signKey: "ddpiSign")
//        }
////        if let docId = documentId {
////            startEsignDonePolling(documentId: docId)
////        }
//    }
//    
////    func startEsignDonePolling(documentId: String) {
////        stopEsignPolling()
////        pollingAttempts = 0
////
////        pollingTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
////            guard let self = self else { return }
////
////            self.pollingAttempts += 1
////
////            if self.pollingAttempts >= self.maxPollingAttempts {
////                print("⛔ Polling timeout")
////                self.stopEsignPolling()
////                return
////            }
////
////            self.checkDDPIEsignStatus(documentId: documentId)
////        }
////    }
//    
//    func startEsignDonePolling(documentId: String) {
//        stopEsignPolling()           // Stop any previous polling
//        pollingAttempts = 0
//        
//        print("🔄 Starting polling for documentId: \(documentId)")
//        
//        // ✅ IMPORTANT: Start background task FIRST
//        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
//            print("⚠️ Background task expiring - iOS is forcing us to stop")
//            self?.stopEsignPolling()
//            self?.endBackgroundTask()
//        }
//        
//        // If background task failed to start (returns .invalid)
//        if backgroundTask == .invalid {
//            print("❌ Failed to start background task")
//            // Still try to poll while app is foreground
//        }
//        
//        // Start timer on main thread
//        DispatchQueue.main.async { [weak self] in
//            guard let self = self else { return }
//            
//            self.pollingTimer = Timer.scheduledTimer(withTimeInterval: 6.0, repeats: true) { [weak self] timer in
//                guard let self = self else {
//                    timer.invalidate()
//                    return
//                }
//                
//                self.pollingAttempts += 1
//                print("📡 Polling attempt \(self.pollingAttempts)/\(self.maxPollingAttempts) at \(Date())")
//                
//                if self.pollingAttempts >= self.maxPollingAttempts {
//                    print("⛔ Polling timeout reached")
//                    self.stopEsignPolling()
//                    return
//                }
//                
//                self.checkDDPIEsignStatus(documentId: documentId)
//            }
//            
//            // Add to common run loop so it fires even when scrolling etc.
//            if let timer = self.pollingTimer {
//                RunLoop.current.add(timer, forMode: .common)
//            }
//        }
//    }
//
//    func stopEsignPolling() {
//        pollingTimer?.invalidate()
//        pollingTimer = nil
//        pollingAttempts = 0
//        endBackgroundTask()
//        print("🛑 Polling stopped")
//    }
//
//    func endBackgroundTask() {
//        if backgroundTask != .invalid {
//            print("🏁 Ending background task")
//            UIApplication.shared.endBackgroundTask(backgroundTask)
//            backgroundTask = .invalid
//        }
//    }
//    
//    func showAlert(message: String) {
//        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        DispatchQueue.main.async {
//            self.present(alert, animated: true, completion: nil)
//        }
//    }
//    
//    @IBAction func QuitBtn(_ sender: UIButton) {
//        self.navigationController?.popViewController(animated: true)
//    }
//    
////    @IBAction func ekraView(_ sender: UIButton) {
////        openPDF(segmentName: "EKRA")
////    }
////
////    @IBAction func aofView(_ sender: UIButton) {
////        openPDF(segmentName: "E")
////    }
//    
////    @IBAction func ddpiView(_ sender: UIButton) {
////        openPDF(segmentName: "DDPI")
////    }
//    
//    
//    @IBAction func ekraView(_ sender: UIButton) {
//        openPDF(segmentName: "EKRA")
//    }
//    
//    @IBAction func aofView(_ sender: UIButton) {
//        openPDF(segmentName: "E")
//    }
//    
//    @IBAction func ddpiView(_ sender: UIButton) {
//        openPDF(segmentName: "DDPI")
//    }
//    
//    func openPDF(segmentName: String) {
//        
//        // ✅ Check if PDF is signed before opening
//        var isSigned = false
//        
//        switch segmentName {
//        case "EKRA":
//            isSigned = (ekraSign == "1")
//        case "E":
//            isSigned = (aofSign == "1")
//        case "DDPI":
//            isSigned = (ddpiSign == "1")
//        default:
//            break
//        }
//        
//        // ❌ If not signed → don't open PDF
//        if !isSigned {
//            showAlert(message: "Please complete eSign first to view the PDF.")
//            return
//        }
//        
//        // ✅ Continue only if signed
//        guard let regId = RegId,
//              let userId = fetchedUserId,
//              let panNo = PanNo,
//              let dynamicID = getDynamicID(forSegment: segmentName) else {
//            print("Missing parameters")
//            return
//        }
//
//        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [weak self] tokenId in
//            guard let self = self else { return }
//            
//            guard let tokenId = tokenId else {
//                CoreDataHelper.generateToken(
//                    decodeByteArrayToString: self.decodeArray ?? "",
//                    USERID: self.fetchedUserId ?? "",
//                    SessionId: self.fetchedSessionID ?? "",
//                    entityName: "TokenMobile",
//                    deviceType: "W",
//                    in: self.view
//                ) { success in
//                    if success {
//                        self.openPDF(segmentName: segmentName)
//                    }
//                }
//                return
//            }
//
//            let baseUrl = "https://signup.hemnxt.com:84/V4.0.0/api/MultiPartImageUpload/PDFDownload"
//            let urlString = "\(baseUrl)?id=\(dynamicID)&RegId=\(regId)&UserId=\(userId)&PanNo=\(panNo)&PDFSegment=\(segmentName)&TokenId=\(tokenId)"
//
//            self.openURLInSystemBrowser(urlString: urlString)
//        }
//    }
//    
//    func ValidateToken(){
//        
//        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
//            guard let tokenId = tokenId else {
//                CoreDataHelper.generateToken(
//                    decodeByteArrayToString: self.decodeArray ?? "",
//                    USERID: self.fetchedUserId ?? "",
//                    SessionId: self.fetchedSessionID ?? "",
//                    entityName: "TokenMobile", deviceType: "W", in: self.view
//                ) { success in
//                    if success {
//                        // Retry SIXTHAPI after token regeneration
//                        self.ValidateToken()
//                    } else {
//                        print("Token generation failed.")
//                    }
//                }
//                // Handle the case where no tokens are available
//                print("No tokens available. Please reload the tokens.")
//                return
//            }
//            let parameters: [String: Any?] = [
//                "UserId":  fetchedUserId,
//                "TokenId": tokenId
//            ]
//            print(parameters)
//            let Url = "TokenAuthentication/ValidateToken"
//            
//            apiCall(url: Url, method: "POST", parameters: parameters as [String : Any], view: self.view) { result in
//                switch result {
//                case .success(let jsonResponse):
//                    print("ValidateToken Response: \(jsonResponse)")
//                    if let errorCode = jsonResponse["ErrorCode"] as? String {
//                        switch errorCode {
//                        case "000000":
//                            DispatchQueue.main.async {
//                                print("api is running")
//                            }
//                        default:
//                            print("Unhandled error code: \(errorCode)")
//                        }
//                    }
//                case .failure(let error):
//                    print("Login API call failed: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
//    
//    func NSDLEsign(segmentName: String, signKey: String) {
//        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [weak self] tokenId in
//            guard let self = self else { return }
//            guard let tokenId = tokenId else {
//                CoreDataHelper.generateToken(
//                    decodeByteArrayToString: self.decodeArray ?? "",
//                    USERID: self.fetchedUserId ?? "",
//                    SessionId: self.fetchedSessionID ?? "",
//                    entityName: "TokenMobile", deviceType: "W", in: self.view
//                ) { success in
//                    if success {
//                        // Retry SIXTHAPI after token regeneration
//                        self.NSDLEsign(segmentName: segmentName, signKey: signKey)
//                    } else {
//                        print("Token generation failed.")
//                    }
//                }
//                print("No tokens available. Please reload the tokens.")
//                return
//            }
//            
//            let parameters: [String: Any?] = [
//                "UserId": fetchedUserId,
//                "TokenId": tokenId,
//                "PanNo": PanNo,
//                "RegId": RegId,
//                "AuthMode": "1",
//                "SegmentName": segmentName,
//                "IsMobOrWeb": "1",
//                "DeviceType": "IOS"
//            ]
//            
//            let url = "NSDLEsign/NSDLEsignRquest"
//            apiCall(url: url, method: "POST", parameters: parameters as [String: Any], view: self.view,loaderText: "processing data for esign,kindly wait until completed...") { result in
//                switch result {
//                case .success(let jsonResponse):
//                    print("NSDLEsignRquest Response: \(jsonResponse)")
//                    self.msg = jsonResponse["eXml"] as? String
//                    self.env = "PROD"
//                    let ErrorMessage = jsonResponse["ErrorMessage"] as? String
//                    self.returnurl = jsonResponse["ReturnURL"] as? String
//                    self.esignType = jsonResponse["EsignType"] as? String ?? ""
//                    let esignUrl = jsonResponse["EsignUrl"] as? String ?? ""
//                    self.txnId = jsonResponse["txn"] as? String ?? ""
//                    let requestURL = jsonResponse["RquestURL"] as? String ?? ""
//                    self.companyName = jsonResponse["CompanyName"] as? String
//                    self.currentEsignSegment = segmentName
//                    self.documentId = jsonResponse["documentId"] as? String
//                    if let errorCode = jsonResponse["ErrorCode"] as? String {
//                        switch errorCode {
//                        case "000000":
//                            
////                            if let isDDPIEsign = jsonResponse["IsDDPIEsign"] as? Int,
////                                             isDDPIEsign == 1,
////                                             segmentName == "DDPI" {
////                                              print("✅ DDPI eSign completed immediately - Closing SDK")
////                                              DispatchQueue.main.async {
////                                                  self.closeSDK()
////                                              }
////                                              return
////                                          }
////
////                            let isDDPIEsign = jsonResponse["IsDDPIEsign"] as? Int ??
////                                                Int(jsonResponse["IsDDPIEsign"] as? String ?? "0") ?? 0
////
////                            self.documentId = jsonResponse["DocumentId"] as? String
////
////                            // ✅ Start polling ONLY for DDPI
////                            if segmentName == "DDPI", let docId = self.documentId {
////                                print("🚀 Starting DDPI polling with documentId: \(docId)")
////                                self.startEsignDonePolling(documentId: docId)
////                            }
//                            
////                            if segmentName == "DDPI", self.msg == nil {
////                                if !esignUrl.isEmpty {
////                                    DispatchQueue.main.async {
////                                        self.openURLInSystemBrowser(urlString: esignUrl)
////                                    }
////                                    return
////                                }
////                            }
//                            
//                            if segmentName == "DDPI", !esignUrl.isEmpty {
//                            DispatchQueue.main.async {
//                                    let vc = WebviewAutoSubmitVC()
//                                    vc.esignUrl = esignUrl   // 👈 pass URL
//                                    vc.isDDPI = true         // 👈 flag if needed
//                                    vc.documentId = self.documentId
//                                    vc.parentVC = self
//                                    self.navigationController?.pushViewController(vc, animated: true)
//                                }
//                                return
//                            }
//
//                            if self.esignType == "SELF" {
//                                DispatchQueue.main.async {
//                                    let vc = WebviewAutoSubmitVC()
//                                    vc.xmlMsg = self.msg ?? ""
//                                    vc.CompanyName = self.companyName ?? ""
//                                    vc.ReturnURL = self.returnurl ?? ""
//                                    vc.txn = self.txnId ?? ""
//                                    self.navigationController?.pushViewController(vc, animated: true)
//                                }
//                                return
//                            }
//
//                        case "111111":
//                            DispatchQueue.main.async {
//                                print("API is running for segment: \(segmentName)")
//                            }
//                        case "999992":
//                            DispatchQueue.main.async {
//                                CoreDataHelper.deleteAllTokens(
//                                    entityName: "TokenMobile")
//                                print("All TokenMobile entries deleted due to error code 999992")
//                                
//                                CoreDataHelper.generateToken(
//                                    decodeByteArrayToString: self.decodeArray ?? "",
//                                    USERID: self.fetchedUserId ?? "",
//                                    SessionId: self.fetchedSessionID ?? "",
//                                    entityName: "TokenMobile", deviceType: "W",
//                                    in: self.view
//                                ) { success in
//                                    if success {
//                                        // Retry SIXTHAPI after token regeneration
//                                        self.ValidateToken()
//                                    } else {
//                                        print("Token generation failed.")
//                                    }
//                                }
//                            }
//                        default:
//                            print("Unhandled error code: \(errorCode)")
//                            self.showAlert(message: "\(String(describing: ErrorMessage))")
//                        }
//                    }
//                case .failure(let error):
//                    print("API call failed: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
//    
//    func esignDone(segmentName: String, transactionID: String, completion: @escaping (Bool) -> Void) {
//        
//        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [weak self] tokenId in
//            guard let self = self else { return }
//            
//            guard let tokenId = tokenId else {
//                completion(false)
//                return
//            }
//            
//            let parameters: [String: Any?] = [
//                "PanNo": self.PanNo,
//                "RegId": self.RegId,
//                "Segment": segmentName,
//                "SessionId": self.fetchedSessionID,
//                "UserId": self.fetchedUserId,
//                "TokenId": tokenId,
//                "TransactionID": transactionID
//            ]
//            
//            apiCall(url: "NSDLEsign/ValidateIsEsignDone", method: "POST", parameters: parameters as [String: Any], view: self.view) { result in
//                
//                switch result {
//                case .success(let jsonResponse):
//                    let ErrorMessage = jsonResponse["ErrorMessage"] as? String
//                    print("ValidateIsEsignDone: \(jsonResponse)")
//                    if let errorCode = jsonResponse["ErrorCode"] as? String {
//                        switch errorCode {
//                            
//                        case "000000":
//                            DispatchQueue.main.async {
//                                print("api is running")
//                                completion(true)
//                                
//                                self.showAlert(message: "E-sign completed successfully!")
//                                
//                                self.ViewAllMultiPDF()
//                            }
//                            
//                        case "000002":
//                            DispatchQueue.main.async {
//                                print("api is running")
//                                completion(true)
//                                
//                                if let nav = self.navigationController,
//                                   let webVC = nav.viewControllers.last as? WebviewAutoSubmitVC {
//                                    nav.popViewController(animated: true)
//                                }
//                                
//                                self.showAlert(message: "Your e-signature name does not match the name on your PAN.")
//                            }
//                            
//                        default:
//                            print("Unhandled error code: \(errorCode)")
//                            DispatchQueue.main.async {
//                                completion(false)
//                                //self.showAlert(message: ErrorMessage ?? "Unknown error occurred")
//                            }
//                        }
//                    }
//                case .failure(let error):
//                    //self.showAlert(message: "Esign page:api failed--- \(error.localizedDescription)")
//                    print("Login API call failed: \(error.localizedDescription)")
//                    
//                }
//            }
//        }
//    }
//    
////    func checkDDPIEsignStatus(documentId: String) {
////        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [weak self] tokenId in
////            guard let self = self else { return }
////
////            guard let tokenId = tokenId else {
////                CoreDataHelper.generateToken(
////                    decodeByteArrayToString: self.decodeArray ?? "",
////                    USERID: self.fetchedUserId ?? "",
////                    SessionId: self.fetchedSessionID ?? "",
////                    entityName: "TokenMobile",
////                    deviceType: "W",
////                    in: self.view
////                ) { success in
////                    if success {
////                        self.checkDDPIEsignStatus(documentId: documentId)
////                    }
////                }
////                return
////            }
////
////            let parameters: [String: Any] = [
////                "documentId": documentId
////            ]
////
////            let url = "NSDLEsignController/ValidateIsDDPIEsignDone"
////
////            apiCall(url: url, method: "POST", parameters: parameters, view: self.view) { result in
////                switch result {
////                case .success(let jsonResponse):
////                    print("📩 DDPI Status Response: \(jsonResponse)")
////
////                    if let errorCode = jsonResponse["ErrorCode"] as? String,
////                       errorCode == "000000" {
////
////                        let isDone = jsonResponse["IsEsignDone"] as? Int ??
////                                     Int(jsonResponse["IsEsignDone"] as? String ?? "0") ?? 0
////
////                        print("🔍 DDPI isDone: \(isDone)")
////
////                        // ✅ WRITE YOUR CODE HERE
////                        if isDone == 1 {
////                            DispatchQueue.main.async {
////                                print("✅ DDPI eSign Completed → Closing SDK")
////
////                                self.stopEsignPolling()
////                                self.closeSDK()
////                            }
////                        }
////                    }
////
////                case .failure(let error):
////                    print("❌ DDPI Status API Failed: \(error.localizedDescription)")
////                }
////            }
////        }
////    }
//    func checkDDPIEsignStatus(documentId: String) {
//        print("🔍 Checking DDPI status for documentId: \(documentId)")
//        print("⏰ Time: \(Date())")
//        
//        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [weak self] tokenId in
//            guard let self = self else { return }
//            
//            guard let tokenId = tokenId else {
//                print("❌ No token available, generating new one...")
//                CoreDataHelper.generateToken(
//                    decodeByteArrayToString: self.decodeArray ?? "",
//                    USERID: self.fetchedUserId ?? "",
//                    SessionId: self.fetchedSessionID ?? "",
//                    entityName: "TokenMobile",
//                    deviceType: "W",
//                    in: self.view
//                ) { success in
//                    if success {
//                        self.checkDDPIEsignStatus(documentId: documentId)
//                    }
//                }
//                return
//            }
//
//            let parameters: [String: Any] = [
//                "documentId": documentId
//            ]
//
//            let url = "NSDLEsign/ValidateIsDDPIEsignDone"
//            print("📤 Calling API: \(url) with params: \(parameters)")
//
//            apiCall(url: url, method: "POST", parameters: parameters, view: self.view) { result in
//                switch result {
//                case .success(let jsonResponse):
//                    print("📩 DDPI Status Response at \(Date()): \(jsonResponse)")
//
//                    if let errorCode = jsonResponse["ErrorCode"] as? String,
//                       errorCode == "000000" {
//                        
//                        // Check for IsPDFSign field
//                        let isPDFSign = jsonResponse["IsPDFSign"] as? String ??
//                                        String(jsonResponse["IsPDFSign"] as? Int ?? 0)
//                        
//                        print("🔍 DDPI IsPDFSign: \(isPDFSign)")
//                        
//                        if isPDFSign == "1" {
//                            print("✅ DDPI eSign Completed (IsPDFSign = 1)")
//                            
//                            DispatchQueue.main.async {
//                                // Stop polling
//                                self.stopEsignPolling()
//                                
//                                // Update local sign value
//                                self.ddpiSign = "1"
//                                
//                                // Refresh PDF list
//                                self.ViewAllMultiPDF()
//                                
//                                // Close the WebView first if it's presented
//                                if let navController = self.navigationController {
//                                    // Find and remove WebviewAutoSubmitVC
//                                    var viewControllers = navController.viewControllers
//                                    viewControllers.removeAll { $0 is WebviewAutoSubmitVC }
//                                    navController.viewControllers = viewControllers
//                                }
//                                
//                                // Small delay to ensure cleanup, then close SDK
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                                    self.closeSDK()
//                                }
//                            }
//                        } else {
//                            print("⏳ DDPI eSign not yet completed (IsPDFSign = \(isPDFSign)), waiting for next poll...")
//                        }
//                    } else {
//                        print("⚠️ Error code: \(jsonResponse["ErrorCode"] ?? "unknown")")
//                    }
//
//                case .failure(let error):
//                    print("❌ DDPI Status API Failed: \(error.localizedDescription)")
//                    // Continue polling on network errors
//                }
//            }
//        }
//    }
//    
//    func NSDLEsignResponse(decodedResponse: String){
//        
//        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
//            guard let tokenId = tokenId else {
//                // Handle the case where no tokens are available
//                CoreDataHelper.generateToken(
//                    decodeByteArrayToString: self.decodeArray ?? "",
//                    USERID: self.fetchedUserId ?? "",
//                    SessionId: self.fetchedSessionID ?? "",
//                    entityName: "TokenMobile", deviceType: "M", in: self.view
//                ) { success in
//                    if success {
//                        // Retry SIXTHAPI after token regeneration
//                        self.NSDLEsignResponse(decodedResponse: decodedResponse)
//                    } else {
//                        print("Token generation failed.")
//                    }
//                }
//                print("No tokens available. Please reload the tokens.")
//                return
//            }
//            let parameters: [String: Any?] = [
//                "UserId":  fetchedUserId,
//                "TokenId": tokenId,
//                "XMLResponse":decodedResponse
//            ]
//            //print(parameters)
//            
//            let Url = "NSDLEsign/NSDLEsignResponse"
//            
//            apiCall(url: Url, method: "POST", parameters: parameters as [String : Any], view: self.view,loaderText: "please wait...") { result in
//                switch result {
//                case .success(let jsonResponse):
//                    let ErrorMessage = jsonResponse["ErrorMessage"] as? String
//                    print("NSDLEsignResponse Response: \(jsonResponse)")
//                    if let errorCode = jsonResponse["ErrorCode"] as? String {
//                        switch errorCode {
//                        case "000000":
//                            DispatchQueue.main.async {
//                                print("api is running")
//                                self.showAlert(message: "Esign page:successfully submitted")
//                                self.ViewAllMultiPDF()
//                            }
//                        default:
//                            print("Unhandled error code: \(errorCode)")
//                            self.showAlert(message: "Esign page:failed to submit")
//                            self.showAlert(message: ErrorMessage ?? "error occured")
//                        }
//                    }
//                case .failure(let error):
//                    self.showAlert(message: "Esign page:api failed--- \(error.localizedDescription)")
//                    print("Login API call failed: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
//    
//    func  ViewAllMultiPDF(){
//        
//        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
//            guard let tokenId = tokenId else {
//                // Handle the case where no tokens are available
//                CoreDataHelper.generateToken(
//                    decodeByteArrayToString: self.decodeArray ?? "",
//                    USERID: self.fetchedUserId ?? "",
//                    SessionId: self.fetchedSessionID ?? "",
//                    entityName: "TokenMobile", deviceType: "M", in: self.view
//                ) { success in
//                    if success {
//                        // Retry SIXTHAPI after token regeneration
//                        self.ViewAllMultiPDF()
//                    } else {
//                        print("Token generation failed.")
//                    }
//                }
//                print("No tokens available. Please reload the tokens.")
//                return
//            }
//            let parameters: [String: Any?] = [
//                "UserId":  fetchedUserId,
//                "TokenId": tokenId,
//                "PanNo":PanNo,
//                "RegId":RegId,
//                "SessionId":fetchedSessionID
//            ]
//            print(parameters)
//            let Url = "/KYC/ViewAllMultiPDF"
//            //KYC/ViewAllMultiPDF
//            
//            apiCall(url: Url, method: "POST", parameters: parameters as [String : Any], view: self.view,loaderText: "please wait...") { result in
//                switch result {
//                case .success(let jsonResponse):
//                    print("jsonresponse:-> \(jsonResponse)")
//                    if let errorCode = jsonResponse["ErrorCode"] as? String, errorCode == "000000" {
//                        if let pdfList = jsonResponse["PDFForEsignList"] as? [[String: Any]] {
//                            self.pdfDataList = pdfList
//                            
//                            //////////////******************static ddpi = 1**//////////////////
////                            for item in pdfList {
////
////                                let segment = item["PDFSegment"] as? String
////
////                                   // 👇 Force DDPI as signed
////                                   let isSigned: Int
////
////                                   if segment == "DDPI" {
////                                       isSigned = 1   // ✅ STATIC VALUE
////                                   } else {
////                                       isSigned = item["IsPDFSign"] as? Int ??
////                                                  Int(item["IsPDFSign"] as? String ?? "0") ?? 0
////                                   }
////
////                                   if segment == "DDPI" && isSigned == 1 {
////                                       print("✅ DDPI Forced Signed → Closing SDK")
////
////                                       DispatchQueue.main.async {
////                                           self.closeSDK()
////                                       }
////                                       return
////                                   }
////                               }
//                                
//                                
//
////                                let segment = item["PDFSegment"] as? String
////                                let isSigned = item["IsPDFSign"] as? Int ?? Int(item["IsPDFSign"] as? String ?? "0")
////
////                                if segment == "DDPI" && isSigned == 1 {
////
////                                    print("✅ DDPI Signed → Closing SDK")
////
////                                    DispatchQueue.main.async {
////                                        self.closeSDK()
////                                    }
////                                    return   // ✅ VERY IMPORTANT (stop further execution)
////                                }
////                            }
////                            for item in pdfList {
////
////                                let segment = item["PDFSegment"] as? String
////
////                                let isSigned = item["IsPDFSign"] as? Int ??
////                                               Int(item["IsPDFSign"] as? String ?? "0") ?? 0
////
////                                // ✅ Only close when DDPI is actually signed from API
////                                if segment == "DDPI" && isSigned == 1 {
////                                    print("✅ DDPI Signed from API → Closing SDK")
////
////                                    DispatchQueue.main.async {
////                                        self.closeSDK()
////                                    }
////                                    return   // ✅ STOP further execution
////                                }
////                            }
//                            
////                            DispatchQueue.main.async {
////                                // Default state: hide all views
//////                                self.holderview1.isHidden = true
//////                                self.holderview2.isHidden = true
//////                                self.holderview3.isHidden = true
////
////                                // Iterate through the PDF list
////                                for pdf in pdfList {
////                                    if let pdfSegment = pdf["PDFSegment"] as? String,
////                                       let isPDFSign = pdf["IsPDFSign"] as? String,
////                                       let id = pdf["Id"] as? String {
////                                        switch pdfSegment {
////                                        case "EKRA":
////
////                                            self.ekraSign = isPDFSign
////                                            self.ekraID = id
////                                            self.ekraStack.isHidden = (isPDFSign == "1")
////                                        case "E":
////                                            self.aofSign = isPDFSign
////                                            self.aofID = id
////                                            self.aofStack.isHidden = (isPDFSign == "1")
////                                        case "DDPI":
////
////                                            self.ddpiSign = isPDFSign
////                                            self.ddpiID = id
////                                            self.ddpiStack.isHidden = (isPDFSign == "1")
////                                        default:
////                                            break
////                                        }
////                                    }
////                                }
////                            }
//                            
//                            DispatchQueue.main.async {
//
//                                for pdf in pdfList {
//                                    if let pdfSegment = pdf["PDFSegment"] as? String,
//                                       let isPDFSign = pdf["IsPDFSign"] as? String,
//                                       let id = pdf["Id"] as? String {
//
//                                        switch pdfSegment {
//                                        case "EKRA":
//                                            self.ekraSign = isPDFSign
//                                            self.ekraID = id
//                                            self.ekraStack.isHidden = (isPDFSign == "1")
//
//                                        case "E":
//                                            self.aofSign = isPDFSign
//                                            self.aofID = id
//                                            self.aofStack.isHidden = (isPDFSign == "1")
//
//                                        case "DDPI":
//                                            // ✅ FORCE STATIC
//                                            self.ddpiSign = isPDFSign
//                                            self.ddpiID = id
//                                            self.ddpiStack.isHidden = (isPDFSign == "1")
//
//                                        default:
//                                            break
//                                        }
//                                    }
//                                }
//
//                                // ✅ FINAL CHECK (ONLY HERE)
////                                if self.ddpiSign == "1"{
////                                    print("✅ EKRA & AOF signed → Closing SDK")
////                                    self.closeSDK()
////                                }
//                            }
//                        }
//                    } else {
//                        print("Unhandled error code: \(jsonResponse["ErrorCode"] ?? "Unknown Error")")
//                    }
//                case .failure(let error):
//                    print("Login API call failed: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
//    
//    func closeSDK() {
//        print("🚀 Closing SDK")
//
//        DispatchQueue.main.async {
//            
//            // ✅ Notify host app first
//            self.onSDKClose?()
//            
//            // ✅ Close full SDK (important)
//            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//               let window = windowScene.windows.first {
//                
//                window.rootViewController?.dismiss(animated: true)
//            } else {
//                self.view.window?.rootViewController?.dismiss(animated: true)
//            }
//        }
//    }
//    
//}
//
//extension ApplicationStatusVC {
//    
//    func SIXTHAPI(userID:String){
//        
//        CoreDataHelper.fetchUserId(entityName: "MobileUser") { [weak self] userId, sessionID , decodeByteArrayString in
//            guard let self = self else { return }
//            
//            if let userId = userId, let sessionID = sessionID {
//                self.fetchedUserId = userId
//                self.fetchedSessionID = sessionID
//                self.decodeArray = decodeByteArrayString
//                print("UserID: \(userId), SessionID: \(sessionID)")
//            } else {
//                print("No UserID or SessionID found.")
//            }
//        }
//        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { tokenId in
//            guard let tokenId = tokenId else {
//                // Handle the case where no tokens are available
//                CoreDataHelper.generateToken(
//                    decodeByteArrayToString: self
//                        .mobiledecodeArray ?? "",
//                    USERID: self.fetchedUserId ?? "",
//                    SessionId: self.fetchedSessionID ?? "",
//                    entityName: "TokenMobile", deviceType: "W",
//                    in: self.view
//                ) { success in
//                    if success {
//                        // Retry SIXTHAPI after token regeneration
//                        self.SIXTHAPI(userID: userID)
//                    } else {
//                        print("Token generation failed.")
//                    }
//                }
//                print("No tokens available. Please reload the tokens.")
//                return
//            }
//            let parameters: [String: Any] = [
//                "UserId": self.fetchedUserId as Any,
//                "TokenId": tokenId
//            ]
//            print("6th api params\(parameters)")
//            let sixthUrl = "ActiveApplication/GetActiveApplicationCL"
//            // API call
//            apiCall(url: sixthUrl, method: "POST", parameters: parameters, view: self.view) { result in
//                switch result {
//                case .success(let jsonResponse):
//                    print("SIXTHAPI Response: \(jsonResponse)")
//                    self.panNo = jsonResponse["PanNo"] as? String
//                    self.regId = jsonResponse["RegId"] as? String
//                    self.PANName = jsonResponse["PANName"] as? String
//                    self.EmailId = jsonResponse["EmailId"] as? String
//                    self.finalStatus = jsonResponse["FinalStatus"] as? String
//                    
//                    if let errorCode = jsonResponse["ErrorCode"] as? String {
//                        switch errorCode {
//                        case "999992":
//                            DispatchQueue.main.async {
//                                CoreDataHelper.deleteAllTokens(entityName: "TokenMobile")
//                                print("All TokenMobile entries deleted due to error code 999992")
//                                
//                                // Regenerate tokens
//                                CoreDataHelper.generateToken(decodeByteArrayToString: self.decodeArray ?? "", USERID: userID, SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
//                                    if success {
//                                        // Retry SIXTHAPI after token regeneration
//                                        self.SIXTHAPI(userID: userID)
//                                    } else {
//                                        print("Token generation failed.")
//                                    }
//                                }
//                            }
//                        case "000000":
//                            print("errorcode 000000 called")
//                            DispatchQueue.main.async{
//                                
//                                self.isDerivative = (jsonResponse["IsDerivative"] as? String ?? "N").uppercased()
//                                self.panNo = jsonResponse["PanNo"] as? String
//                                self.regId = jsonResponse["RegId"] as? String
//                                self.PANName = jsonResponse["PANName"] as? String
//                                //self.updateUIFromSixthAPI(jsonResponse)
//                                //if self.finalStatus == "4"{
//                                DispatchQueue.main.async {
//                                    //                                        self.pdfLbl.isHidden = false
//                                    //                                        self.secondView.isHidden = false
//                                    //                                  }
//                                }
//                            }
//                        default:
//                            print("Unhandled error code: \(errorCode)")
//                        }
//                    }
//                case .failure(let error):
//                    print("SIXTHAPI API call failed: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
//}
// no changes for FLUTTER
import UIKit

class ApplicationStatusVC: UIViewController, @MainActor AadhaarStackDelegate {
    
    func didAcceptTerms(segmentName: String, signKey: String) {
        print("Terms accepted for segment: \(segmentName)")
        NSDLEsign(segmentName: segmentName, signKey: signKey)
    }
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var onBordingView: UIView!
    @IBOutlet weak var applicationView: UIView!
    @IBOutlet weak var waitingView: UIView!
    @IBOutlet weak var approveView: UIView!
    @IBOutlet weak var onBordingDateLbl: UILabel!
    @IBOutlet weak var applicationDateLbl: UILabel!
    @IBOutlet weak var waitingDateLbl: UILabel!
    @IBOutlet weak var approveDateLbl: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var pdfLbl: UILabel!
    @IBOutlet weak var holderview1: UIView!
    @IBOutlet weak var holderview2: UIView!
    @IBOutlet weak var holderview3: UIView!
    @IBOutlet weak var ekraBtn: UIButton!
    @IBOutlet weak var aofBtn: UIButton!
    @IBOutlet weak var ddpiBtn: UIButton!
    @IBOutlet weak var ekraViewBtn: UIButton!
    @IBOutlet weak var aofViewBtn: UIButton!
    @IBOutlet weak var ddpiViewBtn: UIButton!
    @IBOutlet weak var ekraStack: UIStackView!
    @IBOutlet weak var ddpiStack: UIStackView!
    @IBOutlet weak var aofStack: UIStackView!
    
    var fetchedUserId: String?
    var fetchedSessionID: String?
    var mobiledecodeArray: String?
    var decodeArray:String?
    var panNo: String?
    var regId: String?
    var PANName : String?
    var EmailId : String?
    var isDerivative: String = "N"
    var networth: String?
    var networthDate: String?
    var finalStatus: String?
    var ekraSign: String = "0"
    var aofSign: String = "0"
    var ddpiSign: String = "0"
    var ekraID: String?
    var aofID: String?
    var ddpiID: String?
    var PanNo : String?
    var RegId : String?
    var signedResponse: String?
    var msg : String?
    var env : String?
    var pdfDataList: [[String: Any]] = []
    var esignRetryCount = 10
    var companyName: String?
    var returnurl: String?
    var txnId: String?
    var esignType: String?
    var currentEsignSegment: String?
    public var onStartEsign: (() -> Void)?
    public var onSDKClose: (() -> Void)?
    var documentId: String?
    var pollingTimer: Timer?
    var pollingAttempts = 0
    let maxPollingAttempts = 20
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemGroupedBackground
        navigationController?.isNavigationBarHidden = true
//        pdfLbl.isHidden = true
//        secondView.isHidden = true
//        mainView.layer.cornerRadius = 20
//        secondView.layer.cornerRadius = 20
//        secondView.layer.borderColor = UIColor.black.cgColor
//        secondView.layer.borderWidth = 1.0
        SIXTHAPI(userID: fetchedUserId ?? "" )
//        onBordingView.layer.cornerRadius = 25
//        applicationView.layer.cornerRadius = 25
//        waitingView.layer.cornerRadius = 25
//        approveView.layer.cornerRadius = 25
        
        CoreDataHelper.fetchUserId(entityName: "MobileUser") { [weak self] userId, sessionID , decodeByteArrayString in
            guard let self = self else { return }
            
            if let userId = userId, let sessionID = sessionID {
                self.fetchedUserId = userId
                self.fetchedSessionID = sessionID
                self.decodeArray = decodeByteArrayString
                self.ValidateToken()
                print("UserID: \(userId), SessionID: \(sessionID)")
                self.ViewAllMultiPDF()
            } else {
                print("No UserID or SessionID found.")
            }
        }
       // ViewAllMultiPDF()
        view.backgroundColor = .appBackground
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    @objc func appDidBecomeActive() {
        print("🔄 App returned from browser")
        guard let docId = documentId else { return }
        
        // Optional: Do one immediate check
        checkDDPIEsignStatus(documentId: docId)
        
        // Then start polling (but with longer interval, e.g. 8-10 sec to be gentler)
        startEsignDonePolling(documentId: docId)
    }
    
    @IBAction func ekraBtnTapped(_ sender: UIButton) {
        handleSegmentBasedOnSignValue(segmentName: "EKRA", signKey: "ekraSign")
    }
    
    private func handleSegmentTap(segmentName: String, signKey: String) {
        var signValue = getSignValue(forKey: signKey)
        
        if signValue == "1" {
            // Construct URL
            let baseUrl = "https://signup.hemnxt.com:84/V4.0.0/api/MultiPartImageUpload/PDFDownload"
            guard let regId = RegId, let userId = fetchedUserId, let panNo = PanNo else {
                print("Missing parameters for URL construction")
                return
            }
            // Get dynamic ID based on segmentName
            guard let dynamicID = getDynamicID(forSegment: segmentName) else {
                print("No valid ID found for segment \(segmentName)")
                return
            }
            
            CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [weak self] tokenId in
                guard let self = self else { return }
                guard let tokenId = tokenId else {
                    CoreDataHelper.generateToken(
                        decodeByteArrayToString: self.decodeArray ?? "",
                        USERID: self.fetchedUserId ?? "",
                        SessionId: self.fetchedSessionID ?? "",
                        entityName: "TokenMobile", deviceType: "W", in: self.view
                    ) { success in
                        if success {
                            // Retry SIXTHAPI after token regeneration
                            self.handleSegmentTap(segmentName: segmentName, signKey: signKey)
                        } else {
                            print("Token generation failed.")
                        }
                    }
                    print("No tokens available. Please reload the tokens.")
                    return
                }
                
                let urlString = "\(baseUrl)?id=\(dynamicID)&RegId=\(regId)&UserId=\(userId)&PanNo=\(panNo)&PDFSegment=\(segmentName)&TokenId=\(tokenId)"
                print("Constructed URL: \(urlString)")
                self.openURLInSystemBrowser(urlString: urlString)
            }
        } else {
            print("\(segmentName) button tapped")
            //NSDLEsign(segmentName: segmentName, signKey: signKey)
            let sb = UIStoryboard(name: "Esign", bundle: Bundle.module)
            let vc = sb.instantiateViewController(
                withIdentifier: "AadhaarStackVC"
            ) as! AadhaarStackVC
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.delegate = self
            vc.segmentName = segmentName
            vc.signkey = signKey
            present(vc, animated: true)
        }
    }
    
    private func handleSegmentBasedOnSignValue(segmentName: String, signKey: String) {
//        let signValue = getSignValue(forKey: signKey)
//
//        if signValue == "0" {
//            // If eSign value is 0, present the terms screen
//            presentTermsScreen(segmentName: segmentName, signKey: signKey)
//        } else {
//            // Otherwise, directly handle the segment
//            handleSegmentTap(segmentName: segmentName, signKey: signKey)
//        }
        let signValue = getSignValue(forKey: signKey)
        
        if signValue == "0" {
            // If eSign value is 0, present the terms screen
            NSDLEsign(segmentName: segmentName, signKey: signKey)
        } else {
            // Otherwise, directly handle the segment
            handleSegmentTap(segmentName: segmentName, signKey: signKey)
        }
    }
    
    private func presentTermsScreen(segmentName: String, signKey: String) {
        let sb = UIStoryboard(name: "Esign", bundle: Bundle.module)
        let vc = sb.instantiateViewController(
            withIdentifier: "AadhaarStackVC"
        ) as! AadhaarStackVC
        
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.delegate = self
        vc.segmentName = segmentName
        vc.signkey = signKey
        
        present(vc, animated: true)
    }
    
    private func getSignValue(forKey key: String) -> String {
        switch key {
        case "ekraSign": return ekraSign
        case "aofSign": return aofSign
        case "ddpiSign": return ddpiSign
        default: return "0"
        }
    }
    
    private func updateSignValue(forKey key: String, value: String) {
        switch key {
        case "ekraSign": ekraSign = value
        case "aofSign": aofSign = value
        case "ddpiSign": ddpiSign = value
        default: break
        }
    }
    
    private func getDynamicID(forSegment segmentName: String) -> String? {
        switch segmentName {
        case "EKRA": return ekraID
        case "E": return aofID
        case "DDPI": return ddpiID
        default: return nil
        }
    }
    
    private func openURLInSystemBrowser(urlString: String) {
        guard let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) else {
            print("Invalid URL or cannot open URL")
            return
        }
        
        UIApplication.shared.open(url, options: [:]) { success in
            if success {
                print("Successfully opened URL in system browser")
            } else {
                print("Failed to open URL in system browser")
            }
        }
    }
    
    @IBAction func aofBtn(_ sender: UIButton) {
        if ekraSign == "0" {
            showAlert(message: "You need to sign the EKRA segment first.")
        } else {
            handleSegmentBasedOnSignValue(segmentName: "E", signKey: "aofSign")
        }
    }
    @IBAction func ddpiBtn(_ sender: UIButton) {
        if ekraSign == "0" && aofSign == "0" {
            showAlert(message: "You need to sign EKRA & AOF segments.")
        } else if ekraSign == "0" {
            showAlert(message: "You need to sign the EKRA segment first.")
        } else if aofSign == "0" {
            showAlert(message: "You need to sign the AOF segment first.")
        } else {
            handleSegmentBasedOnSignValue(segmentName: "DDPI", signKey: "ddpiSign")
        }
//        if let docId = documentId {
//            startEsignDonePolling(documentId: docId)
//        }
    }
    
//    func startEsignDonePolling(documentId: String) {
//        stopEsignPolling()
//        pollingAttempts = 0
//
//        pollingTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
//            guard let self = self else { return }
//
//            self.pollingAttempts += 1
//
//            if self.pollingAttempts >= self.maxPollingAttempts {
//                print("⛔ Polling timeout")
//                self.stopEsignPolling()
//                return
//            }
//
//            self.checkDDPIEsignStatus(documentId: documentId)
//        }
//    }
    
    func startEsignDonePolling(documentId: String) {
        stopEsignPolling()           // Stop any previous polling
        pollingAttempts = 0
        
        print("🔄 Starting polling for documentId: \(documentId)")
        
        // ✅ IMPORTANT: Start background task FIRST
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            print("⚠️ Background task expiring - iOS is forcing us to stop")
            self?.stopEsignPolling()
            self?.endBackgroundTask()
        }
        
        // If background task failed to start (returns .invalid)
        if backgroundTask == .invalid {
            print("❌ Failed to start background task")
            // Still try to poll while app is foreground
        }
        
        // Start timer on main thread
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.pollingTimer = Timer.scheduledTimer(withTimeInterval: 6.0, repeats: true) { [weak self] timer in
                guard let self = self else {
                    timer.invalidate()
                    return
                }
                
                self.pollingAttempts += 1
                print("📡 Polling attempt \(self.pollingAttempts)/\(self.maxPollingAttempts) at \(Date())")
                
                if self.pollingAttempts >= self.maxPollingAttempts {
                    print("⛔ Polling timeout reached")
                    self.stopEsignPolling()
                    return
                }
                
                self.checkDDPIEsignStatus(documentId: documentId)
            }
            
            // Add to common run loop so it fires even when scrolling etc.
            if let timer = self.pollingTimer {
                RunLoop.current.add(timer, forMode: .common)
            }
        }
    }

    func stopEsignPolling() {
        pollingTimer?.invalidate()
        pollingTimer = nil
        pollingAttempts = 0
        endBackgroundTask()
        print("🛑 Polling stopped")
    }

    func endBackgroundTask() {
        if backgroundTask != .invalid {
            print("🏁 Ending background task")
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func QuitBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
//    @IBAction func ekraView(_ sender: UIButton) {
//        openPDF(segmentName: "EKRA")
//    }
//
//    @IBAction func aofView(_ sender: UIButton) {
//        openPDF(segmentName: "E")
//    }
    
//    @IBAction func ddpiView(_ sender: UIButton) {
//        openPDF(segmentName: "DDPI")
//    }
    
    
    @IBAction func ekraView(_ sender: UIButton) {
        openPDF(segmentName: "EKRA")
    }
    
    @IBAction func aofView(_ sender: UIButton) {
        openPDF(segmentName: "E")
    }
    
    @IBAction func ddpiView(_ sender: UIButton) {
        openPDF(segmentName: "DDPI")
    }
    
    func openPDF(segmentName: String) {
        
        // ✅ Check if PDF is signed before opening
        var isSigned = false
        
        switch segmentName {
        case "EKRA":
            isSigned = (ekraSign == "1")
        case "E":
            isSigned = (aofSign == "1")
        case "DDPI":
            isSigned = (ddpiSign == "1")
        default:
            break
        }
        
        // ❌ If not signed → don't open PDF
        if !isSigned {
            showAlert(message: "Please complete eSign first to view the PDF.")
            return
        }
        
        // ✅ Continue only if signed
        guard let regId = RegId,
              let userId = fetchedUserId,
              let panNo = PanNo,
              let dynamicID = getDynamicID(forSegment: segmentName) else {
            print("Missing parameters")
            return
        }

        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [weak self] tokenId in
            guard let self = self else { return }
            
            guard let tokenId = tokenId else {
                CoreDataHelper.generateToken(
                    decodeByteArrayToString: self.decodeArray ?? "",
                    USERID: self.fetchedUserId ?? "",
                    SessionId: self.fetchedSessionID ?? "",
                    entityName: "TokenMobile",
                    deviceType: "W",
                    in: self.view
                ) { success in
                    if success {
                        self.openPDF(segmentName: segmentName)
                    }
                }
                return
            }

            let baseUrl = "https://signup.hemnxt.com:84/V4.0.0/api/MultiPartImageUpload/PDFDownload"
            let urlString = "\(baseUrl)?id=\(dynamicID)&RegId=\(regId)&UserId=\(userId)&PanNo=\(panNo)&PDFSegment=\(segmentName)&TokenId=\(tokenId)"

            self.openURLInSystemBrowser(urlString: urlString)
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
    
    func NSDLEsign(segmentName: String, signKey: String) {
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [weak self] tokenId in
            guard let self = self else { return }
            guard let tokenId = tokenId else {
                CoreDataHelper.generateToken(
                    decodeByteArrayToString: self.decodeArray ?? "",
                    USERID: self.fetchedUserId ?? "",
                    SessionId: self.fetchedSessionID ?? "",
                    entityName: "TokenMobile", deviceType: "W", in: self.view
                ) { success in
                    if success {
                        // Retry SIXTHAPI after token regeneration
                        self.NSDLEsign(segmentName: segmentName, signKey: signKey)
                    } else {
                        print("Token generation failed.")
                    }
                }
                print("No tokens available. Please reload the tokens.")
                return
            }
            
            let parameters: [String: Any?] = [
                "UserId": fetchedUserId,
                "TokenId": tokenId,
                "PanNo": PanNo,
                "RegId": RegId,
                "AuthMode": "1",
                "SegmentName": segmentName,
                "IsMobOrWeb": "1",
                "DeviceType": "IOS"
            ]
            
            let url = "NSDLEsign/NSDLEsignRquest"
            apiCall(url: url, method: "POST", parameters: parameters as [String: Any], view: self.view,loaderText: "processing data for esign,kindly wait until completed...") { result in
                switch result {
                case .success(let jsonResponse):
                    print("NSDLEsignRquest Response: \(jsonResponse)")
                    self.msg = jsonResponse["eXml"] as? String
                    self.env = "PROD"
                    let ErrorMessage = jsonResponse["ErrorMessage"] as? String
                    self.returnurl = jsonResponse["ReturnURL"] as? String
                    self.esignType = jsonResponse["EsignType"] as? String ?? ""
                    let esignUrl = jsonResponse["EsignUrl"] as? String ?? ""
                    self.txnId = jsonResponse["txn"] as? String ?? ""
                    let requestURL = jsonResponse["RquestURL"] as? String ?? ""
                    self.companyName = jsonResponse["CompanyName"] as? String
                    self.currentEsignSegment = segmentName
                    self.documentId = jsonResponse["documentId"] as? String
                    if let errorCode = jsonResponse["ErrorCode"] as? String {
                        switch errorCode {
                        case "000000":
                            
//                            if let isDDPIEsign = jsonResponse["IsDDPIEsign"] as? Int,
//                                             isDDPIEsign == 1,
//                                             segmentName == "DDPI" {
//                                              print("✅ DDPI eSign completed immediately - Closing SDK")
//                                              DispatchQueue.main.async {
//                                                  self.closeSDK()
//                                              }
//                                              return
//                                          }
//
//                            let isDDPIEsign = jsonResponse["IsDDPIEsign"] as? Int ??
//                                                Int(jsonResponse["IsDDPIEsign"] as? String ?? "0") ?? 0
//
//                            self.documentId = jsonResponse["DocumentId"] as? String
//
//                            // ✅ Start polling ONLY for DDPI
//                            if segmentName == "DDPI", let docId = self.documentId {
//                                print("🚀 Starting DDPI polling with documentId: \(docId)")
//                                self.startEsignDonePolling(documentId: docId)
//                            }
                            
//                            if segmentName == "DDPI", self.msg == nil {
//                                if !esignUrl.isEmpty {
//                                    DispatchQueue.main.async {
//                                        self.openURLInSystemBrowser(urlString: esignUrl)
//                                    }
//                                    return
//                                }
//                            }
                            
                            if segmentName == "DDPI", !esignUrl.isEmpty {
                            DispatchQueue.main.async {
                                    let vc = WebviewAutoSubmitVC()
                                    vc.esignUrl = esignUrl   // 👈 pass URL
                                    vc.isDDPI = true         // 👈 flag if needed
                                    vc.documentId = self.documentId
                                    vc.parentVC = self
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                                return
                            }

                            if self.esignType == "SELF" {
                                DispatchQueue.main.async {
                                    let vc = WebviewAutoSubmitVC()
                                    vc.xmlMsg = self.msg ?? ""
                                    vc.CompanyName = self.companyName ?? ""
                                    vc.ReturnURL = self.returnurl ?? ""
                                    vc.txn = self.txnId ?? ""
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                                return
                            }

                        case "111111":
                            DispatchQueue.main.async {
                                print("API is running for segment: \(segmentName)")
                            }
                        case "999992":
                            DispatchQueue.main.async {
                                CoreDataHelper.deleteAllTokens(
                                    entityName: "TokenMobile")
                                print("All TokenMobile entries deleted due to error code 999992")
                                
                                CoreDataHelper.generateToken(
                                    decodeByteArrayToString: self.decodeArray ?? "",
                                    USERID: self.fetchedUserId ?? "",
                                    SessionId: self.fetchedSessionID ?? "",
                                    entityName: "TokenMobile", deviceType: "W",
                                    in: self.view
                                ) { success in
                                    if success {
                                        // Retry SIXTHAPI after token regeneration
                                        self.ValidateToken()
                                    } else {
                                        print("Token generation failed.")
                                    }
                                }
                            }
                        default:
                            print("Unhandled error code: \(errorCode)")
                            self.showAlert(message: "\(String(describing: ErrorMessage))")
                        }
                    }
                case .failure(let error):
                    print("API call failed: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func esignDone(segmentName: String, transactionID: String, completion: @escaping @Sendable (Bool) -> Void) {
        
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [weak self] tokenId in
            guard let self = self else { return }
            
            guard let tokenId = tokenId else {
                completion(false)
                return
            }
            
            let parameters: [String: Any?] = [
                "PanNo": self.PanNo,
                "RegId": self.RegId,
                "Segment": segmentName,
                "SessionId": self.fetchedSessionID,
                "UserId": self.fetchedUserId,
                "TokenId": tokenId,
                "TransactionID": transactionID
            ]
            
            apiCall(url: "NSDLEsign/ValidateIsEsignDone", method: "POST", parameters: parameters as [String: Any], view: self.view) { result in
                
                switch result {
                case .success(let jsonResponse):
                    let ErrorMessage = jsonResponse["ErrorMessage"] as? String
                    print("ValidateIsEsignDone: \(jsonResponse)")
                    if let errorCode = jsonResponse["ErrorCode"] as? String {
                        switch errorCode {
                            
                        case "000000":
                            DispatchQueue.main.async {
                                print("api is running")
                                completion(true)
                                
                                self.showAlert(message: "E-sign completed successfully!")
                                
                                self.ViewAllMultiPDF()
                            }
                            
                        case "000002":
                            DispatchQueue.main.async {
                                print("api is running")
                                completion(true)
                                
                                if let nav = self.navigationController,
                                   let webVC = nav.viewControllers.last as? WebviewAutoSubmitVC {
                                    nav.popViewController(animated: true)
                                }
                                
                                self.showAlert(message: "Your e-signature name does not match the name on your PAN.")
                            }
                            
                        default:
                            print("Unhandled error code: \(errorCode)")
                            DispatchQueue.main.async {
                                completion(false)
                                //self.showAlert(message: ErrorMessage ?? "Unknown error occurred")
                            }
                        }
                    }
                case .failure(let error):
                    //self.showAlert(message: "Esign page:api failed--- \(error.localizedDescription)")
                    print("Login API call failed: \(error.localizedDescription)")
                    
                }
            }
        }
    }
    
//    func checkDDPIEsignStatus(documentId: String) {
//        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [weak self] tokenId in
//            guard let self = self else { return }
//
//            guard let tokenId = tokenId else {
//                CoreDataHelper.generateToken(
//                    decodeByteArrayToString: self.decodeArray ?? "",
//                    USERID: self.fetchedUserId ?? "",
//                    SessionId: self.fetchedSessionID ?? "",
//                    entityName: "TokenMobile",
//                    deviceType: "W",
//                    in: self.view
//                ) { success in
//                    if success {
//                        self.checkDDPIEsignStatus(documentId: documentId)
//                    }
//                }
//                return
//            }
//
//            let parameters: [String: Any] = [
//                "documentId": documentId
//            ]
//
//            let url = "NSDLEsignController/ValidateIsDDPIEsignDone"
//
//            apiCall(url: url, method: "POST", parameters: parameters, view: self.view) { result in
//                switch result {
//                case .success(let jsonResponse):
//                    print("📩 DDPI Status Response: \(jsonResponse)")
//
//                    if let errorCode = jsonResponse["ErrorCode"] as? String,
//                       errorCode == "000000" {
//
//                        let isDone = jsonResponse["IsEsignDone"] as? Int ??
//                                     Int(jsonResponse["IsEsignDone"] as? String ?? "0") ?? 0
//
//                        print("🔍 DDPI isDone: \(isDone)")
//
//                        // ✅ WRITE YOUR CODE HERE
//                        if isDone == 1 {
//                            DispatchQueue.main.async {
//                                print("✅ DDPI eSign Completed → Closing SDK")
//
//                                self.stopEsignPolling()
//                                self.closeSDK()
//                            }
//                        }
//                    }
//
//                case .failure(let error):
//                    print("❌ DDPI Status API Failed: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
    func checkDDPIEsignStatus(documentId: String) {
        print("🔍 Checking DDPI status for documentId: \(documentId)")
        print("⏰ Time: \(Date())")
        
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [weak self] tokenId in
            guard let self = self else { return }
            
            guard let tokenId = tokenId else {
                print("❌ No token available, generating new one...")
                CoreDataHelper.generateToken(
                    decodeByteArrayToString: self.decodeArray ?? "",
                    USERID: self.fetchedUserId ?? "",
                    SessionId: self.fetchedSessionID ?? "",
                    entityName: "TokenMobile",
                    deviceType: "W",
                    in: self.view
                ) { success in
                    if success {
                        self.checkDDPIEsignStatus(documentId: documentId)
                    }
                }
                return
            }

            let parameters: [String: Any] = [
                "documentId": documentId
            ]

            let url = "NSDLEsign/ValidateIsDDPIEsignDone"
            print("📤 Calling API: \(url) with params: \(parameters)")

            apiCall(url: url, method: "POST", parameters: parameters, view: self.view) { result in
                switch result {
                case .success(let jsonResponse):
                    print("📩 DDPI Status Response at \(Date()): \(jsonResponse)")

                    if let errorCode = jsonResponse["ErrorCode"] as? String,
                       errorCode == "000000" {
                        
                        // Check for IsPDFSign field
                        let isPDFSign = jsonResponse["IsPDFSign"] as? String ??
                                        String(jsonResponse["IsPDFSign"] as? Int ?? 0)
                        
                        print("🔍 DDPI IsPDFSign: \(isPDFSign)")
                        
                        if isPDFSign == "1" {
                            print("✅ DDPI eSign Completed (IsPDFSign = 1)")
                            
                            DispatchQueue.main.async {
                                // Stop polling
                                self.stopEsignPolling()
                                
                                // Update local sign value
                                self.ddpiSign = "1"
                                
                                // Refresh PDF list
                                self.ViewAllMultiPDF()
                                
                                // Close the WebView first if it's presented
                                if let navController = self.navigationController {
                                    // Find and remove WebviewAutoSubmitVC
                                    var viewControllers = navController.viewControllers
                                    viewControllers.removeAll { $0 is WebviewAutoSubmitVC }
                                    navController.viewControllers = viewControllers
                                }
                                
                                // Small delay to ensure cleanup, then close SDK
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    self.closeSDK()
                                }
                            }
                        } else {
                            print("⏳ DDPI eSign not yet completed (IsPDFSign = \(isPDFSign)), waiting for next poll...")
                        }
                    } else {
                        print("⚠️ Error code: \(jsonResponse["ErrorCode"] ?? "unknown")")
                    }

                case .failure(let error):
                    print("❌ DDPI Status API Failed: \(error.localizedDescription)")
                    // Continue polling on network errors
                }
            }
        }
    }
    
    func NSDLEsignResponse(decodedResponse: String){
        
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
            guard let tokenId = tokenId else {
                // Handle the case where no tokens are available
                CoreDataHelper.generateToken(
                    decodeByteArrayToString: self.decodeArray ?? "",
                    USERID: self.fetchedUserId ?? "",
                    SessionId: self.fetchedSessionID ?? "",
                    entityName: "TokenMobile", deviceType: "M", in: self.view
                ) { success in
                    if success {
                        // Retry SIXTHAPI after token regeneration
                        self.NSDLEsignResponse(decodedResponse: decodedResponse)
                    } else {
                        print("Token generation failed.")
                    }
                }
                print("No tokens available. Please reload the tokens.")
                return
            }
            let parameters: [String: Any?] = [
                "UserId":  fetchedUserId,
                "TokenId": tokenId,
                "XMLResponse":decodedResponse
            ]
            //print(parameters)
            
            let Url = "NSDLEsign/NSDLEsignResponse"
            
            apiCall(url: Url, method: "POST", parameters: parameters as [String : Any], view: self.view,loaderText: "please wait...") { result in
                switch result {
                case .success(let jsonResponse):
                    let ErrorMessage = jsonResponse["ErrorMessage"] as? String
                    print("NSDLEsignResponse Response: \(jsonResponse)")
                    if let errorCode = jsonResponse["ErrorCode"] as? String {
                        switch errorCode {
                        case "000000":
                            DispatchQueue.main.async {
                                print("api is running")
                                self.showAlert(message: "Esign page:successfully submitted")
                                self.ViewAllMultiPDF()
                            }
                        default:
                            print("Unhandled error code: \(errorCode)")
                            self.showAlert(message: "Esign page:failed to submit")
                            self.showAlert(message: ErrorMessage ?? "error occured")
                        }
                    }
                case .failure(let error):
                    self.showAlert(message: "Esign page:api failed--- \(error.localizedDescription)")
                    print("Login API call failed: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func  ViewAllMultiPDF(){
        
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
            guard let tokenId = tokenId else {
                // Handle the case where no tokens are available
                CoreDataHelper.generateToken(
                    decodeByteArrayToString: self.decodeArray ?? "",
                    USERID: self.fetchedUserId ?? "",
                    SessionId: self.fetchedSessionID ?? "",
                    entityName: "TokenMobile", deviceType: "M", in: self.view
                ) { success in
                    if success {
                        // Retry SIXTHAPI after token regeneration
                        self.ViewAllMultiPDF()
                    } else {
                        print("Token generation failed.")
                    }
                }
                print("No tokens available. Please reload the tokens.")
                return
            }
            let parameters: [String: Any?] = [
                "UserId":  fetchedUserId,
                "TokenId": tokenId,
                "PanNo":PanNo,
                "RegId":RegId,
                "SessionId":fetchedSessionID
            ]
            print(parameters)
            let Url = "/KYC/ViewAllMultiPDF"
            //KYC/ViewAllMultiPDF
            
            apiCall(url: Url, method: "POST", parameters: parameters as [String : Any], view: self.view,loaderText: "please wait...") { result in
                switch result {
                case .success(let jsonResponse):
                    print("jsonresponse:-> \(jsonResponse)")
                    if let errorCode = jsonResponse["ErrorCode"] as? String, errorCode == "000000" {
                        if let pdfList = jsonResponse["PDFForEsignList"] as? [[String: Any]] {
                            self.pdfDataList = pdfList
                            
                            //////////////******************static ddpi = 1**//////////////////
//                            for item in pdfList {
//
//                                let segment = item["PDFSegment"] as? String
//
//                                   // 👇 Force DDPI as signed
//                                   let isSigned: Int
//
//                                   if segment == "DDPI" {
//                                       isSigned = 1   // ✅ STATIC VALUE
//                                   } else {
//                                       isSigned = item["IsPDFSign"] as? Int ??
//                                                  Int(item["IsPDFSign"] as? String ?? "0") ?? 0
//                                   }
//
//                                   if segment == "DDPI" && isSigned == 1 {
//                                       print("✅ DDPI Forced Signed → Closing SDK")
//
//                                       DispatchQueue.main.async {
//                                           self.closeSDK()
//                                       }
//                                       return
//                                   }
//                               }
                                
                                

//                                let segment = item["PDFSegment"] as? String
//                                let isSigned = item["IsPDFSign"] as? Int ?? Int(item["IsPDFSign"] as? String ?? "0")
//
//                                if segment == "DDPI" && isSigned == 1 {
//
//                                    print("✅ DDPI Signed → Closing SDK")
//
//                                    DispatchQueue.main.async {
//                                        self.closeSDK()
//                                    }
//                                    return   // ✅ VERY IMPORTANT (stop further execution)
//                                }
//                            }
//                            for item in pdfList {
//
//                                let segment = item["PDFSegment"] as? String
//
//                                let isSigned = item["IsPDFSign"] as? Int ??
//                                               Int(item["IsPDFSign"] as? String ?? "0") ?? 0
//
//                                // ✅ Only close when DDPI is actually signed from API
//                                if segment == "DDPI" && isSigned == 1 {
//                                    print("✅ DDPI Signed from API → Closing SDK")
//
//                                    DispatchQueue.main.async {
//                                        self.closeSDK()
//                                    }
//                                    return   // ✅ STOP further execution
//                                }
//                            }
                            
//                            DispatchQueue.main.async {
//                                // Default state: hide all views
////                                self.holderview1.isHidden = true
////                                self.holderview2.isHidden = true
////                                self.holderview3.isHidden = true
//
//                                // Iterate through the PDF list
//                                for pdf in pdfList {
//                                    if let pdfSegment = pdf["PDFSegment"] as? String,
//                                       let isPDFSign = pdf["IsPDFSign"] as? String,
//                                       let id = pdf["Id"] as? String {
//                                        switch pdfSegment {
//                                        case "EKRA":
//
//                                            self.ekraSign = isPDFSign
//                                            self.ekraID = id
//                                            self.ekraStack.isHidden = (isPDFSign == "1")
//                                        case "E":
//                                            self.aofSign = isPDFSign
//                                            self.aofID = id
//                                            self.aofStack.isHidden = (isPDFSign == "1")
//                                        case "DDPI":
//
//                                            self.ddpiSign = isPDFSign
//                                            self.ddpiID = id
//                                            self.ddpiStack.isHidden = (isPDFSign == "1")
//                                        default:
//                                            break
//                                        }
//                                    }
//                                }
//                            }
                            
                         

                                for pdf in pdfList {
                                    if let pdfSegment = pdf["PDFSegment"] as? String,
                                       let isPDFSign = pdf["IsPDFSign"] as? String,
                                       let id = pdf["Id"] as? String {

                                        switch pdfSegment {
                                        case "EKRA":
                                            self.ekraSign = isPDFSign
                                            self.ekraID = id
                                            self.ekraStack.isHidden = (isPDFSign == "1")

                                        case "E":
                                            self.aofSign = isPDFSign
                                            self.aofID = id
                                            self.aofStack.isHidden = (isPDFSign == "1")

                                        case "DDPI":
                                            // ✅ FORCE STATIC
                                            self.ddpiSign = isPDFSign
                                            self.ddpiID = id
                                            self.ddpiStack.isHidden = (isPDFSign == "1")

                                        default:
                                            break
                                        }
                                    }
                                }

                                // ✅ FINAL CHECK (ONLY HERE)
//                                if self.ddpiSign == "1"{
//                                    print("✅ EKRA & AOF signed → Closing SDK")
//                                    self.closeSDK()
//                                }
                            
                        }
                    } else {
                        print("Unhandled error code: \(jsonResponse["ErrorCode"] ?? "Unknown Error")")
                    }
                case .failure(let error):
                    print("Login API call failed: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func closeSDK() {
        print("🚀 Closing SDK")

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
    
}

extension ApplicationStatusVC {
    
    func SIXTHAPI(userID:String){
        
        CoreDataHelper.fetchUserId(entityName: "MobileUser") { [weak self] userId, sessionID , decodeByteArrayString in
            guard let self = self else { return }
            
            if let userId = userId, let sessionID = sessionID {
                self.fetchedUserId = userId
                self.fetchedSessionID = sessionID
                self.decodeArray = decodeByteArrayString
                print("UserID: \(userId), SessionID: \(sessionID)")
            } else {
                print("No UserID or SessionID found.")
            }
        }
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { tokenId in
            guard let tokenId = tokenId else {
                // Handle the case where no tokens are available
                CoreDataHelper.generateToken(
                    decodeByteArrayToString: self
                        .mobiledecodeArray ?? "",
                    USERID: self.fetchedUserId ?? "",
                    SessionId: self.fetchedSessionID ?? "",
                    entityName: "TokenMobile", deviceType: "W",
                    in: self.view
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
            apiCall(url: sixthUrl, method: "POST", parameters: parameters, view: self.view) { result in
                switch result {
                case .success(let jsonResponse):
                    print("SIXTHAPI Response: \(jsonResponse)")
                    self.panNo = jsonResponse["PanNo"] as? String
                    self.regId = jsonResponse["RegId"] as? String
                    self.PANName = jsonResponse["PANName"] as? String
                    self.EmailId = jsonResponse["EmailId"] as? String
                    self.finalStatus = jsonResponse["FinalStatus"] as? String
                    
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
                            print("errorcode 000000 called")
                          
                                
                                self.isDerivative = (jsonResponse["IsDerivative"] as? String ?? "N").uppercased()
                                self.panNo = jsonResponse["PanNo"] as? String
                                self.regId = jsonResponse["RegId"] as? String
                                self.PANName = jsonResponse["PANName"] as? String
                                //self.updateUIFromSixthAPI(jsonResponse)
                                //if self.finalStatus == "4"{
                            
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
